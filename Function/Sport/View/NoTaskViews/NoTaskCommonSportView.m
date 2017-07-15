//
//  NoTaskCommonSportView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NoTaskCommonSportView.h"

@interface NoTaskCommonSportView ()

@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) UILabel *durationLabel;

@property (nonatomic,strong) UILabel *speedLabel;

@end

@implementation NoTaskCommonSportView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    //速度
    UILabel *speedTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 282, 720, 34) title:@"时速km/h" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:34];
    [self addSubview:speedTextLabel];
    [self addSubview:self.speedLabel];
    
    //时间
    UILabel *durationTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 430, 360, 25) title:@"时间" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:durationTextLabel];
    [self addSubview:self.durationLabel];
    
    //里程
    UILabel *distanceTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 430, 360, 25) title:@"里程 km" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
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
#pragma mark --- lazy load
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 514, 360, 50) title:@"00.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _distanceLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 514, 360, 50) title:@"00:00:00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _durationLabel;
}
- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 96, 720, 125) title:@"00.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:140];
    }
    return _speedLabel;
}


@end
