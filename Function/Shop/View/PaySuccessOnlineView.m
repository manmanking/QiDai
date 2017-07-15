//
//  PaySuccessOnlineView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PaySuccessOnlineView.h"
#import "MyOrderModel.h"
@interface PaySuccessOnlineView ()

/** 支付的钱*/
@property (nonatomic,strong) UILabel *moneyLabel;

@end
@implementation PaySuccessOnlineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = kColorFor0f;
    }
    return self;
}
- (void)setupCustomView {
    UIImageView *successImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 204, 92, 92)];
    successImageView.centerX = self.centerX;
    successImageView.image = [UIImage imageNamed:@"good_select_activity_p"];
    [self addSubview:successImageView];
    
    UILabel *successLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 336, 720, 50) title:@"支付成功" titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentCenter font:50];
    //successLabel.top = successLabel.bottom + 40*SizeScale;
    [self addSubview:successLabel];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake720(0, 478, 720, 284)];
    grayView.backgroundColor = kColorFor1c;
    [self addSubview:grayView];
    
    [grayView addSubview:self.moneyLabel];
    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 166, 720, 30) title:@"收到货后,请到“任务“页面参加挑战活动 " titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
    [grayView addSubview:textLabel];
    
    UIButton *checkBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(36, 900, 288, 90) NormalBackgroundImageString:@"pay_check_order_btn" tapAction:^(UIButton *button) {
        self.clickCheckOrderBlock();
    }];
    [self addSubview:checkBtn];
    
    UIButton *returnBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(396, 900, 288, 90) NormalBackgroundImageString:@"pay_return_home_page_btn" tapAction:^(UIButton *button) {
        self.clickReturnBlock();
    }];
    [self addSubview:returnBtn];
}
#pragma mark --- set
- (void)setOrderModel:(MyOrderModel *)orderModel {
    _orderModel = orderModel;
    self.moneyLabel.text = [NSString stringWithFormat:@"订单金额 ￥%@",orderModel.needPayMoney];
}

- (void)setNeedPayMoney:(NSString *)needPayMoney {
    _needPayMoney = needPayMoney;
    self.moneyLabel.text = [NSString stringWithFormat:@"订单金额 ￥%@",needPayMoney];
}
#pragma mark --- lazy load
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 60, 720, 28) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:28];
    }
    return _moneyLabel;
}
@end
