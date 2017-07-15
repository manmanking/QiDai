//
//  ShowCameraManager.h
//  Leqi
//
//  Created by Tianyu on 15/1/13.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface ShowCameraManager : NSObject

@property (copy, nonatomic) NSString *sportTimeStr;
@property (assign, nonatomic) float lat;
@property (assign, nonatomic) float lon;

/** 图片的数量，最多4张*/
@property (assign, nonatomic) int photoCount;

+ (instancetype)instance;

- (void)showActionSheetInTabbar:(UITabBar *)tabbar
               inViewController:(UIViewController *)vc
                        compate:(void(^)(NSString *imgStr))comapte;

- (void)showActionSheetInView:(UIView *)view
             inViewController:(UIViewController *)vc;

- (void)showActionForForeSheetInTabbar:(UITabBar *)tabbar
                      inViewController:(UIViewController *)vc
                               compate:(void(^)(NSString *imgStr))comapte;

@end
