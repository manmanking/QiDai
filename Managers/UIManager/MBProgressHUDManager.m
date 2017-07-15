//
//  MBProgressHUDManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "MBProgressHUDManager.h"

@implementation MBProgressHUDManager

+ (instancetype)instance {
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc] init];
    });
    return pRet;
}

- (void)showHUDLoadingView:(UIView *)view {
    //NSLog(@"第二步%@",[NSThread currentThread]);
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.userInteractionEnabled = NO;
    self.hud.labelText = @"骑待为您努力加载中";
    self.hud.removeFromSuperViewOnHide = YES;
    self.isHide = YES;
    [self.hud hide:YES afterDelay:1];
    //self.hud.mode = MBProgressHUDModeText;
}
- (void)sendRequestShowHUD:(UIView *)view {
    //NSLog(@"第二步%@",[NSThread currentThread]);
    if (self.hud.hidden == NO) {
        [self.hud removeFromSuperview];
    }
    
    
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.labelText = @"骑待为您努力加载中";
    self.hud.userInteractionEnabled = NO;
    self.hud.removeFromSuperViewOnHide = YES;
    
    //NSLog(@"第三步%@",[NSThread currentThread]);
}

- (void)hideHUDLoadingViewAfterHalfSecond {
    if (self.hud.hidden == NO) {
        [self.hud hide:YES afterDelay:0.5];
    }
}
- (void)requestSuccessWithMessage:(NSString *)message {
    //NSLog(@"第四步%@",[NSThread currentThread]);
    if (self.hud.hidden == NO) {
        self.hud.labelText = message;
        [self.hud hide:YES afterDelay:1];
    }
}
- (void)requestFailAndHideHUD {
    if (self.hud.hidden == NO) {
        self.hud.labelText = @"请检查网络";
        [self.hud hide:YES afterDelay:1];
    }
}

- (void)hideHUD {
    self.hud.hidden = YES;
}
- (void)showTextOnlyWithView:(UIView *)view withText:(NSString *)text {
    if (self.hud.hidden == NO) {
        self.hud.hidden = YES;
    }
    NSLog(@"into here ....showTextOnlyWithView ");
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = text;
    self.hud.margin = 10.f;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hide:YES afterDelay:3];
}

- (void)showHUDWithView:(UIView *)view string:(NSString *)string andDisappearIn:(float)seconds {
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.userInteractionEnabled = NO;
    self.hud.labelText = string;
    self.hud.mode = MBProgressHUDModeText;
    self.hud.removeFromSuperViewOnHide = YES;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.hud hide:YES];
    });
}
@end
