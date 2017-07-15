//
//  StoreAddressTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "StoreAddressTableViewCell.h"
#import "OrderDetailModel.h"
#import "ShopAddressModel.h"
@interface StoreAddressTableViewCell ()
/** 店铺地址*/
@property (nonatomic,strong) UILabel *storeNameLabel;
/** 地址*/
@property (nonatomic,strong) UILabel *addressLabel;
/** 距离*/
@property (nonatomic,strong) UILabel *distanceLabel;
@end
@implementation StoreAddressTableViewCell

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
    //
    UIImageView *loactionImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 50, 46, 46)];
    loactionImageView.image = [UIImage imageNamed:@"store_address_image"];
    [self addSubview:loactionImageView];
    
    [self addSubview:self.storeNameLabel];
    
    UIImageView *distanceImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(604, 42, 14, 20)];
    distanceImageView.image = [UIImage imageNamed:@"address_location_image"];
    [self addSubview:distanceImageView];
    [self addSubview:self.distanceLabel];
    
    [self addSubview:self.addressLabel];
    
}
#pragma mark --- set
- (void)setModel:(OrderDetailModel *)model {
    _model = model;
    self.addressLabel.text = model.address;
    self.storeNameLabel.text = model.shopName;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2fkm",[model.distance floatValue]/1000];
}
- (void)setShopModel:(ShopAddressModel *)shopModel {
    _shopModel = shopModel;
    self.addressLabel.text = shopModel.address;
    self.storeNameLabel.text = shopModel.name;
    if (!shopModel.name) {
        self.storeNameLabel.text = shopModel.shopName;
    }
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2fkm",[shopModel.distance floatValue]/1000];
}
#pragma mark --- lazy load
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel qd_labelWithFrame:CGRectMake720(116, 94, 476, 28) title:@"按时发放看公告" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    }
    return _addressLabel;
}
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [UILabel qd_labelWithFrame:CGRectMake720(116, 40, 476, 28) title:@"按时发放看公告" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    }
    return _storeNameLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(630, 42, 80, 20) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:22];
    }
    return _distanceLabel;
}
@end
