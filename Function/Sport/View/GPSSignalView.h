//
//  GPSSignalView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/16.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  gps信号量的view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StatusLevel) {
    No_Signal = 0,
    Poor_Signal,
    Average_Signal,
    Full_Signal,
};
@interface GPSSignalView : UIView

/** 获取当前的gps信号*/
- (void)currentGPS;

@end
