//
//  ProgressBarView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ProgressBarView.h"

@interface ProgressBarView ()

@property (nonatomic,strong) UIView *grayView;

@property (nonatomic,strong) UIView *redView;
/** 进度条上的小人*/
@property (nonatomic,strong) UIImageView *markImageView;

@end
@implementation ProgressBarView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.grayView];
    
    [self addSubview:self.redView];
    
    [self addSubview:self.markImageView];
    
}

#pragma mark --- set
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if(isnan(progress)){
        progress = 0;
    }
    self.redView.width = progress * self.width;
    
    self.markImageView.left = progress * self.width - 8*SizeScale;
    
    if (progress == 0) {
        self.markImageView.left = 0;
    }
    
    if (progress == 1) {
        self.markImageView.left = progress * self.width - 16*SizeScale;
    }
}
- (void)setIsTask:(BOOL)isTask {
    _isTask = isTask;
    if (isTask) {
        self.titleLabel.font = UIFontOfSize720(24);
        self.titleLabel.left = 48*SizeScale;
    }
    
}
#pragma mark --- lazy load
- (UIView *)grayView {
    if (!_grayView) {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake720(5, 58, 630, 12)];
        _grayView.width = self.width;
        _grayView.backgroundColor = UIColorFromAlphaRGB(0xffffff, 0.8);
    }
    return _grayView;
}
- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc]initWithFrame:CGRectMake720(5, 58, 630, 12)];
        _redView.width = 0;
        _redView.backgroundColor = kColorForE60012;
    }
    return _redView;
}
- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 43, 25, 42)];
        _markImageView.image = [UIImage imageNamed:@"sport_bar_mark_image"];
    }
    return _markImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 720, 43) title:@"今日骑行(km)" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:30];
    }
    return _titleLabel;
}
@end
