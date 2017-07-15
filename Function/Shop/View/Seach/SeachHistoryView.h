//
//  SeachHistoryView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/4.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeachHistoryView : UIView

/** 点击清空按钮*/
@property (nonatomic,copy) ClickView clickClearBtnBlock;
/** 点击btn*/
@property (nonatomic,copy) ClickViewWithParameter clickHotSeachBtnBlock;
/** 根据数据建立view*/
- (void)setupViewWithArray:(NSArray *)array;
@end
