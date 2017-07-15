//
//  TaskDetailViewController.m
//  QiDai
//
//  Created by manman'swork on 16/11/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TaskStandardView.h"
#import "ActivityRulesViewController.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "TaskStandardVerifyResultView.h"
#import "TaskRuleViewController.h"
#import "MMKCalendarView.h"
#import "OverTaskModel.h"
#import "UIImage+Tools.h"
#import "UIImageView+WebCache.h"
#import "OngoingTaskModel.h"
#import "UnstartTaskModel.h"
#import "HttpTaskHomeManager.h"
#import "NewTaskDetailModel.h"
#import "RedingRecordDateInfoModel.h"



@interface TaskDetailViewController ()<UMSocialUIDelegate>

@property (nonatomic,strong)TaskStandardView *taskStandardView;

@property (nonatomic,strong) MMKCalendarView *calendarView;

@property (nonatomic,strong) NewTaskDetailModel *taskDetailViewModel;

@property (nonatomic,strong) NSArray *redingRecordDateInfoArr;

@property (nonatomic,strong)UIImageView *shareUserHeaderImageView;

@property (nonatomic,strong)UIImageView *shareMyOutfitOfBikeInfoImageView;

@property (nonatomic,strong)UIImageView *shareBottomView;

@property (nonatomic,strong) UIImage *shareImage;


//
//@property (nonatomic,strong) NSArray *overTaskArr;
//@property (nonatomic,strong) NSArray *unstartTaskArr;
//@property (nonatomic,strong) NSArray *ongoingTaskArr;




@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationView];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.taskStandardView];
    [self.view addSubview:self.calendarView];
    
    [self getTaskDeatailDataSources];
    
    
}


- (void)setupNavigationView {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    [self creatTitleViewWithString:@"挑战详情"];
    [self creatShareBtn];
    
}

- (void)creatShareBtn {
    UIButton *shareBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(670, 65, 31, 36) NormalImageString:@"task_share_btn" tapAction:^(UIButton *button) {
        [self clickShareBtn];
    }];
    [shareBtn setEnlargeEdge:10*SizeScale];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
}





- (void)getTaskDeatailDataSources
{
     [[MBProgressHUDManager instance] sendRequestShowHUD:self.view];
    //8a237a345787ea230157ad71748101a7&taskDetailId=8oJr4YYn
    NSDictionary *requestparamater = @{@"userInfoId":kUserId,
                                       @"taskDetailId":_taskDetailId};
    // 测试
//    NSDictionary *requestparamater = @{@"userInfoId":@"8a237a345787ea230157ad71748101a7",
//                                       @"taskDetailId":@"8oJr4YYn"};
    
    
    [HttpTaskHomeManager netGetTaskDetaildataSources:requestparamater andSuccessResponse:^(BOOL isSuccess, NSDictionary *response) {
        NSLog(@"getTaskDeatailDataSources %@",response);
        
        if (isSuccess) {
            _taskDetailViewModel = response[@"taskDetail"];
            NSLog(@"overtask %@",_taskDetailViewModel.taskId);
            [self setTaskStandardViewDataSources:_taskDetailViewModel];
            _redingRecordDateInfoArr = [RedingRecordDateInfoModel mj_objectArrayWithKeyValuesArray:_taskDetailViewModel.record];
            [self.shareUserHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_taskDetailViewModel.foreImg]];
            [self.shareMyOutfitOfBikeInfoImageView sd_setImageWithURL:[NSURL URLWithString:_taskDetailViewModel.taskShareImage]];
            [self setCalendarViewDataSources];
            
            
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        
    } andFailureResponse:^(BOOL isSuccess, NSDictionary *response) {
        NSLog(@"getTaskDeatailDataSources %@",response);
        [[MBProgressHUDManager instance] requestSuccessWithMessage:response[@"errorMessage"]];
    }];
    
}



-(void)setTaskStandardViewDataSources:(NewTaskDetailModel *)detailModel
{
    _taskStandardView.overFlagStr = _overFlagStr;
    _taskStandardView.taskStandarTaskDetailModel = detailModel;
    
}


- (void)setCalendarViewDataSources
{
    _calendarView.taskDetailViewModel = [_taskDetailViewModel copy];
    _calendarView.dateInfoArr = [_redingRecordDateInfoArr copy];
   
    
}

- (void)clickShareBtn
{
    NSLog(@"点击 分享 按钮");
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:nil
                                     shareImage:self.shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
}


- (void)test
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake750(100, 480, 100, 50)];
    [button setTitle:@"任务" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(testButtonClick: andSelectedRedingRecordDateInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


-(void)testButtonClick:(NSString *)sender andSelectedRedingRecordDateInfo:(RedingRecordDateInfoModel *) selectedRedingRecordDateInfoModel
{
    TaskStandardVerifyResultView *testView = [[TaskStandardVerifyResultView alloc]initWithFrame:kGetKeyWindow.bounds];
    //testView.backgroundColor = [UIColor blackColor];
    testView.isSuccess = sender;
    testView.overFlagStr = _overFlagStr;
    testView.taskCategoryStr = _taskDetailViewModel.taskMainId;
    testView.completeStr = _taskDetailViewModel.complete;
    testView.distancePerDay = _taskDetailViewModel.distancePerDay;
    testView.resultRedingRecordDateInfoModel =  selectedRedingRecordDateInfoModel;

    
    
    [kGetKeyWindow addSubview:testView];
    
    
    
    
}


- (void)clickHelpButton
{
    
    TaskRuleViewController *taskRuleViewController = [[TaskRuleViewController alloc]init];
    
    //ActivityRulesViewController *activityRulesViewController = [[ActivityRulesViewController alloc]init];
    //vc.activityId
    //    if (_activityArrayM.count >= page) {
    //        ActivityModel *model = _activityArrayM[page];
    //        vc.activityId = model.taskDetailId;
    //        vc.activityCommentId = model.id;
    //    }
    taskRuleViewController.taskRuleModel = _taskDetailViewModel;
    taskRuleViewController.isBackBtnShow = YES;
    [self.navigationController pushViewController:taskRuleViewController animated:YES];

}





- (TaskStandardView *)taskStandardView
{
    if (!_taskStandardView) {
        _taskStandardView = [[TaskStandardView alloc]initWithFrame:CGRectMake750(20,10, 710,450)];
        @weakify_self
        _taskStandardView.clickHelpButtonAction = ^{
            // 点击帮助按钮
            @strongify_self
            [self clickHelpButton];
            
        };
    }
    return _taskStandardView;
    
}


- (MMKCalendarView *)calendarView
{
    if (!_calendarView) {
        _calendarView = [[MMKCalendarView alloc]initWithFrame:CGRectMake750(20, 480, 710,640)];
        @weakify_self
        _calendarView.selectedDate = ^(NSString *selectedDate,RedingRecordDateInfoModel *selectedRedingRecordDateInfoModel){
            @strongify_self
            if ([selectedDate isEqualToString:@"3"]) {
               NSLog(@"未达标");
            }else
            {
                [self testButtonClick:selectedDate andSelectedRedingRecordDateInfo:selectedRedingRecordDateInfoModel];
               
            }

        };
        
    }
    
    return _calendarView;
}

// 私有方法  测试
+ (UIImage *)getImageFromView: (UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)shareImage
{
    if (!_shareImage) {
    
        UIImageView *userInfoImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0, 0, 750, 423)];
        [userInfoImageView setImage:[UIImage imageNamed:@"ShareShowUserInfoAndLogoBackgroundViewNew"]];
        userInfoImageView.backgroundColor = [UIColor blackColor];
        [userInfoImageView addSubview:self.shareUserHeaderImageView];
//        
//        UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(646,0, 64, 64)];
//        logoImageView.image = [UIImage imageNamed:@""];
//
        UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake750(196,90,514,33)];
        userNameLabel.textAlignment = NSTextAlignmentLeft;
        userNameLabel.text = _taskDetailViewModel.nickName;
        userNameLabel.font = [UIFont systemFontOfSize:33*SizeScale750];
        userNameLabel.textColor = [UIColor whiteColor];
        [userInfoImageView addSubview:userNameLabel];
        
        UILabel *taskNameLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,200,710,80)];
        taskNameLabel.textAlignment = NSTextAlignmentCenter;
        NSString *taskNameStr = [NSString stringWithFormat:@"“%@”",_taskDetailViewModel.information];
        taskNameLabel.text = taskNameStr;// @"“秋季爱骑行运动耐力”";
        taskNameLabel.textColor = [UIColor whiteColor];
        taskNameLabel.font = [UIFont boldSystemFontOfSize:50*SizeScale750];
        [userInfoImageView addSubview:taskNameLabel];
        
        UIImage *detailImage = [UIImage imageFromView:self.view];
        
        
        
        UIImage *halfImage = [UIImage addImage:[UIImage imageFromView:userInfoImageView] toImage:detailImage];
        
        UIImage *thirdImage = [UIImage addImage:halfImage toImage:[UIImage imageFromView:self.shareMyOutfitOfBikeInfoImageView]];
        
        UIImage *resultImage = [UIImage addImage:thirdImage toImage:[UIImage imageFromView: self.shareBottomView]];
        _shareImage = resultImage;
    }
    
    return _shareImage;
}


- (UIImageView *)shareMyOutfitOfBikeInfoImageView{
    
    if (!_shareMyOutfitOfBikeInfoImageView) {
        _shareMyOutfitOfBikeInfoImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0, 0, 750, 545)];
        _shareMyOutfitOfBikeInfoImageView.backgroundColor = [UIColor blackColor];
        _shareMyOutfitOfBikeInfoImageView.image = [UIImage imageNamed:@"MyOutfitOfBikeInfoImageView"];
    }

    return _shareMyOutfitOfBikeInfoImageView;
    
    
}


#pragma 将图片 底色改为黑色

- (UIImageView *)shareBottomView
{
    
    if (!_shareBottomView) {
        _shareBottomView = [[UIImageView alloc]initWithFrame:CGRectMake750(0, 0,750, 150)];

        _shareBottomView.image = [UIImage imageNamed:@"ShareNewLogoBlackImageNew"];
        _shareBottomView.backgroundColor = [UIColor blackColor];
        
    }
    return _shareBottomView;
}



- (UIImageView *)shareUserHeaderImageView
{
    if (!_shareUserHeaderImageView) {
        _shareUserHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20, 20, 156, 156)];
        _shareUserHeaderImageView.layer.cornerRadius = 156*SizeScale750/2;
        _shareUserHeaderImageView.layer.borderColor = [[UIColor redColor]CGColor];
        _shareUserHeaderImageView.layer.borderWidth = 1.f;
        _shareUserHeaderImageView.layer.masksToBounds = YES;
        
    }
    
    
    return _shareUserHeaderImageView;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
