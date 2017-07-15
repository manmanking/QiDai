//
//  ShopHomePageFirstReusableView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/4.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopHomePageFirstReusableView.h"

@interface ShopHomePageFirstReusableView ()<SDCycleScrollViewDelegate>

/** 标题*/
@property (nonatomic,strong) UILabel *titleLabel;
/** 详情*/
@property (nonatomic,strong) UILabel *detailLabel;

@end
@implementation ShopHomePageFirstReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.detailLabel];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake720(0, 0, 720, 470) delegate:self placeholderImage:[UIImage imageNamed:@"shop_ad_default_image"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"shop_page_control_white"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"shop_page_control_gary"];
    self.cycleScrollView.autoScrollTimeInterval = 4.0;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [self addSubview:self.cycleScrollView];
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(0 + 580*i, 74 + 470, 140, 2)];
        lineView.backgroundColor = UIColorFromAlphaRGB(0x838383, 0.4);
        [self addSubview:lineView];
    }

}
#pragma mark --- SDCycleScrollViewDelegate 点击轮播图片回调
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    self.clickCycleViewBlock(index);
    //NSLog(@"%ld",index);
}
#pragma mark --- lazy laod
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(140, 60 + 470, 440, 36) title:@"热 门 商 品" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
        _titleLabel.font = [UIFont boldSystemFontOfSize:36*SizeScale];
        _titleLabel.attributedText = [NSString addLineSpacingWithString:@"热门商品" spacingSize:35];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel qd_labelWithFrame:CGRectMake720(140, 106 + 470, 440, 25) title:@"最新潮流时尚show" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
        _detailLabel.attributedText = [NSString addLineSpacingWithString:@"最新潮流时尚show" spacingSize:6];
    }
    return _detailLabel;
}
@end
