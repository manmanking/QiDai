//
//  NewTaskDetailModel.h
//  QiDai
//
//  Created by manman'swork on 16/11/8.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedingRecordDateInfoModel.h"

@interface NewTaskDetailModel : NSObject <NSCopying>


@property (nonatomic,copy) NSString *cRefund;

@property (nonatomic,copy) NSString *taskDetailId;

@property (nonatomic,copy) NSString *complete;

@property (nonatomic,copy) NSString *userInfoId;

//information

@property (nonatomic,copy) NSString *information;

@property (nonatomic,copy) NSString *itemId;

@property (nonatomic,copy) NSString *foreImg;

@property (nonatomic,copy) NSArray *record;

@property (nonatomic,copy) NSString *userTaskStartTime;

@property (nonatomic,copy) NSString *completeDay;

@property (nonatomic,copy) NSString *refund;



@property (nonatomic,copy) NSString *bonusIssue;

//A 定期赚 B 天天赚 C 递增赚
@property (nonatomic,copy) NSString *taskMainId;

@property (nonatomic,copy) NSString *sumDistance;

@property (nonatomic,copy) NSString *totalPrizeMoney;

@property (nonatomic,copy) NSString *addBonus;

@property (nonatomic,copy) NSString *sumStandardDays;

@property (nonatomic,copy) NSString *distance;

@property (nonatomic,copy) NSString *validDuration;

@property (nonatomic,copy) NSString *cTime;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *userTaskFinishTime;


@property (nonatomic,copy) NSString *detail;

@property (nonatomic,copy) NSString *totalDuration;

@property (nonatomic,copy) NSString *helpPageImage;

//_shareMyOutfitOfBikeInfoImageView

@property (nonatomic,copy) NSString *taskShareImage;

@property (nonatomic,copy) NSString *distancePerDay;

@property (nonatomic,copy) NSString *taskId;


@end
