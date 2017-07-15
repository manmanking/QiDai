//
//  NotLoginView.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NotLoginView.h"

@implementation NotLoginView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    //默认头像
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(240, 172, 240, 240)];
    iconImageView.image = [UIImage imageNamed:@"mine_default_icon_image"];
    [self addSubview:iconImageView];
    //登录按钮
    UIButton *loginBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(110, 0, 200, 78) title:@"登录" titleColor:kColorForfff titleFont:36 backgroundColor:UIColorFromRGB_16(0xe60012) tapAction:^(UIButton *button) {
        [self.delegate clickLoginBtn];
    }];
    loginBtn.top = iconImageView.bottom + 52*SizeScaleSubjectTo720;
    [self addSubview:loginBtn];
    //注册按钮
    UIButton *registerBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(110, 0, 200, 78) title:@"注册" titleColor:kColorForfff titleFont:36 backgroundColor:nil tapAction:^(UIButton *button) {
        [self.delegate clickRegisterBtn];
    }];
    registerBtn.top = iconImageView.bottom + 52*SizeScaleSubjectTo720;
    registerBtn.left = loginBtn.right + 100*SizeScaleSubjectTo720;
    [registerBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [registerBtn.layer setBorderWidth:1];
    [self addSubview:registerBtn];
    
    
}

@end
