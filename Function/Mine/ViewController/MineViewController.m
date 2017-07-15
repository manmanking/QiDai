//
//  MineViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "MineViewController.h"
#import "UserInfoModel.h"
#import "NotLoginView.h"
#import "UserInfoView.h"
#import "MineFooterView.h"
#import "MineTableViewCell.h"
#import "MQChatViewManager.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "RankingViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"
#import "AccountTableViewController.h"
#import "MyOrdersViewController.h"
#import "UserInfoDBManager.h"
#import "SynchronizeRidingRecordManager.h"
#import "UserInfoManager.h"
static NSString *const kMineTableViewCell = @"MineTableViewCell";
//section之间的间隙
//static const CGFloat kSectionSpace = 18.0;

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,NotLoginViewDelegate,AccountTableViewControllerDelegate,UIScrollViewDelegate>

/** 没有登录的headerView*/
@property (nonatomic,strong) NotLoginView *notLoginView;
/** 登录成功的headerView*/
@property (nonatomic,strong) UserInfoView *userInfoView;

@property (nonatomic,strong) MineFooterView *footerView;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation MineViewController

#pragma mark --- lefe cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    if (![[LoginManager instance] isLogin]) {
        self.tableView.tableHeaderView = self.notLoginView;
    } else {
        self.tableView.tableHeaderView = self.userInfoView;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self refreshMineData];
    
    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMineData) name:kREFRESHDATA_NOTIFICATION object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSportData) name:kUPDATAHISTORY_NOTIFICATION object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark --- private method
- (void)refreshMineData {
    if (![[LoginManager instance] isLogin]) {
        self.tableView.tableHeaderView = self.notLoginView;
    } else {
        self.tableView.tableHeaderView = self.userInfoView;
        
        // 本地获得个人的基本信息
        UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:[[LoginManager instance] getUserId]];
        self.userInfoView.userInfoModel = userInfo;
        
        [self getNetworkData];
    }
    
    
}
- (void)refreshSportData {
    [self getNetworkData];
}
- (void)getNetworkData {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    [SynchronizeRidingRecordManager getAllRidingRecordWithUserId:[[LoginManager instance] getUserId] success:^(NSDictionary *dataList) {
        
        if ([[dataList valueForKey:@"distance"] floatValue] > 0.1) {
            self.userInfoView.distanceLabel.text = [NSString stringWithFormat:@"%.2f",[[dataList valueForKey:@"distance"] floatValue]/1000.0f];
        }else{
            self.userInfoView.distanceLabel.text = @"0.00";
        }
        self.userInfoView.durationLabel.text = [PublicTool getFormatTimeWithValue:(int)[[dataList valueForKey:@"time"] floatValue]];
        dispatch_group_leave(group);
    } failure:^{
        NSLog(@"请求总路程失败");
        dispatch_group_leave(group);
    }];

#warning   在本页面获取用户的基本信息 并保存到数据库  本次上线 不提交
    
    dispatch_group_enter(group);
    [self getUserBaseInfoFormNetwork];
     dispatch_group_leave(group);
    
    
}

/**
 *  获得用户的个人基本信息
 */
- (void)getUserBaseInfoFormNetwork
{
    [UserInfoManager saveUserBaseInfo:[[LoginManager instance] getUserId]];
    
    
}

//解决cell分割线的问题
//- (void)viewDidLayoutSubviews {
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero]; 
//    }
//}
#pragma mark --- AccountTableViewController Delegate
/** 由于修改了个人信息，所以刷新*/
- (void)refreshPersonalInformation {
    UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:[[LoginManager instance] getUserId]];
    self.userInfoView.userInfoModel = userInfo;
}
#pragma mark --- notLoginView Delegate
- (void)clickLoginBtn {
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)clickRegisterBtn {
    RegistViewController *vc = [[RegistViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark --- tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 2;
//    }
    return 6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineTableViewCell];
    
    if (cell == nil) {
        cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMineTableViewCell];
    }
//    if (indexPath.section == 0) {
//        cell.index = indexPath.row;
//    } else if (indexPath.section == 1) {
//        cell.index = 2;
//    } else {
//        cell.index = 3;
//    }
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (![[LoginManager instance] isLogin]) {
        [self clickLoginBtn];
        return;
    }
    
    if (indexPath.row == 0)
    {
        HistoryViewController *vc = [[HistoryViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.navigationController.navigationBarHidden = NO;
        vc.hidesBottomBarWhenPushed = YES;
        //[self creatRippleEffectTransitionAnimation];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else  if(indexPath.row ==1)
    {
        RankingViewController *vc = [[RankingViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.navigationController.navigationBarHidden = NO;
        vc.hidesBottomBarWhenPushed = YES;
        //[self creatOglFlipTransitionAnimation];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        MyOrdersViewController *vc = [[MyOrdersViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.navigationController.navigationBarHidden = NO;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3)
    {
        /**
         *  在线客服
         *
         *  @param 4
         *
         *  @return
         */
        
        UserInfoModel *userInfoModel = [UserInfoDBManager getUserInfoWithUserId:[[LoginManager instance] getUserId]];

        NSDictionary* clientCustomizedAttrs = @{@"name": userInfoModel.nickName,
                                                @"avatar": userInfoModel.foreImg
                                                };
        [MQManager setClientInfo:clientCustomizedAttrs completion:^(BOOL success, NSError *error) {
            
        }];
        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        [chatViewManager pushMQChatViewControllerInViewController:self];
        
        
    }
    else if (indexPath.row == 4)
    {
        /**
         *  电话咨询
         *
         *  @param 5
         *
         *  @return
         */
        
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:0106272571"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }
    else if (indexPath.row == 5)
    {
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.navigationController.navigationBarHidden = NO;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }


}




//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    }
//    return kSectionSpace * SizeScaleSubjectTo720;
//}
#pragma mark - 滑动tableView事件

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    NSLog(@"%f - %f",offsetY,588*SizeScale);
//    
//    // 这部分是用来解决图片放大的
//    if (offsetY > -HCDH) {
//        CGRect frame = self.userInfoView.bgImageView.frame;
//        frame.origin.y = offsetY;
//        frame.size.height = -offsetY + 588*SizeScale;
//        self.userInfoView.bgImageView.frame = frame;
//    }
    
}

#pragma mark --- private method

#pragma mark --- lazy load
- (NotLoginView *)notLoginView {
    if (!_notLoginView) {
        _notLoginView = [[NotLoginView alloc]initWithFrame:CGRectMake720(0, 0, 720, 606)];
        _notLoginView.delegate = self;
    }
    return _notLoginView;
}
- (UserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[UserInfoView alloc]initWithFrame:CGRectMake720(0, 0, 720, 588)];
        @weakify_self
        _userInfoView.clickIconBlock = ^ {
            @strongify_self
            AccountTableViewController *vc = [[AccountTableViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _userInfoView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.height -= 40;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.rowHeight = 110*SizeScaleSubjectTo720;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (MineFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[MineFooterView alloc]initWithFrame:CGRectMake720(0, 0, 720, 200)];
    }
    return _footerView;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
