//
//  TaskCalendarViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskCalendarViewController.h"
#import "TaskArcView.h"
#import "TaskTotalRidingView.h"
#import "TaskPersonalRidingView.h"
#import "TaskRankingTableViewCell.h"
#import "OngoingModel.h"
#import "TaskModel.h"
#import "TaskDetailModel.h"
#import "TaskInfoModel.h"
#import "TaskShareView.h"
#import "TaskShareModel.h"
#import "MJExtension.h"
#import "UMSocial.h"
#import "UIImage+Tools.h"
#import "ActivityRulesViewController.h"
@interface TaskCalendarViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    /** 存放日期的数组------说明:比如30天内任意骑行20天达标,这个数组会返回30个
     --   -1代表未完成，1代表已完成 0代表未开始*/
    NSMutableArray *_dateArrayM;
    
    /** 排名的数据源*/
    NSMutableArray *_rankArrayM;
    
    TaskDetailModel *_taskDetailModel;
    
}
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) TaskTotalRidingView *totalRidingHeaderView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) TaskPersonalRidingView *personalRidingView;

/** 是否是今日骑行*/
@property (nonatomic,assign) BOOL isToday;

/** 分享的view*/
@property (nonatomic,strong) TaskShareView *shareView;

@property (nonatomic,strong) UIImage *shareImage;
@end

@implementation TaskCalendarViewController
static NSString *const kTaskRankingTableViewCell = @"TaskRankingTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.isToday = YES;
    _rankArrayM = @[].mutableCopy;
    _dateArrayM = @[].mutableCopy;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.personalRidingView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self setupNavigationView];
    
    [self getNetworkData];
    
}

- (void)setupNavigationView {

    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(18, 65, 18, 33) NormalImageString:@"reset_back_image" tapAction:^(UIButton *button) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [backBtn setEnlargeEdge:15];
    [self.view addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(670, 65, 31, 36) NormalImageString:@"task_share_btn" tapAction:^(UIButton *button) {
        [self clickShareBtn];
    }];
    [self.view addSubview:shareBtn];
    
    UIButton *ruleBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(670, 154, 31, 36) NormalImageString:@"task_rule_btn" tapAction:^(UIButton *button) {
        [self clickRuleBtn];
    }];
    [self.view addSubview:ruleBtn];
    
    NSArray *array = @[@"今日骑行",@"挑战总骑行"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:array];
    segmentControl.frame=CGRectMake720(186,62,348,44);
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tintColor=[UIColor whiteColor];
    [segmentControl addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
}

- (void)setupScrollView {
    
    //判断活动天数是否大于32 -- 大于scrollview能滑动
    if (_dateArrayM.count <= 32) {
        
    } else {
        self.scrollView.contentSize = CGSizeMake(0, 1800*SizeScale);
    }

    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.totalRidingHeaderView];

    TaskArcView *arcView = [[TaskArcView alloc]initWithFrame:CGRectMake720(0, 580, 310, 700)];
    arcView.alpha = 0.8;
    arcView.greenPercent = [_taskDetailModel.completePercent floatValue];
    arcView.orangePercent = 0.1;
    arcView.grayPercent = 0.05;
    [self.scrollView addSubview:arcView];

    if (_taskDetailModel) {
        arcView.completeDate = _taskDetailModel.completeDay;
        arcView.greenPercent = [_taskDetailModel.completePercent floatValue];
    }
    //大于32天，视图布局出现变化 --拐弯
    NSInteger count = 32;
    if (_dateArrayM.count < 32) {
        count = _dateArrayM.count;
    }
    //小于32的for循环
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(316 + 94*(i%4), 580 + 86*(i/4), 76, 76) title:[NSString stringWithFormat:@"%d",i+1] titleColor:kColorForfff titleFont:24 backgroundColor:nil tapAction:nil];
        if ([_dateArrayM[i]  isEqual: @-1]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"task_data_orange"] forState:UIControlStateNormal];
        } else if ([_dateArrayM[i]  isEqual: @1]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"task_data_green"] forState:UIControlStateNormal];
        }
        [self.scrollView addSubview:btn];
    }

    if (_dateArrayM.count < 32) {
        return;
    }
    //大于32的以后的for循环
    for (int i = 0; i < _dateArrayM.count - 32; i++) {

        UIButton *btn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(34 + 94*(i%7), 1275 + 86*(i/7), 76, 76) title:[NSString stringWithFormat:@"%d",i+33] titleColor:kColorForfff titleFont:24 backgroundColor:nil tapAction:nil];
        
        if ([_dateArrayM[i+32]  isEqual: @1]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"task_data_green"] forState:UIControlStateNormal];
        } else if ([_dateArrayM[i+32]  isEqual: @-1]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"task_data_orange"] forState:UIControlStateNormal];
        } else {
            
        }
        [self.scrollView addSubview:btn];
    }
}
#pragma mark --- interface
- (void)getNetworkData {
    //NSLog(@"%@--%@",self.taskModel.id,self.taskModel.taskDetailId);
    //NSDictionary *paramter = @{@"userTaskId":kUserId};
    [[MBProgressHUDManager instance] sendRequestShowHUD:kGetKeyWindow];
    NSDictionary *paramter = @{@"userTaskId":self.taskModel.userTaskId};
    [QDHttpTool getWithURL:kUrl_TaskGetMyTaskDetail params:paramter success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        if (!isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
            return ;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        _rankArrayM = [TaskInfoModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"ranks"]];
        [_dateArrayM addObjectsFromArray:[responseObject valueForKey:@"details"]];
        
        for (int i = 0; i < _dateArrayM.count; i++) {
            if ([_dateArrayM[i]  isEqual: @0]) {
                self.totalRidingHeaderView.completeDay = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }
        _taskDetailModel = [TaskDetailModel mj_objectWithKeyValues:responseObject];
        self.personalRidingView.model = _taskDetailModel;
        self.totalRidingHeaderView.model = _taskDetailModel;
        
        [self.tableView reloadData];
        self.shareView.shareModel = [TaskShareModel mj_objectWithKeyValues:responseObject[@"share"] ];
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
    
}


#pragma mark --- private method
/** 点击规则按钮*/
- (void)clickRuleBtn {
    
    ActivityRulesViewController *vc = [[ActivityRulesViewController alloc]init];
    vc.activityId = self.taskModel.taskDetailId;
    vc.activityCommentId = _taskDetailModel.taskCommentId;
    vc.isBackBtnShow = YES;
    vc.isPresent = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}
/** 点击分享按钮*/
- (void)clickShareBtn {
    UIImage *shareImage = nil;
    UIImage *bottomImage = [UIImage imageFromView:self.shareView];
    if (self.isToday) {
        UIImage *contentImage = [UIImage imageFromView:self.tableView];
        shareImage = [UIImage addImage:contentImage toImage:bottomImage];
        shareImage = [self watermarkImage:shareImage text:@"今日骑行"];
    } else {
        UIImage *contentImage = [UIImage imageFromView:self.scrollView];
        shareImage = [UIImage addImage:contentImage toImage:bottomImage];
        shareImage = [self watermarkImage:shareImage text:@"挑战总骑行"];
    }
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:nil
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
}
//使用cg绘图，给图片添加文字
- (UIImage *)watermarkImage:(UIImage *)image text:(NSString *)text{

    //1.获取上下文
    //UIGraphicsBeginImageContext(self.size);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //3.绘制水印文字
    CGRect rect = CGRectMake(0, 62*SizeScale, image.size.width, 48*SizeScale);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:44*SizeScale],
                          NSParagraphStyleAttributeName:style,
                          NSForegroundColorAttributeName:[UIColor whiteColor]
                          };
    
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    //4.获取绘制到得图片
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    
    return watermarkImage;
    
}
/** segment的点击方法*/
- (void)changeMode:(UISegmentedControl *)segmentControl {
    NSInteger position = segmentControl.selectedSegmentIndex;
    
    switch (position) {
        case 0:
            if (_scrollView) {
                self.scrollView.hidden = YES;
            }
            [self.view sendSubviewToBack:self.tableView];
            self.tableView.hidden = NO;
            self.isToday = YES;
            break;
        case 1:
            if (_scrollView) {
                self.scrollView.hidden = NO;
            } else {
                [self setupScrollView];
            }
            [self.view sendSubviewToBack:self.scrollView];
            self.tableView.hidden = YES;
            self.isToday = NO;
            break;
        default:
            break;
    }

}
#pragma -mark -tableViewDelegateAndDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rankArrayM.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskRankingTableViewCell];
    if (cell == nil) {
        cell = [[TaskRankingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTaskRankingTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.ranking = indexPath.row + 1;
    cell.model = _rankArrayM[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        //_tableView.height = self.view.height - 64;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.rowHeight = 110*SizeScaleSubjectTo720;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (TaskTotalRidingView *)totalRidingHeaderView {
    if (!_totalRidingHeaderView) {
        _totalRidingHeaderView = [[TaskTotalRidingView alloc]initWithFrame:CGRectMake720(0, 0, 720, 580)];
    }
    return _totalRidingHeaderView;
}
- (TaskPersonalRidingView *)personalRidingView {
    if (!_personalRidingView) {
        _personalRidingView = [[TaskPersonalRidingView alloc]initWithFrame:CGRectMake720(0, 0, 720, 726)];
    }
    return _personalRidingView;
}
- (TaskShareView *)shareView {
    if (!_shareView) {
        _shareView = [[TaskShareView alloc]initWithFrame:CGRectMake720(0, 120, 720, 1138)];
    }
    return _shareView;
}
//- (UIImage *)shareImage {
//    if (!_shareImage) {
//        _shareImage = [UIImage imageFromView:self.shareView];
//    }
//    return _shareImage;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
