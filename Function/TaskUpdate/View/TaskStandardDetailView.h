//
//  TaskStandardDetailView.h
//  QiDai
//
//  Created by manman'swork on 16/11/4.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTaskDetailModel.h"

@interface TaskStandardDetailView : UIView


/**
 *  1 天天赚  定期赚 2 递增赚
 */



@property (nonatomic,strong)NewTaskDetailModel *taskDetailDescripModel;

- (void)customUIView:(NSString *)taskCategory;

@end
