//
//  RegistView.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "RegistView.h"
#import "ReactiveCocoa.h"
@interface RegistView ()

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UITextField *passwordTextField;
/** 第一步的view，填写手机号、密码等*/
@property (nonatomic,strong) UIView *firstView;

/** 第二步的view,填写验证码等*/
@property (nonatomic,strong) UIView *secondView;
/** 已发送到手机*/
@property (nonatomic,strong) UILabel *titleLabel;

/** 注册码*/
@property (nonatomic,strong) UITextField *codeTextField;
/** 点击获取验证码的按钮*/
@property (nonatomic,strong) UIButton *getCodeBtn;
/** 定时器*/
@property (strong, nonatomic) NSTimer *secoundTimer;
/** 定时器计数*/
@property (nonatomic,assign) NSInteger timeStatus;
@end

@implementation RegistView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.timeStatus = 60;
    }
    return self;
}
- (void)setupCustomView {
    
    //上面的X号和新人注册
    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(60, 90, 35, 34) NormalImageString:@"login_X_img" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickBackBtn)]) {
            [self.delegate clickBackBtn];
        }
    }];
    //扩大作用域
    [backBtn setEnlargeEdge:20*SizeScaleSubjectTo720];
    [self addSubview:backBtn];
    
    UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(285, 87, 150, 40) title:@"注册" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self addSubview:titleLabel];
    
    
    [self setupFristView];
    
    [self setupSecondView];
}
- (void)setupFristView {
    [self addSubview:self.firstView];
    
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 152, 32, 39)];
    phoneImageView.image = [UIImage imageNamed:@"login_phone_image"];
    [self.firstView addSubview:phoneImageView];
    
    [self.firstView addSubview:self.phoneTextField];
    [self.phoneTextField becomeFirstResponder];
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 152 + 98, 32, 40)];
    passwordImageView.image = [UIImage imageNamed:@"login_password_image"];
    [self.firstView addSubview:passwordImageView];
    
    [self.firstView addSubview:self.passwordTextField];
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(78, 220, 564, 1)];
        lineView.backgroundColor = UIColorFromRGB_16(0x838383);
        [self.firstView addSubview:lineView];
        if (i == 1) {
            lineView.top = (218 + 98)*SizeScaleSubjectTo720;
        }
    }
    
    //下一步的按钮
    UIButton *nextBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(78, 428, 564, 90) title:@"下一步" titleColor:kColorForfff titleFont:34 backgroundColor:[UIColor clearColor] tapAction:^(UIButton *button) {
        
        [self clickNextBtn];
    }];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    [self.firstView addSubview:nextBtn];
    
    RAC(nextBtn, enabled) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce:^id(NSString *telephone, NSString *password){
        return @(telephone.length == 11 && password.length > 5);
    }];
    
    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 562, 400, 24) title:@"注册即代表已阅读并同意" titleColor:kColorForfff textAlignment:NSTextAlignmentRight font:24];
    [self.firstView addSubview:textLabel];
    
    UIButton *termsBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(400, 562, 250, 24) title:@"《用户服务条款》" titleColor:UIColorFromRGB_16(0xe60012) titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickTermsBtn)]) {
            [self.delegate clickTermsBtn];
        }
    }];
    termsBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.firstView addSubview:termsBtn];
}

- (void)setupSecondView {
    [self addSubview:self.secondView];
    
    self.titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 128, 720, 30) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:32];
    
    [self.secondView addSubview:self.titleLabel];
    
    UIImageView *codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 259, 32, 22)];
    codeImageView.image = [UIImage imageNamed:@"reset_code_image"];
    [self.secondView addSubview:codeImageView];
    
    [self.secondView addSubview:self.codeTextField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(78, 273, 564, 1)];
    lineView.top = codeImageView.bottom + 24*SizeScaleSubjectTo720;
    lineView.backgroundColor = UIColorFromRGB_16(0x838383);
    [self.secondView addSubview:lineView];
    
    UIButton *completeBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(78, 552, 564, 90) title:@"完成" titleColor:kColorForfff titleFont:34 backgroundColor:nil tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickCompleteBtnWithTelephone:withPassword:withAuthCode:)]) {
            [self.delegate clickCompleteBtnWithTelephone:self.phoneTextField.text withPassword:self.passwordTextField.text withAuthCode:self.codeTextField.text];
        }
    }];
    completeBtn.top = lineView.bottom + 122*SizeScaleSubjectTo720;
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    [self.secondView addSubview:completeBtn];
    
    self.getCodeBtn.centerY = codeImageView.centerY;
    [self.secondView addSubview:self.getCodeBtn];
    
    RAC(completeBtn, enabled) = [RACSignal combineLatest:@[self.codeTextField.rac_textSignal] reduce:^id(NSString *code){
        return @(code.length == 6);
    }];
}
#pragma mark --- private method
/** 点击下一步*/
- (void)clickNextBtn {
    
    if (![self.phoneTextField.text isMobileNumberClassification]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showErrorWithMessage:)]) {
            [self.delegate showErrorWithMessage:@"请输入正确的手机号"];
        }
        return;
    }
    
    if (![self.passwordTextField.text judgePassWordLegal]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showErrorWithMessage:)]) {
            [self.delegate showErrorWithMessage:@"请输入6位字母和数字组合的密码"];
        }
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.titleLabel.text = [NSString stringWithFormat:@"已发送验证码到 %@",self.phoneTextField.text];
        //[self setupSecondView];
        self.firstView.left = -720*SizeScaleSubjectTo720;
        self.secondView.left = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickGetCodeBtnWithTelephone: )]) {
            [self.delegate clickGetCodeBtnWithTelephone:self.phoneTextField.text];
        }
        [self timerCountDown];
    }];
}
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
#pragma mark --- lazy load
- (UIView *)firstView {
    if (!_firstView) {
        _firstView = [[UIView alloc]initWithFrame:CGRectMake720(0, 128, 720, 800)];
    }
    return _firstView;
}
- (UIView *)secondView {
    if (!_secondView) {
        _secondView = [[UIView alloc]initWithFrame:CGRectMake720(720, 128, 720, 800)];
    }
    return _secondView;
}
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake720(140, 152, 500, 40)];
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
        _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake720(140, 152+98, 500, 40)];
        _passwordTextField.placeholder = @"密码(6-20位字母和数字组合)";
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
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]initWithFrame:CGRectMake720(144, 259, 250, 25)];
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
- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(426, 224, 216, 40) title:@"60" titleColor:kColorForfff titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickGetCodeBtnWithTelephone:)]) {
                [self.delegate clickGetCodeBtnWithTelephone:self.phoneTextField.text];
            }
            [self timerCountDown];
        }];
        _getCodeBtn.enabled = NO;
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    }
    return _getCodeBtn;
}
@end
