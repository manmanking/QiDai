//
//  ItemModel.h
//  Leqi
//
//  Created by Tianyu on 15/1/17.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (strong, nonatomic) NSString *itemId;

/** sportID*/
@property (strong, nonatomic) NSString *sid;

@property (assign, nonatomic) double latitude;           // 经度
@property (assign, nonatomic) double longitude;          // 纬度
@property (assign, nonatomic) double altitude;           // 海拔_m
@property (assign, nonatomic) double speed;              // 速度_m/s
@property (strong, nonatomic) NSDate *currentDate;       // 当前时间

@end
