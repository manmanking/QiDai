//
//  MMKCalendarView.h
//  QiDai
//
//  Created by manman'swork on 16/11/7.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedingRecordDateInfoModel,NewTaskDetailModel;
typedef void(^SelectDate)(NSString *type ,RedingRecordDateInfoModel *selectedRedingRecordDateInfoModel);

@interface MMKCalendarView : UIView

@property (nonatomic,strong) NewTaskDetailModel *taskDetailViewModel;

@property (nonatomic,strong) NSArray *dateInfoArr;


@property (nonatomic,strong)SelectDate selectedDate;

@end
