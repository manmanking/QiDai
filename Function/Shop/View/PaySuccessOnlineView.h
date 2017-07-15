//
//  PaySuccessOnlineView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  在线支付成功

#import <UIKit/UIKit.h>
@class MyOrderModel;
@interface PaySuccessOnlineView : UIView

@property (nonatomic,copy) ClickView clickCheckOrderBlock;

@property (nonatomic,copy) ClickView clickReturnBlock;

/** 从我的订单进入*/
@property (nonatomic,strong) MyOrderModel *orderModel;

/** 商城进来的,钱*/
@property (nonatomic,copy) NSString *needPayMoney;


@end
