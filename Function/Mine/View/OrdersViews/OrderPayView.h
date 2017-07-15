//
//  OrderPayView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderModel;
@interface OrderPayView : UIView

@property (nonatomic,strong) MyOrderModel *model;

/** 商品的价格*/
@property (nonatomic,copy) NSString *money;
@end
