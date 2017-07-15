//
//  OrderAddressView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "OrderAddressView.h"
#import "PersonalAddressModel.h"
@interface OrderAddressView ()
/** 昵称*/
@property (nonatomic,strong) UILabel *nameLabel;

/** 手机号*/
@property (nonatomic,strong) UILabel *phoneLabel;

/** 地址*/
@property (nonatomic,strong) UILabel *addressLabel;
@end
@implementation OrderAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupCustomView {
    UIImageView *loactionImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 50, 30, 43)];
    loactionImageView.image = [UIImage imageNamed:@"address_location_image"];
    [self addSubview:loactionImageView];
    
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.phoneLabel];
    
    [self addSubview:self.addressLabel];
}
#pragma mark --- set
#pragma mark --- set
- (void)setModel:(PersonalAddressModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = model.address;
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

@end
