//
//  DBManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "DBManager.h"

#define DBFileName_Key   @"SportData.db"
@implementation DBManager
//同步数据库文件
+(void)syschronizeDBFile{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * dbFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:DBFileName_Key];
    if (![fileManager fileExistsAtPath:dbFile]) {
        //NSString *initDBFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBFileName_Key];
        
        NSString *initDBFile = [[NSBundle mainBundle] pathForResource:@"SportData" ofType:@"db"];
        //NSLog(@"initDBFile:%@,dbFile:%@",initDBFile,dbFile);
        NSError *error = nil;
        BOOL success = [fileManager copyItemAtPath:initDBFile toPath:dbFile error:&error];
        if (!success)
        {
            NSLog(@"%@",[error localizedDescription]);
            //NSLog(@"ERROR ON COPYING DB FILE: %@ -> %@",initDBFile,dbFile);
        }else{
            NSLog(@"创建SportData.db数据库成功");
        }
    }else{
        NSLog(@"数据库已经存在");
    }
}


//数据库文件路径
+ (NSString *)dbFilePath
{
    NSString * dbFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:DBFileName_Key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbFile]) {
        return dbFile;
    }
    return nil;
}

@end
