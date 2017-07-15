//
//  SettingViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "SinaManager.h"
#import "QQManager.h"
#import "WeChatManager.h"
#import "SDImageCache.h"
#import "LoginManager.h"
#import "LoginViewController.h"
#import "OfflineDetailViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "UMSocial.h"
#import "SDImageCache.h"
#import "AlertViewManager.h"
#import "AddressViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_imageArray;
    NSArray *_textArray;
}

@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic) NSString *offlineStr;
@end

static NSString *const kSettingTableViewCell = @"SettingTableViewCell";

@implementation SettingViewController
#pragma mark --- cycle life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    [self creatTitleViewWithString:@"设置"];
    
    _textArray = @[@"收货地址管理",@"离线地图",@"清除缓存",@"评价APP",@"意见反馈",@"关于骑待"];
    _imageArray = @[@"ShopUpdateStoreDetailPositionImageView",@"OfflineMaps",@"userinfo_clear",@"evaluate",@"feedback",@"AboutUs"];
    
    [self.view addSubview:self.tableView];
    
    UIButton *footerBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 60, 720, 120) title:@"退出登录" titleColor:[UIColor whiteColor] titleFont:28 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
        [self clickLogOutBtn:self];
    }];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 700)];
    footerView.backgroundColor = UIColorFromRGB_16(0x171717);
    [footerView addSubview:footerBtn];
    self.tableView.tableFooterView = footerView;

    // Do any additional setup after loading the view.
}
- (void)clickLogOutBtn:(id)sender {
    switch ([[LoginManager instance] LoginTypeStatus]) {
          
            
        case telephoneType:
        {
            [[LoginManager instance] telephoneLogout];
            // modify by manman on 2016-09-14 BUG 133 start of line
            //[self showLoginViewController];
            [self showLoginViewControllerWithTransferMainWindows:YES];
            
            // end of line
            break;
        }
        case sinaType:
        {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response is %@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                     [self showLoginViewControllerWithTransferMainWindows:YES];
                    //[self showLoginViewController];
                }
            }];
            [[SinaManager instance] sinaLogout];
            
            break;
        }
        case qqType:
        {

            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response is %@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self showLoginViewControllerWithTransferMainWindows:YES];
                    //[self showLoginViewController];
                }
            }];
            [[QQManager instance] qqLogout];
            
            break;
        }
        case weChatType:
        {
            
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response is %@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self showLoginViewControllerWithTransferMainWindows:YES];
                    //[self showLoginViewController];
                }
            }];
            [[WeChatManager instance] weChatLogout];
            
            break;
        }
        case errType:
            [self showLoginViewControllerWithTransferMainWindows:YES];
            //[self showLoginViewController];
            break;
        default:
            break;
    }
    [MobClick profileSignOff];
    
}
//- (void)showLoginViewController {
//    LoginViewController *vc = [[LoginViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
//}
/** 清除图片缓存*/
- (void)clickClearImageCache {
    [[AlertViewManager instance] showAlertView:@"您是否要清除缓存" withMessage:@"删除缓存包括下载的图片数据等" withFirstBtnAction:^{
        
    } withSecondBtnAction:^{
        float tmpSize = [ [SDImageCache sharedImageCache] getSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize/1024] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize ];
        NSLog(@"%@",clearCacheName);
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
        
        NSLog(@"clear disk");
        
        float tmpSize1 = [ [SDImageCache sharedImageCache] getSize];
        NSLog(@"--%f",tmpSize1);
        [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"清理成功"];
    }];
}

#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //if (section == 0) {
     //   return 1;
   // }
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTableViewCell];
    if (!cell) {
        cell = [[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingTableViewCell];
    }
//    if (indexPath.section == 0) {
//        [cell setupCellWithImage:@"OfflineMaps" text:@"离线地图"];
//    } else {
//        
//    }
    [cell setupCellWithImage:_imageArray[indexPath.row] text:_textArray[indexPath.row] ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12 * SizeScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 12)];
    view.backgroundColor = UIColorFromRGB_16(0x171717);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
    // 收获地址管理
        AddressViewController *vc = [[AddressViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.whereFromFlagStr = kWHEREFROMSETTINGVIEW;
        //vc.addressArrayM = _personalAddressMArr.mutableCopy;
        //vc.delegate = self;
        //vc.addressPage = _addressPage;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.row == 1)
    {
        OfflineDetailViewController *vc = [[OfflineDetailViewController alloc]init];
        vc.isBackBtnShow = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else if (indexPath.row == 2)
    {
         [self clickClearImageCache];
    }
    else if (indexPath.row == 3)
    {
        //评论app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_appstore(kAPPID)]];
    }
    else if (indexPath.row == 4)
    {
        FeedbackViewController *vc = [[FeedbackViewController alloc]init];
        vc.isBackBtnShow = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5) {
        AboutViewController *vc = [[AboutViewController alloc]init];
        vc.isBackBtnShow = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110*SizeScaleSubjectTo720;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
