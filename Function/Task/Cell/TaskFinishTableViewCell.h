//
//  TaskFinishTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  挑战完成的cell

#import <UIKit/UIKit.h>
@class TaskModel;
@interface TaskFinishTableViewCell : UITableViewCell

@property (nonatomic,strong) TaskModel *model;

@end
