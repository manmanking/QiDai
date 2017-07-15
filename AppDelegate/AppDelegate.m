//
//  AppDelegate.m
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarControllerConfig.h"
#import "DBManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import <MeiQiaSDK/MQManager.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "QDHttpTool.h"
#import "PromptUpdateView.h"
#import "MJExtension.h"
#import "SportTaskModel.h"
#import "UserInfoDBManager.h"
#import "SportDataBaseManager.h"
#import "SportModel.h"
#import "UploadFileManager.h"
#import "SynchronizeRidingRecordManager.h"
#import "DBManager.h"
#import "ItemDataBaseManager.h"
#import "HistoryManager.h"
#import "PublicTool.h"
#import "GuideView.h"
#import "Masonry.h"
#import "PaymentManager.h"


@interface AppDelegate ()<WXApiDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSArray *tableViewDataSourceArr;
@property (nonatomic,strong) NSArray *tableViewDataSourceChineseArr;


@property (nonatomic,strong) UITableView *tableView;



@end


static NSString *tableViewCellIdentifyStr = @"tableViewCellIdentifyStr";


@implementation AppDelegate



- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UmengAppkey;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.secret = @"secretstringaldfkals";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //同步数据库文件
    [DBManager syschronizeDBFile];
    
    [SportDataBaseManager addColumnTable:@"SportData" AndColumnName:@"ridingName"];
   
    
    /**
     *
     #define HostAndPort @"http://qdap.q7bike.com/q7bike/mall" //--正式服  青岛
     
     //http://59.110.0.231/
     //#define HostAndPort @"http://apqdtest-temp.q7bike.com/q7bike/mall" //--外网临时  北京外网正式服务器  临时
     
     //http://10.0.0.11:8085/
     //#define HostAndPort @"http://10.0.0.11:8085/q7bike/mall"   //测试服务器 windows
     
     //http://192.168.1.114:8083/
     //#define HostAndPort @"http://192.168.1.116:8083/q7bike/mall"  //内网服务器
     
     //http://apqdtest-temp.q7bike.com
     
     
     #define HostAndPort @"http://101.201.120.189:8080/q7bike/mall"   //北京测试服务器  linux
     */
    
    
    self.tableViewDataSourceChineseArr = @[@"IP地址选择",
                                    @"正式服务器",
                                    @"本地测试服务器",
                                    @"北京测试服务器"];
    self.tableViewDataSourceArr = @[@"IP地址选择",
                                    @"http://qdap.q7bike.com",
                                    @"http://10.0.0.11:8085",
                                    @"http://101.201.120.189:8080"];
    
    
    //判断是否有骑行名称，如果没有则添加，默认值为0 类型字符型 长度小于16
    
    //1是开启 开始bug调节
    [kNSUSERDEFAULE setObject:[NSNumber numberWithInteger:1] forKey:kOpenDebug];
    
   
    
    [[AMapServices sharedServices] setApiKey:kGAODELBS_KEY];
    
    #pragma mark --- 分享有关
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    [self umengTrack];
    
    
    //打开调试log的开关
    //[UMSocialData openLog:YES];
    

    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WEIXIN_KEY appSecret:@"07fc2a568fb5dabaeb2ea356aa44eb7c" url:@"http://www.umeng.com/social"];
    
    //[WXApi registerApp:@"wx35e1aa6c867f5356"];
    
    // 打开新浪微博的SSO开关wb2094968841
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2094968841"
                                              secret:@"8cea8ff65069c33762bc7e6341393f6b"
                                         RedirectURL:@"http://api.weibo.com/oauth2/default.html"];

    //100424468
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104369944" appKey:@"WwvQN8mogHLlpvqH" url:@"http://www.umeng.com/social"];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //#pragma mark --- 美恰
    [MQManager initWithAppkey:@"23fdf68d19eece2b25da76f8a6b6b808" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            //NSLog(@"error:%@",error);
        }
    }];
   
    
   
    // start of line
    // 将检测任务 放在骑行页面
    
    //[self checkWhetherJoinActivity];
    
    
    // end of line
    
    //[self testingHaveNotNploadData];
    
    
   
    
    
    // modify by manman  start of line

    
    TabBarControllerConfig *tabBarControllerConfig = [[TabBarControllerConfig alloc] init];
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    
    [self.window makeKeyAndVisible];
    
    //设置tabbar的一些属性
    [self customizeInterfaceTabbar];
    
    // end of line
    
    
    // add by manman on 2016-10-14  start of line
    //引导页
    if (![kNSUSERDEFAULE boolForKey:kGUIDEISFIRSTSHOW]) {
        GuideView *guideView = [[NSBundle mainBundle] loadNibNamed:@"GuideView" owner:self options:nil][0];
        [kGetKeyWindow addSubview:guideView];
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    // end of line
    
    [UserInfoDBManager deleteExpiredUserSportDataWithUserId:kUserId];
    [self registerWeChat];
    
    //[[NSUserDefaults standardUserDefaults] setObject:@"nice day" forKey:NewIP];
//    [[UIApplication sharedApplication].delegate canOpenUrl:"QiDai"];
    
#warning ---检测更新
    
    if (!QDDEBUG) {
        [self checkUploadAppVersion];
    }
    
    if (QDChoiceSevice) {
        [self choiceSeviceUIViewAutolayout];
    }
    
    
    
    return YES;
}




/**
 *  服务器 选择设置 界面
 */
- (void)choiceSeviceUIViewAutolayout
{
    if (QDChoiceSevice) {
        [kGetKeyWindow addSubview:self.tableView];
    }
    
}


// 微信支付c  注册
- (void)registerWeChat
{
    
    //wx35e1aa6c867f5356
    BOOL isSuccess = [WXApi registerApp:kWeChatAPPID withDescription:@"微信支付"];
    NSLog(@"isSuccess %@",isSuccess == YES ?@"yes":@"no");
}




- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //App 进入后台时，关闭美洽服务
    [MQManager closeMeiqiaService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //App 进入前台时，开启美洽服务
    [MQManager openMeiqiaService];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)resetDefaultParameter
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kLoginSuccessUpdateTaskHome];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kAddTaskSuccessUpdateTaskHome];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kAddTaskSuccessUpdateSportHome];
    
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [MobClick profileSignOff];
    [self resetDefaultParameter];
}




#pragma mark --- private method
//检测是否参加了活动
- (void)checkWhetherJoinActivity {
    
    if (![kNSUSERDEFAULE boolForKey:kGUIDEISFIRSTSHOW]) {
        [kNSUSERDEFAULE setValue:@"0" forKey:kHaveTask];
    }
    
    NSDictionary *params = @{@"userId":kUserId};
    [QDHttpTool getWithURL:kUrl_getDTRidingRecord params:params success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        if (!isSuccess) {
            [kNSUSERDEFAULE setValue:@"0" forKey:kHaveTask];
            return ;
        }
        NSArray *array = [SportTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
        if (array.count == 0) {
            [kNSUSERDEFAULE setValue:@"0" forKey:kHaveTask];
            return;
        } else {
            // modify by manman start of line
            // 任务保存在本地
//            SportTaskModel *model = array[0];
//            [kNSUSERDEFAULE setValue:@"1" forKey:kHaveTask];
//            [kNSUSERDEFAULE setValue:model.distanceDay forKey:kTaskDistanceDay];
//            [kNSUSERDEFAULE setValue:model.distancePerDay forKey:kTaskDistancePerDay];
//            [kNSUSERDEFAULE setValue:model.information forKey:kTaskInformation];
            
           
            
            SportTaskModel *model = array[0];
            [kNSUSERDEFAULE setValue:@"1" forKey:kHaveTask];
            NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
            [kNSUSERDEFAULE setValue:modelData forKey:kTaskModelInfo];

            
            // end of line
        }
        
    } failure:^(NSError *error) {
        //modify by manman   on 2016-10-13 start of line
        // 网络异常时 显示前一次的任务
        BOOL isSuccess = [self verifyTaskExpried];
        if (isSuccess)[kNSUSERDEFAULE setValue:@"1" forKey:kHaveTask];
        else [kNSUSERDEFAULE setValue:@"0" forKey:kHaveTask];
        
        // end of line
    }];

}

- (BOOL)verifyTaskExpried
{
    NSData *sportTaskModelData = [kNSUSERDEFAULE valueForKey:kTaskModelInfo];
    SportTaskModel *sportTaskModel = [NSKeyedUnarchiver unarchiveObjectWithData:sportTaskModelData];
    if (sportTaskModel == nil) return NO;
    NSString *currentDateStr = [PublicTool getCurrentTimeStrFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateformat dateFromString:sportTaskModel.startTime];
    NSDate *endDate = [dateformat dateFromString:sportTaskModel.finishTime];
    NSDate *currentDate = [dateformat dateFromString:currentDateStr];

    NSComparisonResult resultCompareSartDate = [startDate compare:currentDate];
    NSComparisonResult resultCompareEndDate = [endDate compare:currentDate];
    if (resultCompareSartDate == NSOrderedAscending && resultCompareEndDate == NSOrderedDescending) return YES;
    return NO;
    
}



//检测版本更新
- (void)checkUploadAppVersion {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSDictionary *param = @{@"version":appVersion,
                            @"apptype":@"11"};
    [QDHttpTool getWithURL:kUrl_checkUpdAppVersion params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"checkUploadAppVersion %@",responseObject);
        if (isSuccess) {
            if ([[responseObject[@"data"] valueForKey:@"update"]  isEqual: @0]) {
                NSLog(@"不需要更新");
            } else if ([[responseObject[@"data"] valueForKey:@"update"]  isEqual: @1]) {
                NSLog(@"建议更新");
                
                [self updateUIViewAutolayout:responseObject];
                
            } else if ([[responseObject[@"data"] valueForKey:@"update"]  isEqual: @2]) {
                NSLog(@"强制更新");
                [self updateUIViewAutolayout:responseObject];
            }
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateUIViewAutolayout:(NSDictionary *) responseObject
{
    
    PromptUpdateView *updateView = [[PromptUpdateView alloc]initWithFrame:kGetKeyWindow.bounds];
    updateView.updateTypeStr = [responseObject[@"data"] valueForKey:@"update"];
    updateView.titleStr = [responseObject[@"data"] valueForKey:@"version"];
    updateView.detailStr = [responseObject[@"data"] valueForKey:@"desc"];
    
    updateView.clickUploadBlock = ^ {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_downloadapp(kAPPID)]];
    };
    [kGetKeyWindow addSubview:updateView];
    
    
}



/**检测有无没上传的数据 */
- (void)testingHaveNotNploadData {
    
    //需要上传sportModel的数据
    NSMutableArray *needUploadArray = @[].mutableCopy;
    //需要上传点zip的数据
    NSMutableArray *needUploadDetailArray = @[].mutableCopy;
    
    HistoryManager *dataManager = [[HistoryManager alloc] init];
    //[dataManager loadMonthSportDataWithPageIndex:0];
    
    NSArray *sportArray = [NSArray arrayWithArray:[dataManager loadMonthSportDataWithPageIndex:0]];
    if (sportArray.count == 0) {
        
    }else {
        for (SportModel *model in sportArray) {
            if (model.upload == 0) {
                [needUploadArray addObject:model];
            }
            
            if (model.uploadDetail == 0) {
                [needUploadDetailArray addObject:model];
            }
        }
    }
    
    if (needUploadArray.count == 0) {
        NSLog(@"没有需要上传的数据");
    } else {
        for (SportModel *model in needUploadArray) {
            
            [SynchronizeRidingRecordManager uploadRidingRecord:model pictureArray:nil success:^(NSDictionary *result) {
                //更新本地数据库的model上传状态
                [SportDataBaseManager updateUpLoadStatusWithUserId:model.uId sportId:model.sId];
                
            } failure:^{
                
            }];
            
        }
    }
    
    if (needUploadDetailArray.count == 0) {
        NSLog(@"没有需要上传的zip");
    } else {
        
        for (SportModel *model in needUploadArray) {
            
            [UploadFileManager zipAndUploadItemFileWithFileName:model.sId success:^{
                //更新本地数据库的zip上传状态
                [SportDataBaseManager updateUpLoadDetailStatusWithUserId:model.uId sportId:model.sId];
                
            } failure:^{
                
            }];
            
        }
        
        
    }
}

#pragma mark --- alipay callBack  以废弃

//- (void)aliPayCallBackWithUrl:(NSURL *)url {
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService]
//         processOrderWithPaymentResult:url
//         standbyCallback:^(NSDictionary *resultDic) {
//             NSLog(@"do what you want with result --\n resullt %@", resultDic);
//             //[[NSNotificationCenter defaultCenter] postNotificationName:kAliPaySuccessNotification object:nil];
//             
//             if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
//                 [[NSNotificationCenter defaultCenter] postNotificationName:kAliPaySuccessNotification object:nil];
//                 
//             }else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"6001"]){
////                 [SVProgressHUD showErrorWithStatus:@"中途取消支付，请到订单界面完成支付"];
////                 NSTimer*  disMissTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dismissSVHUD) userInfo:nil repeats:NO];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:kAliPayFailureNotification object:nil];
//             }else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"4000"]){
////                 [SVProgressHUD showErrorWithStatus:@"订单支付失败,请到订单界面完成支付"];
//
//             }
//             
//         }];
//    }
//    
//    if ([url.host isEqualToString:@"platformapi"]) {
//        [[AlipaySDK defaultService]
//         processAuthResult:url
//         standbyCallback:^(NSDictionary *resultDic) {
//             NSLog(@"do what you want with result --\n result %@", resultDic);
//         }];
//    }
//}

// modify by manman


#pragma mark --- alipay callBack
- (void)aliPayCallBackWithUrl:(NSURL *)url {
    [[PaymentManager sharedManager] payAliPay:url];
  
}

//以废弃
//#pragma mark - WeiChatPayCallBack
//- (void)onResp:(BaseResp *)resp {
//    if ([resp.class isSubclassOfClass:[PayResp class]]) {
//        PayResp *response = (PayResp *)resp;
//        //根据不同状态做出不同处理
//        switch (response.errCode) {
//            case WXSuccess: {
//                NSLog(@"微信支付成功");
//            } break;
//            case WXErrCodeUserCancel: {
//                NSLog(@"微信支付取消");
//            } break;
//            case WXErrCodeSentFail: {
//                NSLog(@"微信支付失败%@",response.errStr);
//            } break;
//            default:
//                break;
//        }
//        
//        
//    }
//}


// end of line  
#pragma mark --- 友盟
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL isSuccess = [UMSocialSnsService handleOpenURL:url];
   [WXApi handleOpenURL:url delegate:self];
    if (isSuccess == FALSE) {
      
    }
    return isSuccess;
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        if ([sourceApplication isEqualToString:@"com.tencent.xin"]) [WXApi handleOpenURL:url delegate:[PaymentManager sharedManager]];
        else [self aliPayCallBackWithUrl:url];
    }
    return result;
    
    //return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
#pragma mark - iOS9.0及以上会在这个方法执行微信回调，之前的方法被舍弃
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
//    [self aliPayCallBackWithUrl:url];
//    [WXApi handleOpenURL:url delegate:self];
    //if ([sourceApplication hasPrefix:@"com.alipay"])
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        
        NSString *sourceApp = [options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"];
        NSLog(@"source app :%@",sourceApp);
        
        if ([sourceApp isEqualToString:@"com.tencent.xin"]) [WXApi handleOpenURL:url delegate:[PaymentManager sharedManager]];
            else [self aliPayCallBackWithUrl:url];
        
    }
    //return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    
    return YES;
}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}


/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}


#pragma mark --- private
/**
 *  tabBarItem 的选中和不选中文字属性、背景图片
 */
- (void)customizeInterfaceTabbar {
    
//    // 普通状态下的文字属性
//    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
//    
//    // 选中状态下的文字属性
//    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
//    
//    // 设置文字属性
//    UITabBarItem *tabBar = [UITabBarItem appearance];
//    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
    //[tabBar setImageInsets:UIEdgeInsetsMake(2, 0, -2, 0)];
    
    //@"Dispatch Queue 是什么呢？翻译过来就是执行处理的等待队列"
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_image"]];
    
    //[tabBarAppearance setBackgroundColor:[UIColor blackColor]];
    
    
    //tabBarController.tabBar.backgroundColor = UIColorFromRGB_10(35, 24, 21);
    //[[UITabBarItem appearance] setImageInsets:UIEdgeInsetsMake(2, 0, -2, 0)];
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nil;
    }
    return indexPath;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewDataSourceChineseArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifyStr];
    UILabel *ipLable = [[UILabel alloc]initWithFrame:CGRectMake750(0, 0,710, 44)];
    if (self.tableViewDataSourceMArr.count >= indexPath.row) {
        ipLable.text = _tableViewDataSourceChineseArr[indexPath.row];
        ipLable.textAlignment = NSTextAlignmentCenter;
        ipLable.textColor = [UIColor blackColor];
        
    }
    [cell.contentView addSubview:ipLable];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //#define HostAndPort @"http://101.201.120.189:8080/q7bike/mall"
    
    if (self.tableViewDataSourceMArr.count >= indexPath.row)
    {
        
        NSString *ipStr = [NSString stringWithFormat:@"%@/q7bike/mall",self.tableViewDataSourceMArr[indexPath.row]];
        [[NSUserDefaults standardUserDefaults] setObject:ipStr forKey:NewIP];
        [self.tableView removeFromSuperview];
        
    }
    
    
    
    
    
}




#pragma ------lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:MAIN_WINDOW.frame style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellIdentifyStr];
        
        
        
    }

    return _tableView;
    
}

- (NSArray *)tableViewDataSourceMArr
{
    if (!_tableViewDataSourceArr) {
        _tableViewDataSourceArr = [NSMutableArray arrayWithCapacity:5];
        
    }
    return _tableViewDataSourceArr;
}
@end
