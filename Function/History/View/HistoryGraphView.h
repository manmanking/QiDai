//
//  HistoryGraphView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  柱状图

typedef NS_ENUM(NSInteger, StatisticsStatus) {
    StatisticsStatusWeek,
    StatisticsStatusMonth,
    StatisticsStatusYaer
};

#import <UIKit/UIKit.h>

@interface HistoryGraphView : UIView
/** 点的数组*/
@property (nonatomic,strong) NSArray *pointsArray;

/** 赋值后手动创建*/
- (void)setupCustomView;
@end
