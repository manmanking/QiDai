//
//  AddressInfoViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AddressInfoViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import "MAMapViewManager.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ShopAddressModel.h"
#import "UIButton+AcceptEvent.h"
#import "CLLocation+Sino.h"
@interface AddressInfoViewController ()<AMapSearchDelegate,MAMapViewDelegate>
{
    /** 动画红线*/
    UIView *_redAnimationView;
    
//    UIButton *_driveBtn;
//    UIButton *_busBtn;
//    UIButton *_walkBtn;
    UIButton *_tempBtn;
}
@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UISegmentedControl *driveSegmentControl;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) MAMapView *mapView;

/* 路径规划类型 */
@property (nonatomic) AMapRoutePlanningType routePlanningType;

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

@end
static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@implementation AddressInfoViewController
#pragma mark --- life cycle
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    [self.naviRoute removeFromMapView];
    
    self.mapView.delegate = nil;
    
    self.search.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AMapServices sharedServices] setApiKey:kGAODELBS_KEY];
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    
    self.mapView = [MAMapViewManager shareMAMapView];
    self.mapView.frame = CGRectMake720(0, 0, 720, 1000);
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    [self.view addSubview:self.mapView];
    
    self.startCoordinate = CLLocationCoordinate2DMake([[kNSUSERDEFAULE valueForKey:kFind_latitude] floatValue], [[kNSUSERDEFAULE valueForKey:kFind_longitude] floatValue]) ;
    //self.startCoordinate = CLLocationCoordinate2DMake(40.01235195640133,116.3530927963179);
    //self.destinationCoordinate = CLLocationCoordinate2DMake(40.01235195642133,116.3530927963679);
    self.destinationCoordinate = CLLocationCoordinate2DMake([self.model.lat floatValue] , [self.model.lng floatValue] );
    
    
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    self.destinationAnnotation = destinationAnnotation;
    
    [self setupNavitigationView];
    
    [self setupBottomView];
    
    //默认drive导航
    [self SearchNaviWithType:AMapRoutePlanningTypeDrive];

}
- (void)setupNavitigationView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake720(0, 0, 255, 88)];
    titleView.backgroundColor = [UIColor blackColor];
    
    NSArray *driveArray = @[@"驾车",@"公交",@"步行"];
    for (int i = 0; i < driveArray.count; i++) {
        UIButton *btn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(88*i, 0, 88, 88) title:driveArray[i] titleColor:kColorForfff titleFont:30 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            //NSLog(@"tag%ld",(long)button.tag);
            [self searchTypeAction:(button.tag - 900)];
        }];
        [btn setTitleColor:kColorForE60012 forState:UIControlStateSelected];
        btn.tag = 900 + i;
        if (i == 0) {
            btn.selected = YES;
            _tempBtn = btn;
        }
        [titleView addSubview:btn];
    }
    
    _redAnimationView = [[UIView alloc]initWithFrame:CGRectMake720(0, 84, 88, 4)];
    _redAnimationView.backgroundColor = kColorForE60012;
    [titleView addSubview:_redAnimationView];
    self.navigationItem.titleView = titleView;
}
- (void)setupBottomView {
    if (!self.model) {
        return;
    }
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake720(0, 872, 720, 280)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    UILabel *storeNameLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 34, 400, 28) title:self.model.name titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
    [bottomView addSubview:storeNameLabel];
    
    UILabel *addressLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 82, 450, 56) title:self.model.address titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:24];
    addressLabel.numberOfLines = 0;
    [bottomView addSubview:addressLabel];
    
    UILabel *distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(470, 48, 220, 50) title:[NSString stringWithFormat:@"%0.1dkm",[self.model.distance intValue]/1000] titleColor:kColorForccc textAlignment:NSTextAlignmentRight font:50];
    [bottomView addSubview:distanceLabel];
    
    NSString *time = [NSString stringWithFormat:@"营业时间  %@",self.model.openingTime];
    
    UILabel *timeLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 196, 484, 40) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    timeLabel.attributedText = [NSString changFontWithString:time defaultFont:28*SizeScale specifyFont:24*SizeScale defaultColor:kColorForfff specifyColor:kColorForccc specifyRang:NSMakeRange(0, 4)];
    [bottomView addSubview:timeLabel];
    
    UIButton *phoneBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(484, 169, 216, 74) NormalBackgroundImageString:@"store_phone_image" tapAction:^(UIButton *button) {
        [self clickPhoneBtnWtihString:self.model.phone];
    }];
    phoneBtn.qd_acceptEventInterval = 2.0f;
    [bottomView addSubview:phoneBtn];
}
#pragma mark - Handle Action
/** 点击底部的电话咨询*/
- (void)clickPhoneBtnWtihString:(NSString *)phone {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
/* 切换路径规划搜索类型. */
- (void)searchTypeAction:(NSInteger)page {
    
    //NSLog(@"%ld",(long)page);
    UIButton *btn = [self.navigationItem.titleView viewWithTag:(900 + page)];
    if (_tempBtn == btn) {
        return;
    }
    _tempBtn.selected = NO;
    btn.selected = YES;
    _tempBtn = btn;
    [UIView animateWithDuration:0.5 animations:^{
        _redAnimationView.left = 88*SizeScale*page;
    }];
    
    self.routePlanningType = [self searchTypeForSelectedIndex:page];
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self clear];
    
    /* 发起路径规划搜索请求. */
    [self SearchNaviWithType:self.routePlanningType];
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    /* 公交路径规划. */
    if (self.routePlanningType == AMapRoutePlanningTypeBus)
    {
//        if (self.currentCourse) {
//            self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse]];
//        }
        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[0]];
    }
    /* 步行，驾车路径规划. */
    else if (self.routePlanningType == MANaviAnnotationTypeDrive) {
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:MANaviAnnotationTypeDrive showTraffic:YES];
    }
    else
    {
        //MANaviAnnotationType type = self.routePlanningType == AMapRoutePlanningTypeDrive ? MANaviAnnotationTypeDrive : MANaviAnnotationTypeWalking;
        //self.currentCourse
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:MANaviAnnotationTypeWalking showTraffic:YES];
//        if (self.currentCourse) {
//            
//        }
        
    }
    
    
    [self.mapView addAnnotation:self.startAnnotation];
    [self.mapView addAnnotation:self.destinationAnnotation];
    
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
//    /* 公交路径规划. */
//    if (self.routePlanningType == AMapRoutePlanningTypeBus )
//    {
//        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse] startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
//    }
//    else
//    {
//        MANaviAnnotationType type = self.routePlanningType == AMapRoutePlanningTypeDrive ? MANaviAnnotationTypeDrive : MANaviAnnotationTypeWalking;
//        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
//    }
//    
//    [self.naviRoute addToMapView:self.mapView];
//    
//    /* 缩放地图使其适应polylines的展示. */
//    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
//                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
//                           animated:YES];

}

/* 清空地图上已有的路线. */
- (void)clear {
    
    if (self.startAnnotation) {
        [self.mapView removeAnnotation:self.startAnnotation];
    }
    if (self.destinationAnnotation) {
        [self.mapView removeAnnotation:self.destinationAnnotation];
    }
    
    [self.naviRoute removeFromMapView];
    
}

/* 将selectedIndex 转换为响应的AMapRoutePlanningType. */
- (AMapRoutePlanningType)searchTypeForSelectedIndex:(NSInteger)selectedIndex
{
    AMapRoutePlanningType navitgationType = 0;
    
    switch (selectedIndex)
    {
        case 0: navitgationType = AMapRoutePlanningTypeDrive;   break;
        case 1: navitgationType = AMapRoutePlanningTypeBus; break;
        case 2: navitgationType = AMapRoutePlanningTypeWalk;     break;
        default:NSAssert(NO, @"%s: selectedindex = %ld is invalid for RoutePlanning", __func__, (long)selectedIndex); break;
    }
    
    return navitgationType;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 7;
        polylineRenderer.strokeColor = [UIColor blueColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 4;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    //[self updateTotal];
    self.currentCourse = 0;
    
    //[self updateCourseUI];
    //[self updateDetailUI];
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    } else {
        NSLog(@"路径规划没有方案");
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
#pragma mark - RoutePlanning Search

/* 公交路径规划搜索. */
- (void)searchRoutePlanningBus
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    //navi.city             = @"beijing";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapTransitRouteSearch:navi];
}

/* 步行路径规划搜索. */
- (void)searchRoutePlanningWalk
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 提供备选方案*/
    navi.multipath = 1;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapWalkingRouteSearch:navi];
}

/* 驾车路径规划搜索. */
- (void)searchRoutePlanningDrive
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
}

/* 根据routePlanningType来执行响应的路径规划搜索*/
- (void)SearchNaviWithType:(AMapRoutePlanningType)searchType
{
    switch (searchType)
    {
        case AMapRoutePlanningTypeDrive:
        {
            [self searchRoutePlanningDrive];
            
            break;
        }
        case AMapRoutePlanningTypeWalk:
        {
            [self searchRoutePlanningWalk];
            
            break;
        }
        case AMapRoutePlanningTypeBus:
        {
            [self searchRoutePlanningBus];
            
            break;
        }
    }
}

#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
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
