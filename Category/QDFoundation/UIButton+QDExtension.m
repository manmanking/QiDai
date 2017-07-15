//
//  UIButton+QDExtension.m
//  Leqi
//
//  Created by 张汇丰 on 15/12/21.
//  Copyright © 2015年 com.hoolai. All rights reserved.
//

#import "UIButton+QDExtension.h"

@interface QDButton : UIButton
@property (copy, nonatomic) TapButtonActionBlock action;
@end

@implementation QDButton

- (instancetype)init {
    if(self = [super init]) {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)btnClick:(UIButton *)button {
    if(self.action) {
        self.action(self);
    }
}


@end


@implementation UIButton (QDExtension)



+ (instancetype)qd_buttonTextButtonWithFrame:(CGRect)frame
                                       title:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   titleFont:(CGFloat )font
                             backgroundColor:(UIColor *)backgroundColor
                                   tapAction:(TapButtonActionBlock)tapAction {
    
    QDButton *btn = [QDButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    btn.titleLabel.font = UIFontOfSize720(font);
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
    
}

+ (instancetype)qd_buttonImageButtonWithFrame:(CGRect)frame NormalBackgroundImageString:(NSString *)imageString tapAction:(TapButtonActionBlock)tapAction {
    
    QDButton *btn = [QDButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
    
}

+ (instancetype)qd_buttonImageButtonWithFrame:(CGRect)frame NormalImageString:(NSString *)imageString tapAction:(TapButtonActionBlock)tapAction {
    
    QDButton *btn = [QDButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
    
}

@end
