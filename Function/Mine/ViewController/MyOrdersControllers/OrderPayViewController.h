//
//  OrderPayViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  从我的订单去支付进入

#import "QDRootViewController.h"
@class MyOrderModel;
@interface OrderPayViewController : QDRootViewController

@property (nonatomic,strong) MyOrderModel *model;

@end
