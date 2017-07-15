//
//  FirstResetView.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "FirstResetView.h"
#import "ReactiveCocoa.h"
@implementation FirstResetView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(86, 148, 32, 39)];
    phoneImageView.image = [UIImage imageNamed:@"login_phone_image"];
    [self addSubview:phoneImageView];
    
    [self addSubview:self.phoneTextField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(78, 210, 564, 1)];
    lineView.backgroundColor = UIColorFromRGB_16(0x838383);
    [self addSubview:lineView];
    
    //下一步的按钮
    UIButton *nextBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(78, 429, 564, 90) title:@"下一步" titleColor:kColorForfff titleFont:34 backgroundColor:[UIColor clearColor] tapAction:^(UIButton *button) {
        self.clickNextBtn();
    }];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    [self addSubview:nextBtn];
    
    RAC(nextBtn,enabled) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal] reduce:^id(NSString *phone){
        return @(phone.length == 11);
    }];

}
#pragma mark --- lazy load
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake720(140, 148, 500, 40)];
        _phoneTextField.textColor = kColorForfff;
        _phoneTextField.placeholder = @"请输入与骑待绑定的手机号";
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneTextField setValue:UIColorFromRGB_16(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        UIFont *font = UIFontOfSize720(26);
        _phoneTextField.font = font;
        [_phoneTextField setValue:font forKeyPath:@"_placeholderLabel.font"];
        
        
    }
    return _phoneTextField;
}


@end
