//
//  ItemDataBaseManager.m
//  Leqi
//
//  Created by Tianyu on 15/1/18.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "ItemDataBaseManager.h"
#import "FMDatabase.h"
#import "LocationModel.h"
#import "ItemModel.h"
#import "DBManager.h"
#import "NSString+Tools.h"
#import "UploadFileManager.h"
@interface ItemDataBaseManager ()
@end

@implementation ItemDataBaseManager

#pragma mark -- Class method

+ (FMDatabase *)dataBase {
    
    if (![[DBManager dbFilePath] isExist]) {
        Clog(@"SportData.db File is not in SandBox");
        return nil;
    }
    FMDatabase *fmDataBase = [FMDatabase databaseWithPath:[DBManager dbFilePath]];
    return fmDataBase;
}


+ (void)insertItemData:(ItemModel *)itemModel {
    FMDatabase *itemDB = [[self class] dataBase];
    
    if (![itemDB open]) {
        Clog(@"FMDataBase open failure");
        return;
    }
    
    [itemDB setShouldCacheStatements:YES];
    
    NSString *sql = [NSString stringWithFormat:@"insert into ItemData (sid, lat, lon, altitude, speed, time) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                     itemModel.sid,
                     [NSString stringWithFormat:@"%lf",itemModel.latitude],
                     [NSString stringWithFormat:@"%lf",itemModel.longitude],
                     [NSString stringWithFormat:@"%lf",itemModel.altitude],
                     [NSString stringWithFormat:@"%lf",itemModel.speed],
                     [NSString stringWithFormat:@"%lf",[itemModel.currentDate timeIntervalSince1970]]];
    [itemDB executeUpdate:sql];
    [itemDB close];
}




+ (void)insertItemDataArray:(NSArray *)dataArray {
    FMDatabase *itemDB = [[self class] dataBase];
    
    if (![itemDB open]) {
        Clog(@"FMDataBase open failure");
        return;
    }
    [itemDB setShouldCacheStatements:YES];
    if ([dataArray count]>0) {
        for (LocationModel *locationModel in dataArray) {
            
            ItemModel *itemModel = locationModel.itemModel;
            NSString *sql = [NSString stringWithFormat:@"insert into ItemData (sid, lat, lon, altitude, speed, time) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                             itemModel.sid,
                             [NSString stringWithFormat:@"%lf",itemModel.latitude],
                             [NSString stringWithFormat:@"%lf",itemModel.longitude],
                             [NSString stringWithFormat:@"%lf",itemModel.altitude],
                             [NSString stringWithFormat:@"%lf",itemModel.speed],
                             [NSString stringWithFormat:@"%lf",[itemModel.currentDate timeIntervalSince1970]]];
            [itemDB executeUpdate:sql];
        }
    }
    [itemDB close];
}




+ (NSArray *)getItemDataWithSid:(NSString *)sid {
    FMDatabase *itemDB = [[self class] dataBase];
    if (![itemDB open]) {
        Clog(@"FMDataBase open failure");
        return nil;
    }
    
    NSMutableArray *itemDataAry = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSString *sql = [NSString stringWithFormat:@"select * from ItemData where sid = '%@'",sid];
    
    FMResultSet *rs = [itemDB executeQuery:sql];
    
    while ([rs next]) {
        ItemModel *itemModel  = [[ItemModel alloc] init];
        itemModel.itemId      = [NSString stringWithFormat:@"%d",[rs intForColumn:@"itemid"]];
        itemModel.latitude    = [[rs stringForColumn:@"lat"] doubleValue];
        itemModel.longitude   = [[rs stringForColumn:@"lon"] doubleValue];
        itemModel.altitude    = [[rs stringForColumn:@"altitude"] doubleValue];
        itemModel.speed       = [[rs stringForColumn:@"speed"] doubleValue];
        itemModel.currentDate = [NSDate dateWithTimeIntervalSince1970:[[rs stringForColumn:@"time"] doubleValue]];
        
        [itemDataAry addObject:itemModel];
    }
    
    [itemDB close];
    return itemDataAry;
}

+ (NSArray *)getItemDataFromTxtWithSid:(NSString *)sid {
    
    NSString *filePath = [UploadFileManager txtFilePathWithFileName:sid];
    NSString* content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *array = [content componentsSeparatedByString:@"\n"];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    for (NSString *string in array) {
        //itemModel.sid,itemModel.latitude,itemModel.longitude,itemModel.altitude,itemModel.speed
        NSArray *tempAry = [string componentsSeparatedByString:@","];
        if ([tempAry count]==5) {
            ItemModel *item = [[ItemModel alloc] init];
            item.sid = [tempAry objectAtIndex:0];
            item.latitude = [[tempAry objectAtIndex:1] doubleValue];
            item.longitude = [[tempAry objectAtIndex:2] doubleValue];
            item.altitude = [[tempAry objectAtIndex:3] doubleValue];
            item.speed = [[tempAry objectAtIndex:4] doubleValue];
            [itemArray addObject:item];
        }
    }
    return itemArray;
}


@end
