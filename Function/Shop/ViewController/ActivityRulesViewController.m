//
//  ActivityRulesViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ActivityRulesViewController.h"
#import "CommentTableViewCell.h"
#import "ActivityRulesFooterView.h"
#import "ActivityRulesHeaderView.h"
#import "ActivityModel.h"
#import "CommentUtil.h"
#import "CommentModel.h"
#import "RuleJoinModel.h"
#import "ActivityCommentViewController.h"
@interface ActivityRulesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    /** 评论的数组*/
    NSMutableArray *_commentArrayM;
    /** 人数*/
    NSMutableArray *_numberArratM;
    /** 总评论数*/
    NSString *_commentCount;
    /** 好评率*/
    NSString *_goodRate;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ActivityRulesHeaderView *headerView;

@end

@implementation ActivityRulesViewController
static NSString *const kCommentTableViewCell = @"CommentTableViewCell";


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kEventDetails];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kEventDetails];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTitleViewWithString:@"活动详情"];
    _commentArrayM = @[].mutableCopy;
    _numberArratM = @[].mutableCopy;
    
    [self.view addSubview:self.tableView];
    self.headerView = [[ActivityRulesHeaderView alloc]initWithFrame:CGRectMake720(0, 0, 720, 832 + 466)];
    
    self.tableView.tableHeaderView = self.headerView;
    
    ActivityRulesFooterView *footerView = [[ActivityRulesFooterView alloc]initWithFrame:self.view.bounds];
    footerView.height = footerView.dynamicHeight;
    self.tableView.tableFooterView = footerView;
    
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:kCommentTableViewCell];
    
    [self getData];
    [self getCommentDataSource];
    // Do any additional setup after loading the view.
}
#pragma mark --- interface
/** 获取任务的基本数据*/
- (void)getData {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([self.activityId isExist]) {
       [param  setObject:self.activityId forKey:@"taskId"]; 
    }
    
    [QDHttpTool getWithURL:kUrl_TaskGetTaskDetail params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        ActivityModel *model = [ActivityModel mj_objectWithKeyValues:[responseObject valueForKey:@"taskDetail"] ];
        _numberArratM = [RuleJoinModel mj_objectArrayWithKeyValuesArray:[responseObject[@"taskDetail"] valueForKey:@"members"] ];
        self.headerView.activityModel = model;
        //self.headerView.numberArrayM = _numberArratM.mutableCopy;
        [self.headerView setPersonImageViewWithArray:_numberArratM];
        if (_numberArratM.count == 0) {
            self.headerView.height = 832*SizeScale;
            self.tableView.tableHeaderView = self.headerView;
        } else if (_numberArratM.count <= 5) {
            self.headerView.height = (832 + 270)*SizeScale;
            self.tableView.tableHeaderView = self.headerView;
        }
    } failure:^(NSError *error) {

    }];

}
/** 获取活动评价的数据*/
- (void)getCommentDataSource {
    if (![self.activityId isExist]) {
        self.activityId = @"";
    }
    //self.activityId = @"5";
    //查询评价    status：1好评，2中评，3差评，4图，0也可为空    type:2为商品评价，1为活动评价
    NSMutableDictionary *brandParam = [NSMutableDictionary dictionary];
    if ([self.activityCommentId isExist]) {
        [brandParam setObject:@"1" forKey:@"type"];
        [brandParam setObject:self.activityCommentId forKey:@"modelId"];
        [brandParam setObject:@"0" forKey:@"start"];
        [brandParam setObject:@"0" forKey:@"status"];
    }
    
//    NSDictionary *brandParam = @{@"type":@"1",
//                                 @"modelId":self.activityCommentId,
//                                 @"start":@"0",
//                                 @"status":@"0"};
    [QDHttpTool getWithURL:kUrl_getComment params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        
        if (!isSuccess) {
            return ;
        }
        //计算好评率
        _commentCount = [responseObject valueForKey:@"totalComment"];
        NSInteger goodCount = [[responseObject valueForKey:@"goodComment"] floatValue];
        NSString *rate = [NSString stringWithFormat:@"%.2f",goodCount/[_commentCount floatValue]];
        _goodRate = [NSString stringWithFormat:@"%.0f%%",[rate floatValue]*100];
        
        NSArray *commentArray = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (commentArray.count == 0) {
            return ;
        }
        [_commentArrayM addObjectsFromArray:commentArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- super method
- (void)clickBackBtn {
    
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_commentArrayM.count == 0) {
        return 0;
    }
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentTableViewCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.model = _commentArrayM[0];
        cell.isActivity = YES;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake720(239, 18, 242, 33)];
        imageView.image = [UIImage imageNamed:@"comment_click_more_image"];
        [cell addSubview:imageView];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 70*SizeScaleSubjectTo720;
    }
    CommentUtil *util = [[CommentUtil alloc]init];
    util.model = _commentArrayM[0];
    return util.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( indexPath.row == 1) {
        ActivityCommentViewController *vc = [[ActivityCommentViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.commentArray = _commentArrayM.copy;
        vc.totalComment = _commentCount;
        vc.goodRate = _goodRate;
        vc.activityId = self.activityCommentId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 88)];
    bgView.backgroundColor = [UIColor blackColor];
    UILabel *countLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 0, 370, 88) title:[NSString stringWithFormat:@"活动评价(%@)",_commentCount] titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:28];
    [bgView addSubview:countLabel];
    
    UILabel *scaleLabel = [UILabel qd_labelWithFrame:CGRectMake720(396, 0, 290, 88) title:[NSString stringWithFormat:@"好评率%@",_goodRate] titleColor:UIColorFromRGB_16(0x35a4da) textAlignment:NSTextAlignmentRight font:22];
    [bgView addSubview:scaleLabel];
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)  section {
    if (_commentArrayM.count == 0) {
        return 0;
    }
    return 88*SizeScale;
}
#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.height = self.view.height - 64;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor blackColor];
        //_tableView.sectionHeaderHeight = 88*SizeScaleSubjectTo720;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
