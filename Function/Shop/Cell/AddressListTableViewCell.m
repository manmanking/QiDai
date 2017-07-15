//
//  AddressListTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AddressListTableViewCell.h"
#import "PersonalAddressModel.h"
@interface AddressListTableViewCell ()

/** 昵称*/
@property (nonatomic,strong) UILabel *nameLabel;

/** 手机号*/
@property (nonatomic,strong) UILabel *phoneLabel;

/** 地址*/
@property (nonatomic,strong) UILabel *addressLabel;

/** 默认*/
@property (nonatomic,strong) UIImageView *defaultImageView;

@property (nonatomic,strong) UIButton *selectBtn;
@end
@implementation AddressListTableViewCell

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
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1*SizeScaleSubjectTo720));
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadCellView];
        self.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    }
    return self;
    
}
- (void)loadCellView {
    self.selectBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(34, 49, 44, 44) NormalBackgroundImageString:@"good_select_activity" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSelectBtnWithIndex:)]) {
            [self.delegate clickSelectBtnWithIndex:self.index];
        }
    }];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"good_select_activity_p"] forState:UIControlStateSelected];
    [self addSubview:self.selectBtn];
    
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.phoneLabel];
    
    [self addSubview:self.addressLabel];
    
    UIButton *editBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(660, 83, 40, 37) NormalBackgroundImageString:@"address_edit_image" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickEditBtnWithIndex:)]) {
            [self.delegate clickEditBtnWithIndex:self.index];
        }
    }];
    [self addSubview:editBtn];
    
    [self addSubview:self.defaultImageView];
    
}
#pragma mark --- set
- (void)setModel:(PersonalAddressModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = model.address;
    if ([model.is_def isEqualToString:@"1"]) {
        self.defaultImageView.hidden = NO;
    } else {
        self.defaultImageView.hidden = YES;
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.selectBtn.selected = YES;
    } else {
        self.selectBtn.selected = NO;
    }
}
#pragma mark --- lazy load
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel qd_labelWithFrame:CGRectMake720(116, 40, 150, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
    }
    return _nameLabel;
}
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel qd_labelWithFrame:CGRectMake720(224, 40, 226, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
    }
    return _phoneLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel qd_labelWithFrame:CGRectMake720(116, 94, 476, 28) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    }
    return _addressLabel;
}
- (UIImageView *)defaultImageView {
    if (!_defaultImageView) {
        _defaultImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(504, 38, 64, 30)];
        _defaultImageView.image = [UIImage imageNamed:@"address_default_image"];
    }
    return _defaultImageView;
}
@end
