//
//  LogisticsHeaderView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "LogisticsHeaderView.h"
#import "OrderDetailModel.h"
#import "UIImageView+WebCache.h"
@interface LogisticsHeaderView ()
/** 车子的图片*/
@property (nonatomic,strong) UIImageView *bikeImageView;
/** 物流公司*/
@property (nonatomic,strong) UILabel *companyLabel;
/** 货运单号*/
@property (nonatomic,strong) UILabel *orderLabel;
/** 商家电话*/
@property (nonatomic,strong) UILabel *phoneLabel;
/** 退款*/
@property (nonatomic,strong) UILabel *refundLabel;

@property (nonatomic,strong) UILabel *textLabel;
@end
@implementation LogisticsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    [self addSubview:self.bikeImageView];
    [self addSubview:self.companyLabel];
    [self addSubview:self.orderLabel];
    [self addSubview:self.phoneLabel];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(0, 206, 720, 1)];
    lineView.backgroundColor = kColorFor83;
    lineView.alpha = 0.6;
    [self addSubview:lineView];
    
    self.textLabel = [UILabel qd_labelWithFrame:CGRectMake720(35, 276, 300, 28) title:@"物流跟踪" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    [self addSubview:self.textLabel];
}
#pragma mark --- set
- (void)setModel:(OrderDetailModel *)model {
    _model = model;
    [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.companyLabel.text = [NSString stringWithFormat:@"物流公司: %@",model.enwrapCompany];
    self.orderLabel.text = [NSString stringWithFormat:@"货运单号: %@",model.courierNumber];
    self.phoneLabel.text = [NSString stringWithFormat:@"商家电话: %@",model.shopPhone];
    
    if (![model.courierNumber isExist]) {
        self.orderLabel.text = @"";
        self.companyLabel.top += 10*SizeScale;
        self.phoneLabel.top -= 10*SizeScale;
    }
    if (![model.enwrapCompany isExist]) {
        self.companyLabel.text = @"暂未发货,请耐心等待";
    }
}
- (void)setPayType:(NSInteger)payType {
    _payType = payType;
    if (payType == 2) {
        self.companyLabel.hidden = YES;
        self.orderLabel.hidden = YES;
        self.phoneLabel.textColor = kColorForfff;
        self.phoneLabel.centerY = 103*SizeScale;
    }
}
- (void)setIsRefund:(BOOL)isRefund {
    _isRefund = isRefund;
    if (isRefund) {
        self.companyLabel.hidden = YES;
        self.orderLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.refundLabel.text = [NSString stringWithFormat:@"退款金额: ￥%@",self.model.needPayMoney];
        [self addSubview:self.refundLabel];
        self.textLabel.text = @"退款跟踪";
    }
}

#pragma mark --- lazy load
- (UIImageView *)bikeImageView {
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 42, 168, 100)];
    }
    return _bikeImageView;
}
- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [UILabel qd_labelWithFrame:CGRectMake720(244, 42, 475, 28) title:@"物流公司: " titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
    }
    return _companyLabel;
}
- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [UILabel qd_labelWithFrame:CGRectMake720(244, 90, 475, 28) title:@"货运单号: " titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
    }
    return _orderLabel;
}
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel qd_labelWithFrame:CGRectMake720(244, 138, 475, 28) title:@"商家电话: " titleColor:kColorForE60012 textAlignment:NSTextAlignmentLeft font:28];
    }
    return _phoneLabel;
}
- (UILabel *)refundLabel {
    if (!_refundLabel) {
        _refundLabel = [UILabel qd_labelWithFrame:CGRectMake720(244, 138, 475, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
        _refundLabel.centerY = 103*SizeScale;
    }
    return _refundLabel;
}
@end
