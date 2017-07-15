//
//  PaySuccessOfflineView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PaySuccessOfflineView.h"
#import "MyOrderModel.h"
#import "GoodsModel.h"
#import "QDLineView.h"
@interface PaySuccessOfflineView ()

@property (nonatomic,strong) UILabel *orderLabel;

/** 支付的钱*/
@property (nonatomic,strong) UILabel *moneyLabel;

@end
@implementation PaySuccessOfflineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = kColorFor0f;
    }
    return self;
}


- (void)setupCustomView {
    UIImageView *successImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 168, 92, 92)];
    successImageView.centerX = self.centerX;
    successImageView.image = [UIImage imageNamed:@"good_select_activity_p"];
    [self addSubview:successImageView];
    
    UILabel *successLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 300, 720, 50) title:@"支付成功" titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentCenter font:50];
    [self addSubview:successLabel];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake720(0, 418, 720, 514)];
    grayView.backgroundColor = kColorFor1c;
    [self addSubview:grayView];
    
    [grayView addSubview:self.moneyLabel];
    [grayView addSubview:self.orderLabel];
    
    QDLineView *lineView = [[QDLineView alloc]initWithFrame:CGRectMake720(0, 80, 720, 1)];
    [grayView addSubview:lineView];
    
    UIView *redRoundView = [[UIView alloc]initWithFrame:CGRectMake720(56, 375, 14, 14)];
    [redRoundView setRoundedCorners:UIRectCornerAllCorners radius:7*SizeScale];
    redRoundView.backgroundColor = kColorForE60012;
    [grayView addSubview:redRoundView];
    
    UIView *redRoundView1 = [[UIView alloc]initWithFrame:CGRectMake720(56, 375 + 68, 14, 14)];
    redRoundView1.backgroundColor = kColorForE60012;
    [redRoundView1 setRoundedCorners:UIRectCornerAllCorners radius:7*SizeScale];
    [grayView addSubview:redRoundView1];
    
    UILabel *notesLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 220, 720, 75) title:@"(请妥善保管此号码,一经泄露可能会造成\n车辆被盗领)" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:26];
    notesLabel.numberOfLines = 0;
    [grayView addSubview:notesLabel];
    
    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(96, 352, 546, 124) title:@"请关注订单物流信息,商家备好货后,您可凭此\n号码取货\n取到货后可到“任务”页面参加挑战活动" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    textLabel.numberOfLines = 0;
    [grayView addSubview:textLabel];
    
    UIButton *checkBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(36, 1050, 288, 90) NormalBackgroundImageString:@"pay_check_order_btn" tapAction:^(UIButton *button) {
        self.clickCheckOrderBlock();
    }];
    [self addSubview:checkBtn];
    
    UIButton *returnBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(396, 1050, 288, 90) NormalBackgroundImageString:@"pay_return_home_page_btn" tapAction:^(UIButton *button) {
        self.clickReturnBlock();
    }];
    [self addSubview:returnBtn];
}
#pragma mark --- set
- (void)setOrderModel:(MyOrderModel *)orderModel {
    _orderModel = orderModel;
    self.orderLabel.text = orderModel.orderId;
    self.moneyLabel.text = [NSString stringWithFormat:@"订单金额 ￥%@",orderModel.needPayMoney];
}
- (void)setOrderID:(NSString *)orderID {
    _orderID = orderID;
    self.orderLabel.text = orderID;
}
- (void)setNeedPayMoney:(NSString *)needPayMoney {
    _needPayMoney = needPayMoney;
    self.moneyLabel.text = [NSString stringWithFormat:@"订单金额 ￥%@",needPayMoney];
}
#pragma mark --- lazy load
- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 80 + 55, 720, 48) title:@"" titleColor:kColorForE60012 textAlignment:NSTextAlignmentCenter font:48];
    }
    return _orderLabel;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 720, 80) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:28];
    }
    return _moneyLabel;
}

@end
