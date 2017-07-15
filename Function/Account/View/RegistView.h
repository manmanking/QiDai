//
//  RegistView.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  注册的view

#import <UIKit/UIKit.h>

@protocol RegistViewDelegate <NSObject>

//点击返回按钮
- (void)clickBackBtn;

//点击用户条款按钮
- (void)clickTermsBtn;

//点击获取验证码
- (void)clickGetCodeBtnWithTelephone:(NSString *)telephone;

//点击完成按钮
- (void)clickCompleteBtnWithTelephone:(NSString *)telephone withPassword:(NSString *)password withAuthCode:(NSString *)code;

- (void)showErrorWithMessage:(NSString *)message;

@end

@interface RegistView : UIView

@property (nonatomic,weak) id<RegistViewDelegate>delegate;

@end
