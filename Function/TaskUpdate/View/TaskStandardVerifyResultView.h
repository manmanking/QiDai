//
//  TaskStandardVerifyResultView.h
//  QiDai
//
//  Created by manman'swork on 16/11/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedingRecordDateInfoModel.h"

typedef void(^TouchButtonActionBlock) ();


@interface TaskStandardVerifyResultView : UIView


@property (nonatomic,strong) NSString *isSuccess;

@property (nonatomic,strong) NSString *overFlagStr;


@property (nonatomic,strong) NSString *taskCategoryStr;

@property (nonatomic,strong) NSString *completeStr;

@property (nonatomic,strong) NSString *distancePerDay;

@property (nonatomic,strong) RedingRecordDateInfoModel *resultRedingRecordDateInfoModel;



@end
