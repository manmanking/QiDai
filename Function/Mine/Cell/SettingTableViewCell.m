//
//  SettingTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell ()
@property (nonatomic,strong) UIImageView *leftImageView;

@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation SettingTableViewCell

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
        self.backgroundColor = [UIColor blackColor];
        [self loadCellView];
    }
    return self;
    
}
- (void)loadCellView {
    [self addSubview:self.leftImageView];
    
    [self addSubview:self.nameLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(684, 0, 10, 20)];
    arrowImageView.image = [UIImage imageNamed:@"userinfo_right_arrow"];
    arrowImageView.centerY = 65*SizeScaleSubjectTo720;
    [self addSubview:arrowImageView];
}

- (void)setupCellWithImage:(NSString *)image text:(NSString *)text {
    self.leftImageView.image = [UIImage imageNamed:image];
    self.nameLabel.text = text;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect); //上分割线，
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x232323).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

#pragma mark --- lazy load
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(20, 0, 28, 26)];
        _leftImageView.centerY = 65*SizeScaleSubjectTo720;
    }
    return _leftImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel qd_labelWithFrame:CGRectMake720(64, 0, 200, 26) title:@"" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:28];
        _nameLabel.centerY = 65*SizeScaleSubjectTo720;
    }
    return _nameLabel;
}

@end
