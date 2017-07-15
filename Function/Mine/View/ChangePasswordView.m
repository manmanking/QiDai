//
//  ChangePasswordView.m
//  Leqi
//
//  Created by 张汇丰 on 16/1/12.
//  Copyright © 2016年 com.hoolai. All rights reserved.
//

#import "ChangePasswordView.h"

@interface ChangePasswordView ()
{

}



@end

@implementation ChangePasswordView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    NSArray *tfArray = @[self.oldPasswordTF,self.changePasswordTF,self.changePasswordTF2];
    
    NSArray *labelArray = @[@"旧密码",@"新密码",@"再确认"];
    
    for (int i = 0; i < labelArray.count; i++) {
        
        UILabel *leftLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 190, 25) title:labelArray[i] titleColor:UIColorFromRGB_16(0Xd4d4d4) textAlignment:NSTextAlignmentCenter font:24];
        leftLabel.centerY = 65*SizeScaleSubjectTo720;
        
        UITextField *tf = tfArray[i];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 20 + (12 + 110)*i, 720, 110)];;
        bgView.backgroundColor = UIColorFromRGB_16(0x000000);
        [self addSubview:bgView];
        
        [bgView addSubview:leftLabel];
        [bgView addSubview:tf];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark --- get
- (UITextField *)oldPasswordTF {
    if (!_oldPasswordTF) {
        _oldPasswordTF = [[UITextField alloc]initWithFrame:CGRectMake720(190, 0, 500, 40)];
        _oldPasswordTF.centerY = 65*SizeScaleSubjectTo720;
        //_oldPasswordTF.text = @"啦啦啦啦";
        _oldPasswordTF.secureTextEntry = YES;
        _oldPasswordTF.textColor = UIColorFromRGB_16(0xffffff);
        _oldPasswordTF.font = UIFontOfSize720(30);
    }
    return _oldPasswordTF;
}

- (UITextField *)changePasswordTF {
    if (!_changePasswordTF) {
        _changePasswordTF = [[UITextField alloc]initWithFrame:CGRectMake720(190, 0, 500, 40)];
        _changePasswordTF.centerY = 65*SizeScaleSubjectTo720;
        //_changePasswordTF.text = @"啦啦啦啦";
        _changePasswordTF.secureTextEntry = YES;
        _changePasswordTF.textColor = UIColorFromRGB_16(0xffffff);
        _changePasswordTF.font = UIFontOfSize720(30);
    }
    return _changePasswordTF;
}

- (UITextField *)changePasswordTF2 {
    if (!_changePasswordTF2) {
        _changePasswordTF2 = [[UITextField alloc]initWithFrame:CGRectMake720(190, 0, 500, 40)];
        _changePasswordTF2.centerY = 65*SizeScaleSubjectTo720;
        //_changePasswordTF2.text = @"啦啦啦啦";
        _changePasswordTF2.secureTextEntry = YES;
        _changePasswordTF2.textColor = UIColorFromRGB_16(0xffffff);
        _changePasswordTF2.font = UIFontOfSize720(30);
    }
    return _changePasswordTF2;
}

@end
