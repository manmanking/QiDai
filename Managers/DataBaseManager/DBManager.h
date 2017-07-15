//
//  DBManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

//同步数据库文件
+(void)syschronizeDBFile;


//数据库文件路径
+ (NSString *)dbFilePath;

@end
