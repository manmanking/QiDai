//
//  LocationManager.h
//  Leqi
//
//  Created by Tianyu on 14/12/18.
//  Copyright (c) 2014年 com.hoolai. All rights reserved.
//
//  关于GPS定位相关的
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SportModel.h"
#import <MAMapKit/MAMapKit.h>


//typedef enum
//{
//    kSTATUS_LOW = 0,
//    kSTATUS_MIDDLE,
//    kSTATUS_HIEGHT,
//    kSTATUS_ERROR
//} GPSStatus;

typedef NS_ENUM(NSInteger ,GPSStatus) {
    kSTATUS_LOW = 0,
    kSTATUS_MIDDLE,
    kSTATUS_HIEGHT,
    kSTATUS_ERROR
};

typedef void(^LocationDataBlock)(NSMutableArray *dataAry);
typedef void(^GPSStatusBlock)(GPSStatus status);
typedef void(^TimeRunBlock)(int currentTime);
typedef void(^NewLocationBlock)(double speed, NSArray *dataArray,SportModel *sportModel);

@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSMutableArray *locationDataAry;

@property (copy, nonatomic) LocationDataBlock locationDataBlock;

@property (copy, nonatomic) GPSStatusBlock gpsStatusBlock;

@property (copy, nonatomic) TimeRunBlock timeRunBlock;

@property (assign, nonatomic) int curentTime;

@property (strong, nonatomic) NSDate *stareTime;

@property (strong, nonatomic) NSDate *endTime;

@property (strong, nonatomic) SportModel *sportModel;

@property (strong, nonatomic) MAMapView *mapView;

@property (copy, nonatomic) NewLocationBlock locationBlock;

+ (instancetype)instance;

/** 建立LocationManager*/
- (void)setupLocationManager;

/** 测试专用*/
- (void)setUpTestLocationManager;

#pragma mark --- gps
/** 手动暂停*/
- (void)pauseSport;
/** 自动暂停*/
- (void)automaticPauseSport;
/** 结束暂停*/
- (void)playSport;
/** 结束运动*/
- (void)endSport;

#pragma mark --- 码表
- (void)timePause;
- (void)timeGoOn;
- (void)timeEnd;
- (void)sportGoOnWithClock;

- (void)formattData;
- (void)calculateCalorie;
@end
