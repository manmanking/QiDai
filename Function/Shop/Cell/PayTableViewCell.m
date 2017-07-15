//
//  PayTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PayTableViewCell.h"

@interface PayTableViewCell ()
{
    UIButton *_selectBtn;
}
/** 支付类型的logo*/
@property (nonatomic,strong) UIImageView *leftImageView;

/** 支付的平台名*/
@property (nonatomic,strong) UILabel *platformLabel;
@end
@implementation PayTableViewCell

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
        self.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
    }
    return self;
}
- (void)loadCellView {
    _selectBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(644, 40, 44, 44) NormalBackgroundImageString:@"pay_select_image" tapAction:^(UIButton *button) {
        self.clickSelectBtnBlock(self.page);
    }];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"good_select_activity_p"] forState:UIControlStateSelected];
    [self addSubview:_selectBtn];
    
    [self addSubview:self.platformLabel];
    
    [self addSubview:self.leftImageView];
    self.leftImageView.centerY = 60*SizeScaleSubjectTo720;
}

#pragma mark --- set
- (void)setPage:(NSInteger)page {
    _page = page;
    if (_page == 0) {
        self.platformLabel.text = @"支付宝支付";
        self.leftImageView.image = [UIImage imageNamed:@"pay_alipay_icon"];
    } else {
        self.platformLabel.text = @"微信支付";
        self.leftImageView.image = [UIImage imageNamed:@"pay_weixin_icon"];
    }
}
- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
}
#pragma mark --- lazy load
- (UILabel *)platformLabel {
    if (!_platformLabel) {
        _platformLabel = [UILabel qd_labelWithFrame:CGRectMake720(132, 0, 200, 120) title:@"支付宝支付" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:30];
    }
    return _platformLabel;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 0, 64, 64)];
        _leftImageView.image = [UIImage imageNamed:@"pay_alipay_icon"];
    }
    return _leftImageView;
}
@end
