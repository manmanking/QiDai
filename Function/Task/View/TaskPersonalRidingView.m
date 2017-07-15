//
//  TaskPersonalRidingView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskPersonalRidingView.h"
#import "TaskDetailModel.h"
@interface TaskPersonalRidingView ()
/** 奖金*/
@property (nonatomic,strong) UILabel *bonusLabel;

/** 今日完成50%*/
@property (nonatomic,strong) UILabel *percentLabel;
/** 每日目标*/
@property (nonatomic,strong) UILabel *targetLabel;

/** 白条  --进度条的组成之一*/
@property (nonatomic,strong) UIView *whiteBar;
/** 进度条上的小人 --进度条的组成之一*/
@property (nonatomic,strong) UIImageView *markImageView;
/** 排名*/
@property (nonatomic,strong) UILabel *rankingLabel;
/** 每日目标*/
@property (nonatomic,strong) UILabel *distanceLabel;

@end
@implementation TaskPersonalRidingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 658)];//580
    bgImageView.image = [UIImage imageNamed:@"task_riding_bg_image"];
    [self addSubview:bgImageView];
    
    [self addSubview:self.bonusLabel];
    
    [self addSubview:self.percentLabel];
    
    [self addSubview:self.targetLabel];
    
    UIView *translucentView = [[UIView alloc]initWithFrame:CGRectMake720(0, 488, 720, 170)];
    translucentView.alpha = 0.29;
    translucentView.backgroundColor = UIColorFromRGB_16(0x000000);
    [self addSubview:translucentView];
    [translucentView addSubview:self.rankingLabel];
    [translucentView addSubview:self.distanceLabel];
    
    for (int i = 0; i <= 1; i++) {
        UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(145 + 360*i, 103, 100, 32) title:@"今日排名" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:22];
        [translucentView addSubview:textLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake720(110 + 360*i, 103 , 32, 32)];
        imageView.image = [UIImage imageNamed:@"task_ranking_icon"];
        [translucentView addSubview:imageView];
        
        if (i == 1) {
            textLabel.text = @"今日骑行";
            imageView.frame = CGRectMake720(110 + 360*i, 103, 34, 30);
            imageView.image = [UIImage imageNamed:@"task_riding_icon"];
        }
    }
    
    [self addSubview:self.whiteBar];
    
    [self addSubview:self.markImageView];
    
    UILabel *rankTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 658, 720, 72) title:@"今日排名榜" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
    rankTextLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:rankTextLabel];
}
#pragma mark --- set
- (void)setModel:(TaskDetailModel *)model {
    _model = model;
    NSString *refundStr = [NSString stringWithFormat:@"￥%.0f",[model.nowDayMoney floatValue] ];
    self.bonusLabel.attributedText = [NSString changFontWithString:refundStr defaultFont:(180*SizeScale) specifyFont:(88*SizeScale) specifyRang:NSMakeRange(0, 1) ];
    
    self.targetLabel.text = [NSString stringWithFormat:@"每日目标: %.1fkm",[model.todayTarget floatValue]/1000 ];
    self.rankingLabel.text = model.rank;

    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f",[model.todayDistance floatValue]/1000];
    
    //CGFloat progress = [model.todayComplete floatValue];
    CGFloat progress = [model.todayDistance floatValue]/[model.todayTarget floatValue];
    if(isnan(progress)){
        progress = 0.0f;
    }
    if (progress > 1.0f) {
        progress = 1.0f;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.whiteBar.width = 720*SizeScale*progress;
        
        if (progress == 0) {
            self.markImageView.left = 0;
        } else if (progress == 1) {
            self.markImageView.left = progress * self.width - 26*SizeScale;
        } else {
            self.markImageView.left = 720*SizeScale*progress - 2;
        }
    }];
    self.percentLabel.text = [NSString stringWithFormat:@"今日完成%.0f%%",progress*100 ];

}
#pragma mark --- lazy load
- (UILabel *)bonusLabel {
    if (!_bonusLabel) {
        _bonusLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 194, 720, 142) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:180];
    }
    return _bonusLabel;
}
- (UILabel *)percentLabel {
    if (!_percentLabel) {
        _percentLabel = [UILabel qd_labelWithFrame:CGRectMake720(40, 422, 250, 24) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:24];
    }
    return _percentLabel;
}
- (UILabel *)targetLabel {
    if (!_targetLabel) {
        _targetLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 422, 310, 24) title:@"每日目标: 0km" titleColor:kColorForfff textAlignment:NSTextAlignmentRight font:24];
    }
    return _targetLabel;
}

- (UIView *)whiteBar {
    if (!_whiteBar) {
        _whiteBar = [[UIView alloc]initWithFrame:CGRectMake720(0, 482, 0, 6)];
        //_whiteBar.width = 120;
        _whiteBar.backgroundColor = kColorForfff;
    }
    return _whiteBar;
}
- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 467, 25, 42)];
        _markImageView.image = [UIImage imageNamed:@"sport_bar_mark_image"];
    }
    return _markImageView;
}
- (UILabel *)rankingLabel {
    if (!_rankingLabel) {
        _rankingLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 40, 360, 38) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:48];
    }
    return _rankingLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 40, 360, 38) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:48];
    }
    return _distanceLabel;
}
@end
