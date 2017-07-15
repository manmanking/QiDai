//
//  NSDate+Tools.m
//  Leqi
//
//  Created by Tianyu on 15/1/12.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

- (NSString *)dataConvertString:(NSString *)str
{
    NSDateFormatter *formatter;
    NSInteger temp;
    temp = [self timeIntervalSince1970];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:str];
    //return  [NSString stringWithFormat:@"%@",[formatter dateFromString:str]];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:temp]];
}

@end
