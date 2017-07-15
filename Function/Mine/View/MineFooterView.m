//
//  MineFooterView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/17.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "MineFooterView.h"

@implementation MineFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setupCustomView {
    
    UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 72, 720, 26) title:@"别人关注你买不买，我们更关注你骑不骑" titleColor:UIColorFromRGB_16(0x6b6b6b) textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:titleLabel];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(325, 120, 71, 44)];
    logoImageView.image = [UIImage imageNamed:@"mine_logo_image"];
    [self addSubview:logoImageView];
    
    //NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLabel = [UILabel qd_labelWithFrame:CGRectMake720(396, 140, 150, 20) title:appVersion titleColor:UIColorFromRGB_16(0x6b6b6b) textAlignment:NSTextAlignmentLeft font:24];
    [self addSubview:versionLabel];
    
}

@end
