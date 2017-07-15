//
//  LogisticsTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "LogisticsTableViewCell.h"

@interface LogisticsTableViewCell ()

/** 小球*/
@property (nonatomic,strong) UIView *ballView;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *detailLabel;
@end
@implementation LogisticsTableViewCell

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
    CGContextStrokeRect(context, CGRectMake(64*SizeScaleSubjectTo720, 5*SizeScale, 1*SizeScale, rect.size.height ));
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
    [self addSubview:self.ballView];
    
    [self addSubview:self.detailLabel];
    
    [self addSubview:self.timeLabel];
}
- (void)setDate:(NSString *)date {
    _date = date;
    self.timeLabel.text = date;
}
- (void)setStatus:(NSString *)status {
    _status = status;
    self.detailLabel.text = status;
}
- (void)setRow:(NSInteger)row {
    _row = row;
    if (row == 0) {
        self.ballView.backgroundColor = kColorForE60012;
    } else {
        self.ballView.backgroundColor = kColorForccc;
        self.detailLabel.textColor = kColorForfff;
    }
}
#pragma mark --- lazy load
- (UIView *)ballView {
    if (!_ballView) {
        _ballView = [[UIView alloc]initWithFrame:CGRectMake720(54, 2, 24, 24)];
        _ballView.backgroundColor = kColorForccc;
        [_ballView setRoundedCorners:UIRectCornerAllCorners radius:9*SizeScale];
    }
    return _ballView;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel qd_labelWithFrame:CGRectMake720(120, 2, 600, 28) title:@"[已发货]" titleColor:kColorForE60012 textAlignment:NSTextAlignmentLeft font:28];
    }
    return _detailLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel qd_labelWithFrame:CGRectMake720(120, 50, 500, 24) title:@"2016.04.20" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _timeLabel;
}
@end
