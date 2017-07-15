//
//  GoodCommentHeaderView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodCommentHeaderView : UIView

/** 是否是活动评价*/
@property (nonatomic,assign) BOOL isActivity;

/** 左上角的图片,商品评价为车的图片，活动评价则是一个奖状*/
@property (nonatomic,strong) UIImageView *leftImageView;

@property (nonatomic,copy) ClickViewWithPage clickBtnBlock;

/** btn的title的数组*/
@property (nonatomic,strong) NSArray *titleArray;

/** 好评率*/
@property (nonatomic,copy) NSString *goodRate;
@end
