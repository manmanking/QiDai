//
//  HistoryDetailViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MAMapViewManager.h"
#import "LocationManager.h"
#import "SportModel.h"
#import "SportEndView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CardScrollView.h"
#import "SportShareView.h"
#import "LocationModel.h"
#import "CustomAnnotation.h"
#import "NSDate+Tools.h"
#import "SportDataBaseManager.h"
#import "ItemDataBaseManager.h"
#import "SynchronizeRidingRecordManager.h"
#import "UploadImageManager.h"
#import "UploadFileManager.h"
#import "LoginViewController.h"
#import "UploadFileManager.h"
#import "ItemDataBaseManager.h"
#import "UMSocial.h"
#import "SinaManager.h"
#import "QQManager.h"
#import "WeChatManager.h"
#import "SportShareView.h"
#import "ShareIconView.h"
#import "UIImage+Tools.h"
#define kGCCardRatio 0.6
#define kGCCardWidth CGRectGetWidth(self.view.frame)*kGCCardRatio
#define kGCCardHeight kGCCardWidth/kGCCardRatio
@interface HistoryDetailViewController ()<MAMapViewDelegate,CardScrollViewDelegate,CardScrollViewDataSource>
@property (strong, nonatomic) MAMapView *sportMapView;

/** 经纬度点的数组*/
@property (strong, nonatomic) NSArray *itemModelAry;

@property (strong, nonatomic) CustomAnnotation *startAnnotation;
@property (strong, nonatomic) CustomAnnotation *endAnnotation;
@property (nonatomic,strong) UIScrollView *scrollView;

/** 图片浏览器*/
@property (nonatomic, strong) CardScrollView *cardScrollView;
/** 存放图片的数组*/
@property (nonatomic, strong) NSMutableArray *photosArrayM;

/** 地图下面的view*/
@property (strong,nonatomic) SportEndView *sportEndView;

@property (nonatomic,strong) SportShareView *sportShareView;
/** 分享图的头部*/
@property (nonatomic,strong) ShareIconView *shareIconView;
/**二维码view */
@property (nonatomic,strong) UIImageView *shareCodeView;
/** 骑行的截图*/
@property (strong,nonatomic) UIImage *sportDataImage;
/** 分享出去的图*/
@property (nonatomic,strong) UIImage *shareImage;

@end

@implementation HistoryDetailViewController
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clearMapView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self creatTitleViewWithString:@"骑行报告"];
    [self creatShareBtn];
    self.navigationItem.hidesBackButton = YES;
    
    //self.pointsArr = @[].mutableCopy;
    self.photosArrayM = @[].mutableCopy;
    
    [self refreshPictureView];
    
    [self.view addSubview:self.scrollView];
    
    [self setupMapView];
    
    self.sportEndView = [[SportEndView alloc]initWithFrame:CGRectMake720(0, 712, 720, 940)];
    self.sportEndView.isHistory = YES;// 骑行报告 骑行记录名称 不可以修改
    self.sportEndView.sportModel = self.sportModel;
    [self.sportEndView setupSportEndView];
    [self.scrollView addSubview:self.sportEndView];
    
    //如果骑行中有拍照
    if (self.photosArrayM.count != 0) {
        UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 486, 720, 28) title:@"骑行图记" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
        titleLabel.top = self.sportEndView.bottom + 46*SizeScaleSubjectTo720;
        [self.scrollView addSubview:titleLabel];
        
        self.cardScrollView = [[CardScrollView alloc] initWithFrame:CGRectMake720(0, 0, 720, 604)];
        self.cardScrollView.backgroundColor = [UIColor blackColor];
        self.cardScrollView.top = titleLabel.bottom + 62*SizeScaleSubjectTo720;
        self.cardScrollView.cardDelegate = self;
        self.cardScrollView.cardDataSource = self;
        [self.scrollView addSubview:self.cardScrollView];
        [self.cardScrollView loadCard];
        self.scrollView.contentSize = CGSizeMake(0, (1650 + 790)*SizeScaleSubjectTo720 + 104);
    } else {
        self.scrollView.contentSize = CGSizeMake(0, 1650*SizeScaleSubjectTo720 + 104);
    }
    
    // 请求数据 ／／监测本地或者网络下载
    [self getZip];
    // Do any additional setup after loading the view.
}
- (void)setupMapView {
    //配置用户Key
//    [AMapServices sharedServices].apiKey = kGAODELBS_KEY;
//    self.sportMapView = [[MAMapView alloc]initWithFrame:CGRectMake720(0, 0, 720, 712)];
    self.sportMapView = [MAMapViewManager shareMAMapView];
    self.sportMapView.frame = CGRectMake720(0, 0, 720, 712);
    self.sportMapView.delegate = self;
    self.sportMapView.showsCompass = NO;
    self.sportMapView.showsScale = NO;
    [self.scrollView addSubview:self.sportMapView];
}
- (void)refreshMapView {
    
    //[self drowHidenLine];
    //路线显示在地图中心
    if (self.itemModelAry.count>2) {
        ItemModel *itemModel = [self.itemModelAry objectAtIndex:self.itemModelAry.count/2];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(itemModel.latitude, itemModel.longitude);
        [self.sportMapView setCenterCoordinate:coordinate animated:YES];
    }
    
    //路线显示在地图中心
    [self drowMapLine];
    //[self dropColorfulRouteline];
    [self drawStartPointAndEndPoint];
    
    //根据骑行路程调整缩放级别
    if (self.sportModel.totalDistance>20*1000) {
        [self.sportMapView setZoomLevel:11 animated:YES];
    }else if (self.sportModel.totalDistance>10*1000){
        [self.sportMapView setZoomLevel:12 animated:YES];
    }else if (self.sportModel.totalDistance>5*1000){
        [self.sportMapView setZoomLevel:13 animated:YES];
    }else{
        [self.sportMapView setZoomLevel:15 animated:YES];
    }

}
/** 获取经纬度点的zip文件*/
- (void)getZip {
    self.itemModelAry = [ItemDataBaseManager getItemDataFromTxtWithSid:self.sportModel.sId];
    if (self.itemModelAry && self.itemModelAry.count > 0) {
        [self refreshMapView];
    } else {
        
        //请求数据
        [UploadFileManager downLoadDetailRecordWithUserId:[[LoginManager instance] getUserId] fileName:self.sportModel.sId success:^{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //解压数据
                //[UploadFileManager unzipFileWithFileName:self.sportModel.sId];
                //解析数据
                self.itemModelAry = [ItemDataBaseManager getItemDataFromTxtWithSid:self.sportModel.sId];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshMapView];
                });
                
            });
            
        } failure:^{
            
        }];
        
    }

}
#pragma mark --- private method
/** 弹出分享视图*/
- (void)clickShareBtn {
    [self.view addSubview:self.sportShareView];
//    [self.view addSubview:self.shareCodeView];
//    [self.view addSubview:self.shareIconView];
}
- (void)clickShareWithTag:(NSInteger)tag {
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    NSMutableArray *arrayM = @[].mutableCopy;
    if ([[WeChatManager instance] isWeChatInstalled]) {
        [arrayM addObject:UMShareToWechatTimeline];
        [arrayM addObject:UMShareToWechatSession];
    }
    if ([[QQManager instance] isQQInstalled]) {
        //[arrayM addObject:UMShareToQzone];
        [arrayM addObject:UMShareToQQ];
    }
    if ([[SinaManager instance] isSinaInstalled]) {
        [arrayM addObject:UMShareToSina];
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[ arrayM[tag] ] content:@"" image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            //NSLog(@"分享成功！");
        }
    }];
}

/** 获取照片*/
- (void)refreshPictureView {
    NSString *path_Name = [self.sportModel.startTime dataConvertString:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/picture"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *pathArray = [fileManager contentsOfDirectoryAtPath:rootPath error:&error];
    
    if (!error) {
        for (NSString *pathName in pathArray) {
            if ([pathName isEqualToString:path_Name]) {
                NSString *filePath = [rootPath stringByAppendingPathComponent:pathName];
                
                //_geoDict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",filePath,geo_plist_name]];
                
                NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
                for (NSString *fileName in fileArray) {
                    
                    if (![[[fileName componentsSeparatedByString:@"."] lastObject] isEqualToString:@"plist"]) {
                        [self.photosArrayM addObject:[filePath stringByAppendingPathComponent:fileName]];
                    }
                }
            }
        }
    }
}
/** 绘制起始位置的logo*/
- (void)drawStartPointAndEndPoint {
    if (self.startAnnotation) {
        [self.sportMapView removeAnnotation:self.startAnnotation];
    }
    if (self.endAnnotation) {
        [self.sportMapView removeAnnotation:self.endAnnotation];
    }
    self.startAnnotation = [[CustomAnnotation alloc] initWithCoordinate:[self getFirstCoordinate] andMarkTitle:@"开始" andMarkSubTitle:@""];
    self.startAnnotation.image = [UIImage imageNamed:@"point_begin"];
    [self.sportMapView addAnnotation:self.startAnnotation];
    if ([self.itemModelAry count]>1) {
        //[self.sportMapView removeAnnotation:self.startAnnotation];
        self.endAnnotation = [[CustomAnnotation alloc] initWithCoordinate:[self getLastCoordinate] andMarkTitle:@"结束" andMarkSubTitle:@""];
        self.endAnnotation.image = [UIImage imageNamed:@"point_end"];
        [self.sportMapView addAnnotation:self.endAnnotation];
    }
}
/** 绘制地图曲线*/
- (void)drowMapLine {
    CLLocationCoordinate2D pointsToUse[self.itemModelAry.count];
    for (int i = 0; i < self.itemModelAry.count; i++) {
        CLLocationCoordinate2D coords;
        coords.latitude = ((ItemModel *)self.itemModelAry[i]).latitude;
        coords.longitude = ((ItemModel *)self.itemModelAry[i]).longitude;
        pointsToUse[i] = coords;
    }
    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:pointsToUse count:self.itemModelAry.count];
    [self.sportMapView addOverlay:lineOne];
    
    MAMapRect mapRect = lineOne.boundingMapRect;
    [self.sportMapView mapRectThatFits:mapRect edgePadding:UIEdgeInsetsMake(30, 30, 30, 30)];
    
}
/** 地图范围*/
- (void)mapLocationWith:(NSArray *)dataAry {
    LocationModel *location = [dataAry lastObject];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.itemModel.latitude, location.itemModel.longitude);
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    if (coordinate.latitude==0 && coordinate.longitude == 0) {
        coordinate = CLLocationCoordinate2DMake(39.9, 110.3);
        span = MACoordinateSpanMake(150, 150);
    }
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
    [self.sportMapView setRegion:region animated:YES];
}
/** 清除地图*/
- (void)clearMapView {
    if (self.startAnnotation) {
        [self.sportMapView removeAnnotation:self.startAnnotation];
    }
    if (self.endAnnotation) {
        [self.sportMapView removeAnnotation:self.endAnnotation];
    }
    if (self.sportMapView.overlays) {
        [self.sportMapView removeOverlays:self.sportMapView.overlays];
    }
    
    self.sportMapView.delegate = nil;
}
- (CLLocationCoordinate2D)getFirstCoordinate {
    ItemModel *itemModel = [self.itemModelAry firstObject];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(itemModel.latitude, itemModel.longitude);
    return coordinate;
}
- (CLLocationCoordinate2D)getLastCoordinate {
    ItemModel *itemModel = [self.itemModelAry lastObject];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(itemModel.latitude, itemModel.longitude);
    return coordinate;
}
#pragma mark --- 图像操作
/**分享出去的图 */
- (UIImage *)creatShareImage {
    UIImage *iconImage = [UIImage imageFromView:self.shareIconView];
    UIImage *QRCodeImage = [UIImage imageFromView:self.shareCodeView];
    UIImage *sportDataImage = [UIImage imageFromView:self.sportEndView];
    UIImage *mapImage = [self.sportMapView takeSnapshotInRect:self.sportMapView.bounds];
    UIImage *shareImage1 = [UIImage addImage:iconImage toImage:mapImage];
    UIImage *shareImage2 = [UIImage addImage:sportDataImage toImage:QRCodeImage];
    UIImage *shareImage = [UIImage addImage:shareImage1 toImage:shareImage2];
    return shareImage;
}
#pragma mark - mapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        static NSString *customAnnotationIndetifier = @"customAnnotationIndetifier";
        
        MAAnnotationView *annotationView = [self.sportMapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationIndetifier];
        
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:customAnnotationIndetifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.image = ((CustomAnnotation *)annotation).image;
        annotationView.centerOffset = CGPointMake(0, -10);
        annotationView.enabled = YES;
        //annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc]initWithOverlay:overlay];
        polylineRenderer.lineWidth = 5.0f;
        polylineRenderer.strokeColor = [UIColor redColor];
        return polylineRenderer;
    }
    return nil;
}
#pragma mark - CardScrollViewDelegate
- (void)updateCard:(UIView *)card withProgress:(CGFloat)progress direction:(CardMoveDirection)direction {
    if (direction == CardMoveDirectionNone) {
        if (card.tag != [self.cardScrollView currentCard]) {
            CGFloat scale = 0.7;
            card.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
            card.layer.opacity = 1 - 0.3*progress;
        } else {
            card.layer.transform = CATransform3DIdentity;
            card.layer.opacity = 1;
        }
    } else {
        NSInteger transCardTag = direction == CardMoveDirectionLeft ? [self.cardScrollView currentCard] + 1 : [self.cardScrollView currentCard] - 1;
        if (card.tag != [self.cardScrollView currentCard] && card.tag == transCardTag) {
            card.layer.transform = CATransform3DMakeScale(0.8 + 0.2*progress, 0.8 + 0.2*progress, 1.0);
            card.layer.opacity = 0.8 + 0.2*progress;
        } else if (card.tag == [self.cardScrollView currentCard]) {
            card.layer.transform = CATransform3DMakeScale(1 - 0.2 * progress, 1 - 0.2 * progress, 1.0);
            card.layer.opacity = 1 - 0.2*progress;
        }
    }
}

#pragma mark - CardScrollViewDataSource
- (NSInteger)numberOfCards {
    return self.photosArrayM.count;
}

- (UIView *)cardReuseView:(UIView *)reuseView atIndex:(NSInteger)index {
    if (reuseView) {
        // you can set new style
        return reuseView;
    }
    UIImageView *card = [[UIImageView alloc] initWithFrame:CGRectMake720(0, 0, 604,604)];
    card.layer.backgroundColor = [UIColor whiteColor].CGColor;
    card.layer.cornerRadius = 4;
    card.layer.masksToBounds = YES;
    card.layer.borderColor = [UIColor whiteColor].CGColor;
    card.layer.borderWidth = 1*SizeScaleSubjectTo720;
    card.image = [UIImage imageNamed:self.photosArrayM[index] ];
    //card.image = [UIImage imageNamed:@"exist_bg"];
    return card;
}

- (void)deleteCardWithIndex:(NSInteger)index {
    [self.photosArrayM removeObjectAtIndex:index];
}
#pragma mark --- lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(0, 2700*SizeScaleSubjectTo720);
    }
    return _scrollView;
}
- (UIImage *)sportDataImage {
    if (!_sportDataImage) {
        _sportDataImage = [[UIImage alloc]init];
    }
    return _sportDataImage;
}
- (UIImage *)shareImage {
    if (!_shareImage) {
        _shareImage = [self creatShareImage];
    }
    return _shareImage;
}
- (SportShareView *)sportShareView {
    if (!_sportShareView) {
        _sportShareView = [[SportShareView alloc]initWithFrame:self.view.bounds];
        @weakify_self
        _sportShareView.clickShareBtnBlock = ^(NSInteger page) {
            @strongify_self
            [self clickShareWithTag:page];
        };
        _sportShareView.clickCloseBlock = ^ {
            @strongify_self
            [self clickBackBtn];
        };
    }
    return _sportShareView;
}
- (ShareIconView *)shareIconView {
    if (!_shareIconView) {
        _shareIconView = [[ShareIconView alloc]initWithFrame:CGRectMake1(0, -909, 1125, 418-192)];
    }
    return _shareIconView;
}
- (UIImageView *)shareCodeView {
    if (!_shareCodeView) {
        _shareCodeView = [[UIImageView alloc]initWithFrame:CGRectMake720(-740, 0, 720, 160)];
        _shareCodeView.image = [UIImage imageNamed:@"share_code_image"];
        
    }
    return _shareCodeView;
}

/**
 *  结束的时候记得清除一些mapView
 */
- (void)dealloc {
    //[self clearMapView];
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
