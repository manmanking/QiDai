//
//  TaskRuleViewController.h
//  QiDai
//
//  Created by manman'swork on 16/11/4.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDRootViewController.h"

@class NewTaskDetailModel;

@interface TaskRuleViewController :QDRootViewController


@property (nonatomic,assign)TaskCategory taskCategory;


@property (nonatomic,strong)NewTaskDetailModel *taskRuleModel;


@end
