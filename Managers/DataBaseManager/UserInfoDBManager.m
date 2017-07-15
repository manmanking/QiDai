//
//  UserInfoDBManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "UserInfoDBManager.h"
#import "SportModel.h"
#import "DBManager.h"
#import "FMDatabase.h"
#import "UserInfoModel.h"
#import "UploadFileManager.h"
#import "PublicTool.h"
#import "SportDataBaseManager.h"
#define StringFormartIntgerValue(intgerValue) [NSString stringWithFormat:@"%ld",(long)intgerValue]

@implementation UserInfoDBManager

+ (FMDatabase *)dataBase
{
    
    if (![[DBManager dbFilePath] isExist]) {
        //Clog(@"SportData.db File is not in SandBox");
        return nil;
    }
    
    FMDatabase *fmDataBase = [FMDatabase databaseWithPath:[DBManager dbFilePath]];
    return fmDataBase;
}


+ (BOOL)updateUserInfo:(UserInfoModel *)userInfo
{
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        //Clog(@"FMDatabase open failure");
        return NO;
    }
    
    BOOL success;
    
    NSString *sql_table = [NSString stringWithFormat:@"select * from userInfo where userId = '%@'",userInfo.userId];
    
    FMResultSet *rs = [fmDataBase executeQuery:sql_table];
    
    if (![rs next]) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into userInfo (userId, phoneNo, email, password, nickName, gender, height, weight, birthday, foreImg, name, fitting, imgUrl) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%@,%@,%@,%@,\"%@\",\"%@\",\"%@\",\"%@\")",
                         userInfo.userId,
                         userInfo.phoneNo,
                         userInfo.email,
                         userInfo.password,
                         userInfo.nickName,
                         StringFormartIntgerValue([userInfo.gender integerValue]),
                         StringFormartIntgerValue([userInfo.height integerValue]),
                         StringFormartIntgerValue([userInfo.weight integerValue]),
                         StringFormartIntgerValue([userInfo.birthday integerValue]),
                         userInfo.foreImg,
                         userInfo.bicycleName,
                         userInfo.fitting,
                         userInfo.bicycleImg];
        
        success = [fmDataBase executeUpdate:sql];
        
        if (success) {
            NSLog(@"insert userInfo table success");
        } else {
            NSLog(@"insert userInfo table failure");
        }
        
    } else {
        
        NSString *sql = [NSString stringWithFormat:@"update userInfo set phoneNo = \"%@\", email = \"%@\", password = \"%@\", nickName = \"%@\", gender = %@, height = %@, weight = %@, birthday = %@, foreImg = \"%@\", name = \"%@\", fitting = \"%@\", imgUrl = \"%@\" where userId = \"%@\"",
                         userInfo.phoneNo,
                         userInfo.email,
                         userInfo.password,
                         userInfo.nickName,
                         StringFormartIntgerValue([userInfo.gender integerValue]),
                         StringFormartIntgerValue([userInfo.height integerValue]),
                         StringFormartIntgerValue([userInfo.weight integerValue]),
                         StringFormartIntgerValue([userInfo.birthday integerValue]),
                         userInfo.foreImg,
                         userInfo.bicycleName,
                         userInfo.fitting,
                         userInfo.bicycleImg,
                         userInfo.userId];
        
        success = [fmDataBase executeUpdate:sql];
        if (success) {
            NSLog(@"update userInfo table success");
        } else {
            NSLog(@"update userInfo table failure");
        }
    }
    
    [fmDataBase close];
    return success;
    
}

+ (UserInfoModel *)getUserInfoWithUserId:(NSString *)userId
{
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        //Clog(@"FMDatabase open failure");
        return nil;
    }
    
    NSString *sql = @"select * from userInfo";
    if ([userId isExist]) {
        sql = [NSString stringWithFormat:@"select * from userInfo where userId = '%@'",userId];
    }
    
    FMResultSet *rs = [fmDataBase executeQuery:sql];
    if ([rs next]) {
        UserInfoModel *userInfo = [[UserInfoModel alloc] init];
        userInfo.phoneNo        = [rs stringForColumn:@"phoneNo"];
        userInfo.email          = [rs stringForColumn:@"email"];
        userInfo.password       = [rs stringForColumn:@"password"];
        userInfo.nickName       = [rs stringForColumn:@"nickName"];
        userInfo.gender         = @([rs intForColumn:@"gender"]);
        userInfo.height         = @([rs intForColumn:@"height"]);
        userInfo.weight         = @([rs intForColumn:@"weight"]);
        userInfo.birthday       = @([rs intForColumn:@"birthday"]);
        userInfo.foreImg        = [rs stringForColumn:@"foreImg"];
        userInfo.bicycleName    = [rs stringForColumn:@"name"];
        userInfo.fitting        = [rs stringForColumn:@"fitting"];
        userInfo.bicycleImg     = [rs stringForColumn:@"imgUrl"];
        
        [fmDataBase close];
        return userInfo;
    }
    
    [fmDataBase close];
    return nil;
}

/**
 *  验证当前用户是否有存在未上传的数据
 *
 *  @param userId
 *
 *  @return
 */

+ (NSArray *)verifySportDataExistWillUploadWithUserId:(NSString *)userId
{
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        //Clog(@"FMDatabase open failure");
        return nil;
    }
    
   // BOOL success;
    NSMutableArray *sportDataAry = [[NSMutableArray alloc]init];
    NSString *sql_table = [NSString stringWithFormat:@"select * from SportData where uid = '%@' AND ( upload = 0 OR uploadDetail = 0 )",userId];
    
    FMResultSet *rs = [fmDataBase executeQuery:sql_table];
    while([rs next])
    {
//        QDLog(@"result %@",@([result intForColumn:@"upload"]));
//        QDLog(@"result %@",@([result intForColumn:@"uploadDetail"]));
        //NSString *test = [rs stringForColumn:@"sid"];
       
        SportModel *sporeModel      = [[SportModel alloc] init];
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
        
        [sportDataAry addObject:sporeModel];
        
        
    }
    
    /**
     *  	`upload`	integer NOT NULL DEFAULT '0',
     `uploadDetail`
     */
    
    
    
    
    
    
    return sportDataAry;//[NSArray arrayWithArray:sportDataAry];
    
}

+ (NSArray *)verifyFreshSportDataExistWillUploadWithUserId:(NSString *)userId
{
    FMDatabase *fmDataBase = [[self class] dataBase];
    
    if (![fmDataBase open]) {
        //Clog(@"FMDatabase open failure");
        return nil;
    }
    
    // BOOL success;
    NSMutableArray *sportDataAry = [[NSMutableArray alloc]init];
    NSString *sql_table = [NSString stringWithFormat:@"select * from SportData where uid = '%@' AND ( upload = 0 OR uploadDetail = 0 )  order by starttime desc limit 1",userId];
    
    FMResultSet *rs = [fmDataBase executeQuery:sql_table];
    while([rs next])
    {
        
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
    
    /**
     *  	`upload`	integer NOT NULL DEFAULT '0',
     `uploadDetail`
     */
    
    
    
    
    
    
    return sportDataAry;//[NSArray arrayWithArray:sportDataAry];
    
}






+ (void)deleteExpiredUserSportDataWithUserId:(NSString *)userId
{
    NSArray *existUploadDataArr =  [UserInfoDBManager verifySportDataExistWillUploadWithUserId:[[LoginManager instance] getUserId]];
    NSDate *currentDate = [NSDate date];
    
    NSMutableArray *expiredSportDataMArr = [[NSMutableArray alloc]init];
    
    for (SportModel *tmpModel in existUploadDataArr) {
     NSDateComponents *dateCompoent = [PublicTool intervalFromLastDate:tmpModel.startTime AndExpiredDate:currentDate];
        NSLog(@"date componet day :%ld hour :%ld   %@  current %@",dateCompoent.day,dateCompoent.hour,tmpModel.startTime,currentDate);
        if (dateCompoent.year >= 1 ||dateCompoent.month >= 1||dateCompoent.day >= 1) {
            [expiredSportDataMArr addObject:tmpModel];
            
        }
        
    }
    if (expiredSportDataMArr.count >0) {
     BOOL deleBool =    [SportDataBaseManager deleSportData:[[LoginManager instance] getUserId] andSportData:expiredSportDataMArr];
        if (deleBool) {
            NSLog(@"数据库删除成功 ....");
        }

    }
    
    //删除本地数据
    NSString *fileHeader = [NSString stringWithFormat:@"%@/item/",[UploadFileManager  currentUserHomeFolder]];
    for (SportModel *tmpModel in expiredSportDataMArr) {
        NSLog(@"文件删除 ....");
        NSLog(@"fileheader :%@",fileHeader);
        NSString *fileTextFilePath = [fileHeader stringByAppendingString:[NSString stringWithFormat:@"%@%@.txt",fileHeader,tmpModel.sId]];
        [self deleteFileExpiredSportRecord:fileTextFilePath];
        NSString *fileZipFilePath = [fileHeader stringByAppendingString:[NSString stringWithFormat:@"%@itemZip/%@.zip",fileHeader,tmpModel.sId]];
        [self deleteFileExpiredSportRecord:fileZipFilePath];
        
        
    }

    
    
}


#pragma -------私有方法
/**
 *
 *
 *  @param filePath
 *
 *  @return
 */
+ (BOOL)deleteFileExpiredSportRecord:(NSString *)filePath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL isSuccess = NO;
    if (filePath != nil) {
        isSuccess = [fileMgr removeItemAtPath:filePath error:&error];
        if (isSuccess) {
            NSLog(@" dele file success filePath ：%@",filePath);
        }
        else
        {
            NSLog(@" dele file failure filePath ：%@  error:%@",filePath,error);
        }
    }
    
    return isSuccess;
    
    
}




@end

