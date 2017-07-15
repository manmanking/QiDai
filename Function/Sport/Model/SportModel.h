//
//  SportModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportModel : NSObject<NSCoding>

/** sportID ---类型NSString*/
@property (strong, nonatomic) NSString *sId;

/** userID ---类型NSString*/
@property (strong, nonatomic) NSString *uId;

/** 开始运动时间 ---类型NSData*/
@property (strong, nonatomic) NSDate *startTime;

/** 结束运动时间 ---类型NSData*/
@property (strong, nonatomic) NSDate *endTime;

/** 本次运动总用时 ---类型int*/
@property (assign, nonatomic) int sumTime;              // 本次运动总用时

/** 本次运动总公里数 ---类型double*/
@property (assign, nonatomic) double totalDistance;     // 本次运动总公里数

/** 平均速度 ---类型double*/
@property (assign, nonatomic) double averageSpeed;      // 平均速度

/** 最大速度 ---类型double*/
@property (assign, nonatomic) double maxSpeed;          // 最大速度

/** 消耗卡路里 ---类型double*/
@property (assign, nonatomic) double calorie;           // 消耗卡路里

/** 平均海拔 ---类型double*/
@property (assign, nonatomic) double averageAltitude;   // 平均海拔

/** 最大海拔 ---类型double*/
@property (assign, nonatomic) double maxAltitude;       // 最大海拔

/** 累计上升海拔 ---类型double*/
@property (assign, nonatomic) double upAltitude;         // 累计上升海拔

/** 累计下降海拔 ---类型double*/
@property (assign, nonatomic) double downAltitude;       // 累计下降海拔

/** 本次运动累计总积分 ---类型int*/
@property (assign,nonatomic) int totalPoints;           //累计总积分

/** 分享的网址 ---类型NSString(可能要废弃)*/
@property (copy,nonatomic) NSString *shareUrl;        //分享的网址

@property (nonatomic,copy) NSString *ridingName;

/** 判断sportModel是否上传成功 ---类型int*/
@property (assign, nonatomic) int upload;

/** 判断经纬度点的zip是否上传成功 ---类型int*/
@property (assign, nonatomic) int uploadDetail;

// 码表使用字段,暂时停止
@property (assign, nonatomic) double clockDistance;    // 里程
@property (assign, nonatomic) double clockFrequency;   // 踏频
@property (assign, nonatomic) double clockCalorie;     // 卡路里
@property (assign, nonatomic) double clockSpeed;       // 时速

/** 词典转model的方法*/
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/** model转词典*/
- (NSDictionary *)dictionary;
/** model转字符串---好像弃用了*/
- (NSString *)string;
/** 运动结束后，需要调用，计算数据*/
- (void)endSport;

@end
