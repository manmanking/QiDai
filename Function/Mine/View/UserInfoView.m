//
//  UserInfoView.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "UserInfoView.h"
#import "UserInfoModel.h"
#import "UIButton+WebCache.h"
@interface UserInfoView ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIButton *headPortraitButton;

@property (nonatomic,strong) UIImageView *genderImageView;



@end
@implementation UserInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 588)];
    self.bgImageView.image = [UIImage imageNamed:@"mine_userInfo_bg"];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.bgImageView];
    
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.headPortraitButton];
    
    [self addSubview:self.genderImageView];
    
    [self addSubview:self.distanceLabel];
    
    [self addSubview:self.durationLabel];
    
    UILabel *distanceTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(10, 518, 340, 22) title:@"总里程(km)" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
    [self addSubview:distanceTextLabel];
    
    UILabel *durationTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(370, 518, 340, 22) title:@"总时长" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
    [self addSubview:durationTextLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(362, 468, 1, 70)];
    lineView.backgroundColor = kColorFor999;
    [self addSubview:lineView];
}
#pragma mark --- set
- (void)setUserInfoModel:(UserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    self.nameLabel.text = userInfoModel.nickName;
    
    [self.headPortraitButton sd_setImageWithURL:[NSURL URLWithString:userInfoModel.foreImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_default_icon_image"]];
    
    if ([userInfoModel.gender integerValue] == 0) {
        self.genderImageView.image = [UIImage imageNamed:@"mine_userInfo_boy"];
    }else {
        self.genderImageView.image = [UIImage imageNamed:@"mine_userInfo_girl"];
    }
}

#pragma mark --- lazy load
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 40, 720, 88) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    }
    return _nameLabel;
}

- (UIButton *)headPortraitButton {
    if (!_headPortraitButton) {
        _headPortraitButton = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 172, 240, 240) NormalBackgroundImageString:@"head_portrait_btn" tapAction:^(UIButton *button) {
            //[self.delegate clickHeadPortraitButton];
            self.clickIconBlock();
        }];
        [_headPortraitButton setImage:[UIImage imageNamed:@"mine_default_icon_image"] forState:UIControlStateNormal];
        [_headPortraitButton setRoundedCorners:UIRectCornerAllCorners radius:182/2*SizeScaleSubjectTo720];
        _headPortraitButton.centerX = self.centerX;
    }
    return _headPortraitButton;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(428, 360, 52, 52)];
        _genderImageView.image = [UIImage imageNamed:@"mine_userInfo_boy"];
    }
    return _genderImageView;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(10, 468, 340, 30) title:@"0" titleColor:UIColorFromRGB_16(0xffffff) textAlignment:NSTextAlignmentCenter font:36];
    }
    return _distanceLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(370, 468, 340, 30) title:@"00:00:00" titleColor:UIColorFromRGB_16(0xffffff) textAlignment:NSTextAlignmentCenter font:36];
    }
    return _durationLabel;
}
@end
