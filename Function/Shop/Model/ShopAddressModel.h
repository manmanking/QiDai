//
//  ShopAddressModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/6.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  商店地址model

#import <Foundation/Foundation.h>


@interface ShopAddressModel : NSObject

@property (nonatomic,copy) NSString *id;
/** 距离*/
@property (nonatomic,copy) NSString *distance;
/** 电话*/
@property (nonatomic,copy) NSString *phone;
/** 开门时间*/
@property (nonatomic,copy) NSString *openingTime;
/** 店铺的名字*/
@property (nonatomic,copy) NSString *name;
/** 地址*/
@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *taskDetailId;

// 任务
@property (nonatomic,copy) NSString *taskId;

//活动
@property (nonatomic,copy) NSString *activityId;

@property (nonatomic,copy) NSString *lat;

@property (nonatomic,copy) NSString *lng;

/** 店铺拥有的车的颜色*/
//@property (copy, nonatomic) NSString *color_price;
@property (nonatomic,copy) NSString *color_ios;

/** 和name一样*/
@property (nonatomic,copy) NSString *shopName;

@end

