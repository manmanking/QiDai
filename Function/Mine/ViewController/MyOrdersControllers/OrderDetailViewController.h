//
//  OrderDetailViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  订单详情--除去“去支付”都进入这里

#import "QDRootViewController.h"
@class MyOrderModel;
@interface OrderDetailViewController : QDRootViewController

@property (nonatomic,strong) MyOrderModel *model;

@property (nonatomic,copy) void(^refreshDataSourceBlock)();

@end
 