//
//  SportStartViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportStartViewController.h"
#import "ProgressBarView.h"
#import "CommonSportView.h"
#import "NoTaskCommonSportView.h"
#import "PulldownSportView.h"
#import "PullupSportView.h"
#import "SportMapView.h"
#import "NoTaskSportMapView.h"
#import "GPSSignalView.h"
#import "SportEndViewController.h"

#import "LocationManager.h"
#import "LocationModel.h"
#import "ShowCameraManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MAMapViewManager.h"
#import "CustomAnnotation.h"
#import "AlertViewManager.h"
#import "NSDate+Tools.h"
#define kLINEWIDTH 5

@interface SportStartViewController ()<PulldownSportViewDelegate,PullupSportViewDelegate,MAMapViewDelegate>

@property (nonatomic,strong) ProgressBarView *progressBarView;
/** 结束、暂停、点击地图的页面,可往上滑动*/
@property (nonatomic,strong) PulldownSportView *downView;
/** 数据详情的页面,可往上滑动*/
@property (nonatomic,strong) PullupSportView *upView;
/** 基本数据页面,一直存在*/
@property (nonatomic,strong) CommonSportView *commonView;
/** 无任务情况的基本数据*/
@property (nonatomic,strong) NoTaskCommonSportView *noTaskCommonView;
/** 记录gps的时间*/
@property (nonatomic,assign) NSInteger gpsCount;
/** 保存数据的定时器，间隔1分钟*/
@property (nonatomic,strong) NSTimer *saveDataTimer;
/** 定位点的位置的数组*/
@property (nonatomic,strong) NSMutableArray *locationModelAry;
/** gps信号*/
@property (nonatomic,strong) GPSSignalView *gpsView;
#pragma mark --- 地图
@property (nonatomic,strong) UIView *mapBgView;
/** 地图模式下 topView的数据展示*/
@property (nonatomic,strong) SportMapView *sportMapView;
/** 无任务--地图模式下 topView的数据展示*/
@property (nonatomic,strong) NoTaskSportMapView *noTaskSportMapView;

@property (strong, nonatomic) MAMapView *mapView;

@property (strong, nonatomic) CustomAnnotation *startAnnotation;

@property (strong, nonatomic) CustomAnnotation *endAnnotation;
/** 是否跟随*/
@property (assign, nonatomic) BOOL isLocationUnFollow;
/** 是否自动定位*/
@property (assign, nonatomic) BOOL isAutomaticPause;
/** 图片的数量，最多4张*/
@property (assign, nonatomic) int photoCount;
@end

@implementation SportStartViewController

#pragma mark --- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    QDLog(@"home start animated :%d",[UIApplication sharedApplication].statusBarHidden);
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (_haveTask) {
//        // add by manman on 2016-09-14 BUG 045 start of line
//        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//        bgImageView.image = [UIImage imageNamed:@"sport_homepage_bg_image"];
//        [self.view addSubview:bgImageView];
//        
//        // end of line
//    }
    
    self.locationModelAry = @[].mutableCopy;
    
    //重置本次运动拍照的数量
    [kNSUSERDEFAULE setObject:@(0) forKey:kSportPhotoCount];
    
    [self setupNavigationView];
    
    self.gpsView = [[GPSSignalView alloc]initWithFrame:CGRectMake720(0, 0, 360, 36)];
    [self.view addSubview:self.gpsView];
    
    if (_haveTask) {
        
        //添加背景图片
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        bgImageView.image = [UIImage imageNamed:@"sport_homepage_bg_image"];
        [self.view addSubview:bgImageView];
        
        [self.view addSubview:self.commonView];
        //self.commonView.alpha = 0.3;
        

    } else {
        [self.view addSubview:self.noTaskCommonView];
    }
    
    [self.view addSubview:self.upView];
    [self.view addSubview:self.downView];
    
    [self setupMapView];
    
    [self startLoaction];
}
#pragma mark --- setup UI
/** 创建导航栏*/
- (void)setupNavigationView {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor blackColor];
    UIButton *cameraBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 0, 47, 39) NormalImageString:@"sport_show_camera" tapAction:^(UIButton *button) {
        [self clickShowCameraBtn];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
}
/** 创建地图容器*/
- (void)setupMapView {
    self.mapBgView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.mapBgView.left = self.view.right;
    [self.view addSubview:self.mapBgView];
    
    self.mapView = [MAMapViewManager shareMAMapView];
    self.mapView.frame = self.view.bounds;
    //self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    [self.mapBgView addSubview:self.mapView];
    
    if (_haveTask) {
        [self.mapBgView addSubview:self.sportMapView];
    } else {
        [self.mapBgView addSubview:self.noTaskSportMapView];
    }
    
    UIButton *positionBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(576, 0, 104, 104) NormalBackgroundImageString:@"map_location_image" tapAction:^(UIButton *button) {
        [self clickShowLocationBtn];
    }];
    positionBtn.top = HCDH - 394*SizeScaleSubjectTo720;
    [self.mapBgView addSubview:positionBtn];
    
    UIButton *closeBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(576, 0, 104, 104) NormalBackgroundImageString:@"map_close_image" tapAction:^(UIButton *button) {
        [self clickMapViewCloseBtn];
    }];
    closeBtn.top = positionBtn.bottom + 34*SizeScaleSubjectTo720;
    [self.mapBgView addSubview:closeBtn];
    
}
#pragma mark --- private method
#pragma mark -- 地图view的click method
/** 点击回到自己的按钮*/
- (void)clickShowLocationBtn {
    if (self.locationModelAry.count) {
        LocationModel *location = [self.locationModelAry lastObject];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.itemModel.latitude, location.itemModel.longitude);
        self.mapView.centerCoordinate = coordinate;
    }
}
/** 点击关闭地图的按钮*/
- (void)clickMapViewCloseBtn {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.mapBgView.left = self.view.right;
    }];
}
/** 点击拍照*/
- (void)clickShowCameraBtn {
    [ShowCameraManager instance].sportTimeStr = [[LocationManager instance].sportModel.startTime dataConvertString:@"yyyy-MM-dd HH:mm:ss"];
    [ShowCameraManager instance].lat = [LocationManager instance].locationManager.location.coordinate.latitude;
    [ShowCameraManager instance].lon = [LocationManager instance].locationManager.location.coordinate.longitude;
    [[ShowCameraManager instance] showActionSheetInView:self.view inViewController:self];
}
/** 清除地图*/
- (void)clearMapView {
    if (self.startAnnotation) {
        [self.mapView removeAnnotation:self.startAnnotation];
    }
    if (self.endAnnotation) {
        [self.mapView removeAnnotation:self.endAnnotation];
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
    [self.saveDataTimer invalidate];
    self.saveDataTimer = nil;
}
#pragma -mark --- 传递数据
//开始定位
/** 开始定位的相关逻辑*/
- (void)startLoaction {
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //30秒保存一次数据到本地，防止闪退数据丢失
    self.saveDataTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(saveSportToLocal) userInfo:nil repeats:YES];
    
    //时间有关的逻辑
    [LocationManager instance].timeRunBlock = ^(int currentTime){
        if (_haveTask) {
            self.commonView.duration = [PublicTool getFormatTimeWithValue:currentTime];
            self.sportMapView.duration = [PublicTool getFormatTimeWithValue:currentTime];
        } else {
            self.noTaskCommonView.duration = [PublicTool getFormatTimeWithValue:currentTime];
            self.noTaskSportMapView.duration = [PublicTool getFormatTimeWithValue:currentTime];
        }
        
        self.gpsCount ++;
        
    };
    
    //速度里程 的逻辑
    [LocationManager instance].locationBlock = ^(double speed, NSArray *dataArray,SportModel *sportModel) {
        if (speed < 0.001) {
            
            if (_haveTask) {
                self.commonView.speed = @"0.00";
                self.sportMapView.speed = @"0.00";
            } else {
                self.noTaskCommonView.speed = @"0.00";
                self.noTaskSportMapView.speed = @"0.00";
            }
        }else{
            if (_haveTask) {
                self.commonView.speed = [NSString stringWithFormat:@"%.2f",speed*3.6];
                self.sportMapView.speed = [NSString stringWithFormat:@"%.2f",speed*3.6];
            } else {
                self.noTaskCommonView.speed = [NSString stringWithFormat:@"%.2f",speed*3.6];
                self.noTaskSportMapView.speed = [NSString stringWithFormat:@"%.2f",speed*3.6];
            }
        }
        //自动暂停
        if (speed == 0) {
            [[LocationManager instance] automaticPauseSport];
            self.isAutomaticPause = YES;
            self.downView.sportPauseBtn.selected = YES;
        }else{
            [[LocationManager instance] sportGoOnWithClock];
            self.isAutomaticPause = NO;
            self.downView.sportPauseBtn.selected = NO;
        }
        //地图
        if (dataArray && [dataArray count]) {
            
            if (self.locationModelAry && self.locationModelAry.count > 0) {
                [self.locationModelAry removeAllObjects];
            }
            [self.locationModelAry addObjectsFromArray:dataArray];
            [self drawStartPointAndEndPoint];
            [self mapLocationWith:self.locationModelAry];
            [self drowMapLine];
        }
        
        if (dataArray.count > 0 && sportModel) {
            
            LocationModel *locationModel = [dataArray lastObject];
            
            [[LocationManager instance] calculateCalorie];
            NSDictionary *dic = @{@"averageSpeed":@(sportModel.averageSpeed),
                                  @"altitude":@(locationModel.itemModel.altitude),
                                  @"upAltitude":@(sportModel.upAltitude),
                                  @"kCal":@(sportModel.calorie)};
            
            if (_haveTask) {
                CGFloat distance = self.todayDistance + sportModel.totalDistance/1000.0;
                self.commonView.progress = distance/self.totalDistance;
                
                self.sportMapView.progress = distance/self.totalDistance;
                
                if (distance >= self.totalDistance) {
                    self.commonView.progress = 1.0f;
                    self.sportMapView.progress = 1.0f;
                }
                self.commonView.totalDistance = [NSString stringWithFormat:@"%.1f",distance];
                
                self.commonView.distance = [NSString stringWithFormat:@"%.2f",sportModel.totalDistance/1000.0];
                self.sportMapView.distance = [NSString stringWithFormat:@"%.2f",sportModel.totalDistance/1000.0];
                
                self.sportMapView.totalDistance = [NSString stringWithFormat:@"%.1f",distance];
            } else {
                self.noTaskCommonView.distance = [NSString stringWithFormat:@"%.2f",sportModel.totalDistance/1000.0];
                self.noTaskSportMapView.distance = [NSString stringWithFormat:@"%.2f",sportModel.totalDistance/1000.0];
            }
            //刷新
            [self.upView updateSportDataWithParame:dic];
            
        }
    };
    
    // 真实数据
    [[LocationManager instance] setupLocationManager];
    //假数据
    //[[LocationManager instance] setUpTestLocationManager];
    
    [self.gpsView currentGPS];
    
}
#pragma -mark --- 30秒保存一次数据
/** 30秒保存一次数据的相关处理*/
- (void)saveSportToLocal {
    SportModel *sportModel = [LocationManager instance].sportModel;
    [sportModel endSport];
    NSData *sportObject = [NSKeyedArchiver archivedDataWithRootObject:sportModel];
    [kNSUSERDEFAULE setObject:sportObject forKey:kSportData];
    
    NSData *data  = [NSKeyedArchiver archivedDataWithRootObject:self.locationModelAry];
    [kNSUSERDEFAULE setObject:data forKey:kSportPoint];
    [kNSUSERDEFAULE synchronize];
}
#pragma mark --- 绘制地图
/** 绘制地图的起始位置的大头针*/
- (void)drawStartPointAndEndPoint {
    if (self.startAnnotation) {
        [self.mapView removeAnnotation:self.startAnnotation];
    }
    if (self.endAnnotation) {
        [self.mapView removeAnnotation:self.endAnnotation];
    }
    self.startAnnotation = [[CustomAnnotation alloc] initWithCoordinate:[self getFirstCoordinate] andMarkTitle:@"开始" andMarkSubTitle:@""];
    self.startAnnotation.image = [UIImage imageNamed:@"point_begin"];
    [self.mapView addAnnotation:self.startAnnotation];
    if ([self.locationModelAry count] > 1) {
        self.endAnnotation = [[CustomAnnotation alloc] initWithCoordinate:[self getLastCoordinate] andMarkTitle:@"结束" andMarkSubTitle:@""];
        self.endAnnotation.image = [UIImage imageNamed:@"sport_location_image"];
        [self.mapView addAnnotation:self.endAnnotation];
    }
}
- (void)mapLocationWith:(NSArray *)dataAry {
    //if (!self.isLocationUnFollow) {
    LocationModel *location = [dataAry lastObject];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.itemModel.latitude, location.itemModel.longitude);
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    if (coordinate.latitude==0 && coordinate.longitude == 0) {
        coordinate = CLLocationCoordinate2DMake(39.9, 110.3);
        span = MACoordinateSpanMake(150, 150);
    }
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
    //self.isLocationUnFollow = kLOCATIONUNFOLLOW_SWITCH;
    //}
}
/** 绘制地图的运动轨迹*/
- (void)drowMapLine {
    CLLocationCoordinate2D pointsToUse[self.locationModelAry.count];
    for (int i = 0; i < self.locationModelAry.count; i++) {
        CLLocationCoordinate2D coords;
        coords.latitude = ((LocationModel *)self.locationModelAry[i]).itemModel.latitude;
        coords.longitude = ((LocationModel *)self.locationModelAry[i]).itemModel.longitude;
        pointsToUse[i] = coords;
    }
    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:pointsToUse count:[self.locationModelAry count]];
    if ([self.mapView.overlays indexOfObject:self.mapView.overlays]) {
        [self.mapView removeOverlays:self.mapView.overlays];
    }
    [self.mapView addOverlay:lineOne];
    const CGFloat screenEdgeInset = 20;
    UIEdgeInsets inset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset, screenEdgeInset);
    [self.mapView setVisibleMapRect:lineOne.boundingMapRect edgePadding:inset animated:NO];
}
- (CLLocationCoordinate2D)getFirstCoordinate {
    LocationModel *location = [self.locationModelAry firstObject];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.itemModel.latitude, location.itemModel.longitude);
    return coordinate;
}
- (CLLocationCoordinate2D)getLastCoordinate {
    LocationModel *location = [self.locationModelAry lastObject];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.itemModel.latitude, location.itemModel.longitude);
    return coordinate;
}
#pragma mark - MAMapView Delegate
- (void)offlineDataWillReload:(MAMapView *)mapView {
    Clog(@"离线地图将要加载");
}

- (void)offlineDataDidReload:(MAMapView *)mapView {
    Clog(@"离线地图加载完成");
    [kNSUSERDEFAULE setBool:NO forKey:kOFFLINEMAP_NEEDRELOAD];
    [kNSUSERDEFAULE synchronize];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if (![annotation isKindOfClass:[CustomAnnotation class]]) {
        return nil;
    }
    static NSString *customAnnotationIndetifier = @"customAnnotationIndetifier";
    MAAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationIndetifier];
    if (!annotationView) {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:customAnnotationIndetifier];
    } else {
        annotationView.annotation = annotation;
    }
    annotationView.image = ((CustomAnnotation *)annotation).image;
    annotationView.centerOffset = CGPointMake(0, -10);
    annotationView.enabled = YES;
    return annotationView;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if (![overlay isKindOfClass:[MAPolyline class]]) {
        return nil;
    }
    MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc]initWithOverlay:overlay];
    polylineRenderer.lineWidth = kLINEWIDTH;
    polylineRenderer.strokeColor = [UIColor redColor];
    return polylineRenderer;
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation) {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

#pragma mark --- PulldownSportViewDelegate
- (void)clickSportEndBtn {

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //删除自动保存的数据
    [kNSUSERDEFAULE removeObjectForKey:kSportData];
    [kNSUSERDEFAULE removeObjectForKey:kSportPoint];
    [kNSUSERDEFAULE synchronize];

#pragma mark --- ——正式
    [[LocationManager instance] pauseSport];
    if ([LocationManager instance].sportModel.totalDistance < 50.0f) {
        [[AlertViewManager instance] showAlertView:@"运动距离过短,记录不会被保存\n确定结束本次骑行吗?" withMessage:@"" withFirstBtnAction:^{
            [[LocationManager instance] playSport];
        } withSecondBtnAction:^{
            // 停止定位
            [[LocationManager instance] endSport];
            [self clearMapView];
            [self dismissViewControllerAnimated:YES completion:^{
                self.tabBarController.tabBar.hidden = NO;
            }];
            
        }];
    }else{
        [[LocationManager instance] endSport];
        SportEndViewController *sportVC = [[SportEndViewController alloc] init];
        sportVC.sportModel = [LocationManager instance].sportModel;
        sportVC.locationModelAry = self.locationModelAry.mutableCopy;
        sportVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:sportVC animated:YES];
        [self clearMapView];
    }
    #pragma mark --- ——正式
    
#pragma -mark -测试
#warning ---  -测试
//    [[LocationManager instance] pauseSport];
//    
//    [[AlertViewManager instance] showAlertView:@"您确定结束本次骑行吗？" withMessage:@"" withFirstBtnAction:^{
//        [[LocationManager instance] playSport];
//    } withSecondBtnAction:^{
//        // 停止定位
//        [[LocationManager instance] endSport];
//        SportEndViewController *sportVC = [[SportEndViewController alloc] init];
//        sportVC.sportModel = [LocationManager instance].sportModel;
//        sportVC.locationModelAry = self.locationModelAry.mutableCopy;
//        sportVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self.navigationController pushViewController:sportVC animated:YES];
//        [self clearMapView];
//    }];

}
/** 点击暂停按钮*/
- (void)clickSportPauseBtn:(UIButton *)button {
    //NSLog(@"%ld",button.selected);
    BOOL select = !self.downView.sportPauseBtn.selected;
    
    if (self.isAutomaticPause) {
        
        if (select) {
            [[LocationManager instance] automaticPauseSport];
        } else {
            [[LocationManager instance] sportGoOnWithClock];
        }
    } else {
        if (select) {
            [[LocationManager instance] pauseSport];
        } else {
            [[LocationManager instance] playSport];
        }
    }
    self.downView.sportPauseBtn.selected = select;
}
/** 点击显示地图按钮*/
- (void)clickShowMapBtn {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = YES;
        self.mapBgView.left = 0;
    }];
}
/** 点击更多按钮*/
- (void)clickPulldownBtn {
    [UIView animateWithDuration:0.5f animations:^{
        CGFloat height = 709;
        if (!_haveTask) {
            height = 640;
        }
        self.downView.top = (770+586)*SizeScale;
        self.upView.top = height * SizeScale;
    }];
    //[self.view addSubview:self.upView];
}
#pragma mark --- PullupSportViewDelegate
/** 点击向上的按钮*/
- (void)clickPullupBtn {    
    [UIView animateWithDuration:0.5f animations:^{
        
        CGFloat height = 709;
        if (!_haveTask) {
            height = 640;
        }
        self.downView.top = height * SizeScale;
        self.upView.top = (770+586) * SizeScale;
    }];
    //[self.view addSubview:self.downView];
}
#pragma mark --- lazy load
- (CommonSportView *)commonView {
    if (!_commonView) {
        //198
        _commonView = [[CommonSportView alloc]initWithFrame:CGRectMake720(0, 36, 720, 585)];
        CGFloat distance = self.todayDistance;
        _commonView.totalDistance = [NSString stringWithFormat:@"%0.1f",distance];
        _commonView.progress = distance/self.totalDistance;
        if (distance >= self.totalDistance) {
            
            self.commonView.progress = 1.0f;
        }
    }
    return _commonView;
}
- (NoTaskCommonSportView *)noTaskCommonView {
    if (!_noTaskCommonView) {
        _noTaskCommonView = [[NoTaskCommonSportView alloc]initWithFrame:CGRectMake720(0, 36, 720, 585)];
    }
    return _noTaskCommonView;
}
- (PulldownSportView *)downView {
    if (!_downView) {
        _downView = [[PulldownSportView alloc]initWithFrame:CGRectMake720(0, 709, 720, 440) isHaveTask:_haveTask];
        if (!_haveTask) {
            _downView.top = 640*SizeScale;
            _downView.backgroundColor = [UIColor blackColor];
        }else
        {
            //_downView.alpha = 0.5;
        }
        _downView.delegate = self;
    }
    return _downView;
}
- (PullupSportView *)upView {
    if (!_upView) {
        _upView = [[PullupSportView alloc]initWithFrame:CGRectMake720(0, 709 + 586, 720, 440)];
        _upView.delegate = self;
        if (!_haveTask) {
            _upView.top = (640 + 709)*SizeScale;
            _upView.backgroundColor = [UIColor blackColor];
        }else
        {
            // 有任务的时候  修改页面 背景色
           // _upView.alpha = 0.5;
        }
        
        
    }
    return _upView;
}
- (NoTaskSportMapView *)noTaskSportMapView {
    if (!_noTaskSportMapView) {
        _noTaskSportMapView = [[NoTaskSportMapView alloc]initWithFrame:CGRectMake720(0, 0, 720, 200)];
    }
    return _noTaskSportMapView;
}
- (SportMapView *)sportMapView {
    if (!_sportMapView) {
        _sportMapView = [[SportMapView alloc]initWithFrame:CGRectMake720(0, 0, 720, 320)];
        _sportMapView.totalDistance = [NSString stringWithFormat:@"%0.1f",self.todayDistance];
    }
    return _sportMapView;
}
#pragma mark --- super method
- (void)clickBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
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
