//
//  SportStartViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  运动中的页面

#import "QDRootViewController.h"

@interface SportStartViewController : QDRootViewController

/** 任务模式下应该骑的公里数*/
@property (nonatomic,assign) CGFloat totalDistance;

/** 今日已经骑行的公里数*/
@property (nonatomic,assign) CGFloat todayDistance;

/** 时候有活动*/
@property (nonatomic,assign) BOOL haveTask;

@end
