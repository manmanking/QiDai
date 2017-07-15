//
//  TaskStandard.h
//  QiDai
//
//  Created by manman'swork on 16/11/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OngoingTaskModel.h"
#import "OverTaskModel.h"
#import "UnstartTaskModel.h"
#import "NewTaskDetailModel.h"

typedef void(^TouchButtonActionBlock) ();

@interface TaskStandardView : UIView


@property (nonatomic,strong) NSString *overFlagStr;

@property (nonatomic,strong)TouchButtonActionBlock clickHelpButtonAction;

@property (nonatomic,strong) NewTaskDetailModel *taskStandarTaskDetailModel;


@end
