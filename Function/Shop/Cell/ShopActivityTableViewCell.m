//
//  ShopActivityTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopActivityTableViewCell.h"

@interface ShopActivityTableViewCell ()

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) UILabel *titleLabel;
@end
@implementation ShopActivityTableViewCell

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
    CGContextSetStrokeColorWithColor(context, UIColorFromAlphaRGB(0x838383, 0.4).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1*SizeScaleSubjectTo720));
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
    [self addSubview:self.bgImageView];
    
    [self addSubview:self.titleLabel];
}
#pragma mark --- set
- (void)setRow:(NSInteger)row {
    _row = row;
    switch (row) {
        case 0:
            self.bgImageView.image = [UIImage imageNamed:@"shop_activity_bg1"];
            self.titleLabel.text = @"100 - 499元奖金";
            break;
        case 1:
            self.bgImageView.image = [UIImage imageNamed:@"shop_activity_bg2"];
            self.titleLabel.text = @"500 - 999元奖金";
            break;
        case 2:
            self.bgImageView.image = [UIImage imageNamed:@"shop_activity_bg3"];
            self.titleLabel.text = @"1000 - 1999元奖金";
            break;
        case 3:
            self.bgImageView.image = [UIImage imageNamed:@"shop_activity_bg4"];
            self.titleLabel.text = @"2000元以上";
            break;
        default:
            break;
    }
}

#pragma mark --- lazy load
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 340)];
    }
    return _bgImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 150, 720, 40) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
        _titleLabel.font = [UIFont boldSystemFontOfSize:30*SizeScaleSubjectTo720];
    }
    return _titleLabel;
}
@end
