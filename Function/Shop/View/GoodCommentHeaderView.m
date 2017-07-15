//
//  GoodCommentHeaderView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "GoodCommentHeaderView.h"
#import "CWStarRateView.h"
@interface GoodCommentHeaderView ()<CWStarRateViewDelegate>{
    NSMutableArray *_btnArrayM;
    
    UIButton *_tempBtn;
}

/** 好评率*/
@property (nonatomic,strong) UILabel *percentLabel;

/** 星星星*/
@property (strong, nonatomic) CWStarRateView *starRateView;

@end
@implementation GoodCommentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupCustomView {
    _btnArrayM = @[].mutableCopy;
    
    [self addSubview:self.leftImageView];
    
    [self addSubview:self.percentLabel];
    
    [self addSubview:self.starRateView];
    
    UILabel *percentTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(218, 110, 110, 24) title:@"好评率" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:percentTextLabel];
    
    for (int i = 0; i < 5; i++) {
        UIButton *allBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(144*i, 180, 144, 110) title:@"全部评价\n0" titleColor:kColorForfff titleFont:24 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            [self clickBtn:button];
        }];
        allBtn.tag = 800 + i;
        [allBtn setTitleColor:kColorForE60012 forState:UIControlStateSelected];
        allBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        allBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        allBtn.titleLabel.numberOfLines = 0;
        [self addSubview:allBtn];
        if (i == 0) {
            allBtn.selected = YES;
            _tempBtn = allBtn;
        }
        [_btnArrayM addObject:allBtn];
    }
    
}
- (void)clickBtn:(UIButton *)sender {
    if (_tempBtn == sender) {
        return;
    }
    
    _tempBtn.selected = NO;
    sender.selected = YES;
    _tempBtn = sender;
    
    self.clickBtnBlock(sender.tag-800);
}
#pragma mark --- set
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    if (!(titleArray.count == _btnArrayM.count) ) {
        return;
    }
    NSArray *textArray = @[@"全部评价",@"好评",@"中评",@"差评",@"晒图"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = _btnArrayM[i];
        [btn setTitle:[NSString stringWithFormat:@"%@\n%@",textArray[i],titleArray[i]] forState:UIControlStateNormal];
    }
}
- (void)setGoodRate:(NSString *)goodRate {
    _goodRate = goodRate;
    self.percentLabel.text = goodRate;
    
    //去除%
    NSString *tempStr = [goodRate substringWithRange:NSMakeRange(0, goodRate.length-1)];
    
    self.starRateView.scorePercent = [tempStr floatValue]/100;
}

#pragma mark --- lazy load
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(30, 52, 154, 94)];
        _leftImageView.image = [UIImage imageNamed:@"shop_medal_image"];
    }
    return _leftImageView;
}
- (UILabel *)percentLabel {
    if (!_percentLabel) {
        _percentLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 52, 130, 34) title:@"0%" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:42];
    }
    return _percentLabel;
}
- (CWStarRateView *)starRateView {
    if (!_starRateView) {
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake720(360, 86, 200, 34) numberOfStars:5];
        _starRateView.scorePercent = 1;
        _starRateView.allowIncompleteStar = NO;
        _starRateView.hasAnimation = YES;
        //_starRateView.delegate = self;
    }
    return _starRateView;
}
@end
