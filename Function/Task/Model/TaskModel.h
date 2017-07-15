//
//  TaskModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  即将开赛和已经结束的任务的model

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject
/** 状态--“已结束”*/
@property (nonatomic,copy) NSString *status;
/** 返现*/
@property (nonatomic,copy) NSString *refund;
/** 描述*/
@property (nonatomic,copy) NSString *information;

@property (nonatomic,copy) NSString *id;
/** 拒多少天开始 --*/
@property (nonatomic,copy) NSString *countdown;
/** 参加人数*/
@property (nonatomic,copy) NSString *quantity;
/** 任务的image ---左边图片的url*/
@property (nonatomic,copy) NSString *image;
/** 车的名字*/
@property (nonatomic,copy) NSString *bike;
/** 开始时间*/
@property (nonatomic,copy) NSString *startTime;
/** 任务活动的名称*/
@property (nonatomic,copy) NSString *name;
/** 总里程*/
@property (nonatomic,copy) NSString *disSum;
/** 时候完成 1完成*/
@property (nonatomic,copy) NSString *complete;
/** 完成天数*/
@property (nonatomic,copy) NSString *completeDay;
@end
