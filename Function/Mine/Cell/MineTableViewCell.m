//
//  MineTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

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
    
    CGFloat left = 40 * SizeScaleSubjectTo720;
    //下分割线
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x838383).CGColor);
    CGContextStrokeRect(context, CGRectMake(left, rect.size.height, rect.size.width - left * 2, 1));
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = UIColorFromRGB_10(16, 16, 16);
    self.alpha = 0.96;
    if (self) {
        [self loadCellView];
    }
    return self;
    
}
- (void)loadCellView {
    
    [self addSubview:self.leftImageView];
    
    [self addSubview:self.titleLabel];
    
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(670, 45, 10, 20)];
    arrowImageView.image = [UIImage imageNamed:@"mine_right_arrow_image"];
    [self addSubview:arrowImageView];
    
}
#pragma mark --- set
- (void)setIndex:(NSInteger)index {
    _index = index;
    switch (index) {
        case 0:
            self.leftImageView.image = [UIImage imageNamed:@"mine_history_image"];
            self.leftImageView.width = 40*SizeScaleSubjectTo720;
            self.leftImageView.height = 34*SizeScaleSubjectTo720;
            self.titleLabel.text = @"历史骑行";
            break;
        case 1:
            self.leftImageView.image = [UIImage imageNamed:@"mine_ranking_image"];
            self.leftImageView.width = 40*SizeScaleSubjectTo720;
            self.leftImageView.height = 40*SizeScaleSubjectTo720;
            self.titleLabel.text = @"排行榜";
            break;
        case 2:
            self.leftImageView.image = [UIImage imageNamed:@"mine_order_image"];
            self.leftImageView.width = 30*SizeScaleSubjectTo720;
            self.leftImageView.height = 34*SizeScaleSubjectTo720;
            self.titleLabel.text = @"我的订单";
            break;
        case 3:
            self.leftImageView.image = [UIImage imageNamed:@"MineNewOnlineServiceImageView"];
            self.leftImageView.width = 38*SizeScaleSubjectTo720;
            self.leftImageView.height = 38*SizeScaleSubjectTo720;
            self.titleLabel.text = @"在线客服";
            break;
        case 4:
            self.leftImageView.image = [UIImage imageNamed:@"MineNewTelephoneServiceImageView"];
            self.leftImageView.width = 30*SizeScaleSubjectTo720;
            self.leftImageView.height = 34*SizeScaleSubjectTo720;
            self.titleLabel.text = @"电话咨询";
            break;
        case 5:
            self.leftImageView.image = [UIImage imageNamed:@"mine_setting_image"];
            self.leftImageView.width = 38*SizeScaleSubjectTo720;
            self.leftImageView.height = 38*SizeScaleSubjectTo720;
            self.titleLabel.text = @"设置";
            break;
            
        default:
            break;
    }
    self.leftImageView.centerX = 60*SizeScaleSubjectTo720;
    self.leftImageView.centerY = 55*SizeScaleSubjectTo720;
}
#pragma mark --- lazy load
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(40, 35, 40, 40)];
    }
    return _leftImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(110, 35, 200, 40) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:32];
    }
    return _titleLabel;
}

@end
