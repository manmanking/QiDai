//
//  LogisticsHeaderView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailModel;
@interface LogisticsHeaderView : UIView

@property (nonatomic,strong) OrderDetailModel *model;

/** 付款方式，1快递，2到店自取*/
@property (nonatomic,assign) NSInteger payType;

/** 时候是退款*/
@property (nonatomic,assign) BOOL isRefund;
@end
