//
//  ShopHomePageHeaderView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopHomePageHeaderView.h"

@interface ShopHomePageHeaderView ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *detailLabel;

@end
@implementation ShopHomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    //140
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.detailLabel];
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(0 + 580*i, 74, 140, 1)];
        lineView.backgroundColor = UIColorFromAlphaRGB(0x838383, 0.4);
        [self addSubview:lineView];
    }
}
#pragma mark --- set
- (void)setSection:(NSInteger)section {
    _section = section;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"“惠”等你来"];
    NSDictionary * attris = @{NSKernAttributeName:@(25 * SizeScale)};
    switch (section) {
        case 1:
            //self.titleLabel.attributedText = [NSString addLineSpacingWithString:@"“惠”等你来" spacingSize:40];
            
            
            
            //[attributedString setAttributes:attris range:NSMakeRange(1,1)];
            [attributedString setAttributes:attris range:NSMakeRange(2,attributedString.length - 3)];
            self.titleLabel.attributedText = attributedString;
            //self.detailLabel.text = @"先行抢购,开始在即";
            self.detailLabel.attributedText = [NSString addLineSpacingWithString:@"先行抢购,开始在即" spacingSize:6];
            break;
        case 2:
            //self.titleLabel.text = @"任 性 购 车";
            self.titleLabel.attributedText = [NSString addLineSpacingWithString:@"任性购 车" spacingSize:35];
            //self.detailLabel.text = @"不看奖金,只看品质";
            self.detailLabel.attributedText = [NSString addLineSpacingWithString:@"不看奖金,只看品质" spacingSize:6];
            break;
        default:
            break;
    }
}
#pragma mark --- lazy laod
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(140, 60, 440, 36) title:@"热门商品" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
        _titleLabel.font = [UIFont boldSystemFontOfSize:36*SizeScale];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel qd_labelWithFrame:CGRectMake720(140, 106, 440, 25) title:@"热门商品" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
    }
    return _detailLabel;
}
@end
