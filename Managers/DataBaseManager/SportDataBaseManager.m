//
//  SportDataBaseManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportDataBaseManager.h"
#import "FMDatabase.h"
#import "SportModel.h"
#import "NSString+Tools.h"
#import "AppConstant.h"
#import "DBManager.h"

@interface SportDataBaseManager ()
@property (nonatomic,strong) FMDatabase *dataBase;
@end
@implementation SportDataBaseManager
#pragma mark -- instance method
-(instancetype)init{
    if (self = [super init]) {
        if (![[DBManager dbFilePath] isExist]) {
            Clog(@"SportData.db File is not in SandBox");
            return nil;
        }
        self.dataBase = [FMDatabase databaseWithPath:[DBManager dbFilePath]];
    }
    return self;
    
}

//给指定的表中添加 新字段
+ (BOOL)addColumnTable:(NSString *)tableName AndColumnName:(NSString *)columnName {
    //先打开数据库
    FMDatabase *fmDataBase = self.dataBase;
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return nil;
    }
    // 先检测 制定表是否存在 若表不存在 则推出
    //select count(*)  from sqlite_master where type='table' and name = 'yourtablename';
    //NSString *sqlTableStr = @"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'";
    NSString *sqlTableStr = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'",tableName];
    FMResultSet *rsTable = [fmDataBase executeQuery:sqlTableStr];
    if (!rsTable) {
        NSLog(@"此表不存在");
        return NO;
        
    }
    
    //检测表中 字段是否存在
    NSString *sqlTableColumnStr = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD `%@` VARCHAR(16) DEFAULT '0'",tableName,columnName];
    
    BOOL success1 = [fmDataBase executeUpdate:sqlTableColumnStr];
    if (success1) {
        NSLog(@" insert columnName successed");
    }else{
        NSLog(@"insert columnName failed");
    }
    [fmDataBase close];
    
    
    return YES;
}

- (NSArray *)getSportDataWithUserId:(NSString *)userId
{
    FMDatabase *fmDataBase = _dataBase;
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return nil;
    }
    
    NSMutableArray *sportDataAry = [[NSMutableArray alloc] init];
    NSString *sqltring = @"select * from SportData ";
#ifdef Data_Test
    userId = @"";
#endif
    if ([userId isExist]) {
        sqltring = [sqltring stringByAppendingFormat:@"where uid = '%@'",userId];
    }
    FMResultSet *rs = [fmDataBase executeQuery:sqltring];
    while ([rs next]) {
        SportModel *sporeModel      = [[SportModel alloc] init];
        sporeModel.sId              = [NSString stringWithFormat:@"%d",[rs intForColumn:@"sid"]];
        sporeModel.startTime        = [NSDate dateWithTimeIntervalSince1970:[[rs stringForColumn:@"starttime"] doubleValue]];
        sporeModel.endTime          = [NSDate dateWithTimeIntervalSince1970:[[rs stringForColumn:@"endtime"] doubleValue]];
        sporeModel.sumTime          = [[rs stringForColumn:@"sumtime"] intValue];
        sporeModel.totalDistance    = [[rs stringForColumn:@"totaldistance"] doubleValue];
        sporeModel.averageSpeed     = [[rs stringForColumn:@"averagespeed"] doubleValue];
        sporeModel.maxSpeed         = [[rs stringForColumn:@"maxspeed"] doubleValue];
        sporeModel.calorie          = [[rs stringForColumn:@"calorie"] doubleValue];
        sporeModel.averageAltitude  = [[rs stringForColumn:@"averagealtitude"] doubleValue];
        sporeModel.maxAltitude      = [[rs stringForColumn:@"maxaltitude"] doubleValue];
        sporeModel.upAltitude        = [[rs stringForColumn:@"upatitude"] doubleValue];
        sporeModel.downAltitude      = [[rs stringForColumn:@"downatitude"] doubleValue];
        sporeModel.upload           = [rs intForColumn:@"upload"];
        sporeModel.uploadDetail     = [rs intForColumn:@"uploadDetail"];
        [sportDataAry addObject:sporeModel];
    }
    [fmDataBase close];
    return sportDataAry;
}


- (NSArray *)getSportDataWithUserId:(NSString *)userId starDate:(NSDate *)starDate endDate:(NSDate *)endDate{
    
    FMDatabase *fmDataBase = _dataBase;
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return nil;
    }
    
    
    NSMutableArray *sportDataAry = [[NSMutableArray alloc] init];
    NSString *sqltring = @"select * from SportData ";
    
#ifdef Data_Test
    userId = @"";
#endif
    
    if ([userId isExist]) {
        sqltring = [sqltring stringByAppendingFormat:@"where uid = '%@' ",userId];
    }
    if (starDate) {
        if ([userId isExist]) {
            sqltring = [sqltring stringByAppendingFormat:@"and starttime >= %f ",[starDate timeIntervalSince1970]];
        }else{
            sqltring = [sqltring stringByAppendingFormat:@"where starttime >= %f ",[starDate timeIntervalSince1970]];
        }
    }
    if (endDate) {
        if (starDate) {
            sqltring = [sqltring stringByAppendingFormat:@"and starttime < %f ",[endDate timeIntervalSince1970]];
        }else{
            sqltring = [sqltring stringByAppendingFormat:@"where starttime < %f ",[endDate timeIntervalSince1970]];
        }
    }
    sqltring = [sqltring stringByAppendingString:@"order by starttime desc"];
    FMResultSet *rs = [fmDataBase executeQuery:sqltring];
    while ([rs next]) {
        SportModel *sporeModel      = [[SportModel alloc] init];
        sporeModel.uId = userId;
        sporeModel.sId              = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"sid"]];
        sporeModel.startTime        = [NSDate dateWithTimeIntervalSince1970:[[rs stringForColumn:@"starttime"] doubleValue]];
        sporeModel.endTime          = [NSDate dateWithTimeIntervalSince1970:[[rs stringForColumn:@"endtime"] doubleValue]];
        sporeModel.sumTime          = [[rs stringForColumn:@"sumtime"] intValue];
        sporeModel.totalDistance    = [[rs stringForColumn:@"totaldistance"] doubleValue];
        sporeModel.averageSpeed     = [[rs stringForColumn:@"averagespeed"] doubleValue];
        sporeModel.maxSpeed         = [[rs stringForColumn:@"maxspeed"] doubleValue];
        sporeModel.calorie          = [[rs stringForColumn:@"calorie"] doubleValue];
        sporeModel.averageAltitude  = [[rs stringForColumn:@"averagealtitude"] doubleValue];
        sporeModel.maxAltitude      = [[rs stringForColumn:@"maxaltitude"] doubleValue];
        sporeModel.upAltitude        = [[rs stringForColumn:@"upatitude"] doubleValue];
        sporeModel.downAltitude      = [[rs stringForColumn:@"downatitude"] doubleValue];
        sporeModel.upload           = [rs intForColumn:@"upload"];
        sporeModel.uploadDetail     = [rs intForColumn:@"uploadDetail"];
        sporeModel.clockFrequency   = [rs intForColumn:@"Field16"];
        sporeModel.shareUrl   = [rs stringForColumn:@"shareUrl"];
        sporeModel.ridingName   = [rs stringForColumn:@"ridingName"];
        [sportDataAry addObject:sporeModel];
    }
    [fmDataBase close];
    return sportDataAry;
}


-(NSString *)getTotalDistanceWithUserId:(NSString *)userId{
    
    FMDatabase *fmDataBase = _dataBase;
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return nil;
    }
    
    
    
    NSString *totalDistance = @"0.0";
    NSString *sqltring = @"select sum(totaldistance) from SportData ";
    
#ifdef Data_Test
    userId = @"";
#endif
    
    if ([userId isExist]) {
        sqltring = [sqltring stringByAppendingFormat:@"where uid ='%@' ",userId];
    }
    
    FMResultSet *rs = [fmDataBase executeQuery:sqltring];
    while ([rs next]) {
        totalDistance = [rs stringForColumnIndex:0];
    }
    [fmDataBase close];
    
    return totalDistance;
}


-(int)getTotalDurationWithUserId:(NSString *)userId{
    
    FMDatabase *fmDataBase = _dataBase;
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return 0;
    }
    
    int totalDutaion = 0;
    
    NSString *sqltring = @"select sum(sumtime) from SportData ";
    
#ifdef Data_Test
    userId = @"";
#endif
    
    if ([userId isExist]) {
        sqltring = [sqltring stringByAppendingFormat:@"where uid ='%@' ",userId];
    }
    
    FMResultSet *rs = [fmDataBase executeQuery:sqltring];
    while ([rs next]) {
        totalDutaion = [rs intForColumnIndex:0];
    }
    [fmDataBase close];
    
    return totalDutaion;
}



/**
 *  获得本账号的总运动次数
 *
 *  @param userId
 *
 *  @return 
 */
+(NSInteger)getTotalTimesWithUserId:(NSString *)userId{
    
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return 0;
    }
    
    NSInteger totalTimes = 0;
    
#ifdef Data_Test
    userId = @"";
#endif
    
    NSString *sqltring = @"select count(*) from SportData ";
    if ([userId isExist]) {
        sqltring = [sqltring stringByAppendingFormat:@"where uid = '%@'",userId];
    }
    FMResultSet *rs = [fmDataBase executeQuery:sqltring];
    while ([rs next]) {
        totalTimes = [rs intForColumnIndex:0];
    }
    [fmDataBase close];
    return totalTimes;
}

+(int)getTotalPointsWithUserId:(NSString *)userId{
    
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return 0;
    }
    
    NSInteger totalPoints = 0;
    
#ifdef Data_Test
    //userId = @"";
#endif
    
    NSString *sqltring = @"select count(totalPoints) from SportData ";
    if ([userId isExist]) {
        sqltring = [sqltring stringByAppendingFormat:@"where uid = '%@'",userId];
    }
    FMResultSet *rs = [fmDataBase executeQuery:sqltring];
    while ([rs next]) {
        totalPoints = [rs intForColumnIndex:0];
    }
    [fmDataBase close];
    return (int)totalPoints;
}



#pragma mark -- Class method

+(FMDatabase *)dataBase{
    
    if (![[DBManager dbFilePath] isExist]) {
        Clog(@"SportData.db File is not in SandBox");
        return nil;
    }
    
    FMDatabase *fmDataBase = [FMDatabase databaseWithPath:[DBManager dbFilePath]];
    return fmDataBase;
}


+ (BOOL)insertSportData:(SportModel *)sportModel
{
    
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return NO;
    }
    
    [fmDataBase setShouldCacheStatements:YES];
    
    
    
    
    NSString *sql = [NSString stringWithFormat:@"insert into SportData (sid, uid, starttime, endtime, sumtime, totaldistance, averagespeed, maxspeed, calorie, averagealtitude, maxaltitude, upatitude, downatitude, Field16 ,ridingName) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\")",
                     sportModel.sId,
                     sportModel.uId,
                     [NSString stringWithFormat:@"%lf",[sportModel.startTime timeIntervalSince1970]],
                     [NSString stringWithFormat:@"%lf",[sportModel.endTime timeIntervalSince1970]],
                     [NSString stringWithFormat:@"%d",sportModel.sumTime],
                     [NSString stringWithFormat:@"%lf",sportModel.totalDistance],
                     [NSString stringWithFormat:@"%lf",sportModel.averageSpeed],
                     [NSString stringWithFormat:@"%lf",sportModel.maxSpeed],
                     [NSString stringWithFormat:@"%lf",sportModel.calorie],
                     [NSString stringWithFormat:@"%lf",sportModel.averageAltitude],
                     [NSString stringWithFormat:@"%lf",sportModel.maxAltitude],
                     [NSString stringWithFormat:@"%lf",sportModel.upAltitude],
                     [NSString stringWithFormat:@"%lf",sportModel.downAltitude],
                     [NSString stringWithFormat:@"%lf",sportModel.clockFrequency],
                     sportModel.ridingName
                     ];
    
    BOOL success = [fmDataBase executeUpdate:sql];
    if (success) {
        NSLog(@"insert successed");
    }else{
        NSLog(@"insert failed");
    }
    [fmDataBase close];
    return success;
}

+ (BOOL)insertSportDataArray:(NSArray *)dataArray{
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        Clog(@"FMDatabase open failure");
        return NO;
    }
    
    [fmDataBase setShouldCacheStatements:YES];
    
    BOOL success = NO;
    for (SportModel *sportModel in dataArray) {
        NSString *sql = [NSString stringWithFormat:@"insert into SportData (sid, uid, starttime, endtime, sumtime, totaldistance, averagespeed, maxspeed, calorie, averagealtitude, maxaltitude, upatitude, downatitude,upload,uploadDetail,ridingName) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',1,1,'%@')",
                         sportModel.sId,
                         sportModel.uId,
                         [NSString stringWithFormat:@"%lf",[sportModel.startTime timeIntervalSince1970]],
                         [NSString stringWithFormat:@"%lf",[sportModel.endTime timeIntervalSince1970]],
                         [NSString stringWithFormat:@"%d",sportModel.sumTime],
                         [NSString stringWithFormat:@"%lf",sportModel.totalDistance],
                         [NSString stringWithFormat:@"%lf",sportModel.averageSpeed],
                         [NSString stringWithFormat:@"%lf",sportModel.maxSpeed],
                         [NSString stringWithFormat:@"%lf",sportModel.calorie],
                         [NSString stringWithFormat:@"%lf",sportModel.averageAltitude],
                         [NSString stringWithFormat:@"%lf",sportModel.maxAltitude],
                         [NSString stringWithFormat:@"%lf",sportModel.upAltitude],
                         [NSString stringWithFormat:@"%lf",sportModel.downAltitude],
                         sportModel.ridingName
                         ];
        
        success = [fmDataBase executeUpdate:sql];
    }
    [fmDataBase close];
    if (success) {
        NSLog(@"insert successed");
    }else{
        NSLog(@"insert failed");
    }
    return success;
}

+(BOOL)updateUpLoadShareUrlWithUrl:(NSString *)shareUrl UserId:(NSString *)userId  sportId:(NSString *)sportId{
    
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        return NO;
    }
    NSString *updateSQL = [NSString stringWithFormat:@"update SportData set shareUrl = '%@' where uid = '%@' and sid = '%@'",shareUrl,userId,sportId];
    BOOL success = [fmDataBase executeUpdate:updateSQL];
    if (success) {
        Clog(@"update SportData shareUrl success");
    }else{
        Clog(@"update SportData shareUrl failure");
    }
    [fmDataBase close];
    return success;
}

+ (BOOL)updateUpLoadStatusWithUserId:(NSString *)userId  sportId:(NSString *)sportId{
    
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        return NO;
    }
    NSString *updateSQL = [NSString stringWithFormat:@"update SportData set upload = 1 where uid = '%@' and sid = '%@'",userId,sportId];
    BOOL success = [fmDataBase executeUpdate:updateSQL];
    if (success) {
        Clog(@"update SportData set upload = 1 success");
    }else{
        Clog(@"update SportData set upload = 1 failure");
    }
    [fmDataBase close];
    return success;
}



+ (BOOL)updateUpLoadDetailStatusWithUserId:(NSString *)userId  sportId:(NSString *)sportId{
    
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        return NO;
    }
    NSString *updateSQL = [NSString stringWithFormat:@"update SportData set uploadDetail = 1 where uid = '%@' and sid = '%@'",userId,sportId];
    BOOL success = [fmDataBase executeUpdate:updateSQL];
    if (success) {
        Clog(@"update SportData set uploadDetail = 1 success");
    }else{
        Clog(@"update SportData set uploadDetail = 1 failure");
    }
    [fmDataBase close];
    return success;
}

+ (BOOL  )deleSportData:(NSString *)userId andSportData:(NSArray *)aSPortDataArr
{
    
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        return NO;
    }
    NSString *sidAssemble =@"";
    for (SportModel *tmpModel in aSPortDataArr) {
       
        sidAssemble = [sidAssemble stringByAppendingFormat:@"'%@',",tmpModel.sId];
      
    }
    sidAssemble = [sidAssemble substringToIndex:[sidAssemble length]-1];
    
    NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM SportData  WHERE uid = '%@' AND  sid in (%@)",userId,sidAssemble];
    BOOL isSuccess  = [fmDataBase executeUpdate:updateSQL];
    
    [fmDataBase close];
    if (isSuccess) {
        QDLog(@"DELETE SportData  WHERE uid success");
        return YES;
    }
    
    QDLog(@"DELETE SportData  WHERE uidfailure");
   // [fmDataBase close];
    
    
    
    return NO;
    
    
    
}



@end

