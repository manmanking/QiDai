//
//  HistoryManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/19.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SportModel;
@class HistorySectionModel;
@interface HistoryManager : NSObject

@property (nonatomic,copy) NSString *totalDistance;

@property (nonatomic,copy) NSString *duration;

@property (nonatomic,copy) NSString *currentMonth;

@property (nonatomic,strong) NSMutableArray *monthArrayData;

/** 根据页码加载数据*/
- (NSArray *)loadMonthSportDataWithPageIndex:(NSInteger)pageIndex;

/** 一月的数据*/
//- (NSArray *)getMonthSportDataWithPageIndex:(NSInteger)pageIndex;

- (NSString *)getTotalDistanceWithSection:(NSInteger)section;

- (NSString *)getcurrentMonthWithSection:(NSInteger)section;

/** 是否加载了 数据库中的所有数据*/
- (BOOL)hadLoadAllData;


@end


