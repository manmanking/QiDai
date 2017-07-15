//
//  SportEndViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/6.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportEndViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MAMapViewManager.h"
#import "LocationManager.h"
#import "SportModel.h"
#import "QDAlertView.h"
#import "SportEndView.h"
#import "SportShareView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CardScrollView.h"
#import "SportShareView.h"
#import "ShareIconView.h"
#import "LocationModel.h"
#import "CustomAnnotation.h"
#import "NSDate+Tools.h"
#import "UIImage+Tools.h"
#import "SportDataBaseManager.h"
#import "ItemDataBaseManager.h"
#import "SynchronizeRidingRecordManager.h"
#import "UploadImageManager.h"
#import "UploadFileManager.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "SinaManager.h"
#import "QQManager.h"
#import "UserInfoDBManager.h"
#import "WeChatManager.h"
#import "ReachabilityManager.h"
#define kGCCardRatio 0.6
#define kGCCardWidth CGRectGetWidth(self.view.frame)*kGCCardRatio
#define kGCCardHeight kGCCardWidth/kGCCardRatio
@interface SportEndViewController ()<MAMapViewDelegate,CardScrollViewDelegate,CardScrollViewDataSource>
/** 管理键盘用的*/
@property (nonatomic,strong) TPKeyboardAvoidingScrollView *scrollView;
/** 地图起点的大头针*/
@property (strong, nonatomic) CustomAnnotation *startAnnotation;
/** 地图终点的大头针*/
@property (strong, nonatomic) CustomAnnotation *endAnnotation;
/** 图片浏览器*/
@property (nonatomic, strong) CardScrollView *cardScrollView;
/** 存放图片的数组*/
@property (nonatomic, strong) NSMutableArray *photosArrayM;
/** 骑行的截图*/
@property (strong,nonatomic) UIImage *sportDataImage;
/** 地图下面的view*/
@property (strong,nonatomic) SportEndView *sportEndView;
/** 运动结束弹出来的分享的view*/
@property (nonatomic,strong) SportShareView *sportShareView;
/** 分享图的头部*/
@property (nonatomic,strong) ShareIconView *shareIconView;
/** 分享图的二维码,由该view截图获取 */
@property (nonatomic,strong) UIImageView *shareCodeView;
/** 要分享出去的图片，应该多次图像操作*/
@property (nonatomic,strong) UIImage *shareImage;


@property (nonatomic,strong)QDAlertView *customAlertView;

@end

@implementation SportEndViewController
#pragma mark --- life cycle
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clearMapView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self creatTitleViewWithString:@"骑行报告"];
    
    self.navigationItem.hidesBackButton = YES;
    
    //self.pointsArr = @[].mutableCopy;
    self.photosArrayM = @[].mutableCopy;
    
    [self refreshPictureView];

    [self.view addSubview:self.scrollView];
    
    [self setupMapView];
    
    self.sportEndView = [[SportEndView alloc]initWithFrame:CGRectMake720(0, 712, 720, 940)];
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
    
    [self setupBottomView];
    
    
    // Do any additional setup after loading the view.
}
/** 创建地图*/
- (void)setupMapView {
    //配置用户Key
    //[AMapServices sharedServices].apiKey = kGAODELBS_KEY;
    self.sportMapView = [MAMapViewManager shareMAMapView];
    self.sportMapView.frame = CGRectMake720(0, 0, 720, 712);
    self.sportMapView.delegate = self;
    self.sportMapView.showsCompass = NO;
    self.sportMapView.showsScale = NO;
    [self.scrollView addSubview:self.sportMapView];
    //路线显示在地图中心
    if (self.locationModelAry.count>2) {
        LocationModel *location = [self.locationModelAry objectAtIndex:self.locationModelAry.count/2];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.itemModel.latitude, location.itemModel.longitude);
        [self.sportMapView setCenterCoordinate:coordinate animated:YES];
    }
    //根据骑行路程调整缩放级别
    CGFloat totalDistance = self.sportModel.totalDistance;
    if (totalDistance > 20*1000) {
        [self.sportMapView setZoomLevel:10 animated:YES];
    } else if (totalDistance > 10*1000) {
        [self.sportMapView setZoomLevel:11 animated:YES];
    } else if (totalDistance > 5*1000) {
        [self.sportMapView setZoomLevel:12 animated:YES];
    } else if (totalDistance > 2*1000) {
        [self.sportMapView setZoomLevel:13.5 animated:YES];
    } else if (totalDistance > 1*1000) {
        [self.sportMapView setZoomLevel:14.5 animated:YES];
    } else if (totalDistance > 0.5*1000) {
        [self.sportMapView setZoomLevel:15 animated:YES];
    } else if (totalDistance > 50) {
        [self.sportMapView setZoomLevel:16 animated:YES];
    } else {
        [self.sportMapView setZoomLevel:8 animated:YES];
    }
    
    //绘制地图相关
    [self drawStartPointAndEndPoint];
    [self mapLocationWith:self.locationModelAry];
    [self drowMapLine];
}
/** 建立底部的view*/
- (void)setupBottomView {
    UIButton *discardBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 0, 360, 110) title:@"丢弃" titleColor:kColorForfff titleFont:36 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
        [self clickDiscardBtn];
    }];
    UIButton *saveBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(360, 0, 360, 110) title:@"保存" titleColor:UIColorFromRGB_16(0xe60012) titleFont:36 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
        [self clickSaveBtn];
    }];
    discardBtn.top = HCDH - 110*SizeScaleSubjectTo720 - 64;
    saveBtn.top = HCDH - 110*SizeScaleSubjectTo720 - 64;
    [self.view addSubview:discardBtn];
    [self.view addSubview:saveBtn];
}
#pragma mark --- click Action
//点击丢弃按钮
- (void)clickDiscardBtn {
    [[LocationManager instance] formattData];
    //[self clearMapView];
    
    if (self.isPush) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击保存按钮
- (void)clickSaveBtn {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //没登录让登陆
    if (![[LoginManager instance] isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    //修改骑行的名称
    self.sportModel.ridingName = self.sportEndView.nameTF.text;
    //保存本地
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    self.sportModel.uId = [[LoginManager instance] getUserId];
    QDLog(@"sport model %@",self.sportModel.mj_keyValues);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //运动详细数据  运动总数据
        [SportDataBaseManager  insertSportData:self.sportModel];
        [ItemDataBaseManager insertItemDataArray:_locationModelAry];
        
        [self saveSportData];
    });
    
}
/** 保存骑行数据*/
- (void)saveSportData {
    
    
    

    NSString *sid =  self.sportModel.sId;
    NSString *uid = [[LoginManager instance] getUserId];
    //上传骑行数据
    [SynchronizeRidingRecordManager uploadRidingRecord:self.sportModel pictureArray:self.photosArrayM success:^(NSDictionary *result) {
        
        self.sportModel.shareUrl = [result valueForKey:@"link"];
        //更新分享的url
        [SportDataBaseManager updateUpLoadShareUrlWithUrl:self.sportModel.shareUrl UserId:uid sportId:sid];
        
        //更新上传状态
        [SportDataBaseManager updateUpLoadStatusWithUserId:uid sportId:sid];
        
        //NSString *ridingId = [result valueForKey:@"id"];
        
        //self.urlDictionary = result;
        //[self saveDataCompletionWithTag:tag];
        
        //NSLog(@"%@",result);
        NSString *ridingId = [result valueForKey:@"id"];
        // start of line
        
        // 加入图片 测试接口
//        UIImageView *testImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_add_friend"]];
//        NSString *testImageStr = @"testImage/";
//        [self.photosArrayM addObject:testImageStr];
        
        
        // end of line
        //多图上传
        if (self.photosArrayM.count>0) {
            [UploadImageManager uploadImageWithArray:self.photosArrayM  dataImage:self.sportDataImage ridingId:ridingId userId:[[LoginManager instance] getUserId] WithSuccess:^(double progress) {
                NSLog(@"多图上传完成");
            } completion:^(NSDictionary *dic) {
                if ([[dic valueForKey:@"code"] isEqualToString:@"00"]) {
                    NSLog(@" 上传成功 。。。");
                } else {
                    NSLog(@" 上传失败 。。。");
                }
            }];
        }
        

        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"保存成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
            //[self clickDiscardBtn];
            [self popShareView];
        });
        
    } failure:^{
        
        // modify by manman on 2016-10-21  start of line
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[MBProgressHUDManager instance] hideHUD];
//            UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
//            bgView.backgroundColor = UIColorFromAlphaRGB(0x000000, 0.2);
//            [self.view addSubview:bgView];
//            UIImageView *alertImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 554, 740)];
//            alertImageView.center = self.view.center;
//            alertImageView.top = 160*SizeScale;
//            alertImageView.image = [UIImage imageNamed:@"sport_no_network"];
//            UIButton *sureBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(155, 615, 244, 70) title:@"知道了" titleColor:kColorForfff titleFont:28 backgroundColor:kColorForE60012 tapAction:^(UIButton *button) {
//                [self clickDiscardBtn];
//            }];
//            alertImageView.userInteractionEnabled = YES;
//            [alertImageView addSubview:sureBtn];
//            [bgView addSubview:alertImageView];
//            
//        });
        // end of line
        // add by manman on 2016-10-21 start of line
        [[MBProgressHUDManager instance] hideHUD];
        [self alertViewForSportDataUploadFailure];
        
        // end of line
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
    }];
    
    //把每个定位点的数据压缩到zip 文件中 并上传到服务器
    [UploadFileManager zipAndUploadItemFileWithFileName:sid success:^{
        NSLog(@"上传定位点成功");
        //更新本地状态
        [SportDataBaseManager updateUpLoadDetailStatusWithUserId:[[LoginManager instance] getUserId] sportId:sid];
    } failure:^{
        NSLog(@"上传定位点失败");
    }];
    
    
}


- (void)alertViewForSportDataUploadFailure
{
    [self.view addSubview:self.customAlertView];
    NSString *alertTitle = @"无网络连接，请在网络状态良好的时，到“历史骑行”中上传服务器，否则在";
    
    self.customAlertView.title = [NSString stringWithFormat:@"%@%ld小时后被丢弃。",alertTitle,[self calculateRemainTime]];//您有未完成的运动记录是否保存
    QDLog(@"into verifyWhetherExceptionSportData ...");
    self.customAlertView.sureBtnTitle = @"知道了";
    @weakify_self
    self.customAlertView.clickSureBlock = ^{
        @strongify_self
       [self clickDiscardBtn];
    };
    
    [self.customAlertView updateUIAutolayout];
    
}

- (NSInteger)calculateRemainTime
{
    NSInteger remainTime = 24;
    NSArray *existUploadDataArr =  [UserInfoDBManager verifyFreshSportDataExistWillUploadWithUserId:[[LoginManager instance] getUserId]];
    NSDate *currentDate = [NSDate date];
    
    if (existUploadDataArr.count>0) {
        SportModel *tmpModel  =  existUploadDataArr[0];
         NSDateComponents *dateCompoent = [PublicTool intervalFromLastDate:tmpModel.startTime AndExpiredDate:currentDate];
        remainTime  = 24 - dateCompoent.hour;
        return remainTime;
        
    }

    return remainTime;
}


- (BOOL)verifyNetwork
{
    
    
    
    return YES;
}


#pragma mark --- private method
/** 弹出分享视图*/
- (void)popShareView {
    [self.view addSubview:self.sportShareView];
//    [self.view addSubview:self.shareCodeView];
//    [self.view addSubview:self.shareIconView];
}
/**
 *  点击分享页面的按钮
 *
 *  @param tag tag - 当前的tag
 */
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
    //if ([[SinaManager instance] isSinaInstalled]) {
        [arrayM addObject:UMShareToSina];
    //}
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
    if ([self.locationModelAry count]>1) {
        //[self.sportMapView removeAnnotation:self.startAnnotation];
        self.endAnnotation = [[CustomAnnotation alloc] initWithCoordinate:[self getLastCoordinate] andMarkTitle:@"结束" andMarkSubTitle:@""];
        self.endAnnotation.image = [UIImage imageNamed:@"point_end"];
        [self.sportMapView addAnnotation:self.endAnnotation];
    }
}
/** 绘制地图曲线*/
- (void)drowMapLine {
    CLLocationCoordinate2D pointsToUse[self.locationModelAry.count];
    //_pointsArr = [[NSMutableArray alloc]initWithCapacity:self.locationModelAry.count];
    for (int i = 0; i < self.locationModelAry.count; i++) {
        CLLocationCoordinate2D coords;
        coords.latitude = ((LocationModel *)self.locationModelAry[i]).itemModel.latitude;
        coords.longitude = ((LocationModel *)self.locationModelAry[i]).itemModel.longitude;
        pointsToUse[i] = coords;
    }
    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:pointsToUse count:[self.locationModelAry count]];
    if ([self.sportMapView.overlays indexOfObject:self.sportMapView.overlays]) {
        //[self.sportMapView removeOverlays:self.sportMapView.overlays];
    }
    [self.sportMapView addOverlay:lineOne];
    const CGFloat screenEdgeInset = 20;
    UIEdgeInsets inset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset, screenEdgeInset);
    [self.sportMapView setVisibleMapRect:lineOne.boundingMapRect edgePadding:inset animated:NO];
    
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
    [self.sportMapView removeOverlays:self.sportMapView.overlays];
    self.sportMapView.delegate = nil;
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
#pragma mark --- 图像操作
/**分享出去的图 */
- (UIImage *)creatShareImage {
    UIImage *iconImage = [UIImage imageFromView:self.shareIconView];
    UIImage *QRCodeImage = [UIImage imageFromView:self.shareCodeView];
    //modify by manman BUG 217 on 2016-09-13 start of line
    [self.sportEndView setWhetherShowWriteImageView:YES];
    //end of line
    UIImage *sportDataImage = [UIImage imageFromView:self.sportEndView];
    UIImage *mapImage = [self.sportMapView takeSnapshotInRect:self.sportMapView.bounds];
    UIImage *shareImage1 = [UIImage addImage:iconImage toImage:mapImage];
    UIImage *shareImage2 = [UIImage addImage:sportDataImage toImage:QRCodeImage];
    UIImage *shareImage = [UIImage addImage:shareImage1 toImage:shareImage2];
    return shareImage;
}

#pragma mark - mapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if (![annotation isKindOfClass:[CustomAnnotation class]]) {
        return nil;
    }
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
    return annotationView;
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if (![overlay isKindOfClass:[MAPolyline class]]) {
        return nil;
    }
    MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc]initWithOverlay:overlay];
    polylineRenderer.lineWidth = 5.0;
    polylineRenderer.strokeColor = [UIColor redColor];
    return polylineRenderer;
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
    return card;
}

- (void)deleteCardWithIndex:(NSInteger)index {
    [self.photosArrayM removeObjectAtIndex:index];
}
#pragma mark --- lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
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
            [self clickDiscardBtn];
        };
    }
    return _sportShareView;
}
- (ShareIconView *)shareIconView {
    if (!_shareIconView) {
        _shareIconView = [[ShareIconView alloc]initWithFrame:CGRectMake1(0, 909, 1125, 418-192)];
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

- (QDAlertView *)customAlertView
{
    //NSLog(@"")
    if (!_customAlertView) {
        _customAlertView = [[QDAlertView alloc]initWithFrame:self.view.bounds];
    }
    return _customAlertView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
