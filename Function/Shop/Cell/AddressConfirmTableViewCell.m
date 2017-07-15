//
//  AddressConfirmTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AddressConfirmTableViewCell.h"
#import "PersonalAddressModel.h"
@interface AddressConfirmTableViewCell ()
/** 昵称*/
@property (nonatomic,strong) UILabel *nameLabel;

/** 手机号*/
@property (nonatomic,strong) UILabel *phoneLabel;

/** 地址*/
@property (nonatomic,strong) UILabel *addressLabel;
@end
@implementation AddressConfirmTableViewCell
{
    UIImageView *arrowImageView;
}
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
    UIImageView *loactionImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 50, 30, 43)];
    loactionImageView.image = [UIImage imageNamed:@"address_location_image"];
    [self addSubview:loactionImageView];
    
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.phoneLabel];
    
    [self addSubview:self.addressLabel];
    
    arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(676, 68, 10, 20)];
    arrowImageView.image = [UIImage imageNamed:@"mine_right_arrow_image"];
    [self addSubview:arrowImageView];
}
#pragma mark --- set
- (void)setModel:(PersonalAddressModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = model.address;
}
- (void)setIsArrowShow:(BOOL)isArrowShow {
    _isArrowShow = isArrowShow;
    if (!isArrowShow) {
        arrowImageView.hidden = YES;
    } else {
        arrowImageView.hidden = NO;
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
        _phoneLabel = [UILabel qd_labelWithFrame:CGRectMake720(280, 40, 226, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
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
