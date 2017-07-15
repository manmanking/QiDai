//
//  SportTaskModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportTaskModel : NSObject <NSCoding>

/** 今日已经骑得*/
@property (nonatomic,copy) NSString *distanceDay;
/** 今日应该骑的*/
@property (nonatomic,copy) NSString *distancePerDay;
/** 活动名字*/
@property (nonatomic,copy) NSString *information;//information

@property (nonatomic,copy) NSString *startTime;

@property (nonatomic,copy) NSString *finishTime;

@end
