//
//  OrderConfirmationView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@class ActivityModel;
@interface OrderConfirmationView : UIView

@property (nonatomic,strong) GoodsModel *goodModel;

@property (nonatomic,copy) NSString *color;

@property (nonatomic,assign) NSInteger colorPage;

@property (nonatomic,strong) ActivityModel *activityModel;

@property (nonatomic,copy) ClickViewWithParameter clickSelectPayTypeBlock;
@end
