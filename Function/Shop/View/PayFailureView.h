//
//  PayFailureView.h
//  QiDai
//
//  Created by manman'swork on 16/10/29.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;

@interface PayFailureView : UIView

@property (nonatomic,copy) ClickView clickRepayBlock;

@property (nonatomic,copy) ClickView clickReturnBlock;

/** 从我的订单进入*/
@property (nonatomic,strong) MyOrderModel *orderModel;

/** 商城进来的,钱*/
@property (nonatomic,copy) NSString *needPayMoney;


@end
