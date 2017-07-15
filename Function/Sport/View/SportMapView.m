//
//  SportMapView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/15.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportMapView.h"
#import "ProgressBarView.h"
@interface SportMapView ()

@property (nonatomic,strong) ProgressBarView *progressBarView;

@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) UILabel *durationLabel;

@property (nonatomic,strong) UILabel *speedLabel;

@end
@implementation SportMapView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 320)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8;
    [self addSubview:bgView];
    
    self.progressBarView.progress = 0.0;
    [bgView addSubview:self.progressBarView];
    
    NSArray *tempArray = @[@"时间",@"时速 km/h",@"里程 km"];
    for (int i = 0; i < tempArray.count; i++) {
        UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 198, 240, 22) title:tempArray[i] titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
        [bgView addSubview:titleLabel];
        
        switch (i) {
            case 0:
                titleLabel.frame = CGRectMake720(0, 198, 302, 22);
                break;
            case 1:
                titleLabel.frame = CGRectMake720(302, 198, 206, 22);
                break;
            case 2:
                titleLabel.frame = CGRectMake720(508, 198, 212, 22);
                break;
            default:
                break;
        }
        
    }
    [bgView addSubview:self.durationLabel];
    [bgView addSubview:self.speedLabel];
    [bgView addSubview:self.distanceLabel];
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
    //防崩溃
    if(isnan(progress)){
        progress = 0;
    }
    if (isinf(progress)) {
        progress = 0;
    }
    self.progressBarView.progress = progress;
}
#pragma mark --- lazy load
- (ProgressBarView *)progressBarView {
    if (!_progressBarView) {
        _progressBarView = [[ProgressBarView alloc]initWithFrame:CGRectMake720(40, 44, 640, 85)];
    }
    return _progressBarView;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 236, 302, 50) title:@"00:00:00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _durationLabel;
}
- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [UILabel qd_labelWithFrame:CGRectMake720(302, 236, 206, 50) title:@"0.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _speedLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(508, 236, 212, 50) title:@"0.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _distanceLabel;
}
@end
