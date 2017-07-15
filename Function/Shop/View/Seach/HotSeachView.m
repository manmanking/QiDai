//
//  HotSeachView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/4.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HotSeachView.h"

@implementation HotSeachView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UILabel *historyLabel = [UILabel qd_labelWithFrame:CGRectMake720(36, 92, 200, 24) title:@"热门搜索" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:24];
    [self addSubview:historyLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(36, 136, 648, 1)];
    lineView.backgroundColor = UIColorFromAlphaRGB(0x838383, 0.4);

    
    [self addSubview:lineView];
}
- (void)setupViewWithArray:(NSArray *)array {
    for (int i = 0; i < array.count; i++) {
        if (i >= 6) {
            return;
        }
        UIButton *btn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(36 + (i%3)*233,136 + 56 + (i/3)*104, 182, 56) title:array[i] titleColor:kColorForccc titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            self.clickHotSeachBtnBlock(button.titleLabel.text);
        }];
        btn.layer.cornerRadius = 4*SizeScaleSubjectTo720;
        btn.layer.borderWidth = 1*SizeScale;
        btn.layer.borderColor = UIColorFromRGB_16(0x666666).CGColor;
        [self addSubview:btn];
    }
}
@end
