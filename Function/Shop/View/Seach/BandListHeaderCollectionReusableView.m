//
//  BandListHeaderCollectionReusableView.m
//  QiDai
//
//  Created by manman'swork on 16/9/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "BandListHeaderCollectionReusableView.h"
#import "UIImageView+WebCache.h"

@interface BandListHeaderCollectionReusableView()

@property (nonatomic,strong) UIImageView *brandImageView;


@property (nonatomic,strong) UILabel *brandLabel;

@end

@implementation BandListHeaderCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        
        [self setupUIViewLayout];
        
    }
    return self;
    
    
}


- (void)setupUIViewLayout
{
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 468)];
    bgImageView.image = [UIImage imageNamed:@"brand_list_bg_image"];
    [self addSubview:bgImageView];
    [bgImageView addSubview:self.brandImageView];
    [bgImageView addSubview:self.brandLabel];
    
    
}

- (void)setBrandTitle:(NSString *)brandTitleStr AndBrandImageURL:(NSURL *)brandImageURL
{
    self.brandLabel.text = brandTitleStr;
    [self.brandImageView sd_setImageWithURL:brandImageURL];
    
}


- (UIImageView *)brandImageView {
    if (!_brandImageView) {
        _brandImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(295, 170, 130, 130)];
        [_brandImageView setRoundedCorners:UIRectCornerAllCorners radius:(65*SizeScaleSubjectTo720)];
    }
    return _brandImageView;
}
- (UILabel *)brandLabel {
    if (!_brandLabel) {
        _brandLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 342, 720, 30) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
    }
    return _brandLabel;
}

@end
