//
//  LocationManager.m
//  Leqi
//
//  Created by Tianyu on 14/12/18.
//  Copyright (c) 2014年 com.hoolai. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#import "LocationModel.h"
#import "CLLocation+Sino.h"

#import "SportModel.h"
#import "MJExtension.h"
#import "ItemModel.h"
#import "TotalDataModel.h"
#import "UserInfoModel.h"
#import "UserInfoDBManager.h"
#import "LoginManager.h"
#import "UploadFileManager.h"
#import "PublicTool.h"
#import <mach/mach_time.h>

#define kGPSRANGE_GETPOINT 45

static const NSUInteger kDistanceFilter = 5; // the minimum distance (meters) for which we want to receive location updates (see docs for CLLocationManager.distanceFilter)
static const NSUInteger kHeadingFilter = 30; // the minimum angular change (degrees) for which we want to receive heading updates (see docs for CLLocationManager.headingFilter)
static const NSUInteger kDistanceAndSpeedCalculationInterval = 3; // the interval (seconds) at which we calculate the user's distance and speed
static const NSUInteger kMinimumLocationUpdateInterval = 6; // the interval (seconds) at which we ping for a new location if we haven't received one yet
static const NSUInteger kNumLocationHistoriesToKeep = 10; // the number of locations to store in history so that we can look back at them and determine which is most accurate
static const NSUInteger kValidLocationHistoryDeltaInterval = 3; // the maximum valid age in seconds of a location stored in the location history
static const NSUInteger kNumSpeedHistoriesToAverage = 3; // the number of speeds to store in history so that we can average them to get the current speed
static const NSUInteger kPrioritizeFasterSpeeds = 1; // if > 0, the currentSpeed and complete speed history will automatically be set to to the new speed if the new speed is faster than the averaged speed
static const NSUInteger kMinLocationsNeededToUpdateDistanceAndSpeed = 3; // the number of locations needed in history before we will even update the current distance and speed
static const CGFloat kRequiredHorizontalAccuracy = 20.0; // the required accuracy in meters for a location.  if we receive anything above this number, the delegate will be informed that the signal is weak
static const CGFloat kMaximumAcceptableHorizontalAccuracy = 70.0; // the maximum acceptable accuracy in meters for a location.  anything above this number will be completely ignored
static const NSUInteger kGPSRefinementInterval = 15; // the number of seconds at which we will attempt to achieve kRequiredHorizontalAccuracy before giving up and accepting kMaximumAcceptableHorizontalAccuracy

static const CGFloat kSpeedNotSet = -1.0;
@interface LocationManager ()<CLLocationManagerDelegate>

@property (assign, nonatomic) BOOL isSportPause;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *testTimer;

@property (assign, nonatomic) double sumSpeed;
@property (assign, nonatomic) double fastestSpeed;
@property (assign, nonatomic) double upAltitude;
@property (assign, nonatomic) double downAltitude;
@property (assign, nonatomic) double sumAltitude;
@property (assign, nonatomic) double maxAltitude;
@property (assign, nonatomic) double sumDistance;
@property (assign, nonatomic) double sumCalorie;

@property (assign, nonatomic) int weight;

//New Location
@property (nonatomic, strong) NSDate *startTimestamp;
@property (nonatomic) double currentSpeed;
@property (nonatomic, strong) NSMutableArray *speedHistory;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic) BOOL readyToExposeDistanceAndSpeed;
@property (nonatomic) NSUInteger lastDistanceAndSpeedCalculation;
@property (nonatomic) BOOL forceDistanceAndSpeedCalculation;
@property (nonatomic, strong) CLLocation *lastRecordedLocation;
@property (nonatomic) CLLocationDistance totalDistance;
@property (nonatomic) BOOL sportLocation;
@property (nonatomic, strong)CLGeocoder *geocoder;


@property (nonatomic) BOOL isWeekGPS;

//用户静止数据
@property (nonatomic,strong) NSMutableArray *stopArray;

//@property (strong, nonatomic) UILabel *testDataLabel;

@end

@implementation LocationManager

double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /  (double)timebase.denom / 1e9;
}

+ (instancetype)instance
{
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc] init];
    });
    return pRet;
}

- (id)init
{
    if (self = [super init]) {

//        self.testDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 100)];
//        self.testDataLabel.text = @"点击开始运动";
//        [[UIApplication sharedApplication].keyWindow addSubview:self.testDataLabel];
        
     

        self.locationDataAry = [[NSMutableArray alloc] initWithCapacity:10];
        self.curentTime = 0;
        self.sumSpeed = 0;
        self.fastestSpeed = 0;
        self.upAltitude = 0;
        self.downAltitude = 0;
        self.sumAltitude = 0;
        self.maxAltitude = 0;
        self.sumDistance = 0;
        self.sumCalorie = 0;
        
        self.speedHistory = [NSMutableArray arrayWithCapacity:kNumSpeedHistoriesToAverage];
        self.locationHistory = [NSMutableArray arrayWithCapacity:kNumLocationHistoriesToKeep];
        self.stopArray = [NSMutableArray arrayWithCapacity:10];
        [self initLocationManager];
    }
    
    return self;
}

- (void)initLocationManager
{
    if (self.locationManager) {
        
        [self.locationManager startUpdatingLocation];
        
    } else {
        self.geocoder = [[CLGeocoder alloc]init];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5.0;
        self.locationManager.headingFilter = 5;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            //[self.locationManager requestWhenInUseAuthorization];//只在前台开启定位
            [self.locationManager requestAlwaysAuthorization];//在后台也可定位
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        }
    }
}

- (void)setupLocationManager
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:[[LoginManager instance] getUserId]];
    self.weight =  userInfo.weight ? [userInfo.weight intValue] : 0;
    self.sportModel = [[SportModel alloc] init];
    self.sportModel.startTime = [NSDate date];
#pragma -mark -sid
    self.sportModel.sId = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    [self setUpTimer];
    [self prepLocationUpdates];    
}

- (BOOL)prepLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationHistory removeAllObjects];
        [self.speedHistory removeAllObjects];
        self.lastDistanceAndSpeedCalculation = 0;
        self.currentSpeed = kSpeedNotSet;
        self.readyToExposeDistanceAndSpeed = YES;
        self.forceDistanceAndSpeedCalculation = YES;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        self.sportLocation = YES;
        return YES;
    } else {
        return NO;
    }
}

- (void)setUpTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)timeRun:(NSTimer *)timer
{
    self.curentTime++;
    
    // 本次运动用时
    self.sportModel.sumTime = self.curentTime;

    if (self.timeRunBlock) {
        self.timeRunBlock(self.curentTime);
    }
    
    CLLocation *location = self.locationManager.location;
    if (location.horizontalAccuracy > 45.0f || location.horizontalAccuracy<0) {
        
        if (self.locationBlock && !_isWeekGPS) {
            self.locationBlock(0.0,nil,nil);
        }
        
        _isWeekGPS = YES;
    }else{
        _isWeekGPS = NO;
    }
    
    if (location) {
        
        if ([_stopArray count] == 0) {
            [_stopArray addObject:location];
        }else{
            
            CLLocation *lastLocation = [_stopArray lastObject];
            CLLocationDistance distance = [location distanceFromLocation:lastLocation];
            if (distance<0.000000000001f) {
                [_stopArray addObject:location];
            }else{
                [_stopArray removeAllObjects];
            }
            
            if ([_stopArray count]>=7)
            {
                [_stopArray removeAllObjects];
                
                if ([_locationDataAry count]>0)
                {
                    self.locationBlock(0.0,nil,nil);
                }
                else
                {
                    LocationModel *locationModel = [[LocationModel alloc] initWithLocation:[location locationMarsFromEarth]];
                    locationModel.itemModel.sid = self.sportModel.sId;
                    NSString *fileName = locationModel.itemModel.sid;
                    [UploadFileManager writeToTxtWithFileName:fileName item:locationModel.itemModel];
                    [self.locationDataAry addObject:locationModel];
                    self.locationBlock(0.0,_locationDataAry,nil);
                }
            }
        }
    }
}

- (void)timePause
{
    [self.timer setFireDate:[NSDate distantFuture]];
    [self pauseTestTimer];
}

- (void)timeGoOn
{
    [self.timer setFireDate:[NSDate date]];
    [self goOnTestTimer];
}

- (void)timeEnd
{
    [self.timer invalidate];
    self.curentTime = 0;
    [self stopTestTimer];
}


#pragma mark - CLLocationManager Delegate ------start
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (
        ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] && status != kCLAuthorizationStatusNotDetermined && status != kCLAuthorizationStatusAuthorizedAlways) ||
        (![self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] && status != kCLAuthorizationStatusNotDetermined && status != kCLAuthorizationStatusAuthorized)
        ) {
        
        NSString *message = @"您的手机目前并未开启定位服务，如欲开启定位服务，请至设定->隐私->定位服务，开启本程序的定位服务功能";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法定位" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }else {
        
        [self.locationManager startUpdatingLocation];
    }
}



- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{

   // NSLog(@"newHeadIng magneticHeading = %f   trueHeading = %f",newHeading.magneticHeading,newHeading.trueHeading);

}




- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 此回调必须实现，否则 self.locationManager 无法改变
//    self.testDataLabel.text = [NSString stringWithFormat:@"%.2f",((CLLocation *)[locations lastObject]).speed *3.6];
    
    if ([locations count] <1 || !self.sportLocation) {
        return;
    }

    CLLocation *oldLocation = [self.locationHistory lastObject];
    
//    self getAddressByLatitude:oldLocation.altitude longitude:oldLocation.
    BOOL isStaleLocation = ([oldLocation.timestamp compare:self.startTimestamp] == NSOrderedAscending);
    
    double horizontalAccuracy = kRequiredHorizontalAccuracy;
    
    CLLocation *newLocation = [locations lastObject];
    
    if (!isStaleLocation && newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy <= horizontalAccuracy) {
        
        [self.locationHistory addObject:newLocation];
        if ([self.locationHistory count] > kNumLocationHistoriesToKeep) {
            [self.locationHistory removeObjectAtIndex:0];
        }
        
        BOOL canUpdateDistanceAndSpeed = NO;
        if ([self.locationHistory count] >= kMinLocationsNeededToUpdateDistanceAndSpeed) {
            canUpdateDistanceAndSpeed = YES && self.readyToExposeDistanceAndSpeed;
        }

        if (self.forceDistanceAndSpeedCalculation || [NSDate timeIntervalSinceReferenceDate] - self.lastDistanceAndSpeedCalculation > kDistanceAndSpeedCalculationInterval) {
            //self.forceDistanceAndSpeedCalculation = NO;
            self.lastDistanceAndSpeedCalculation = [NSDate timeIntervalSinceReferenceDate];
            
            CLLocation *lastLocation = (self.lastRecordedLocation != nil) ? self.lastRecordedLocation : oldLocation;
            
            CLLocation *bestLocation = nil;
            CGFloat bestAccuracy = kRequiredHorizontalAccuracy;
            for (CLLocation *location in self.locationHistory) {
                if ([NSDate timeIntervalSinceReferenceDate] - [location.timestamp timeIntervalSinceReferenceDate] <= kValidLocationHistoryDeltaInterval) {
                    if (location.horizontalAccuracy <= bestAccuracy && location != lastLocation) {
                        bestAccuracy = location.horizontalAccuracy;
                        bestLocation = location;
                    }
                }
            }
            if (bestLocation == nil) bestLocation = newLocation;
            
            CLLocationDistance distance = [bestLocation distanceFromLocation:lastLocation];
            if (canUpdateDistanceAndSpeed) self.totalDistance += distance;
            self.lastRecordedLocation = bestLocation;
            
            NSTimeInterval timeSinceLastLocation = [bestLocation.timestamp timeIntervalSinceDate:lastLocation.timestamp];
            if (timeSinceLastLocation > 0) {
               // CGFloat speed = distance / timeSinceLastLocation;  //根据距离计算速度
                CGFloat speed = bestLocation.speed;
                if (speed <= 0 && [self.speedHistory count] == 0) {
                    // don't add a speed of 0 as the first item, since it just means we're not moving yet
                } else {
                    [self.speedHistory addObject:[NSNumber numberWithDouble:speed]];
                }
                if ([self.speedHistory count] > kNumSpeedHistoriesToAverage) {
                    [self.speedHistory removeObjectAtIndex:0];
                }
                if ([self.speedHistory count] > 1) {
                    double totalSpeed = 0;
                    for (NSNumber *speedNumber in self.speedHistory) {
                        totalSpeed += [speedNumber doubleValue];
                    }
                    if (canUpdateDistanceAndSpeed) {
                        double newSpeed = totalSpeed / (double)[self.speedHistory count];
                        if (kPrioritizeFasterSpeeds > 0 && speed > newSpeed) {
                            newSpeed = speed;
                            [self.speedHistory removeAllObjects];
                            for (int i=0; i<kNumSpeedHistoriesToAverage; i++) {
                                [self.speedHistory addObject:[NSNumber numberWithDouble:newSpeed]];
                            }
                        }
                        self.currentSpeed = newSpeed;
                    }
                }
            }
            
            [self handleLocation:_lastRecordedLocation];
        }
    }
}
#pragma -----mark ------------CLLocationManagerDelegate ---end
#pragma mark - 最新方式数据逻辑处理
-(void)handleLocation:(CLLocation *)location{

    LocationModel *locationModel = [[LocationModel alloc] initWithLocation:[location locationMarsFromEarth]];
    locationModel.itemModel.sid = self.sportModel.sId;

    // 本次运动卡路里
//    [self calculateCalorie:(locationModel.itemModel.speed < 0.0 ? 0.0 : locationModel.itemModel.speed)];
    
    // 本次运动最大速度
    // 本次运动最高海拔
    // 本次运动累计上升海拔
    if (self.locationDataAry.count >= 1) {
        
        if (_currentSpeed > self.fastestSpeed) {
            self.fastestSpeed = _currentSpeed;
        }
        
        self.maxAltitude = [PublicTool geFastestWithValue1:((LocationModel *)[self.locationDataAry lastObject]).itemModel.altitude
                                                 withValue2:locationModel.itemModel.altitude];
        
        double value = [PublicTool getDValueWithFirstValue:locationModel.itemModel.altitude
                                            withSecondValue:((LocationModel *)[self.locationDataAry lastObject]).itemModel.altitude];
        if (value > 0.0) {
            self.upAltitude  += value;
        } else {
            self.downAltitude += fabs(value);
        }
        
    } else {
        
        self.fastestSpeed = 0.0;
        self.maxAltitude = 0.0;
        self.upAltitude = 0.0;
        self.downAltitude = 0.0;
    }
    
    self.sportModel.maxSpeed = self.fastestSpeed;
    self.sportModel.maxAltitude = self.maxAltitude;
    self.sportModel.upAltitude = self.upAltitude;
    self.sportModel.totalDistance = _totalDistance;
    self.sportModel.downAltitude = self.downAltitude;
    
    
    // 本次运动总公里数
    if (self.locationDataAry.count > 1) {
        CLLocation *oldLocation = [self getLocationWithLatitude:((LocationModel *)[self.locationDataAry lastObject]).itemModel.latitude withLongitude:((LocationModel *)[self.locationDataAry lastObject]).itemModel.longitude];
        CLLocation *newLocation = [self getLocationWithLatitude:locationModel.itemModel.latitude withLongitude:locationModel.itemModel.longitude];
        self.sumDistance = self.sumDistance + [self calculateDistanceWithOld:oldLocation withNew:newLocation];
        self.sportModel.totalDistance = self.sumDistance;
    }
#pragma -mark -改
    self.sportModel.totalDistance = self.sumDistance;
#pragma -mark -最快速度，平均速度
    // 本次运动平均速度
    NSString *timeString = [NSString stringWithFormat:@"%d.00f",_curentTime];
    self.sportModel.averageSpeed = _totalDistance/[timeString floatValue];
    if (self.sportModel.averageSpeed > self.fastestSpeed) {
        self.sportModel.averageSpeed = 0.8*self.fastestSpeed;
    }
#pragma -mark -海拔
    // 本次运动平均海拔
    self.sumAltitude = self.sumAltitude + locationModel.itemModel.altitude;
    self.sportModel.averageAltitude = (self.locationDataAry.count > 0) ? self.sumAltitude/self.locationDataAry.count : 0.0;
    
    if ([_locationDataAry count]>0) {
        // create data array
        if (locationModel.horizontalAccuracy <= 20) {
            
            if ([_locationDataAry count] == 1) {
                LocationModel *model = [_locationDataAry objectAtIndex:0];
                if (model.horizontalAccuracy>20) {
                    [_locationDataAry removeObjectAtIndex:0];
                }
            }
            
            // 写入txt文件
            NSString *fileName = locationModel.itemModel.sid;
            [UploadFileManager writeToTxtWithFileName:fileName item:locationModel.itemModel];
            [self.locationDataAry addObject:locationModel];
        }
        
    }else{
        
        // 写入txt文件
        NSString *fileName = locationModel.itemModel.sid;
        [UploadFileManager writeToTxtWithFileName:fileName item:locationModel.itemModel];
        [self.locationDataAry addObject:locationModel];
    }
    
    if (self.locationBlock) {
        self.locationBlock(_currentSpeed,_locationDataAry,_sportModel);
    }
}


#pragma mark 根据坐标取得地名

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
}






#pragma mark - old handle --弃用

- (void)setupLocationDataWith:(LocationModel *)locationModel
{
    if (locationModel.horizontalAccuracy >= kGPSRANGE_GETPOINT && self.locationDataAry.count > 0) {
        
        NSLog(@"噪点坐标经度:%f",locationModel.horizontalAccuracy);
        
        locationModel.itemModel.speed = 0.0;
        locationModel.horizontalAccuracy = 0.0;
        locationModel.itemModel.latitude = ((LocationModel *)[self.locationDataAry lastObject]).itemModel.latitude;
        locationModel.itemModel.longitude = ((LocationModel *)[self.locationDataAry lastObject]).itemModel.longitude;
        
        //写入txt文件
        NSString *fileName = locationModel.itemModel.sid;
        [UploadFileManager writeToTxtWithFileName:fileName item:locationModel.itemModel];
        
        [self.locationDataAry addObject:locationModel];
        
        if (self.locationDataBlock) {
            self.locationDataBlock(self.locationDataAry);
        }
        
        return;
    }
    
    // 本次运动平均速度
    self.sumSpeed = self.sumSpeed + (locationModel.itemModel.speed < 0 ? 0 :  locationModel.itemModel.speed);
    self.sportModel.averageSpeed = (self.locationDataAry.count > 0) ? self.sumSpeed/self.locationDataAry.count : 0.0;
    
    // 本次运动平均海拔
    self.sumAltitude = self.sumAltitude + locationModel.itemModel.altitude;
    self.sportModel.averageAltitude = (self.locationDataAry.count > 0) ? self.sumAltitude/self.locationDataAry.count : 0.0;
    
    // 本次运动卡路里
//    [self calculateCalorie:(locationModel.itemModel.speed < 0.0 ? 0.0 :  locationModel.itemModel.speed)];
    
    // 本次运动最大速度
    // 本次运动最高海拔
    // 本次运动累计上升海拔
    if (self.locationDataAry.count >= 1) {
        
        if (locationModel.itemModel.speed > self.fastestSpeed) {
            self.fastestSpeed = locationModel.itemModel.speed;
        }
        
        self.maxAltitude = [PublicTool geFastestWithValue1:((LocationModel *)[self.locationDataAry lastObject]).itemModel.altitude
                                                 withValue2:locationModel.itemModel.altitude];
        
        double value = [PublicTool getDValueWithFirstValue:locationModel.itemModel.altitude
                                            withSecondValue:((LocationModel *)[self.locationDataAry lastObject]).itemModel.altitude];
        if (value > 0) {
            self.upAltitude = self.upAltitude + value;
        } else {
            self.downAltitude = self.downAltitude + fabs(value);
        }
        
    } else {
        
        self.fastestSpeed = 0.0;
        self.maxAltitude = 0.0;
        self.upAltitude = 0.0;
        self.downAltitude = 0.0;
    }
    
    self.sportModel.maxSpeed = self.fastestSpeed;
    self.sportModel.maxAltitude = self.maxAltitude;
    self.sportModel.upAltitude = self.upAltitude;
    
    // 本次运动总公里数
    if (self.locationDataAry.count > 1) {
        CLLocation *oldLocation = [self getLocationWithLatitude:((LocationModel *)[self.locationDataAry lastObject]).itemModel.latitude withLongitude:((LocationModel *)[self.locationDataAry lastObject]).itemModel.longitude];
        CLLocation *newLocation = [self getLocationWithLatitude:locationModel.itemModel.latitude withLongitude:locationModel.itemModel.longitude];
        self.sumDistance = self.sumDistance + [self calculateDistanceWithOld:oldLocation withNew:newLocation];
        self.sportModel.totalDistance = self.sumDistance;
    }
    
    
    if ([_locationDataAry count]>0) {
        // create data array
        if (locationModel.horizontalAccuracy <= 20) {
            
            if ([_locationDataAry count] == 1) {
                LocationModel *model = [_locationDataAry objectAtIndex:0];
                if (model.horizontalAccuracy>20) {
                    [_locationDataAry removeObjectAtIndex:0];
                }
            }
            
            // 写入txt文件
            NSString *fileName = locationModel.itemModel.sid;
            [UploadFileManager writeToTxtWithFileName:fileName item:locationModel.itemModel];
            [self.locationDataAry addObject:locationModel];
        }
        
    }else{
#warning text data
        // 写入txt文件
        NSString *fileName = locationModel.itemModel.sid;
        [UploadFileManager writeToTxtWithFileName:@"123456" item:locationModel.itemModel];
        [self.locationDataAry addObject:locationModel];
    }

    // 位置数据集合
    if (self.locationDataBlock) {
        self.locationDataBlock(self.locationDataAry);
    }
    
}



#pragma  mark  --helper
- (void)pauseSport
{
    self.isSportPause = YES;
    self.sportLocation = NO;
    [self timePause];
}
- (void)automaticPauseSport
{
    self.isSportPause = YES;
    self.sportLocation = YES;
    [self timePause];
}
- (void)playSport
{
    self.isSportPause = NO;
    self.sportLocation = YES;
    [self timeGoOn];
}

- (void)sportGoOnWithClock
{
    if (self.isSportPause) {
        self.isSportPause = NO;
        self.sportLocation = YES;
        [self timeGoOn];
    }
}

- (void)endSport
{
    [self calculateCalorie];

    self.sportModel.endTime = [NSDate date];
    self.sportLocation = NO;
    [self timeEnd];
}

- (void)calculateCalorie
{
    CGFloat t = self.curentTime / 60.0;
    CGFloat u = 0.01 * t + 0.8;
    CGFloat v = self.totalDistance / self.curentTime * 3.6;
    
    // 卡路里 = t(分钟) * v(速度km/h) / 3 * u * (1 + 体重(kg) / 1200)
    self.sportModel.calorie = t * v / 3 * u * (1 + self.weight / 1200);
    
//    self.testDataLabel.adjustsFontSizeToFitWidth = YES;
//    self.testDataLabel.text = [NSString stringWithFormat:@"平均速度：%f，总路程：%f，体重：%d，卡路里：%f",self.sportModel.averageSpeed, _totalDistance, self.weight, self.sportModel.calorie];
}

- (double)calculateDistanceWithOld:(CLLocation *)orig withNew:(CLLocation *)dist
{
    CLLocationDistance kilometers = [orig distanceFromLocation:dist];
    return kilometers;
}

- (CLLocation *)getLocationWithLatitude:(double)la withLongitude:(double)lon
{
    CLLocation *location=[[CLLocation alloc] initWithLatitude:la longitude:lon];
    return location;
}

- (void)formattData
{
    self.locationDataBlock = nil;
    self.gpsStatusBlock = nil;
    self.timeRunBlock = nil;
    [self.locationDataAry removeAllObjects];
    self.curentTime = 0;
    self.sumSpeed = 0;
    self.fastestSpeed = 0;
    self.upAltitude = 0;
    self.sumAltitude = 0;
    self.maxAltitude = 0;
    self.sumDistance = 0;
    self.downAltitude = 0;
    self.timer = nil;
    self.sportModel = nil;
    self.weight = 0;
    self.sumCalorie = 0;

    
    [self.speedHistory removeAllObjects];
    self.currentSpeed = kSpeedNotSet;
    self.readyToExposeDistanceAndSpeed = NO;
    self.totalDistance = 0;
    self.startTimestamp = [NSDate dateWithTimeIntervalSinceNow:0];
    self.forceDistanceAndSpeedCalculation = NO;
    self.lastRecordedLocation = nil;
    self.sportLocation = NO;
}


#pragma mark - make test data
- (void)setUpTestLocationManager
{
    self.testTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self.testTimer fire];
    
    UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:[[LoginManager instance] getUserId]];
    self.weight =  userInfo.weight ? [userInfo.weight intValue] : 0;
    self.sportModel = [[SportModel alloc] init];
    self.sportModel.startTime = [NSDate date];
    //self.sportModel.sId = [@([[NSDate date] timeIntervalSince1970]) stringValue];
    self.sportModel.sId = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
    
    [self setUpTimer];
}
//测试
- (void)timerFired:(NSTimer *)timer
{
    static double latitude = 40.00045717;
    latitude += 100000000000 / 100000000000000.0f;
    latitude = latitude > 42 ? 42 : latitude;
    latitude = latitude < 40 ? 40 : latitude;
    
    static double longitude = 116.38360226;
    longitude += 100000000000 / 100000000000000.0f;
    longitude = longitude > 120 ? 120 : longitude;
    longitude = longitude < 110 ? 110 : longitude;
    
    double altitude = 0.0;
    altitude += ((int)(arc4random()) % 100)+20;
    
    double hAccuracy = 0.0; // 0~200随机
    hAccuracy = [PublicTool getRandomNumber:0 to:200];
    
    double vAccuracy = 0.0; // 0~100随机
    vAccuracy = [PublicTool getRandomNumber:0 to:100];
    
    double speed = [self getTestSpeed];
    
    double course = 0.0; // 0~360随机
    course = [PublicTool getRandomNumber:0 to:360];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord
                                                         altitude:altitude
                                               horizontalAccuracy:hAccuracy
                                                 verticalAccuracy:vAccuracy
                                                           course:course
                                                            speed:speed
                                                        timestamp:[NSDate date]];
    
    
    if (!self.isSportPause) {
        
        if (!self.isSportPause) {
#pragma -mark 老
            LocationModel *locationModel = [[LocationModel alloc] initWithLocation:[location locationMarsFromEarth]];
            locationModel.itemModel.sid = self.sportModel.sId;
            [self setupLocationDataWith:locationModel];
            
        }
    }
}

- (double)getTestSpeed
{
    static int i = 0;
    static double speed = 0.0;
    if (i<=9) {
        switch (i) {
            case 0:
                speed = 0;
                break;
            case 1:
                speed = 0.15;
                break;
            case 2:
                speed =0.55;
                break;
            case 3:
                speed =0.6;
                break;
            case 4:
                speed =0.65;
                break;
            case 5:
                speed =1.2;
                break;
            case 6:
                speed =10.8;
                break;
            case 7:
                speed =15.5;
                break;
            case 8:
                speed =0.8;
                break;
            default:
                speed = 20;
                break;
        }
        
    }else{
        speed = 5-0.1;
    }
    i++;
    return  speed*10;
}

- (void)pauseTestTimer
{
    [self.testTimer setFireDate:[NSDate distantFuture]];
}

- (void)goOnTestTimer
{
    [self.testTimer setFireDate:[NSDate date]];
}

- (void)stopTestTimer
{
    [self.testTimer invalidate];
    self.testTimer = nil;
}




@end
