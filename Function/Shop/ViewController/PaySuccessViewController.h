//
//  PaySuccessViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDRootViewController.h"
@class GoodsModel;
@class MyOrderModel;
@interface PaySuccessViewController : QDRootViewController

/** 是否是商城进来的*/
@property (nonatomic,assign) BOOL isShopEnter;

/** 商城进来的,钱*/
@property (nonatomic,copy) NSString *needPayMoney;
/** 商城进来的,订单号*/
@property (nonatomic,copy) NSString *orderID;

/** 1快递，2自取*/
@property (nonatomic,copy) NSString *payType;


@end
