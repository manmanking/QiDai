//
//  locationModel.h
//  Leqi
//
//  Created by Tianyu on 14/12/18.
//  Copyright (c) 2014年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ItemModel.h"
@interface LocationModel : NSObject<NSCoding>

@property (assign, nonatomic) double horizontalAccuracy; // 坐标精度
@property (assign, nonatomic) double verticalAccuracy;   // 海拔精度
@property (assign, nonatomic) double course;             // 方向__0.0~259.9__-1

@property (strong, nonatomic) ItemModel *itemModel;


- (id)initWithLocation:(CLLocation *)location;

@end
