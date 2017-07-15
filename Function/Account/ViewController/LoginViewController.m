//
//  LoginViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/5.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LoginView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "RegistViewController.h"
#import "ResetViewController.h"
#import "QDHttpTool.h"
#import "NSString+Encryption.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "LoginManager.h"
#import "UserInfoDBManager.h"
#import "QQManager.h"
#import "WeChatManager.h"
#import "SinaManager.h"
#import "SportDataBaseManager.h"
#import "SynchronizeRidingRecordManager.h"
#import "UploadFileManager.h"
@interface LoginViewController ()<LoginViewDelegate>
{
    TPKeyboardAvoidingScrollView *_scrollView;
}
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 键盘管理
    _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    // 视图的定制 通过代理 传递事件或者传值
    LoginView *loginView = [[LoginView alloc]initWithFrame:CGRectMake720(0, 0, 720, 1280)];
    loginView.delegate = self;
    [_scrollView addSubview:loginView];
    
    if ([PublicTool isIphone4]) {
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(0, loginView.height);
    }
    
    // Do any additional setup after loading the view.
}

#pragma mark --- private method
-(void)initRelateData{
    NSLog(@"同步数据");
    NSString *userId = [[LoginManager instance] getUserId];
    //同步数据 加载所有的本帐号数据
    if ([SportDataBaseManager getTotalTimesWithUserId:userId]==0) {
        
        [SynchronizeRidingRecordManager loadAllRidingRecordWithUserId:userId
                                                              success:^(NSArray *dataList) {
                                                                  if ([dataList count]>0) {
                                                                      [SportDataBaseManager insertSportDataArray:dataList];
                                                                  }
                                                              }
                                                              failure:^{
                                                                  
                                                                  
                                                              }];
        
    }
    
    // 创建帐号文件夹
    [UploadFileManager createUserFolder:userId];
    
    
}

#pragma mark --- LoginView delegate
- (void)clickBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRegisterBtn {
    RegistViewController *vc = [[RegistViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickForgetPasswordBtn {
    ResetViewController *vc = [[ResetViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


// 手机号登录
- (void)clickLoginBtnWithPhone:(NSString *)phone password:(NSString *)password {
    if (![phone isMobileNumberClassification]) {
        //NSLog(@"请输入正确的手机号");
        [[MBProgressHUDManager instance]showTextOnlyWithView:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.view];
    //请求后台验证  本地存储
    [[LoginManager instance] telePhoneLoginWithTelephone:phone withPassword:password compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
        if (isSuccess) {
            //[[MBProgressHUDManager instance]showTextOnlyWithView:self.view withText:@"登录成功"];
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kREFRESHDATA_NOTIFICATION object:nil];
            //modify by manman BUG 133 start of line
             QDLog(@"主页面Phone 2%@",_isMain == YES ?@"是":@"否");
            if (_isMain == YES)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
                tab.selectedIndex = 0;
                
                
                
            }else
            {
                [self dismissViewControllerAnimated:YES completion:nil];// 本页面将消失
            }
            
            
            // end of line
            
            
            // add by manman on 2016-10-10 start of line
            //友盟的帐号统计
            [MobClick profileSignInWithPUID:@"playerID"];
            
            // end of line
            
            //add by manman  on 2016-10-17 start of line
            // 登录成功  点击任务页面需刷新
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateTaskHome];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateSportHome];
            
            
            // end of line
            
            [self initRelateData];
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:errStr ];
        }
    }];
    
}

- (void)clickQQBtn {
    
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeMobileQQ];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            //NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);            
            NSDictionary *dict = @{@"usid":snsAccount.usid,
                                   @"nickname":snsAccount.userName,
                                   @"iconURL":snsAccount.iconURL,
                                   @"accessToken":snsAccount.accessToken,
                                   @"expirationDate":snsAccount.expirationDate};
             //NSLog(@"dic:%@",dict);
            [[QQManager instance] qqLoginWithResponse:dict compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kREFRESHDATA_NOTIFICATION object:nil];
                    //modify by manman BUG 133 start of line
                    if (_isMain == YES)
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
                        tab.selectedIndex = 0;
                        
                        
                        
                    }else
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];// 本页面将消失
                    }
                    
                    // end of line
                    [MobClick profileSignInWithPUID:@"playerID" provider:@"QQ"];
                    //add by manman  on 2016-10-17 start of line
                    // 登录成功  点击任务页面需刷新
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateTaskHome];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateSportHome];
                    
                    // end of line
                    
                    [self initRelateData];
                }
            }];
            
        }});
}


- (void)clickWeChatBtn {
    
    //[UMSocialData setAppKey:UmengAppkey];

    //[UMSocialWechatHandler setWXAppId:@"wx35e1aa6c867f5356" appSecret:@"07fc2a568fb5dabaeb2ea356aa44eb7c" url:@"http://www.umeng.com/social"];
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeWechatSession];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            //NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            NSDictionary *dict = @{@"usid":snsAccount.usid,
                                   @"nickname":snsAccount.userName,
                                   @"iconURL":snsAccount.iconURL,
                                   @"accessToken":snsAccount.accessToken,
                                   @"expirationDate":snsAccount.expirationDate};
            //NSLog(@"dic:%@",dict);
            [[MBProgressHUDManager instance] sendRequestShowHUD:kGetKeyWindow];
            [[WeChatManager instance] weChatLoginWithResponse:dict compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
                if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kREFRESHDATA_NOTIFICATION object:nil];
                    //modify by manman BUG 133 start of line
                    if (_isMain == YES)
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
                        tab.selectedIndex = 0;
                        
                        
                        
                    }else
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];// 本页面将消失
                    }
                    
                    // end of line
                    
                    [MobClick profileSignInWithPUID:@"playerID" provider:@"WC"];
                    //add by manman  on 2016-10-17 start of line
                    // 登录成功  点击任务页面需刷新
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateTaskHome];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateSportHome];
                    
                    // end of line
                    
                    [self initRelateData];
                }
            }];
        }
        
    });
}

//- (void)test
//{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//       
//        response.thirdPlatformUserProfile 
//    });
//    
//    
//}

- (void)clickSinaBtn {
    //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeSina];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    QDLog(@"主页面Sina 1 %@",_isMain == YES ?@"是":@"否");
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
         QDLog(@"主页面Sina2 %@",_isMain == YES ?@"是":@"否");
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            
            NSDictionary *dict = @{@"usid":snsAccount.usid,
                                   @"nickname":snsAccount.userName,
                                   @"iconURL":snsAccount.iconURL,
                                   @"accessToken":snsAccount.accessToken,
                                   @"expirationDate":snsAccount.expirationDate};
            //NSLog(@"dic:%@",dict);
            [[SinaManager instance] sinaLoginWithResponse:dict compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kREFRESHDATA_NOTIFICATION object:nil];
                     QDLog(@"主页面Sina 3%@",_isMain == YES ?@"是":@"否");
                    //modify by manman BUG 133 start of line
                    if (_isMain == YES)
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
                        tab.selectedIndex = 0;
                        
                        
                        
                    }else
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];// 本页面将消失
                    }
                    
                    // end of line
                    [MobClick profileSignInWithPUID:@"playerID" provider:@"WB"];
                    
                    //add by manman  on 2016-10-17 start of line
                    // 登录成功  点击任务页面需刷新
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateTaskHome];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kLoginSuccessUpdateSportHome];
                    
                    // end of line
                    
                    [self initRelateData];
                }
            }];
            
        }});
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
