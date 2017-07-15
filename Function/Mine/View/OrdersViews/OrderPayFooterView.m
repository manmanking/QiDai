//
//  OrderPayFooterView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  写的太匆忙.......

#import "OrderPayFooterView.h"

#import "MyOrderModel.h"
#import "OrderDetailModel.h"

@implementation OrderPayFooterView
{
    UILabel *_needPayLabel;
    
    UILabel *rightLabel;
    
    UILabel *leftLabel2;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UILabel *leftLabel1 = [UILabel qd_labelWithFrame:CGRectMake720(20, 0, 200, 110) title:@"支付类别" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    [self addSubview:leftLabel1];
    
    leftLabel2 = [UILabel qd_labelWithFrame:CGRectMake720(20, 110, 200, 110) title:@"商品总额" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    [self addSubview:leftLabel2];
    
    rightLabel = [UILabel qd_labelWithFrame:CGRectMake720(500, 0, 200, 110) title:@"支付全额" titleColor:kColorForfff textAlignment:NSTextAlignmentRight font:26];
    [self addSubview:rightLabel];
    
    _needPayLabel = [UILabel qd_labelWithFrame:CGRectMake720(500, 110, 200, 110) title:@"￥0" titleColor:kColorForE60012 textAlignment:NSTextAlignmentRight font:26];
    [self addSubview:_needPayLabel];
    
    UIButton *payBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(35, 340, 650, 90) title:@"去支付" titleColor:kColorForfff titleFont:34 backgroundColor:nil tapAction:^(UIButton *button) {
        self.clickPayBtnBlock();
    }];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"order_red_btn"] forState:UIControlStateNormal];
    [self addSubview:payBtn];
}
- (void)setNeedPay:(NSString *)needPay {
    _needPay = needPay;
    _needPayLabel.text = [NSString stringWithFormat:@"￥%@",needPay];
}
- (void)setOrderModel:(MyOrderModel *)orderModel {
    _orderModel = orderModel;
}
- (void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel {
    _orderDetailModel = orderDetailModel;
    
    
    if (![_orderDetailModel.needPayMoney isEqualToString:_orderDetailModel.price]) {
        rightLabel.text = @"支付押金";
        leftLabel2.text = @"押金支付";
    }
    if (!([_orderDetailModel.threePay rangeOfString:@"支付宝"].location == NSNotFound) ) {
        rightLabel.text = [NSString stringWithFormat:@"支付宝%@",rightLabel.text];
    }
}
@end
