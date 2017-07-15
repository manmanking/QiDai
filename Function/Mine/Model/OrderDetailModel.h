//
//  OrderDetailModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic,copy) NSString *phone;

@property (nonatomic,copy) NSString *userAddress;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *series;

@property (nonatomic,copy) NSString *brand;

@property (nonatomic,copy) NSString *color;
/** 支付方式*/
@property (nonatomic,copy) NSString *payType;

@property (nonatomic,copy) NSString *image;

@property (nonatomic,copy) NSString *needPayMoney;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *shopName;

@property (nonatomic,copy) NSString *activityName;

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,copy) NSString *distance;

@property (nonatomic,copy) NSString *model;
/** 状态*/
@property (nonatomic,copy) NSString *status;
/** 奖金*/
@property (nonatomic,copy) NSString *bonus;

@property (nonatomic,copy) NSString *price;
/** 物流状态,已","隔开*/
@property (nonatomic,copy) NSString *recordList;
/** 物流时间,已","隔开*/
@property (nonatomic,copy) NSString *date;

/** 物流公司*/
@property (nonatomic,copy) NSString *enwrapCompany;
/** 快递单号*/
@property (nonatomic,copy) NSString *courierNumber;
/** 商店的电话*/
@property (nonatomic,copy) NSString *shopPhone;
/** 遍历有无支付宝3字*/
@property (nonatomic,copy) NSString *threePay;
@end
