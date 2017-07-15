//
//  PayFailureView.m
//  QiDai
//
//  Created by manman'swork on 16/10/29.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "MyOrderModel.h"
#import "PayFailureView.h"
#import "QDLineView.h"
#import "AppDelegate.h"


@interface PayFailureView()

@property (nonatomic,strong) UILabel *orderLabel;

/** 支付的钱*/
@property (nonatomic,strong) UILabel *moneyLabel;

@end

@implementation PayFailureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    successImageView.image = [UIImage imageNamed:@"Failure"];
    [self addSubview:successImageView];
    
    UILabel *successLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 300, 720, 50) title:@"支付失败" titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentCenter font:50];
    [self addSubview:successLabel];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake720(0, 418, 720, 514)];
    grayView.backgroundColor = kColorFor0f;
    [self addSubview:grayView];

    [grayView addSubview:self.orderLabel];
    self.orderLabel.text = @"订单信息";
    
//    QDLineView *lineView = [[QDLineView alloc]initWithFrame:CGRectMake720(0, 80, 720, 1)];
//    [grayView addSubview:lineView];
    
//    UIView *redRoundView = [[UIView alloc]initWithFrame:CGRectMake720(56, 375, 14, 14)];
//    [redRoundView setRoundedCorners:UIRectCornerAllCorners radius:7*SizeScale];
//    redRoundView.backgroundColor = kColorForE60012;
//    [grayView addSubview:redRoundView];
    
//    UIView *redRoundView1 = [[UIView alloc]initWithFrame:CGRectMake720(56, 375 + 68, 14, 14)];
//    redRoundView1.backgroundColor = kColorForE60012;
//    [redRoundView1 setRoundedCorners:UIRectCornerAllCorners radius:7*SizeScale];
//    [grayView addSubview:redRoundView1];
    
    UILabel *notesLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 220, 720, 75) title:@"(该订单会为你保留24小时，24小时之后如果\n还未付款，系统将自动取消该订单)" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:26];
    notesLabel.numberOfLines = 0;
    [grayView addSubview:notesLabel];
    
//    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(96, 352, 546, 124) title:@"请关注订单物流信息,商家备好货后,您可凭此\n号码取货\n取到货后可到“任务”页面参加挑战活动" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
//    textLabel.numberOfLines = 0;
//    [grayView addSubview:textLabel];
    
    UIButton *checkBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(36, 1050, 288, 90) NormalBackgroundImageString:@"pay_rePay_red" tapAction:^(UIButton *button) {
        //self.clickRepayBlock();
        [self removeFromSuperview];
    }];
    [self addSubview:checkBtn];
    
    UIButton *returnBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(396, 1050, 288, 90) NormalBackgroundImageString:@"pay_return_home_page_btn_white" tapAction:^(UIButton *button) {
        
        self.clickReturnBlock();
        [self removeFromSuperview];
       
        
    }];
    [self addSubview:returnBtn];
}
#pragma mark --- set
//- (void)setOrderModel:(MyOrderModel *)orderModel {
//    _orderModel = orderModel;
//    self.orderLabel.text = orderModel.orderId;
//    self.moneyLabel.text = [NSString stringWithFormat:@"订单金额 ￥%@",orderModel.needPayMoney];
//}
//- (void)setOrderID:(NSString *)orderID {
//    self.orderLabel.text = orderID;
//}
//- (void)setNeedPayMoney:(NSString *)needPayMoney {
//    _needPayMoney = needPayMoney;
//    self.moneyLabel.text = [NSString stringWithFormat:@"订单金额 ￥%@",needPayMoney];
//}
#pragma mark --- lazy load
- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 80 + 55, 720, 48) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:48];
    }
    return _orderLabel;
}


@end
