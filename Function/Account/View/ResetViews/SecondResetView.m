//
//  SecondResetView.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SecondResetView.h"
#import "ReactiveCocoa.h"
@interface SecondResetView ()

@property (nonatomic,strong) UILabel *titleLabel;
/** 注册码*/
@property (nonatomic,strong) UITextField *codeTextField;
/** 密码*/
@property (nonatomic,strong) UITextField *passwordTextField;

/** 定时器*/
@property (strong, nonatomic) NSTimer *secoundTimer;
/** 定时器计数*/
@property (nonatomic,assign) NSInteger timeStatus;

@property (nonatomic,strong) UIButton *getCodeBtn;
@end

@implementation SecondResetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.timeStatus = 60;
    }
    return self;
}
- (void)setupCustomView {
    self.titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 84, 720, 30) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:32];
    [self addSubview:self.titleLabel];
    
    UIImageView *codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 224, 32, 22)];
    codeImageView.image = [UIImage imageNamed:@"reset_code_image"];
    [self addSubview:codeImageView];
    
    [self addSubview:self.codeTextField];
    
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 314, 32, 40)];
    passwordImageView.image = [UIImage imageNamed:@"login_password_image"];
    [self addSubview:passwordImageView];
    
    [self addSubview:self.passwordTextField];
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(78, 273, 564, 1)];
        lineView.backgroundColor = UIColorFromRGB_16(0x838383);
        [self addSubview:lineView];
        if (i == 1) {
            lineView.top = (272 + 98)*SizeScaleSubjectTo720;
        }
    }
    //确定的按钮
    UIButton *nextBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(78, 552, 564, 90) title:@"确定" titleColor:kColorForfff titleFont:34 backgroundColor:[UIColor clearColor] tapAction:^(UIButton *button) {
        self.clickSureBtnBlock(self.phone,self.passwordTextField.text,self.codeTextField.text);
    }];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    [self addSubview:nextBtn];
    
    RAC(nextBtn, enabled) = [RACSignal combineLatest:@[self.codeTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^id(NSString *telephone, NSString *password){
        return @(telephone.length == 6 && password.length >= 6);
    }];
    self.getCodeBtn.centerY = codeImageView.centerY;
    [self addSubview:self.getCodeBtn];
    
}
#pragma mark --- private method
/** 定时器开始*/
- (void)timerCountDown {
    if (self.timeStatus != 60) {
        self.timeStatus = 60;
    }
    [self.codeTextField becomeFirstResponder];
    self.getCodeBtn.left = 426*SizeScaleSubjectTo720;
    self.getCodeBtn.width = 216*SizeScaleSubjectTo720;
    self.secoundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideSendAgainBtn) userInfo:nil repeats:YES];
    [self.secoundTimer fire];
}
/** 定时器每秒刷新*/
- (void)hideSendAgainBtn {
    self.timeStatus--;
    self.getCodeBtn.enabled = NO;
    
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重发验证码(%ld)s",(long)self.timeStatus] forState:UIControlStateDisabled];
    //    self.getCodeBtn.titleLabel.attributedText = [NSString]
    if (self.timeStatus == 0) {
        [self.secoundTimer invalidate];
        [self showSendAgainBtn];
    }
}
/** 定时器再次开始*/
- (void)showSendAgainBtn {
    self.getCodeBtn.enabled = YES;
    
    self.getCodeBtn.left = 496*SizeScaleSubjectTo720;
    self.getCodeBtn.width = 146*SizeScaleSubjectTo720;
    [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    
}

#pragma mark --- set
- (void)setPhone:(NSString *)phone {
    _phone = phone;
    self.titleLabel.text = [NSString stringWithFormat:@"已发送验证码到 %@",phone];
}
#pragma mark --- lazy load
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]initWithFrame:CGRectMake720(144, 224, 300, 25)];
        _codeTextField.textColor = kColorForfff;
        _codeTextField.placeholder = @"验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_codeTextField setValue:UIColorFromRGB_16(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        UIFont *font = UIFontOfSize720(26);
        _codeTextField.font = font;
        [_codeTextField setValue:font forKeyPath:@"_placeholderLabel.font"];
    }
    return _codeTextField;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake720(144, 314, 500, 40)];
        _passwordTextField.placeholder = @"输入新密码(6-20位字母和数字)";
        //_passwordTextField.secureTextEntry = YES;
        [_passwordTextField setValue:UIColorFromRGB_16(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.textColor = kColorForfff;
        UIFont *font = UIFontOfSize720(26);
        _passwordTextField.font = font;
        [_passwordTextField setValue:font forKeyPath:@"_placeholderLabel.font"];
        
        UIButton *eyeBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 0, 36, 21) NormalImageString:@"register_eye_close_image" tapAction:^(UIButton *button) {
            button.selected = !button.selected;
            if (button.selected) {
                _passwordTextField.secureTextEntry = NO;
            } else {
                _passwordTextField.secureTextEntry = YES;
            }
        }];
        [eyeBtn setImage:[UIImage imageNamed:@"register_eye_open_image"] forState:UIControlStateSelected];
        _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
        _passwordTextField.rightView = eyeBtn;
    }
    return _passwordTextField;
}

- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(496, 224, 216, 40) title:@"60" titleColor:kColorForfff titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            self.clickGetCodeBtn(self.phone);
            [self timerCountDown];
        }];
        _getCodeBtn.enabled = NO;
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    }
    return _getCodeBtn;
}
@end
