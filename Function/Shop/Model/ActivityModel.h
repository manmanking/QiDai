//
//  ActivityModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityModel : NSObject <NSCopying>

/**
 *   更新  活动 molde
 
 */

/** */
@property (nonatomic,copy) NSString *assembled_type;

/** 组装 类型*/
@property (nonatomic,copy) NSString *type;

/** 运费*/
@property (nonatomic,copy) NSString *luggage;


/** 返钱*/
@property (nonatomic,copy) NSString *refundLoadingCharge;



// end of line



/**活动的id */
@property (nonatomic,copy) NSString *id;

/** 总奖金*/
@property (nonatomic,copy) NSString *refund;

/** */
@property (nonatomic,copy) NSString *totalDuration;




/** 活动的信息 如:每天10公里，持续30天*/
@property (copy,nonatomic) NSString *information;

/** 详细信息*/
@property (nonatomic,copy) NSString *detail;

/** 倒计时*/
@property (nonatomic,copy) NSString *countdown;

/** 每天反的钱数*/
@property (nonatomic,copy) NSString *CRefund;

/** 类型 如:B*/
//@property (nonatomic,copy) NSString *type;

/** 人数*/
@property (nonatomic,copy) NSString *quantity;

/** 开始时间*/
@property (nonatomic,copy) NSString *beginTime;

/** 结束时间*/
@property (nonatomic,copy) NSString *endTime;

@property (nonatomic,copy) NSString *distancePerDay;

@property (nonatomic,copy) NSString *taskDetailId;

/** "已报名2人，已开始7天"*/ 
@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *count;


@property (nonatomic,copy) NSString *color;

@property (nonatomic,copy) NSString *shop_id;
@end
