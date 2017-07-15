//
//  OngoingModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  正在进行的model

#import <Foundation/Foundation.h>

@interface OngoingModel : NSObject
/** 今日骑行*/
@property (nonatomic,copy) NSString *daySum;
/** 每天应该骑行多少*/
@property (nonatomic,copy) NSString *distancePerDay;
/** id*/ 
@property (nonatomic,copy) NSString *id;
/** 活动图片*/
@property (nonatomic,copy) NSString *image;
/** 活动名称*/
@property (nonatomic,copy) NSString *activityName;
/** 活动*/
@property (nonatomic,copy) NSString *name;
/** 活动总骑行*/
@property (nonatomic,copy) NSString *sum;
/** 返现*/
@property (nonatomic,copy) NSString *money;
//没用
@property (nonatomic,copy) NSString *userTaskId;
/** 钱数*/
@property (nonatomic,assign) NSInteger refund;
/** taskDetailID*/
@property (nonatomic,copy) NSString *taskDetailId;
/** 每天完成的比例*/
@property (nonatomic,copy) NSString *completionRate;
@end
