//
//  CommonSportView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/2.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "CommonSportView.h"
#import "ProgressBarView.h"
@interface CommonSportView ()
/** 距离的label*/
@property (nonatomic,strong) UILabel *distanceLabel;
/** 时长的label*/
@property (nonatomic,strong) UILabel *durationLabel;
/** 速度的label*/
@property (nonatomic,strong) UILabel *speedLabel;
/** 进度条*/
@property (nonatomic,strong) ProgressBarView *progressBarView;

@end

@implementation CommonSportView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor blackColor];
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    
    [self addSubview:self.progressBarView];
 
    
    
    //速度
    UILabel *speedTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 243 + 162, 720, 30) title:@"时速km/h" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:30];
    [self addSubview:speedTextLabel];
    [self addSubview:self.speedLabel];
    
    //时间
    UILabel *durationTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 353 + 162, 360, 25) title:@"时间" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:durationTextLabel];
    [self addSubview:self.durationLabel];
    
    //里程
    UILabel *distanceTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 353 + 162, 360, 25) title:@"里程 km" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:distanceTextLabel];
    [self addSubview:self.distanceLabel];
}
#pragma mark --- set
- (void)setSpeed:(NSString *)speed {
    _speed = speed;
    self.speedLabel.text = speed;
}
- (void)setDuration:(NSString *)duration {
    _duration = duration;
    self.durationLabel.text = duration;
}
- (void)setDistance:(NSString *)distance {
    _distance = distance;
    self.distanceLabel.text = distance;
}
- (void)setTotalDistance:(NSString *)totalDistance {
    _totalDistance = totalDistance;
    NSString *title = [NSString stringWithFormat:@"今日骑行%@km",totalDistance];
    self.progressBarView.titleLabel.attributedText = [NSString changFontWithString:title defaultFont:30*SizeScale specifyFont:60*SizeScale specifyRang:NSMakeRange(4, totalDistance.length)];
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if(isnan(progress)){
        progress = 0;
    }
    if (isinf(progress)) {
        progress = 0;
    }
    self.progressBarView.progress = progress;
}
#pragma mark --- lazy load
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 418 + 162, 360, 50) title:@"0.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _distanceLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 418 + 162, 360, 50) title:@"00:00:00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _durationLabel;
}
- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 116 + 162, 720, 93) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:120];
    }
    return _speedLabel;
}
- (ProgressBarView *)progressBarView {
    if (!_progressBarView) {
        _progressBarView = [[ProgressBarView alloc]initWithFrame:CGRectMake720(40, 44, 640, 85)];
    }
    return _progressBarView;
}

@end
