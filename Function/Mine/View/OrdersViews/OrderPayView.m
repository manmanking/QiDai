//
//  OrderPayView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "OrderPayView.h"
#import "MyOrderModel.h"
#import "UIImageView+WebCache.h"
@implementation OrderPayView
{
    /** 车的图片*/
    UIImageView *_bikeImageView;
    /** 车的信息*/
    UILabel *_bikeLabel;
    /** 总价格*/
    UILabel *_priceLabel;
    /** 返现*/
    UILabel *_refundLabel;
    /** 活动*/
    UILabel *_activityLabel;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
//    UIImageView *statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 38, 44, 44)];
//    statusImageView.image = [UIImage imageNamed:@"order_need_pay_image"];
//    [self addSubview:statusImageView];
//    
//    UILabel *statusLabel = [UILabel qd_labelWithFrame:CGRectMake720(100, 38, 44, 120) title:@"待付款" titleColor:kColorForE60012 textAlignment:NSTextAlignmentLeft font:32];
//    [self addSubview:statusLabel];
    
    _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 66, 168, 168)];
    [self addSubview:_bikeImageView];
    
    _bikeLabel = [UILabel qd_labelWithFrame:CGRectMake720(250, 66, 420, 88) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:30];
    _bikeLabel.numberOfLines = 0;
    [self addSubview:_bikeLabel];
    
    _priceLabel = [UILabel qd_labelWithFrame:CGRectMake720(250, 162, 228, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
    [self addSubview:_priceLabel];
    
    _refundLabel = [UILabel qd_labelWithFrame:CGRectMake720(478, 162, 200, 28) title:@"" titleColor:kColorForE60012 textAlignment:NSTextAlignmentLeft font:28];
    [self addSubview:_refundLabel];
    
    _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 236, 700, 120) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    [self addSubview:_activityLabel];
    
}
#pragma mark --- set
- (void)setModel:(MyOrderModel *)model {
    [_bikeImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    _bikeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.brand,model.series,model.model,model.color];
    //_priceLabel.text = [NSString stringWithFormat:@"￥%@",model.needPayMoney];
    NSString *refund = [NSString stringWithFormat:@"奖金￥%@",model.bonus];
    _refundLabel.attributedText = [NSString changTitleColorWithString:refund defaultColor:kColorForfff specifyColor:kColorForE60012 specifyRang:NSMakeRange(0, 2)];
    
    if ([model.information isExist]) {
        _activityLabel.text = [NSString stringWithFormat:@"已选活动: %@",model.information];
    } else {
        _activityLabel.text = [NSString stringWithFormat:@"已选活动: 无活动"];
    }

}
- (void)setMoney:(NSString *)money {
    _money = money;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",money];
}
@end
