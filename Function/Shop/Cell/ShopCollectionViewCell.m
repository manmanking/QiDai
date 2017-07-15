//
//  ShopCollectionViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopCollectionViewCell.h"
#import "ShopHomePageModel.h"
#import "UIImageView+WebCache.h"
#import "ShopHomePageModel.h"
@interface ShopCollectionViewCell ()

@property (nonatomic,strong) UIImageView *bikeImageView;

/** 现价*/
@property (nonatomic,strong) UILabel *priceLabel;

/** 原价，这个参数可能没有*/
@property (nonatomic,strong) UILabel *originalPrice;

/** 车辆详情*/
@property (nonatomic,strong) UILabel *detailLabel;

@end
@implementation ShopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupCustomView {
    [self addSubview:self.bikeImageView];
    
    self.bikeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView)];
    [self.bikeImageView addGestureRecognizer:tapGR];
    
    [self addSubview:self.priceLabel];
    
    [self addSubview:self.originalPrice];
    
    [self addSubview:self.detailLabel];
    
    //立即购买
    UIButton *buyBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(30, 446 + 10
                                                                            , 272, 60) title:@"抢先购" titleColor:kColorForfff titleFont:26 backgroundColor:kColorForE60012 tapAction:^(UIButton *button) {
        self.clickBuyBtnBlock(self.model.id);
    }];
    [buyBtn setRoundedCorners:UIRectCornerAllCorners radius:8*SizeScaleSubjectTo720];
    [self addSubview:buyBtn];
}
/**  添加一个横线
 @param str 需要修改的str
 */
- (NSMutableAttributedString *)addHorizontalLineWithString:(NSString *)str {
    NSUInteger length = [str length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB_16(0xcccccc) range:NSMakeRange(0, length)];
    return attri;
}

- (void)clickImageView {
    self.clickBuyBtnBlock(self.model.id);
}

#pragma mark --- set
- (void)setModel:(ShopHomePageModel *)model {
    _model = model;

    [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]] placeholderImage:[UIImage imageNamed:@"goods_default_image"]];

    CGFloat price = [model.price floatValue] - [model.refund floatValue];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.0f",price];
    
    [self.originalPrice setAttributedText:[self addHorizontalLineWithString:[NSString stringWithFormat:@"￥%@",model.price]] ];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.brand,model.series,model.model];;
}
- (void)setNoActivity:(BOOL)noActivity {
    _noActivity = noActivity;
    if (noActivity) {
        self.originalPrice.hidden = YES;
        self.priceLabel.centerX = 320/2*SizeScale;
    } else {
        self.originalPrice.hidden = NO;
        self.priceLabel.left = 0;
    }
}
#pragma mark --- lazy load
- (UIImageView *)bikeImageView {
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 332, 320)];
    }
    return _bikeImageView;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 346 + 10, 200, 34) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
        _priceLabel.font = [UIFont fontWithName:@"Lantinghei SC Extralight" size:34*SizeScale];
    }
    return _priceLabel;
}
- (UILabel *)originalPrice {
    if (!_originalPrice) {
        _originalPrice = [UILabel qd_labelWithFrame:CGRectMake720(200, 346 + 10, 120, 34) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
        //_originalPrice = [UILabel qd_labelWithFrame:CGRectMake720(200, 346, 120, 34) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:34];
    }
    return _originalPrice;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 400 - 4 + 10, 332, 28) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:24];
    }
    return _detailLabel;
}
@end
