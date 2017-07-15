//
//  TaskDetailModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDetailModel : NSObject

/** 今天完成情况*/
@property (nonatomic,copy) NSString *todayComplete;
/** 今日骑行*/
@property (nonatomic,copy) NSString *todayDistance;
/** 今日目标的公里数，单位m*/
@property (nonatomic,copy) NSString *todayTarget;
/** 今日自己的排名*/
@property (nonatomic,copy) NSString *rank;
/** 总骑行的距离,单位是m*/
@property (nonatomic,copy) NSString *totalDistance;
/** 活动的总返现*/
@property (nonatomic,copy) NSString *totalRefund;
/** 用户累计总返现*/
@property (nonatomic,copy) NSString *cumulativeRefund;
/** 用户今天的返现*/
@property (nonatomic,copy) NSString *todayRefund;
/** 有效的天数，比如:比如30天内任意骑行20天达标,这个就是20天*/
@property (nonatomic,copy) NSString *validDay;
/** 已得到的返现 --弃用*/
@property (nonatomic,copy) NSString *refund;
/** 今天还差多少米完成*/
@property (nonatomic,copy) NSString *disparity;
/** 总共完成的百分比*/
@property (nonatomic,copy) NSString *completePercent;
/** 总共完成的天数*/
@property (nonatomic,copy) NSString *completeDay;
/** 今日是否完成*/
@property (nonatomic,copy) NSString *complete;
/** 活动id,用于请求评论*/
@property (nonatomic,copy) NSString *taskCommentId;
/** 挑战第几天*/
@property (nonatomic,copy) NSString *challengesDay;

/** 当天的返现*/
@property (nonatomic,copy) NSString *nowDayMoney;
/** 活动活动的总返现*/
@property (nonatomic,copy) NSString *totalDayMoney;

@end
