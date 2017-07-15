//
//  PullupSportView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PullupSportView.h"

@interface PullupSportView ()
/** 卡路里*/
@property (nonatomic,strong) UILabel *calorieLabel;
/** 匀速*/
@property (nonatomic,strong) UILabel *averageSpeedLabel;
/** 海拔*/
@property (nonatomic,strong) UILabel *altitudeLabel;
/** 累计爬升*/
@property (nonatomic,strong) UILabel *upAltitudeLabel;

@end
@implementation PullupSportView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor blackColor];
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    NSArray *tempArray = @[@"卡路里 kCal",@"匀速 km/h",@"海拔 m",@"累计爬升 m"];
    
    for (int i = 0; i < tempArray.count; i++) {
        UILabel *loopLabel = [UILabel qd_labelWithFrame:CGRectMake720(i%2*360, 44 + i/2*158, 360, 23) title:tempArray[i] titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
        [self addSubview:loopLabel];
    }
    
    [self addSubview:self.calorieLabel];
    [self addSubview:self.averageSpeedLabel];
    [self addSubview:self.altitudeLabel];
    [self addSubview:self.upAltitudeLabel];
    
    UIButton *arrowBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(340, 404, 40, 14) NormalImageString:@"sport_pull_up_image" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickPullupBtn)]) {
            [self.delegate clickPullupBtn];
        }
    }];
    [arrowBtn setEnlargeEdge:40];
    [self addSubview:arrowBtn];
    
}

- (void)updateSportDataWithParame:(NSDictionary *)parame {
    
    double cal = [parame[@"kCal"] doubleValue];
    NSString *calStr = [NSString stringWithFormat:@"%.0f",cal];
    self.calorieLabel.text = calStr;
    
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%.2f",[parame[@"averageSpeed"] doubleValue]*3.6];
    self.altitudeLabel.text = [NSString stringWithFormat:@"%.1f",[parame[@"altitude"] doubleValue]];
    self.upAltitudeLabel.text   = [NSString stringWithFormat:@"%.1f",[parame[@"upAltitude"] doubleValue]];
}

#pragma mark --- lazy load
- (UILabel *)calorieLabel {
    if (!_calorieLabel) {
        _calorieLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 109, 360, 60) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _calorieLabel;
}
- (UILabel *)averageSpeedLabel {
    if (!_averageSpeedLabel) {
        _averageSpeedLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 109, 360, 60) title:@"0.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _averageSpeedLabel;
}
- (UILabel *)altitudeLabel {
    if (!_altitudeLabel) {
        _altitudeLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 267, 360, 60) title:@"0.0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _altitudeLabel;
}
- (UILabel *)upAltitudeLabel {
    if (!_upAltitudeLabel) {
        _upAltitudeLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 267, 360, 60) title:@"0.0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _upAltitudeLabel;
}
@end
