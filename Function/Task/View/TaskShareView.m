//
//  TaskShareView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskShareView.h"
#import "TaskShareModel.h"
#import "UIImageView+WebCache.h"
#import "UserInfoModel.h"
#import "UserInfoDBManager.h"
@interface TaskShareView ()
/** 头像*/
@property (nonatomic,strong) UIImageView *portraitsImageView;
/** 名字*/
@property (nonatomic,strong) UILabel *nameLabel;
//--- 左上角的logo
@property (nonatomic,strong) UIImageView *bikeIconImageView;
/** 车的大图*/
@property (nonatomic,strong) UIImageView *bikeImageView;
/** 车的名字 比如:Tern link N8*/
@property (nonatomic,strong) UILabel *bikeLabel;
/** 零售价*/
@property (nonatomic,strong) UILabel *priceLabel;
/** 购买地*/
@property (nonatomic,strong) UILabel *addressLabel;
/** 特 点*/
@property (nonatomic,strong) UILabel *characterLabel;
/** 底部的二维码*/
@property (nonatomic,strong) UIImageView *bottomCodeImageView;

@end
@implementation TaskShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = UIColorFromRGB_16(0x1e0306);
    }
    return self;
}
- (void)setupCustomView {
    UILabel *topLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 78, 720, 34) title:@"我的装备" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self addSubview:topLabel];
    
    [self addSubview:self.portraitsImageView];
    
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.bikeIconImageView];
    [self addSubview:self.bikeImageView];
    
    [self addSubview:self.bikeLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.addressLabel];
    
    UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:kUserId];
    if ([userInfo.foreImg isExist]) {
        if ([userInfo.foreImg hasPrefix:@"http"]) {
            [self.portraitsImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.foreImg] placeholderImage:[UIImage imageNamed:@"head_portrait_btn"]];
        } else {
            self.portraitsImageView.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:userInfo.foreImg]];
        }
    } else {
        self.portraitsImageView.image = [UIImage imageNamed:@"head_portrait_btn"];
    }
    self.nameLabel.text = userInfo.nickName;
    
    self.bottomCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 906 + 61, 720, 160)];
    self.bottomCodeImageView.image = [UIImage imageNamed:@"share_code_image"];
    self.bottomCodeImageView.top = self.characterLabel.bottom + 100*SizeScale;
    [self addSubview:self.bottomCodeImageView];
}
- (void)setShareModel:(TaskShareModel *)shareModel {
    _shareModel = shareModel;
    
    self.bikeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:shareModel.bikeImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _bikeIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bikeIconImageView sd_setImageWithURL:[NSURL URLWithString:shareModel.logo]];
    //_brandLabel.text = [NSString stringWithFormat:@"%@ %@ %@",shareModel.brand,shareModel.series,shareModel.model];
    
    self.bikeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",shareModel.brand,shareModel.series,shareModel.model];
    self.priceLabel.text = [NSString stringWithFormat:@"零售价:￥%@",shareModel.price];
    
    NSString *addressStr = [NSString stringWithFormat:@"购买地:%@",shareModel.name];
    self.addressLabel.text = addressStr;
}
#pragma mark --- lazy load
- (UIImageView *)portraitsImageView {
    if (!_portraitsImageView) {
        _portraitsImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(249, 184, 222, 222)];
        [_portraitsImageView setRoundedCorners:UIRectCornerAllCorners radius:111*SizeScale];
    }
    return _portraitsImageView;
}
- (UIImageView *)bikeIconImageView {
    if (!_bikeIconImageView) {
        _bikeIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(50, 454, 124, 90)];
        //_bikeIconImageView.backgroundColor = [UIColor whiteColor];
    }
    return _bikeIconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel qd_labelWithFrame:CGRectMake720(505, 318, 200, 22) title:@"name" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:22];
    }
    return _nameLabel;
}
- (UIImageView *)bikeImageView {
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(355, 390, 350, 308)];
    }
    return _bikeImageView;
}
- (UILabel *)bikeLabel {
    if (!_bikeLabel) {
        _bikeLabel = [UILabel qd_labelWithFrame:CGRectMake720(50, 654, 450, 28) title:@"tern link n8" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:36];
    }
    return _bikeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel qd_labelWithFrame:CGRectMake720(50, 730, 346, 26) title:@"零售价：" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:30];
    }
    return _priceLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel qd_labelWithFrame:CGRectMake720(50 , 782, 650, 26) title:@"购买地：" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    }
    return _addressLabel;
}
- (UILabel *)characterLabel {
    if (!_characterLabel) {
        _characterLabel = [UILabel qd_labelWithFrame:CGRectMake720(50, 834, 650, 26) title:@"特点：" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    }
    return _characterLabel;
}

@end
