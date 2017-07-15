//
//  ShopHomePageFooterView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopHomePageFooterView.h"

@implementation ShopHomePageFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UIButton *btn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(20, 0, 680, 110) NormalBackgroundImageString:@"shop_more_bike_btn" tapAction:^(UIButton *button) {
        self.clickMoreBtnBlock();
    }];
    [self addSubview:btn];
}
@end
