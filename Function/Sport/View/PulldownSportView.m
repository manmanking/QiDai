//
//  PulldownSportView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/2.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PulldownSportView.h"
#import "UIButton+AcceptEvent.h"
@interface PulldownSportView ()

@end
@implementation PulldownSportView
{
    /** 是否参加活动*/
    BOOL _isHaveTask;
}
- (instancetype)initWithFrame:(CGRect)frame isHaveTask:(BOOL)isHaveTask {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor blackColor];
        _isHaveTask = isHaveTask;
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    UIButton *arrowBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(340, 46, 40, 14) NormalImageString:@"sport_pull_down_image" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickPulldownBtn)]) {
            [self.delegate clickPulldownBtn];
        }
    }];
    [arrowBtn setEnlargeEdge:40];
    [self addSubview:arrowBtn];
    
    UIButton *sportEndBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(40, 168, 144, 144) NormalBackgroundImageString:@"sport_end_image" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSportEndBtn)]) {
            [self.delegate clickSportEndBtn];
        }
    }];
    [self addSubview:sportEndBtn];
    
    self.sportPauseBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(276, 162, 168, 168) NormalBackgroundImageString:@"sport_pause_image" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSportPauseBtn:)]) {
            [self.delegate clickSportPauseBtn:button];
        }
    }];
    self.sportPauseBtn.qd_acceptEventInterval = 1.0f;
    [self.sportPauseBtn setBackgroundImage:[UIImage imageNamed:@"sport_go_on_image"] forState:UIControlStateSelected];
    [self addSubview:self.sportPauseBtn];
    
    UIButton *mapBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(536, 168, 144, 144) NormalBackgroundImageString:@"sport_map_image" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickShowMapBtn)]) {
            [self.delegate clickShowMapBtn];
        }
    }];
    [self addSubview:mapBtn];
}

@end
