//
//  TaskFinishTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskFinishTableViewCell.h"
#import "TaskModel.h"
#import "UIImageView+WebCache.h"
@interface TaskFinishTableViewCell ()
/** 活动图片*/
@property (nonatomic,strong) UIImageView *activityImageView;
/** 活动名字*/
@property (nonatomic,strong) UILabel *activityLabel;
/** 状态：成功或者失败*/
@property (nonatomic,strong) UILabel *activityStatusLabel;
/** 状态：成功为橙色，失败为蓝色*/
@property (nonatomic,strong) UIImageView *statusImageView;
/** 返现*/
@property (nonatomic,strong) UILabel *refundLabel;
/** 总里程*/
@property (nonatomic,strong) UILabel *distanceLabel;
/** 达标天数*/
@property (nonatomic,strong) UILabel *standardDayLabel;
@end
@implementation TaskFinishTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x838383).CGColor);
    CGContextStrokeRect(context, CGRectMake(37*SizeScaleSubjectTo720, 0, 2*SizeScaleSubjectTo720, rect.size.height));
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadCellView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
    
}
- (void)loadCellView {
    
    [self addSubview:self.activityImageView];
    [self addSubview:self.activityLabel];

    [self addSubview:self.activityStatusLabel];
    
    
    [self addSubview:self.statusImageView];
    
    UILabel *moneyTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 108, 130, 24) title:@"累计奖金(元)" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
    [self addSubview:moneyTextLabel];
    
    UILabel *distanceTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(392, 108, 130, 24) title:@"总里程(km)" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
    [self addSubview:distanceTextLabel];
    
    UILabel *dayLabel = [UILabel qd_labelWithFrame:CGRectMake720(562, 108, 125, 24) title:@"总达标天数" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:dayLabel];
    
    [self addSubview:self.refundLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.standardDayLabel];
}
#pragma mark --- set
- (void)setModel:(TaskModel *)model {
    _model = model;
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.activityLabel.text = model.name;
    //self.activityDetailLabel.text = model.information;
    //self.countdownLabel.text = model.countdown;
    self.refundLabel.text = model.refund;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f",[model.disSum floatValue]/1000];
    self.standardDayLabel.text = model.completeDay;
    
    if ([model.complete isEqualToString:@"1"]) {
        self.activityStatusLabel.text = @"成功";
        self.activityStatusLabel.textColor = UIColorFromRGB_16(0x35a4da);
        self.statusImageView.image = [UIImage imageNamed:@"task_status_blue"];
    } else {
        self.activityStatusLabel.text = @"失败";
        self.activityStatusLabel.textColor = UIColorFromRGB_16(0x35a4da);
        self.statusImageView.image = [UIImage imageNamed:@"task_status_blue"];
    }
    
    
}
#pragma mark --- lazy load
- (UIImageView *)activityImageView {
    if (!_activityImageView) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(80, 26, 108, 108)];
        _activityImageView.backgroundColor = [UIColor whiteColor];
        [_activityImageView setRoundedCorners:UIRectCornerAllCorners radius:_activityImageView.height/2];
    }
    return _activityImageView;
}
- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(682, 42, 18, 38)];
        _statusImageView.image = [UIImage imageNamed:@"task_status_orange"];
    }
    return _statusImageView;
}

- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 48, 300, 30) title:@"tern link n8 挑战" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:32];
    }
    return _activityLabel;
}
- (UILabel *)activityStatusLabel {
    if (!_activityStatusLabel) {
        _activityStatusLabel = [UILabel qd_labelWithFrame:CGRectMake720(560, 42, 120, 38) title:@"" titleColor:UIColorFromRGB_16(0xe97b1a) textAlignment:NSTextAlignmentCenter font:32];
    }
    return _activityStatusLabel;
}
- (UILabel *)refundLabel {
    if (!_refundLabel) {
        _refundLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 148, 130, 32) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:32];
    }
    return _refundLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(392, 148, 130, 32) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:32];
    }
    return _distanceLabel;
}
- (UILabel *)standardDayLabel {
    if (!_standardDayLabel) {
        _standardDayLabel = [UILabel qd_labelWithFrame:CGRectMake720(562, 148, 130, 32) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:32];
    }
    return _standardDayLabel;
}
@end
