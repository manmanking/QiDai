//
//  ShopHomePageFirstReusableView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/4.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  collection的第一个的headerView

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface ShopHomePageFirstReusableView : UICollectionReusableView
/** 点击*/
@property (nonatomic,copy) ClickViewWithPage clickCycleViewBlock;
/** 轮播图*/
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end
