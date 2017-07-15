//
//  ProgressBarView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  运动界面的红条

#import <UIKit/UIKit.h>

@interface ProgressBarView : UIView

/** 进度*/
@property (nonatomic,assign) CGFloat progress;

/** 今日骑行的文本框*/
@property (nonatomic,strong) UILabel *titleLabel;

/** 每日任务需要的骑行公里数的数组*/
@property (nonatomic,strong) NSArray *distanceArray;

/** 是否是任务页面的进度条---ui有微调*/
@property (nonatomic,assign) BOOL isTask;
@end
