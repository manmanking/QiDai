//
//  ShopCollectionViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopHomePageModel;
@interface ShopCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) ShopHomePageModel *model;

@property (nonatomic,copy) ClickViewWithParameter clickBuyBtnBlock;

/** 无活动的情况*/
@property (nonatomic,assign) BOOL noActivity;

@end
