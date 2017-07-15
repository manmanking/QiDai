//
//  SportHomePageViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/25.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportHomePageViewController.h"
#import "WeakGPSView.h"
#import "UserInfoDBManager.h"
#import "NoTaskHomePageView.h"
#import "TaskHomePageView.h"
#import "SportStartViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Sino.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "LocationManager.h"
#import "UploadFileManager.h"
#import "SportTaskModel.h"
#import "AlertViewManager.h"
#import "SportEndViewController.h"
#import "GuideView.h"
#import "QDCustomAlertView.h"
#import "Masonry.h"
#import "QDAlertView.h"
#import "PromptUpdateView.h"
@interface SportHomePageViewController ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

/** gps信号差的情况弹出*/
@property (nonatomic,strong) WeakGPSView *weakGPSView;
/** 定位有关的类*/
@property (nonatomic,strong) CLLocationManager *locationManager;
/** 逆地理编码有关的类*/
@property (strong, nonatomic) AMapSearchAPI *amapSearch;
/** 定时器,作用：定位坐标，获取当前经纬度和城市*/
@property (strong, nonatomic) NSTimer *timer;
/** 没有任务的视图*/
@property (nonatomic,strong) NoTaskHomePageView *noTaskHomePageView;
/** 有任务的视图*/
@property (nonatomic,strong) TaskHomePageView *taskHomePageView;
/** 弹框*/
@property (nonatomic,strong) QDAlertView *alertVIew;

@property (nonatomic,strong) QDAlertView *customAlertView;

@property (nonatomic,assign) BOOL isUpdate;

@property (nonatomic,strong)UIView *setIPBaseView;


@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SportHomePageViewController
{
    /** 任务的model的数组，来源：请求网络*/
    NSMutableArray *_dataArray;
    /** 任务的model，来源：请求网络*/
    SportTaskModel *_model;
}
#pragma mark --- life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
     QDLog(@"sport home animated :%@",[[NSUserDefaults standardUserDefaults] objectForKey:kAddTaskSuccessUpdateSportHome ]);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:kAddTaskSuccessUpdateSportHome ] isEqualToString:@"1"]
        ||[[[NSUserDefaults standardUserDefaults] valueForKey:kLoginSuccessUpdateSportHome ] isEqualToString:@"1"]
        ||[[[NSUserDefaults standardUserDefaults] valueForKey:refreshTaskUpdateHomeAndRedingHome] isEqualToString:@"1"]
        ||[[[NSUserDefaults standardUserDefaults] valueForKey:refreshSportHomeForSportEndSaveData] isEqualToString:@"1"])
    {
        [self verifyWhetherJoinActivity];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:kAddTaskSuccessUpdateSportHome ] isEqualToString:@"1"])
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kAddTaskSuccessUpdateSportHome];
        else
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kLoginSuccessUpdateSportHome];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:refreshTaskUpdateHomeAndRedingHome];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:refreshSportHomeForSportEndSaveData] isEqualToString:@"1"]) {
             [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:refreshSportHomeForSportEndSaveData];
        }
        
    }
    
    NSLog(@"IP %@",[[NSUserDefaults standardUserDefaults] objectForKey:NewIP]);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
//    QDLog(@"sport home animated :%d",[UIApplication sharedApplication].statusBarHidden);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isUpdate = YES;
    
    // modify by manman on 2016-10-14  start of line
    //引导页  放在这不合适 现在更改位置
    //引导页
//    if (![kNSUSERDEFAULE boolForKey:kGUIDEISFIRSTSHOW]) {
//        GuideView *guideView = [[NSBundle mainBundle] loadNibNamed:@"GuideView" owner:self options:nil][0];
//        [kGetWindow addSubview:guideView];
//        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//        }];
//    }
    
   
    //[self checkUploadAppVersion];
    
    
    // end of line
    _dataArray = @[].mutableCopy;

    // modify by manman on2016-09-30 start of line
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    
    
#warning 正在修改这个页面视图  start
//    if ([[kNSUSERDEFAULE valueForKey:kHaveTask] isEqualToString:@"0"]) {
//        [self.view addSubview:self.noTaskHomePageView];
//        [self creatTitleViewWithString:@"骑行"];
//    } else {
//        [self.view addSubview:self.taskHomePageView];
//        _model = [SportTaskModel new];
//        // add by manman  检测是否有未上传的数据 start of line
//        NSArray *existUploadDataArr =  [UserInfoDBManager verifySportDataExistWillUploadWithUserId:[[LoginManager instance] getUserId]];
//        if (existUploadDataArr.count>0) self.taskHomePageView.existUploadData = YES;
//        
//        // end of line
//        _model.distanceDay = [kNSUSERDEFAULE valueForKey:kTaskDistanceDay];
//        _model.distancePerDay = [kNSUSERDEFAULE valueForKey:kTaskDistancePerDay];
//        _model.information = [kNSUSERDEFAULE valueForKey:kTaskInformation];
//        
//        NSData *sportTaskModelData = [kNSUSERDEFAULE valueForKey:kTaskModelInfo];
//        _model = [NSKeyedUnarchiver unarchiveObjectWithData:sportTaskModelData];
//        
//        self.taskHomePageView.model = _model;
//    }
    // end of  line
    
#warning 正在修改这个页面视图  end
    
#warning 正在修改这个页面视图   替换上面的视图配置 start

    [self setupUIViewAutolayout];
    
#warning 正在修改这个页面视图   替换上面的视图配置 end
    
    self.locationManager = [LocationManager instance].locationManager;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
    [self.timer fire];
    
//给其他订不到位置的人，写的假数据，默认北京
//    [kNSUSERDEFAULE setValue:@"010" forKey:kFind_cityCode];
//    [kNSUSERDEFAULE setValue:@(116.3530892375852) forKey:kFind_longitude];
//    [kNSUSERDEFAULE setValue:@(40.01222535221645) forKey:kFind_latitude];
    // Do any additional setup after loading the view.
    
    //[self getSportData];
    
    //任务保存成功之后 刷新这个页面 进度条
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyWhetherJoinActivity) name:kUPDATAHISTORY_NOTIFICATION object:nil];
    
    
    //modify by manman on 2016-09-27 start of line
    // 用下面的 的方法代替这个方法
//    //判断是否有未完成的运动记录
//    if ([kNSUSERDEFAULE valueForKey:kSportData]) {
//        
//        [[AlertViewManager instance] showAlertView:@"您有未完成的运动记录" withMessage:@"是否保存" withFirstBtnAction:^{
//            [kNSUSERDEFAULE removeObjectForKey:kSportData];
//            [kNSUSERDEFAULE removeObjectForKey:kSportPoint];
//            [kNSUSERDEFAULE synchronize];
//        } withSecondBtnAction:^{
//            [self showSportEndViewController];
//        }];
//    }
    
    // end of line
    
    // add by manman on 2016-09-27 start of line
    /**
     *  更改 判断是否有未完成的运动记录 提示样式信息
     *
     */
    QDLog(@"custom %@",[kNSUSERDEFAULE valueForKey:kSportData]);
    //[self verifyWhetherExceptionSportData];
    
    // end of line
    
}

#pragma 将这个 添加 start


- (void)setupUIViewAutolayout
{
    
    // default there is no task
    [kNSUSERDEFAULE  setObject:@"0" forKey:kHaveTask];
    if ([[kNSUSERDEFAULE valueForKey:kHaveTask] isEqualToString:@"0"]) {
        [self.view addSubview:self.noTaskHomePageView];
        [self creatTitleViewWithString:@"骑行"];
    }
    [self verifyWhetherJoinActivity];
    
    
    
    
}

/**
 *  验证是否存在异常记录
 */
- (void)verifyWhetherExceptionSportData
{
    if ([kNSUSERDEFAULE valueForKey:kSportData])
    {
        //self.customAlertView = [[QDAlertView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.customAlertView];
        self.customAlertView.title = @"您有未完成的运动记录是否保存";//您有未完成的运动记录是否保存
        QDLog(@"into verifyWhetherExceptionSportData ...");
        self.customAlertView.sureBtnTitle = @"是";
        @weakify_self
        self.customAlertView.clickSureBlock = ^{
            @strongify_self
            [self showSportEndViewController];
        };
        
        self.customAlertView.cancleBtnTitle = @"否";
        self.customAlertView.rewriteCancleMethod = YES;
        
        self.customAlertView.clickCancleBlock  = ^
        {
            [kNSUSERDEFAULE removeObjectForKey:kSportData];
            [kNSUSERDEFAULE removeObjectForKey:kSportPoint];
            [kNSUSERDEFAULE synchronize];
        };
        [self.customAlertView updateUIAutolayout];
        
    }
    
    
}

//检测是否参加了活动
- (void)verifyWhetherJoinActivity {
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:kGetKeyWindow];
    NSDictionary *params = @{@"userId":kUserId};
    [QDHttpTool getWithURL:kUrl_getDTRidingRecord params:params success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"verifyWhetherJoinActivity %@",responseObject);
        NSArray *array = [SportTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
        if ([[responseObject valueForKey:@"code"]  isEqual: @"00"] && array.count>0 ) {
            SportTaskModel *model = array[0];
            [kNSUSERDEFAULE setValue:@"1" forKey:kHaveTask];
            NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
            [kNSUSERDEFAULE setValue:modelData forKey:kTaskModelInfo];
            [self.view addSubview:self.taskHomePageView];
            //self.taskHomePageView.model = model;
            
            
            self.taskHomePageView.existUploadData = NO;
            //检测本地数据是否有为上传的数据
            NSArray *existUploadDataArr =  [UserInfoDBManager verifySportDataExistWillUploadWithUserId:[[LoginManager instance] getUserId]];
            NSLog(@"userId%@",[[LoginManager instance] getUserId]);
            if (existUploadDataArr.count>0)
            {
                
                self.taskHomePageView.existUploadData = YES;
                // 计算今天的本地数据 显示到进度条上
                NSInteger localDistance = [self getDistanceForlocalWillUploadUserSportData:existUploadDataArr];
                model.distanceDay  = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:(model.distanceDay.integerValue +localDistance)]];
            }
            
            self.taskHomePageView.model = model;
            [self showTheTitleView:YES];
            //   检测是否有异常退出数据
            if ([kNSUSERDEFAULE valueForKey:kSportData]) {
                NSLog(@"verifyWhetherExceptionSportData  show");
                [self verifyWhetherExceptionSportData];
                [self.view insertSubview:self.customAlertView aboveSubview:self.taskHomePageView];
                
            }
            
           
        }else
        {
            [self.taskHomePageView removeFromSuperview];
            //   检测是否有异常退出数据
            if ([kNSUSERDEFAULE valueForKey:kSportData]) {
                NSLog(@"verifyWhetherExceptionSportData  show");
                [self verifyWhetherExceptionSportData];
                [self.view insertSubview:self.customAlertView aboveSubview:self.noTaskHomePageView];
                
            }
        }
         [[MBProgressHUDManager instance] hideHUD];
        //else
           // [[MBProgressHUDManager instance] requestSuccessWithMessage:[responseObject valueForKey:@"message"]];
        
    } failure:^(NSError *error) {
        //modify by manman   on 2016-10-13 start of line
        // 网络异常时 显示前一次的任务
        BOOL isSuccess = [self verifyTaskExpried];
        if (isSuccess){
            [kNSUSERDEFAULE setValue:@"1" forKey:kHaveTask];
            [self.view addSubview:self.taskHomePageView];
            SportTaskModel *sportTaskInfo = [NSKeyedUnarchiver unarchiveObjectWithData:   [kNSUSERDEFAULE objectForKey:kTaskModelInfo]];
            
            //检测本地数据是否有为上传的数据
            NSArray *existUploadDataArr =  [UserInfoDBManager verifySportDataExistWillUploadWithUserId:[[LoginManager instance] getUserId]];
            if (existUploadDataArr.count>0)
            {
                // 计算今天的本地数据 显示到进度条上
                self.taskHomePageView.existUploadData = YES;
                NSInteger localDistance = [self getDistanceForlocalWillUploadUserSportData:existUploadDataArr];
                sportTaskInfo.distanceDay  = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:(sportTaskInfo.distanceDay.integerValue +localDistance)]];
            }
            else
            {
                if (self.taskHomePageView.existUploadData == YES) {
                    self.taskHomePageView.existUploadData = NO;
                    
                }
            }
            //self.taskHomePageView.model = model;
            
            self.taskHomePageView.model = sportTaskInfo;
            // 有任务检测
            if ([kNSUSERDEFAULE valueForKey:kSportData]) {
                NSLog(@"verifyWhetherExceptionSportData  show");
                [self verifyWhetherExceptionSportData];
                
                [self.view insertSubview:self.customAlertView aboveSubview:self.taskHomePageView];
            }
        }
        else // 无任务检测
        {
                [kNSUSERDEFAULE setValue:@"0" forKey:kHaveTask];
            if ([kNSUSERDEFAULE valueForKey:kSportData]) {
                NSLog(@"verifyWhetherExceptionSportData  show");
                [self verifyWhetherExceptionSportData];
                [self.view insertSubview:self.customAlertView aboveSubview:self.noTaskHomePageView];
            }
        }
        
        
        // end of line
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
    
}


/**
 *  计算本地当天未上传的运动数据   计算运动长度
 *
 *  @param aDataArr
 *
 *  @return  当天本地运动距离
 */
- (NSInteger)getDistanceForlocalWillUploadUserSportData:(NSArray *)aDataArr
{
    NSInteger sumLocalDistance = 0;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    QDLog(@"current time%@",[NSString stringWithFormat:@"%@ 00:00:00",[PublicTool getCurrentTimeStrFormat:@"YYYY-MM-dd"]]);
    NSDate *currentDayStart = [format  dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",[PublicTool getCurrentTimeStrFormat:@"YYYY-MM-dd"]]];
   // NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    
    NSDate *currentDayEnd = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDayStart];//后一天
    //&& [tmpModel.endTime compare:currentDayEnd] == NSOrderedAscending

    
    for (SportModel *tmpModel in aDataArr) {
        if ([tmpModel.startTime compare:currentDayStart] == NSOrderedDescending ) {
             sumLocalDistance += tmpModel.totalDistance;
        }
        //sumLocalDistance += tmpModel.totalDistance;
    }
    
    
    
    return sumLocalDistance;
    
    
    
    
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
    if ((resultCompareSartDate == NSOrderedAscending ||resultCompareSartDate == NSOrderedSame) && (resultCompareEndDate == NSOrderedDescending ||resultCompareEndDate == NSOrderedSame)) return YES;
    return NO;
    
}


#pragma 将这个 添加 end


#pragma mark --- get networking
/** 刷新任务数据*/
- (void)refreshSportData {
    
    if ([[kNSUSERDEFAULE valueForKey:kHaveTask] isEqualToString:@"0"]) {
        return;
    }
    
    NSDictionary *params = @{@"userId":kUserId};
    
    [QDHttpTool getWithURL:kUrl_getDTRidingRecord params:params success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (!isSuccess) {
            return ;
        }
        NSArray *array = [SportTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
        [_dataArray addObjectsFromArray:array];
        
        if (_dataArray.count == 0) {
            return;
        } else {
            //[self.view addSubview:self.taskHomePageView];
            self.taskHomePageView.model = _dataArray[0];
        }
        
    } failure:^(NSError *error) {
        // 无网的时候  读取本地数据
        //检测本地数据是否有为上传的数据
        
        NSLog(@"before distance %@",self.taskHomePageView.model.distanceDay);
        SportTaskModel *tmpModel = self.taskHomePageView.model;
        
        NSArray *existUploadDataArr =  [UserInfoDBManager verifySportDataExistWillUploadWithUserId:[[LoginManager instance] getUserId]];
        if (existUploadDataArr.count>0)
        {
            
            self.taskHomePageView.existUploadData = YES;
            // 计算今天的本地数据 显示到进度条上
            NSInteger localDistance = [self getDistanceForlocalWillUploadUserSportData:existUploadDataArr];
            tmpModel.distanceDay = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:(tmpModel.distanceDay.integerValue +localDistance)]];
        }
        self.taskHomePageView.model = tmpModel;
        NSLog(@"sum distance %@",self.taskHomePageView.model.distanceDay);
        
    }];
}
#pragma mark --- private method
- (void)timeRun:(NSTimer *)timer {
    CLLocation *location = [self.locationManager.location locationMarsFromEarth];
    //每次进入软件的时候，定位的次数，默认3次
    static int i = 0;
    if (i <= 3) {
        [self requestGeoWithLon:location.coordinate.longitude lat:location.coordinate.latitude];
        i++;
    }
    [kNSUSERDEFAULE setValue:@(location.coordinate.longitude) forKey:kFind_longitude];
    [kNSUSERDEFAULE setValue:@(location.coordinate.latitude) forKey:kFind_latitude];
    
}
/** 检测是否登录*/
- (void)checkLogin {
    if (![[LoginManager instance] isLogin]) {
        [self.view addSubview:self.alertVIew];
    } else {
        [self clickStartBtn];
    }
}
/** 点击开始*/
- (void)clickStartBtn {

    //检测gps信号，如果不好，弹出gps信号弱的view,如果好就进入下个界面
    if (self.locationManager.location.horizontalAccuracy < 0 || self.locationManager.location.horizontalAccuracy > 163) {
        self.weakGPSView.hidden = NO;
        [self.view addSubview:self.weakGPSView];
        
    } else {
     
        [self pushNextView];
    }
}
/** 进入下个页面*/
- (void)pushNextView {
    SportStartViewController *vc = [[SportStartViewController alloc]init];
    //vc.isBackBtnShow = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.hidesBottomBarWhenPushed = YES;
    if (_model) {
        vc.todayDistance = [_model.distanceDay integerValue]/1000.0;
        vc.totalDistance = [_model.distancePerDay integerValue]/1000;
        vc.haveTask = YES;
    }
    [self presentViewController:nav animated:YES completion:nil];
//    // add by manman on 2016-09-14 BUG 227 start of line
//    self.alertVIew.hidden = YES;
//    //[self.alertVIew removeFromSuperview];
//    
//    // end of line
    
}
/** 手动销毁weakGPSView*/
- (void)manualRemoveWeakGPSView {
    self.weakGPSView.hidden = YES;
}
/** 意外退出，进入运动结束界面*/
- (void)showSportEndViewController {
    SportEndViewController *vc = [[SportEndViewController alloc] init];
    NSData * sportData = [[NSUserDefaults standardUserDefaults] objectForKey:kSportData];
    SportModel *sportModel = [NSKeyedUnarchiver unarchiveObjectWithData:sportData];
    vc.sportModel = sportModel;
    
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:kSportPoint];
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    vc.locationModelAry = [[NSMutableArray alloc]initWithArray:array];
    [kNSUSERDEFAULE removeObjectForKey:kSportData];
    [kNSUSERDEFAULE removeObjectForKey:kSportPoint];
    [kNSUSERDEFAULE synchronize];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.isBackBtnShow = NO;
    vc.isPush = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark kGAODELBS_KEY
-(void)requestGeoWithLon:(float)lon lat:(float)lat{
    
    if (!_amapSearch) {
        [[AMapServices sharedServices] setApiKey:kGAODELBS_KEY];
        _amapSearch = [[AMapSearchAPI alloc] init];
        _amapSearch.delegate = self;
    }
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    //request.searchType =  AMapSearchType_ReGeocode;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    request.location = point;
    [_amapSearch AMapReGoecodeSearch:request];
    
}
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    /*
     @property (nonatomic, strong) NSString *province; // 省
     @property (nonatomic, strong) NSString *city; // 市
     @property (nonatomic, strong) NSString *district; // 区
     @property (nonatomic, strong) NSString *township; // 乡镇
     @property (nonatomic, strong) NSString *neighborhood; // 社区
     @property (nonatomic, strong) NSString *building; // 建筑
     @property (nonatomic, strong) NSString *citycode; // 城市编码
     @property (nonatomic, strong) NSString *adcode; // 区域编码
     @property (nonatomic, strong) AMapStreetNumber *streetNumber; // 门牌信息
     */
    //NSLog(@"%@",response);
    
    [kNSUSERDEFAULE setValue:[response.regeocode.addressComponent valueForKey:@"citycode"] forKey:kFind_cityCode];
    if ([[response.regeocode.addressComponent valueForKey:@"city"] isExist]) {
        [kNSUSERDEFAULE setValue:[response.regeocode.addressComponent valueForKey:@"city"] forKey:kFind_city];
    }else {
        [kNSUSERDEFAULE setValue:[response.regeocode.addressComponent valueForKey:@"province"] forKey:kFind_city];
    }
    
    //    self.testLabel.text = [NSString stringWithFormat:@"%@--%@",[response.regeocode.addressComponent valueForKey:@"city"],[response.regeocode.addressComponent valueForKey:@"province"]];
    //    NSLog(@"%@",response);
    //NSLog(@"city = %@",response.regeocode.addressComponent);
    //NSLog(@"citycode = %@",[kNSUSERDEFAULE valueForKey:kFind_cityCode]);
    NSLog(@"position %@ - %@ - %@",kGetCityCode,kGetLat,kGetLng);
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



#pragma mark --- lozy load
- (WeakGPSView *)weakGPSView {
    if (!_weakGPSView) {
        _weakGPSView = [[WeakGPSView alloc]initWithFrame:CGRectMake720(0, 0, 554, 740)];
        _weakGPSView.center = self.view.center;
        _weakGPSView.top -= 64;
        @weakify_self
        _weakGPSView.continueBlock = ^{
            @strongify_self
            [self manualRemoveWeakGPSView];
            [self pushNextView];
        };
        _weakGPSView.cancelBlock = ^{
            @strongify_self
            [self manualRemoveWeakGPSView];
        };
    }
    return _weakGPSView;
}
- (NoTaskHomePageView *)noTaskHomePageView {
    if (!_noTaskHomePageView) {
        _noTaskHomePageView = [[NoTaskHomePageView alloc]initWithFrame:self.view.bounds];
        _noTaskHomePageView.height -= 44;
        @weakify_self
        _noTaskHomePageView.clickStartBtnBlock = ^ {
            @strongify_self
            [self checkLogin];
        };
    }
    return _noTaskHomePageView;
}
- (TaskHomePageView *)taskHomePageView {
    if (!_taskHomePageView) {
        _taskHomePageView = [[TaskHomePageView alloc]initWithFrame:self.view.bounds];
        _taskHomePageView.height -= 44;
        @weakify_self
        _taskHomePageView.clickStartBtnBlock = ^ {
            @strongify_self
            [self checkLogin];
        };
    }
    return _taskHomePageView;
}


/**
 *  未登录的自定义提示信息
 *
 *  @return
 */
- (QDAlertView *)alertVIew {
    if (!_alertVIew) {
        _alertVIew = [[QDAlertView alloc]initWithFrame:self.view.bounds];
        _alertVIew.title = @"您未登录账户,\n骑行数据将不会保存";
        _alertVIew.sureBtnTitle = @"马上登录";
        _alertVIew.cancleBtnTitle = @"仍要骑行";
        _alertVIew.rewriteCancleMethod = YES;
        @weakify_self
        _alertVIew.clickSureBlock = ^ {
            @strongify_self
            [self showLoginViewController];
            //add by manman  on 2016-09-14  BUG  start of line
            //self.alertVIew.hidden = YES;
             // end of line
        };
        _alertVIew.clickCancleBlock = ^ {
            @strongify_self
            [self clickStartBtn];
            //add by manman  on 2016-09-14  BUG  start of line
            //self.alertVIew.hidden = YES;
             // end of line
        };
        [_alertVIew updateUIAutolayout];
    }
    //add by manman  on 2016-09-14  BUG  start of line
//    if (_alertVIew.hidden) {
//        _alertVIew.hidden = NO;
//    }
    // end of line
    return _alertVIew;
}

- (QDAlertView *)customAlertView
{
    //NSLog(@"")
    if (!_customAlertView) {
        _customAlertView = [[QDAlertView alloc]initWithFrame:self.view.bounds];
    }
    return _customAlertView;
}

- (void)setupCustomAlertView:(NSString *) title AndOKButtonTitle:(NSString *) okTitleStr
        AndCancleButtonTitle:(NSString *) cancleTitleStr
{
    [self.view addSubview:self.customAlertView];
    self.customAlertView.title = title;
    if (okTitleStr != nil) {
        self.customAlertView.sureBtnTitle = okTitleStr;
    }
    if (cancleTitleStr != nil) {
       self.customAlertView.cancleBtnTitle = cancleTitleStr;
    }
   
    
    
}






- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
