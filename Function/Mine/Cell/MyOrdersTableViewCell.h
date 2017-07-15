//
//  MyOrdersTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderModel;

@protocol MyOrdersTableViewCellDelegate <NSObject>

/** 去支付*/
- (void)clickPayWithModel:(MyOrderModel *)model;
/** 查看物流*/
- (void)clickCheckLogisticsWithModel:(MyOrderModel *)model;
/** 添加商品评价*/
- (void)clickAddGoodCommentWithModel:(MyOrderModel *)model;
/** 添加活动评价*/
- (void)clickAddActivityCommentWithModel:(MyOrderModel *)model;

@end

@interface MyOrdersTableViewCell : UITableViewCell

@property (nonatomic,assign) OrderStatus status;

@property (nonatomic,strong) MyOrderModel *model;

@property (nonatomic,weak) id<MyOrdersTableViewCellDelegate> delegate;

@end
