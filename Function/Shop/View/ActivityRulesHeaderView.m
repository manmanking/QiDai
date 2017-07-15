//
//  ActivityRulesHeaderView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ActivityRulesHeaderView.h"
#import "ActivityModel.h"
#import "RuleJoinModel.h"
#import "UIImageView+WebCache.h"
@interface ActivityRulesHeaderView ()
/** 人数*/
@property (nonatomic,strong) UILabel *quantityLabel;
/** 活动详情*/
@property (nonatomic,strong) UILabel *activityLabel;
/** 返现*/
@property (nonatomic,strong) UILabel *refundLabel;
/** 规则*/
@property (nonatomic,strong) UILabel *rulesLabel;
/** 剩余时间*/
@property (nonatomic,strong) UILabel *restLabel;
/** 活动的日期*/
@property (nonatomic,strong) UILabel *dateLabel;
/** 已报人数*/
@property (nonatomic,strong) UILabel *countLabel;

@end
@implementation ActivityRulesHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupCustomView {
    
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 340)];
    topImageView.image = [UIImage imageNamed:@"shop_activity_bg2"];
    [self addSubview:topImageView];
    
    UILabel *dateTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(208, 290, 110, 50) title:@"距活动结束" titleColor:kColorFor999 textAlignment:NSTextAlignmentRight font:22];
    [self addSubview:dateTextLabel];
    
    [self addSubview:self.restLabel];
    
    [self addSubview:self.activityLabel];
    
    UIImageView *bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(48, 62 + 340, 61, 72)];
    bikeImageView.image = [UIImage imageNamed:@"rule_cycle_image"];
    [self addSubview:bikeImageView];
    
    UILabel *dateTextLabel1 = [UILabel qd_labelWithFrame:CGRectMake720(160, 340 + 132, 120, 23) title:@"活动时间" titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentLeft font:24];
    [self addSubview:dateTextLabel1];
    
    [self addSubview:self.dateLabel];
    
    UIImageView *bonusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(34, 610, 248, 146)];
    bonusImageView.image = [UIImage imageNamed:@"good_bonus_frame_p"];
    [self addSubview:bonusImageView];
    [bonusImageView addSubview:self.refundLabel];
    
    UILabel *ruleTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(320, 560, 370, 24) title:@"活动规则" titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:ruleTextLabel];
    
    [self addSubview:self.rulesLabel];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 20)];
    grayView.backgroundColor = UIColorFromRGB_10(19, 19, 19);
    grayView.top = bonusImageView.top + 218*SizeScale;
    [self addSubview:grayView];
}
#pragma mark --- set
- (void)setActivityModel:(ActivityModel *)activityModel {
    _activityModel = activityModel;
    
    NSString *beginTime =  [activityModel.beginTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime =  [activityModel.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",beginTime,endTime];
    self.restLabel.text = [NSString stringWithFormat:@"%@天",activityModel.countdown];
    if ([activityModel.countdown isEqualToString:@"过期"]) {
        self.restLabel.text = activityModel.countdown;
    }
    self.activityLabel.text = activityModel.information;
    self.rulesLabel.text = activityModel.detail;
    NSString *refund = [NSString stringWithFormat:@"￥%@",activityModel.refund];
    self.refundLabel.attributedText = [NSString changFontWithString:refund defaultFont:60*SizeScale specifyFont:36*SizeScale specifyRang:NSMakeRange(0, 1)];
}
- (void)setPersonImageViewWithArray:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    //852
    UIImageView *joinImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(40, 872, 42, 91)];
    joinImageView.image = [UIImage imageNamed:@"rule_join_image"];
    [self addSubview:joinImageView];
    
    [self addSubview:self.quantityLabel];
    for (int i = 0; i < array.count; i++) {
        RuleJoinModel *model = array[i];
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(128 + (i%5)*122, 978 + (i/5)*146, 74, 74)];
        [iconImageView setRoundedCorners:UIRectCornerAllCorners radius:37*SizeScale];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.foreImg] placeholderImage:[UIImage imageNamed:@"head_portrait_btn"] ];
        [self addSubview:iconImageView];
        
        UILabel *nameLabel = [UILabel qd_labelWithFrame:CGRectMake720(118 + (i%5)*122, 1070 + (i/5)*146, 94, 18) title:@"" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:20];
        nameLabel.text = [NSString stringWithFormat:@"%.0fkm",[model.distance floatValue]/1000];
        [self addSubview:nameLabel];
    }
    self.quantityLabel.text = [NSString stringWithFormat:@"已报人数(%lu人)",(unsigned long)array.count];
}

#pragma mark --- lazy load
- (UILabel *)quantityLabel {
    if (!_quantityLabel) {
        _quantityLabel = [UILabel qd_labelWithFrame:CGRectMake720(120, 919, 280, 20) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    }
    return _quantityLabel;
}
- (UILabel *)restLabel {
    if (!_restLabel) {
        _restLabel = [UILabel qd_labelWithFrame:CGRectMake720(348, 290, 200, 50) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _restLabel;
}
- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(160, 412, 540, 30) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:30];
    }
    return _activityLabel;
}
- (UILabel *)refundLabel {
    if (!_refundLabel) {
        _refundLabel = [UILabel qd_labelWithFrame:CGRectMake720(4, 28, 240, 48) title:@"￥0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:60];
    }
    return _refundLabel;
}
- (UILabel *)rulesLabel {
    if (!_rulesLabel) {
        _rulesLabel = [UILabel qd_labelWithFrame:CGRectMake720(320, 610, 370, 160) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
        _rulesLabel.numberOfLines = 0;
    }
    return _rulesLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel qd_labelWithFrame:CGRectMake720(280, 340+132, 400, 23) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _dateLabel;
}
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel qd_labelWithFrame:CGRectMake720(120, 919, 300, 26) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    }
    return _countLabel;
}
@end
