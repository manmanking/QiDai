//
//  TaskArcView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  挑战总骑行 --圆弧

#import <UIKit/UIKit.h>

@interface TaskArcView : UIView

@property (nonatomic,assign) CGFloat greenPercent;

@property (nonatomic,assign) CGFloat orangePercent;

@property (nonatomic,assign) CGFloat grayPercent;

/** 完成天数*/
@property (nonatomic,copy) NSString *completeDate;
@end
