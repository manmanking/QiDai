//
//  LoginView.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/5.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "LoginView.h"
#import "UIButton+EnlargeEdge.h"
#import "ReactiveCocoa.h"
#import "SinaManager.h"
#import "QQManager.h"
#import "WeChatManager.h"
@interface LoginView ()

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UITextField *passwordTextField;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setupCustomView {
    
    // 添加视图背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"LoginBGImage"];
    [self addSubview:bgImageView];
    [self setupTopView];
    
    [self setupMiddleView];

    [self setupBottomView];
}
/** 顶部的view*/
- (void)setupTopView {
    
    //上面的X号和新人注册
    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(60, 90, 35, 34) NormalImageString:@"login_X_img" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickBackBtn)]) {
            [self.delegate clickBackBtn];
        }
    }];
    [backBtn setEnlargeEdge:20*SizeScaleSubjectTo720];
    [self addSubview:backBtn];
    
        
    //新人注册的按钮
    UIButton *registerBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(480, 90, 180, 34) title:@"新人注册" titleColor:UIColorFromRGB_16(0xe60012) titleFont:32 backgroundColor:[UIColor clearColor] tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickRegisterBtn)]) {
            [self.delegate clickRegisterBtn];
        }
    }];
    [registerBtn setEnlargeEdge:20*SizeScaleSubjectTo720];
    [self addSubview:registerBtn];
    
    //logo的imageView
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(286, 222, 148, 140)];
    logoImageView.image = [UIImage imageNamed:@"login_icon_img"];
    [self addSubview:logoImageView];
    
}
/** 手机号与密码，忘记密码，登录等中间部位的view*/
- (void)setupMiddleView {
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 510, 32, 39)];
    phoneImageView.image = [UIImage imageNamed:@"login_phone_image"];
    [self addSubview:phoneImageView];
    
    [self addSubview:self.phoneTextField];
    
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 510 + 98, 32, 40)];
    passwordImageView.image = [UIImage imageNamed:@"login_password_image"];
    [self addSubview:passwordImageView];
    
    [self addSubview:self.passwordTextField];
    
    //忘记密码的按钮
    UIButton *forgetBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(480, 695, 180, 34) title:@"忘记密码?" titleColor:UIColorFromRGB_16(0xffffff) titleFont:32 backgroundColor:[UIColor clearColor] tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickForgetPasswordBtn)]) {
            [self.delegate clickForgetPasswordBtn];
        }
    }];
    [self addSubview:forgetBtn];

    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(78, 567, 564, 1)];
        lineView.backgroundColor = UIColorFromRGB_16(0x838383);
        [self addSubview:lineView];
        if (i == 1) {
            lineView.top = (567 + 98)*SizeScaleSubjectTo720;
        }
    }
    
    //登录的按钮
    UIButton *loginBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(78, 803, 564, 90) title:@"登录" titleColor:UIColorFromRGB_16(0xffffff) titleFont:34 backgroundColor:[UIColor clearColor] tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickLoginBtnWithPhone:password:)]) {
            [self.delegate clickLoginBtnWithPhone:self.phoneTextField.text password:self.passwordTextField.text];
        }
    }];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    [self addSubview:loginBtn];
    RAC(loginBtn,enabled) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,self.passwordTextField.rac_textSignal] reduce:^id(NSString *phone,NSString *password){
        return @(phone.length == 11 && password.length >= 6);
    }];
    
}
/** 第三方登录按钮*/
- (void)setupBottomView {
    
    // 监测 第三方APP是否已安装 若都没有安装  则没有第三方登录方式
//    if (![[QQManager instance] isQQInstalled] && ![[WeChatManager instance] isWeChatInstalled] && ![[SinaManager instance] isSinaInstalled]) {
//        return;
//    }
    
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(78, 1020, 132, 1)];
        lineView.backgroundColor = UIColorFromRGB_16(0x838383);
        [self addSubview:lineView];
        if (i == 1) {
            lineView.left = 510*SizeScaleSubjectTo720;
        }
    }
    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 1008, 300, 24) title:@"第三方账号快速登录" titleColor:UIColorFromRGB_16(0x999999) textAlignment:NSTextAlignmentCenter font:26];
    [self addSubview:textLabel];
    
    UIButton *qqBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(78, 1092, 98, 98) NormalBackgroundImageString:@"login_qq_img" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickQQBtn)]) {
            [self.delegate clickQQBtn];
        }
    }];
    [self addSubview:qqBtn];
    
    UIButton *weChatBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(311, 1092, 98, 98) NormalBackgroundImageString:@"login_wechart_img" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickWeChatBtn)]) {
            [self.delegate clickWeChatBtn];
        }
    }];
    [self addSubview:weChatBtn];
    
    UIButton *sinaBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(544, 1092, 98, 98) NormalBackgroundImageString:@"login_sina_img" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSinaBtn)]) {
            [self.delegate clickSinaBtn];
        }
    }];
    
    [self addSubview:sinaBtn];
    
    // 监测 第三方APP是否已安装
    // modify  by manman  on 2016-11-01 BUG 331
    
//    if (![[QQManager instance] isQQInstalled]) {
//        qqBtn.hidden = YES;
//        weChatBtn.left -= 110*SizeScale;
//        sinaBtn.left -= 110*SizeScale;
//        
//        if (![[WeChatManager instance] isWeChatInstalled]) {
//            sinaBtn.left = 310*SizeScale;
//        }
//    }
    if (![[WeChatManager instance] isWeChatInstalled]) {
        weChatBtn.hidden = YES;
        qqBtn.left += 110*SizeScale;
        sinaBtn.left -= 110*SizeScale;
    }
//    if (![[SinaManager instance] isSinaInstalled]) {
//        sinaBtn.hidden = YES;
//        weChatBtn.left += 110*SizeScale;
//        qqBtn.left += 110*SizeScale;
//        
//        if (![[WeChatManager instance] isWeChatInstalled]) {
//            qqBtn.left = 310*SizeScale;
//        }
//        
//    }
    
    // end of line
    
}
#pragma mark --- click action

#pragma mark --- lazy load
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake720(140, 510, 520, 40)];
        _phoneTextField.textColor = kColorForfff;
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneTextField setValue:UIColorFromRGB_16(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        UIFont *font = UIFontOfSize720(26);
        _phoneTextField.font = font;
        [_phoneTextField setValue:font forKeyPath:@"_placeholderLabel.font"];
        
        
    }
    return _phoneTextField;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake720(140, 510+98, 520, 40)];
        _passwordTextField.textColor = kColorForfff;
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField setValue:UIColorFromRGB_16(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        UIFont *font = UIFontOfSize720(26);
        _passwordTextField.font = font;
        [_passwordTextField setValue:font forKeyPath:@"_placeholderLabel.font"];
    }
    return _passwordTextField;
}
@end
