//
//  ShopBrandTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopBrandTableViewCell.h"
#import "BrandModel.h"
#import "UIImageView+WebCache.h"
@interface ShopBrandTableViewCell ()

@property (nonatomic,strong) UIImageView *brandImageView;
@property (nonatomic,strong) UILabel *brandLabel;

@end
@implementation ShopBrandTableViewCell

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
    [self addSubview:self.brandLabel];
    
    [self addSubview:self.brandImageView];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(686, 71, 14, 28)];
    arrowImageView.image = [UIImage imageNamed:@"mine_right_arrow_image"];
    [self addSubview:arrowImageView];
    
}
#pragma mark --- set
- (void)setModel:(BrandModel *)model {
    _model = model;
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
    self.brandLabel.text = model.name;
}
#pragma mark --- lazy load
- (UIImageView *)brandImageView {
    if (!_brandImageView) {
        _brandImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(30, 28, 112, 112)];
    }
    return _brandImageView;
}
- (UILabel *)brandLabel {
    if (!_brandLabel) {
        _brandLabel = [UILabel qd_labelWithFrame:CGRectMake720(190, 69, 200, 28) title:@"啊啊啊啊啊" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _brandLabel;
}
@end
