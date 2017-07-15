//
//  OrderConfirmationViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  确认订单

#import "QDRootViewController.h"
@class GoodsModel;
@class ActivityModel;
@class ShopAddressModel;
@interface OrderConfirmationViewController : QDRootViewController


//---------------必填-----------------//
/** 支付方式，1为快递，2自取*/
//@property (nonatomic,assign) NSInteger payType;
/** 颜色*/
@property (nonatomic,copy) NSString *colorStr;

@property (nonatomic,assign) NSInteger colorPage;
/** 应支付的钱*/
//@property (nonatomic,copy) NSString *money;
/** 奖金*/
//@property (nonatomic,copy) NSString *bonus;
/** 活动id，必填*/
//@property (nonatomic,copy) NSString *activityId;
/** 收货地址id(到店自取传-1)*/ 
//@property (nonatomic,copy) NSString *addressId;

/** (店铺地址,必填,)*/ 
//@property (nonatomic,copy) NSString *shopId;
//---------------必填-----------------//

@property (nonatomic,strong) ShopAddressModel *shopModel;

@property (nonatomic,strong) GoodsModel *goodModel;

@property (nonatomic,strong) ActivityModel *activityModel;
/** (店铺地址)*/
@property (nonatomic,copy) NSString *shopId;

@end
