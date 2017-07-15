//
//  PaySuccessOfflineView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  线下支付成功

#import <UIKit/UIKit.h>
@class GoodsModel;
@class MyOrderModel;
@interface PaySuccessOfflineView : UIView

@property (nonatomic,copy) ClickView clickCheckOrderBlock;

@property (nonatomic,copy) ClickView clickReturnBlock;

/** 从我的订单进入*/
@property (nonatomic,strong) MyOrderModel *orderModel;

/** 从我的订单进入*/
@property (nonatomic,strong) GoodsModel *goodsModel;

/** 商城进来的,钱*/
@property (nonatomic,copy) NSString *needPayMoney;
/** 商城进来的,订单号*/
@property (nonatomic,copy) NSString *orderID;

@end
