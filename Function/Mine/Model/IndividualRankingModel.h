//
//  IndividualRankingModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  个人排名的model

#import <Foundation/Foundation.h>

@interface IndividualRankingModel : NSObject
/** 距离*/
@property (nonatomic,copy) NSString *distance;
/** 排名*/
@property (nonatomic,copy) NSString *rank;
/** 总时长*/
@property (nonatomic,copy) NSString *time;

@end
