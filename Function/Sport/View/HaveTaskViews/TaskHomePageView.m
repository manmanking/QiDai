//
//  TaskHomePageView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskHomePageView.h"
#import "ProgressBarView.h"
#import "SportTaskModel.h"
@interface TaskHomePageView ()

/** 当日骑行公里数*/
@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) ProgressBarView *progressBarView;


@property (nonatomic,strong) UIButton *alertUploadInfoButton;

@property (nonatomic,strong) UILabel *activityLabel;

@property (nonatomic,strong) UILabel *activityDistanceLabel;

@end

@implementation TaskHomePageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"sport_homepage_bg_image"];
    [self addSubview:bgImageView];
    
    [self addSubview:self.distanceLabel];
    
    [self addSubview:self.progressBarView];
   [self addSubview:self.alertUploadInfoButton];
    self.alertUploadInfoButton.hidden = YES;
    
//    if (_existUploadData != YES) {
//        self.alertUploadInfoButton.hidden = YES;
//        
//    }
    

    UIButton *startBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(276, 796, 168, 168) NormalBackgroundImageString:@"sport_start_image" tapAction:^(UIButton *button) {
        self.clickStartBtnBlock();
    }];
    [self addSubview:startBtn];
    
    UIImageView *activityBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(50, 518, 620, 94)];
    activityBgImageView.image = [UIImage imageNamed:@"sport_round_bg_image"];
    [self addSubview:activityBgImageView];
    
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(53, 25, 78, 44)];
    iconImageView.image = [UIImage imageNamed:@"sport_activity_icon"];
    [activityBgImageView addSubview:iconImageView];
    [activityBgImageView addSubview:self.activityDistanceLabel];
    [activityBgImageView addSubview:self.activityLabel];
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressBarView.progress = progress;
}
- (void)setModel:(SportTaskModel *)model {
    _model = model;
    NSLog(@" model distanceDay %@",model.distanceDay);
    if (model.distanceDay) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",(float)([model.distanceDay floatValue]/1000) ];
    } else {
        self.distanceLabel.text = @"0";
    }
    self.activityLabel.text = model.information;
    self.activityDistanceLabel.text = [NSString stringWithFormat:@"%dkm",(int)([model.distancePerDay integerValue]/1000) ];
    CGFloat progress = [model.distanceDay doubleValue]/[model.distancePerDay doubleValue];
    if (progress >= 1.0) {
        progress = 1.0f;
    }
    
    if(!isnan(progress)){
        self.progress = progress;
    }
    
}


- (void)setExistUploadData:(BOOL)existUploadData
{
    if (existUploadData == YES) {
        // 添加提示未上传数据
        self.alertUploadInfoButton.hidden = !existUploadData;
    }else
    {
        self.alertUploadInfoButton.hidden = !existUploadData;
        
    }
    
}
#pragma mark --- lazy load
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 38, 720, 148) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:190];
    }
    return _distanceLabel;
}
- (ProgressBarView *)progressBarView {
    if (!_progressBarView) {
        _progressBarView = [[ProgressBarView alloc]initWithFrame:CGRectMake720(40, 270, 640, 85)];
    }
    return _progressBarView;
}

//添加提醒信息
- (UIButton *)alertUploadInfoButton
{
    if (!_alertUploadInfoButton) {
        _alertUploadInfoButton = [[UIButton alloc]initWithFrame:CGRectMake720(457, 270 +85 +40 , 243, 32)];
        [_alertUploadInfoButton setImage:[UIImage imageNamed:@"alertRed"] forState:UIControlStateNormal];
        [_alertUploadInfoButton setTitle:@"有未上传骑行报告" forState:UIControlStateNormal];
        _alertUploadInfoButton.userInteractionEnabled = NO;
        _alertUploadInfoButton.titleLabel.font = UIFontOfSize720(24);
        [_alertUploadInfoButton setTitleColor:kColorForfff forState:UIControlStateNormal];
        
    }
    return _alertUploadInfoButton;
 
}

- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(140, 32, 340, 30) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
    }
    return _activityLabel;
}
- (UILabel *)activityDistanceLabel {
    if (!_activityDistanceLabel) {
        _activityDistanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(460, 22, 140, 50) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentRight font:30];
    }
    return _activityDistanceLabel;
}
@end
