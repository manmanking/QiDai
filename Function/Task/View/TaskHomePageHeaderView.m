//
//  TaskHomePageHeaderView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskHomePageHeaderView.h"
#import "ProgressBarView.h"
#import "OngoingModel.h"
#import "UIImageView+WebCache.h"
@interface TaskHomePageHeaderView ()
/** 活动图片*/
@property (nonatomic,strong) UIImageView *activityImageView;
/** 活动名字*/
@property (nonatomic,strong) UILabel *activityLabel;
/** 活动详情*/
@property (nonatomic,strong) UILabel *activityDetailLabel;
/** 奖金*/
@property (nonatomic,strong) UILabel *moneyLabel;
/** 今日骑行的里程*/
@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) ProgressBarView *progressBar;

/** 每日应该骑的距离*/
@property (nonatomic,strong) UILabel *targetLabel;
@end
@implementation TaskHomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupCustomView {
    [self addSubview:self.activityLabel];
    [self addSubview:self.activityDetailLabel];
    [self addSubview:self.activityImageView];
    
    UIButton *clearBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 0, 720, 190) NormalImageString:nil tapAction:^(UIButton *button) {
        self.clickBlock();
    }];
    [self addSubview:clearBtn];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(690, 98, 10, 20)];
    arrowImageView.image = [UIImage imageNamed:@"mine_right_arrow_image"];
    [self addSubview:arrowImageView];
    
    UILabel *moneyLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 190, 720, 28) title:@"累计奖金(元)" titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentCenter font:26];
    [self addSubview:moneyLabel];
    
    [self addSubview:self.moneyLabel];
    
    [self addSubview:self.distanceLabel];
    
    [self addSubview:self.progressBar];
    [self.progressBar addSubview:self.targetLabel];
}
- (void)setModel:(OngoingModel *)model {
    _model = model;
    self.activityLabel.text = model.name;
    self.activityDetailLabel.text = [NSString stringWithFormat:@"活动: %@",model.activityName];
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld",(long)model.refund];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f",[model.daySum floatValue]/1000];
    self.targetLabel.text = [NSString stringWithFormat:@"每日目标: %.1fkm",[model.distancePerDay floatValue]/1000 ];
    //#warning ---改动 --model.daySum -- model.sum
    CGFloat progress = [model.daySum floatValue]/[model.distancePerDay floatValue];
    
    if (progress >= 1) {
        progress = 1.0f;
    }
    if(isnan(progress)){
        progress = 0;
    }
    self.progressBar.progress = progress;
}
#pragma mark --- lazy load
- (ProgressBarView *)progressBar {
    if (!_progressBar) {
        _progressBar = [[ProgressBarView alloc]initWithFrame:CGRectMake720(0, 408, 720, 124)];
        _progressBar.isTask = YES;
        _progressBar.progress = 0.0;
    }
    return _progressBar;
}
- (UIImageView *)activityImageView {
    if (!_activityImageView) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(20, 46, 124, 124)];
        [_activityImageView setRoundedCorners:UIRectCornerAllCorners radius:_activityImageView.height/2];
    }
    return _activityImageView;
}
- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(190, 66, 300, 32) title:@"无正在参加的活动" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:32];
    }
    return _activityLabel;
}
- (UILabel *)activityDetailLabel {
    if (!_activityDetailLabel) {
        _activityDetailLabel = [UILabel qd_labelWithFrame:CGRectMake720(190, 118, 300, 22) title:@"活动: 无" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _activityDetailLabel;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 266, 300, 107) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:136];
    }
    return _moneyLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(48, 342, 150, 46) title:@"0" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:60];
    }
    return _distanceLabel;
}
- (UILabel *)targetLabel {
    if (!_targetLabel) {
        _targetLabel = [UILabel qd_labelWithFrame:CGRectMake720(340, 0, 320, 43) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentRight font:24];
    }
    return _targetLabel;
}
@end
