//
//  NoTaskHomePageView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NoTaskHomePageView.h"
#import "QDLineView.h"
@implementation NoTaskHomePageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UILabel *speedUnitLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 136, 720, 36) title:@"时速km/h" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:36];
    [self addSubview:speedUnitLabel];
    
    UILabel *speedLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 230, 720, 150) title:@"00.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:150];
    [self addSubview:speedLabel];
    
    UILabel *timeUnitLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 504, 360, 30) title:@"时间" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:30];
    [self addSubview:timeUnitLabel];
    UILabel *distanceUnitLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 504, 360, 30) title:@"里程 km" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:30];
    [self addSubview:distanceUnitLabel];
    
    UILabel *timeLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 588, 360, 55) title:@"00:00:00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    [self addSubview:timeLabel];
    
    UILabel *distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 588, 360, 55) title:@"00.00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    [self addSubview:distanceLabel];
    
    QDLineView *lineView = [[QDLineView alloc]initWithFrame:CGRectMake720(360, 504, 1, 132)];
    [self addSubview:lineView];
    
    UIButton *startBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(276, 782, 168, 168) NormalBackgroundImageString:@"sport_start_image" tapAction:^(UIButton *button) {
        self.clickStartBtnBlock();
    }];
    [self addSubview:startBtn];
}

@end
