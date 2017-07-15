//
//  NSArray+MMArrayCategory.m
//  QiDai
//
//  Created by manman'swork on 16/11/28.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "NSArray+MMArrayCategory.h"

@implementation NSArray (MMArrayCategory)


- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}


@end
