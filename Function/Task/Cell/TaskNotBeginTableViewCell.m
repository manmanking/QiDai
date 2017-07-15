//
//  TaskNotBeginTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskNotBeginTableViewCell.h"
#import "TaskModel.h"
#import "UIImageView+WebCache.h"
@interface TaskNotBeginTableViewCell ()
/** 活动图片*/
@property (nonatomic,strong) UIImageView *activityImageView;
/** 活动名字*/
@property (nonatomic,strong) UILabel *activityLabel;
/** 活动详情*/
@property (nonatomic,strong) UILabel *activityDetailLabel;
/** 倒计时几天*/
@property (nonatomic,strong) UILabel *countdownLabel;
@end
@implementation TaskNotBeginTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    [self addSubview:self.activityDetailLabel];
    
    UILabel *activityStatusLabel = [UILabel qd_labelWithFrame:CGRectMake720(560, 42, 120, 22) title:@"距活动开始" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
    [self addSubview:activityStatusLabel];
    [self addSubview:self.countdownLabel];
    
    UIImageView *statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(682, 42, 18, 38)];
    statusImageView.image = [UIImage imageNamed:@"task_status_red"];
    [self addSubview:statusImageView];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x838383).CGColor);
    CGContextStrokeRect(context, CGRectMake(37*SizeScaleSubjectTo720, 0, 2*SizeScaleSubjectTo720, rect.size.height));
}
#pragma mark --- set
- (void)setModel:(TaskModel *)model {
    _model = model;
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.activityLabel.text = model.information;
    self.activityDetailLabel.text = [NSString stringWithFormat:@"活动: %@",model.name ];
    if ([model.countdown isExist]) {
        self.countdownLabel.text = model.countdown;
    } else {
        self.countdownLabel.text = @"0";
    }
    
}
#pragma mark --- lazy load
- (UIImageView *)activityImageView {
    if (!_activityImageView) {
        _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(80, 26, 108, 108)];
        [_activityImageView setRoundedCorners:UIRectCornerAllCorners radius:_activityImageView.height/2];
    }
    return _activityImageView;
}
- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 48, 300, 30) title:@"tern link n8 挑战" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:32];
    }
    return _activityLabel;
}
- (UILabel *)activityDetailLabel {
    if (!_activityDetailLabel) {
        _activityDetailLabel = [UILabel qd_labelWithFrame:CGRectMake720(210, 96, 300, 24) title:@"活动: 定期赚" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _activityDetailLabel;
}
- (UILabel *)countdownLabel {
    if (!_countdownLabel) {
        _countdownLabel = [UILabel qd_labelWithFrame:CGRectMake720(560, 80, 140, 40) title:@"1" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:50];
    }
    return _countdownLabel;
}

@end
