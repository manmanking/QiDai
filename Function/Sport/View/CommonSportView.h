//
//  CommonSportView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/2.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  开始骑行的普通界面

#import <UIKit/UIKit.h>

@interface CommonSportView : UIView

/** 本次运动速度*/
@property (nonatomic,copy) NSString *speed;
/** 本次运动总时长*/
@property (nonatomic,copy) NSString *duration;
/** 本次运动总骑行*/
@property (nonatomic,copy) NSString *distance;
/** 今日总骑行*/
@property (nonatomic,copy) NSString *totalDistance;
/** 今日任务的进度*/
@property (nonatomic,assign) CGFloat progress;

@end
