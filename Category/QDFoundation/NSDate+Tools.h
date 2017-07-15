//
//  NSDate+Tools.h
//  Leqi
//
//  Created by Tianyu on 15/1/12.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tools)

/**
 *  NSDate转换成NSString
 *
 *  @param str 格式（例:yyyy年MM月dd日）
 *
 *  @return 字符串结果
 */
- (NSString *)dataConvertString:(NSString *)str;

@end
