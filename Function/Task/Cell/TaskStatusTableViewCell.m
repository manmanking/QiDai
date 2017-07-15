//
//  TaskStatusTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/19.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskStatusTableViewCell.h"

@interface TaskStatusTableViewCell ()

@property (nonatomic,strong) UIImageView *statusImageView;
@property (nonatomic,strong) UILabel *statusLabel;
@end
@implementation TaskStatusTableViewCell

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
    
    [self addSubview:self.statusImageView];
    
    [self addSubview:self.statusLabel];
    
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x838383).CGColor);
    
    if (!self.finish) {
        CGContextStrokeRect(context, CGRectMake(37*SizeScale, 44*SizeScale, 2*SizeScale, rect.size.height - 44*SizeScale));
    } else {
        CGContextStrokeRect(context, CGRectMake(37*SizeScale, 0, 2*SizeScale, rect.size.height));
    }
    
    
}
- (void)setFinish:(BOOL)finish {
    _finish = finish;
    if (finish) {
        self.statusImageView.image = [UIImage imageNamed:@"task_activity_finish"];
        self.statusLabel.text = @"挑战完成";
    } else {
        self.statusImageView.image = [UIImage imageNamed:@"task_activity_prepare"];
        self.statusLabel.text = @"即将开赛";
    }
}
#pragma mark --- lazy load
- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(20, 44, 36, 36)];
    }
    return _statusImageView;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel qd_labelWithFrame:CGRectMake720(80, 44, 120, 36) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:24];
    }
    return _statusLabel;
}
@end
