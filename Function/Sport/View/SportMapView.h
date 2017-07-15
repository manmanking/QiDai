//
//  SportMapView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/15.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  有任务的骑行地图的view

#import <UIKit/UIKit.h>

@interface SportMapView : UIView
/** 速度*/
@property (nonatomic,copy) NSString *speed;
/** 时长*/
@property (nonatomic,copy) NSString *duration;
/** 当前运动距离*/
@property (nonatomic,copy) NSString *distance;
/** 总距离---今日骑行的总距离*/
@property (nonatomic,copy) NSString *totalDistance;
/** 今日任务的进度*/
@property (nonatomic,assign) CGFloat progress;
@end
