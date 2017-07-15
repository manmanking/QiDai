//
//  ReachabilityManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/8/15.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  负责监控网络

#import <Foundation/Foundation.h>

@interface ReachabilityManager : NSObject

/**
 *  检测有无网络
 *
 *  @return bool
 */
+ (BOOL)detectNetwork;

@end
