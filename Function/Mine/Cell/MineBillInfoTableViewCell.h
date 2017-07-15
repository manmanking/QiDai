//
//  MineBillInfoTableViewCell.h
//  QiDai
//
//  Created by manman'swork on 16/12/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderModel.h"

#define kMineBillInfoPayAction  @"MineBillInfoPayAction"

#define kMineBillInfoCommentGoodsAction  @"MineBillInfoCommentGoodsAction"

#define kMineBillInfoCommentActivityAction  @"MineBillInfoCommentActivityAction"

#define kMineBillInfoLogisticsButtonAction @"MineBillInfoLogisticsButtonAction"

#define kMineBillInfoDeleteBillAction  @"MineBillInfoDeleteBillAction"

typedef void(^MinBillInfoActin)(NSDictionary *parameterDic,MyOrderModel *mineOrderModel);

@interface MineBillInfoTableViewCell : UITableViewCell


@property (nonatomic,assign) OrderStatus status;

@property (nonatomic,strong) MyOrderModel *orderUpdateModel;

@property (nonatomic,copy) MinBillInfoActin minBillInfoActin;

@end
