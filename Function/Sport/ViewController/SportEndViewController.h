//
//  SportEndViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/6.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  骑行结束页面

#import "QDRootViewController.h"
@class MAMapView;
@class SportModel;
@interface SportEndViewController : QDRootViewController

@property (strong, nonatomic) MAMapView *sportMapView;

@property (strong,nonatomic) SportModel *sportModel;
/** 存放经纬度model的数组*/
@property (strong, nonatomic) NSMutableArray *locationModelAry;

/** 是否是push进来的,默认为no*/
@property (nonatomic,assign) BOOL isPush;

@end
