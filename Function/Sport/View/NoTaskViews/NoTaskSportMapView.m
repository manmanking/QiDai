//
//  NoTaskSportMapView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NoTaskSportMapView.h"

@interface NoTaskSportMapView ()
@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) UILabel *durationLabel;

@property (nonatomic,strong) UILabel *speedLabel;
@end
@implementation NoTaskSportMapView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8;
    [self addSubview:bgView];
    
    NSArray *tempArray = @[@"时间",@"时速 km/h",@"里程 km"];
    for (int i = 0; i < tempArray.count; i++) {
        UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 52, 240, 26) title:tempArray[i] titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:26];
        [bgView addSubview:titleLabel];
        
        switch (i) {
            case 0:
                titleLabel.frame = CGRectMake720(0, 52, 302, 26);
                break;
            case 1:
                titleLabel.frame = CGRectMake720(302, 52, 206, 26);
                break;
            case 2:
                titleLabel.frame = CGRectMake720(508, 52, 212, 26);
                break;
            default:
                break;
        }
        
    }
    [bgView addSubview:self.durationLabel];
    [bgView addSubview:self.speedLabel];
    [bgView addSubview:self.distanceLabel];
}
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
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 112, 302, 50) title:@"00:00:00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _durationLabel;
}
- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [UILabel qd_labelWithFrame:CGRectMake720(302, 112, 206, 50) title:@"0.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _speedLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(508, 112, 212, 50) title:@"0.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _distanceLabel;
}
@end
