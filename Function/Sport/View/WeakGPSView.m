//
//  WeakGPSView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "WeakGPSView.h"

@implementation WeakGPSView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"sport_no_gps_image"];
    [self addSubview:bgImageView];
    
    UIButton *continueBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(22, 610, 244, 70) title:@"继续骑行" titleColor:kColorForfff titleFont:30 backgroundColor:kColorFor999 tapAction:^(UIButton *button) {
        self.continueBlock();
    }];
    [self addSubview:continueBtn];
    
    UIButton *cancelBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(288, 610, 244, 70) title:@"取消" titleColor:kColorForfff titleFont:30 backgroundColor:kColorForE60012 tapAction:^(UIButton *button) {
        self.cancelBlock();
    }];
    [self addSubview:cancelBtn];
}

@end
