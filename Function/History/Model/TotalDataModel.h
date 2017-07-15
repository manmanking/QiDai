//
//  TotalDataModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalDataModel : NSObject

@property (assign, nonatomic) double totalDistance; // 总行程

@property (assign, nonatomic) int totalFrequency;   // 总次数

@property (assign, nonatomic) int totalTime;        // 总时长_秒

@end
