//
//  SynchronizeRidingRecordManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SportModel;
@interface SynchronizeRidingRecordManager : NSObject


//骑行数据上报
+ (void)uploadRidingRecord:(SportModel *)sportModel pictureArray:(NSArray *)arr
                   success:(void(^)(NSDictionary *result))success
                   failure:(void(^)())failure;

//请求骑行数据
+ (void)loadRidingRecordWithUserId:(NSString *)userId
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endtime
                           success:(void(^)(NSArray *dataList))success
                           failure:(void(^)())failure;

//请求所有
+ (void)loadAllRidingRecordWithUserId:(NSString *)userId
                              success:(void(^)(NSArray *dataList))success
                              failure:(void(^)())failure;
//获取总数据，总路程
+(void)getAllRidingRecordWithUserId:(NSString *)userId
                            success:(void(^)(NSDictionary *dataList))success
                            failure:(void(^)())failure;

@end
