//
//  MAMapViewManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/8/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "MAMapViewManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@implementation MAMapViewManager

static MAMapView *_mapView = nil;

+ (MAMapView *)shareMAMapView {
    @synchronized(self) {
        [[AMapServices sharedServices] setApiKey:kGAODELBS_KEY];
        if (_mapView == nil) {
            CGRect frame = [[UIScreen mainScreen] bounds];
            _mapView = [[MAMapView alloc] initWithFrame:frame];
            _mapView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            //_mapView.showsUserLocation = YES;
            _mapView.zoomEnabled = YES;
        }
        _mapView.frame = [UIScreen mainScreen].bounds;
        return _mapView;
    }
}

- (void)setMapViewFrame:(CGRect)mapViewFrame {
    _mapViewFrame = mapViewFrame;
    _mapView.frame = mapViewFrame;
}
////重写allocWithZone保证分配内存alloc相同
//+ (id)allocWithZone:(NSZone *)zone {
//    @synchronized(self) {
//        
//        if (_mapView == nil) {
//            _mapView = [super allocWithZone:zone];
//            return _mapView; // assignment and return on first allocation
//        }
//    }
//    return nil; // on subsequent allocation attempts return nil
//}

//保证copy相同
+ (id)copyWithZone:(NSZone *)zone {
    return _mapView;
}

@end
