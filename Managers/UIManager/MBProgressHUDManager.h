//
//  MBProgressHUDManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface MBProgressHUDManager : NSObject

@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,assign) BOOL isHide;

+ (instancetype)instance;

/** 显示hud,3秒后销毁*/
- (void)showTextOnlyWithView:(UIView *)view withText:(NSString *)text;
/** 显示hud,自定义销毁的秒数*/
- (void)showHUDWithView:(UIView *)view string:(NSString *)string andDisappearIn:(float)seconds;
/** loading,1s后销毁*/
- (void)showHUDLoadingView:(UIView *)view;

/** 请求网络时用，销毁调用hideHUDLoadingViewAfterHalfSecond*/
- (void)sendRequestShowHUD:(UIView *)view;
/** 请求成功，0.5s后销毁*/
- (void)requestSuccessWithMessage:(NSString *)message;
/** 请求失败，0.5s后销毁*/
- (void)requestFailAndHideHUD;
/** 0.5s后销毁*/
- (void)hideHUDLoadingViewAfterHalfSecond;

/** 直接隐藏销毁*/
- (void)hideHUD;

@end
