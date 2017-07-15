//
//  GoodsActivityTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  商品详情-活动的cell

#import <UIKit/UIKit.h>

@class ActivityModel;

@protocol GoodsActivityTableViewCellDelegate <NSObject>

- (void)clickActivityCellWithPage:(NSInteger)page;

@end

@interface GoodsActivityTableViewCell : UITableViewCell

/** 时候被选中*/
@property (nonatomic,assign) BOOL isSelect;


/** 当前的page,来源是index.row*/
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,weak) id<GoodsActivityTableViewCellDelegate>delegate;

/** 点击*/
@property (nonatomic,copy) ClickViewWithPage clickDetailBlock;

@property (nonatomic,strong) ActivityModel *activityModel;
@end
