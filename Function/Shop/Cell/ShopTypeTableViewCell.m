//
//  ShopTypeTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopTypeTableViewCell.h"

@interface ShopTypeTableViewCell ()

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) UILabel *titleLabel;

/** 英文翻译*/
@property (nonatomic,strong) UILabel *translationLabel;
@end
@implementation ShopTypeTableViewCell

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
    
    [self addSubview:self.translationLabel];
}
#pragma mark --- set
- (void)setTypeRow:(NSInteger)typeRow {
    _typeRow = typeRow;
    switch (typeRow) {
        case 0:
            self.bgImageView.image = [UIImage imageNamed:@"shop_type_bg1"];
            self.titleLabel.text = @"运动休闲";
            self.translationLabel.text = @"Sport & Leisure";
            break;
        case 1:
            self.bgImageView.image = [UIImage imageNamed:@"shop_type_bg2"];
            self.titleLabel.text = @"城市通勤";
            self.translationLabel.text = @"InnerCity Commute";
            break;
        case 2:
            self.bgImageView.image = [UIImage imageNamed:@"shop_type_bg3"];
            self.titleLabel.text = @"专业挑战";
            self.translationLabel.text = @"Professional Competition";
            break;
        case 3:
            self.bgImageView.image = [UIImage imageNamed:@"shop_type_bg4"];
            self.titleLabel.text = @"智能骑行";
            self.translationLabel.text = @"Smart Biking";
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
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 136, 720, 30) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
    }
    return _titleLabel;
}
- (UILabel *)translationLabel {
    if (!_translationLabel) {
        _translationLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 182, 720, 26) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:22];
    }
    return _translationLabel;
}
@end
