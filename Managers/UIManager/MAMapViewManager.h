//
//  MAMapViewManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/8/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
@class MAMapView;
@interface MAMapViewManager : NSObject

//@property (strong, nonatomic) MAMapView *mapView;

+ (MAMapView *)shareMAMapView;

@property (nonatomic,assign) CGRect mapViewFrame;

@end
