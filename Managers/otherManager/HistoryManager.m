//
//  HistoryManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/19.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HistoryManager.h"
#import "SportDataBaseManager.h"
#import "SportModel.h"

@interface HistoryManager ()
@property (nonatomic,strong) SportDataBaseManager *sportDataBaseManager;

@property (nonatomic,strong) NSMutableArray *historySportArray;

@property (nonatomic,strong) NSMutableArray *distanceSectionArray;  //历史界面HeaderSection数据

@property (nonatomic,strong) NSMutableArray *currentMonthSectionArray;

@property (nonatomic,assign) NSInteger totalTimes;

@property (nonatomic,assign) NSInteger hadLoadDataCount;

@end

@implementation HistoryManager



-(instancetype)init{
    if (self = [super init]) {
        //_historySectionArray = [[NSMutableArray alloc] init];
        _historySportArray = @[].mutableCopy;
        
        _distanceSectionArray = @[].mutableCopy;
        _currentMonthSectionArray = @[].mutableCopy;
        
        _sportDataBaseManager = [[SportDataBaseManager alloc] init];
    }
    return self;
}

-(void)loadTotalData{
    NSString *userID = [[LoginManager instance] getUserId];
    _totalDistance = [_sportDataBaseManager getTotalDistanceWithUserId:userID];
    _totalTimes = [SportDataBaseManager getTotalTimesWithUserId:userID];
    
}

- (NSArray *)loadMonthSportDataWithPageIndex:(NSInteger)pageIndex {
    if (pageIndex == 0) {
        _totalTimes = [SportDataBaseManager getTotalTimesWithUserId:[[LoginManager instance] getUserId]];
        _hadLoadDataCount = 0;
    }
    NSDate *nowData = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                               fromDate:nowData];
    NSInteger nowYear = [components year];  //当前的年份
    NSInteger nowMonth = [components month];  //当前的月份
    
    NSInteger startYear = nowYear;
    NSInteger startMonth = nowMonth;
    NSInteger startDay = 30;
    if (nowMonth <= pageIndex) {
        NSInteger temp = (pageIndex-nowMonth)/12;
        startYear = nowYear - temp -1 ;
        startMonth = nowMonth + 12*(temp + 1) - pageIndex;
    } else {
        startMonth = startMonth - pageIndex;
    }
    startDay = [self howManyDaysInThisYear:startYear month:startMonth];
    
    NSString *startDateString = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00",(long)startYear,(long)startMonth];
    NSDate *startDate = [PublicTool dateFromString:startDateString format:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *endDateString = [NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59",(long)startYear,(long)startMonth,(long)startDay];
    NSDate *endDate = [PublicTool dateFromString:endDateString format:@"yyyy-MM-dd HH:mm:ss"];
    
    //NSLog(@"%ld, %@,%@",(long)pageIndex,startDateString,endDateString);
    //NSLog(@"%@--%@",startDate,endDate);
    //运动记录数据
    NSArray *sportArray = [_sportDataBaseManager getSportDataWithUserId:[[LoginManager instance] getUserId] starDate:startDate endDate:endDate];
    
    self.currentMonth = [NSString stringWithFormat:@"%ld.%ld",(long)startYear,(long)startMonth];
    
    self.totalDistance = @"0m";
    
    _hadLoadDataCount += [sportArray count];
    
    //计算本月数据
    if ([sportArray count]>0) {
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        double weekDistance = 0.0;
        for (int i =0; i < 31; i++) {
            double startime = [endDate timeIntervalSince1970]-24*3600*(i+1)+1;
            double endtime = [endDate timeIntervalSince1970]+0.9-24*3600*i;
            double distance = 0.0f;
            for (SportModel *sportModel in sportArray) {
                double time = [sportModel.startTime timeIntervalSince1970];
                if (sportModel.startTime) {
                    if (time>startime && time<endtime) {
                        distance +=sportModel.totalDistance;
                    }
                }
            }
            if (distance > 0.0) {
                SportModel *sportInfo = [[SportModel alloc] init];
                sportInfo.totalDistance = distance;
                sportInfo.startTime = [NSDate dateWithTimeIntervalSince1970:startime];
                [resultArray addObject:sportInfo];
            }
            
            weekDistance +=distance;
        }
        
        if (weekDistance>=1000.00) {
            self.totalDistance = [NSString stringWithFormat:@"%.1fkm",weekDistance/1000.0];
        }else{
            self.totalDistance = [NSString stringWithFormat:@"%.1fm",weekDistance];
        }
        
    }
    //    if (pageIndex == 0) {
    //        [_distanceSectionArray removeAllObjects];
    //        [_currentMonthSectionArray removeAllObjects];
    //        [_historySportArray removeAllObjects];
    //    }
    //NSLog(@"@%ld %@,%@",pageIndex,self.currentMonth,self.totalDistance);
    
    [_distanceSectionArray addObject:self.totalDistance];
    [_currentMonthSectionArray addObject:self.currentMonth];
    
    //NSLog(@"%--@",_currentMonthSectionArray);
    return sportArray;
}


- (NSString *)getTotalDistanceWithSection:(NSInteger)section {
    
    if (_distanceSectionArray && [_distanceSectionArray count] > section) {
        
        return [_distanceSectionArray objectAtIndex:section];
    }
    return nil;
}

- (NSString *)getcurrentMonthWithSection:(NSInteger)section {
    if (_currentMonthSectionArray && [_currentMonthSectionArray count]>section) {
        
        return [_currentMonthSectionArray objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)howManyDaysInThisYear:(NSInteger)year month:(NSInteger)imonth {
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3)) {
        return 28;
    }
    if(year%400 == 0) {
        return 29;
    }
    if(year%100 == 0) {
        return 28;
    }
    return 29;
    
}
-(BOOL)hadLoadAllData{
    //NSLog(@"%ld %ld",(long)_totalTimes,_hadLoadDataCount);
    if (_totalTimes > _hadLoadDataCount) {
        return NO;
    }else{
        return YES;
    }
}




@end
