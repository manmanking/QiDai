//
//  TaskTotalRidingView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  挑战总骑行的headerView

#import <UIKit/UIKit.h>
@class TaskDetailModel;
@interface TaskTotalRidingView : UIView

@property (nonatomic,strong) TaskDetailModel *model;

/** 今日是第几天 ---好像弃用*/
@property (nonatomic,copy) NSString *completeDay;

@end
