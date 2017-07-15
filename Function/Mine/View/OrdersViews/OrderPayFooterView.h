//
//  OrderPayFooterView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailModel;
@class MyOrderModel;

@interface OrderPayFooterView : UIView

@property (nonatomic,copy) NSString *needPay;

@property (nonatomic,copy) ClickView clickPayBtnBlock;

@property (nonatomic,strong) MyOrderModel *orderModel;

@property (nonatomic,strong) OrderDetailModel *orderDetailModel;
@end
