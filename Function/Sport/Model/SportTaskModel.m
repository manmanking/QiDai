//
//  SportTaskModel.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportTaskModel.h"
#import <objc/runtime.h>// 导入运行时文件

@implementation SportTaskModel



/**
 *   解码
 *
 *  @param aDecoder
 *
 *  @return
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
    }
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数

    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [aDecoder decodeObjectForKey:key];
        
        // 设置到成员变量身上
        [self setValue:value forKey:key];
    }
    
    free(ivars);
    
    return self;
    
    
}


/**
 *  编码
 *
 *  @param aCoder
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
    
    
}

@end
