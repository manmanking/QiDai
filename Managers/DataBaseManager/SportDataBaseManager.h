//
//  SportDataBaseManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SportModel;
@interface SportDataBaseManager : NSObject

/**
 *  给指定的表中添加 新字段
 *
 *  @param tableName  表名
 *  @param columnName 字段名
 *
 *  @return 是否成功
 */
+ (BOOL)addColumnTable:(NSString *)tableName AndColumnName:(NSString *)columnName;

//查询骑行数据
- (NSArray *)getSportDataWithUserId:(NSString *)userId;

- (NSArray *)getSportDataWithUserId:(NSString *)userId starDate:(NSDate *)starDate endDate:(NSDate *)endDate;

//加载总距离
- (NSString *)getTotalDistanceWithUserId:(NSString *)userId;

//加载总时长
- (int)getTotalDurationWithUserId:(NSString *)userId;

//加载总次数
+ (NSInteger)getTotalTimesWithUserId:(NSString *)userId;

+ (BOOL)insertSportData:(SportModel *)sportModel;
//批量插入数据
+ (BOOL)insertSportDataArray:(NSArray *)dataArray;
/**
 更新每次运动分享的url
 */
+(BOOL)updateUpLoadShareUrlWithUrl:(NSString *)shareUrl UserId:(NSString *)userId  sportId:(NSString *)sportId;

/**
 更新每次运动的数据是否上传成功
 */
+ (BOOL)updateUpLoadStatusWithUserId:(NSString *)userId  sportId:(NSString *)sportId;

/**
 更新每次运动的详细数据zip 是否上传成功
 */
+ (BOOL)updateUpLoadDetailStatusWithUserId:(NSString *)userId  sportId:(NSString *)sportId;


+ (BOOL)deleSportData:(NSString *)userId andSportData:(NSArray *)aSPortDataArr;

@end

