//
//  OrderConfirmationView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "OrderConfirmationView.h"

#import "GoodsModel.h"
#import "ActivityModel.h"
#import "NSArray+MMArrayCategory.h"
#import "UIImageView+WebCache.h"
@interface OrderConfirmationView ()
{
    BOOL *_isAll;
    
    UIButton *_tempBtn;
}
/** 车的图片*/
@property (nonatomic,strong) UIImageView *bikeImageView;

/** 车的名称系列*/
@property (nonatomic,strong) UILabel *bikeLabel;

/** 车的颜色*/
@property (nonatomic,strong) UILabel *colorLabel;

/** 车的返现*/
@property (nonatomic,strong) UILabel *refundLabel;

/** 支付类型*/
@property (nonatomic,strong) UILabel *paymentTypeLabel;

/** 已选活动*/
@property (nonatomic,strong) UILabel *activityLabel;

/** 付款*/
@property (nonatomic,strong) UILabel *shouldPayLabel;

/** 选择支付方式的view*/
/** 支付全额*/
@property (nonatomic,strong) UIButton *payAllBtn;
/** 支付一部分*/
@property (nonatomic,strong) UIButton *payLittleBtn;
@end
@implementation OrderConfirmationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    }
    return self;
}
- (void)setupCustomView {
    [self addSubview:self.bikeImageView];
    [self addSubview:self.bikeLabel];
    
    NSArray *tempArray = @[@"颜色",@"奖金",@"支付类别"];
    for (int i = 0; i < tempArray.count; i++) {
        UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(0 + 240*i, 348 + 6, 240, 24) title:tempArray[i] titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentCenter font:24];
        [self addSubview:textLabel];
        if (i > 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(240 * i, 348, 1, 80)];
            lineView.backgroundColor = kColorFor83;
            [self addSubview:lineView];
        }
    }
    
    [self addSubview:self.colorLabel];
    [self addSubview:self.refundLabel];
    [self addSubview:self.paymentTypeLabel];
    [self addSubview:self.shouldPayLabel];
    [self addSubview:self.activityLabel];
    [self addSubview:self.paymentTypeLabel];
    
//    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake720(0, 726, 720, 20)];
//    grayView.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
//    [self addSubview:grayView];
    
}
#pragma mark --- private method
- (void)clickRefresh:(UIButton *)sender {

    if (sender == _tempBtn) {
        return;
    }
    _tempBtn.selected = NO;
    sender.selected = YES;
    _tempBtn = sender;
    
    if (self.payAllBtn.selected) {
        self.paymentTypeLabel.text = @"支付全额";
        NSString *needPay = [NSString stringWithFormat:@"合计: ￥%@",self.goodModel.price];
        self.shouldPayLabel.attributedText = [NSString changTitleColorWithString:needPay defaultColor:kColorForE60012 specifyColor:kColorForfff specifyRang:NSMakeRange(0, 3)];
        self.clickSelectPayTypeBlock(self.goodModel.price);
    } else {
        self.paymentTypeLabel.text = @"支付押金";
        NSInteger money =  [self.activityModel.refund integerValue] + [self.goodModel.price integerValue]/50 ;
        NSString *needPay = [NSString stringWithFormat:@"合计: ￥%ld",money];
        self.shouldPayLabel.attributedText = [NSString changTitleColorWithString:needPay defaultColor:kColorForE60012 specifyColor:kColorForfff specifyRang:NSMakeRange(0, 3)];
        self.clickSelectPayTypeBlock( [NSString stringWithFormat:@"%ld",money]);
    }
    
}
#pragma mark --- set
- (void)setGoodModel:(GoodsModel *)goodModel {
    _goodModel = goodModel;
    
    if (goodModel.share_image.length >2) {
    
        NSArray *array = [goodModel.share_image componentsSeparatedByString:@","];
        
        if (array.count >= self.colorPage && array.count != 0 ) {
            if ([array objectAtIndexCheck:self.colorPage])
            {
                NSString *bikeImageUrl = array[self.colorPage];
                if ([bikeImageUrl isExist]) {
                    [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:bikeImageUrl ]];
                } else {
                    [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image]];
                }
            }
            else
            {
                [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image]];
            }
           
            
        } else {
            [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image]];
        }
    }else {
        [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image]];
    }
    
    self.bikeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",goodModel.brand,goodModel.series,goodModel.model];
    NSString *needPay = [NSString stringWithFormat:@"合计: ￥%@",goodModel.price];
    self.shouldPayLabel.attributedText = [NSString changTitleColorWithString:needPay defaultColor:kColorForE60012 specifyColor:kColorForfff specifyRang:NSMakeRange(0, 3)];
    if ([goodModel.pay_type isEqualToString:@"2"]) {
        [self addSubview:self.payAllBtn];
        [self addSubview:self.payLittleBtn];
        self.payAllBtn.selected = YES;
        _tempBtn = self.payAllBtn;
        if (![self.activityModel.information isExist]) {
            self.payAllBtn.top = 470*SizeScale;
            self.payLittleBtn.top = 470*SizeScale;
        }
        self.shouldPayLabel.top = self.payAllBtn.bottom + 48*SizeScale;
    }
}
- (void)setActivityModel:(ActivityModel *)activityModel {
    _activityModel = activityModel;
    self.refundLabel.text = [NSString stringWithFormat:@"￥%@",activityModel.refund];
    if (![activityModel.refund isExist]) {
        self.refundLabel.text = @"￥0";
    }
    self.paymentTypeLabel.text = @"支付全额";
    NSString *activity = [NSString stringWithFormat:@"已选活动: %@",activityModel.information];
    if (![activityModel.information isExist]) {
        //self.activityLabel.text = @"已选活动: 无";
        self.activityLabel.hidden = YES;
        self.shouldPayLabel.top = 470*SizeScale;
    }
    self.activityLabel.attributedText = [NSString changFontWithString:activity defaultFont:28*SizeScale specifyFont:24*SizeScale defaultColor:kColorForfff specifyColor:kColorForE60012 specifyRang:NSMakeRange(0, 5)];
}
- (void)setColor:(NSString *)color {
    _color = color;
    self.colorLabel.text = color;
}
#pragma mark --- lazy load
- (UIImageView *)bikeImageView {
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(218, 40, 284, 200)];
        _bikeImageView.image = [UIImage imageNamed:@"address_default_image"];
        _bikeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bikeImageView;
}
- (UILabel *)bikeLabel {
    if (!_bikeLabel) {
        _bikeLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 276, 720, 25) title:@"按时发放看公告" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:22];
    }
    return _bikeLabel;
}
- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 400, 240, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:22];
    }
    return _colorLabel;
}
- (UILabel *)refundLabel {
    if (!_refundLabel) {
        _refundLabel = [UILabel qd_labelWithFrame:CGRectMake720(240, 400, 240, 28) title:@"baise" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:22];
    }
    return _refundLabel;
}
- (UILabel *)paymentTypeLabel {
    if (!_paymentTypeLabel) {
        _paymentTypeLabel = [UILabel qd_labelWithFrame:CGRectMake720(480, 400, 240, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:22];
    }
    return _paymentTypeLabel;
}
- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(54, 500, 612, 80) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:22];
        _activityLabel.layer.borderColor = kColorFor83.CGColor;
        _activityLabel.layer.borderWidth = 1*SizeScaleSubjectTo720;
        _activityLabel.layer.cornerRadius = 8*SizeScaleSubjectTo720;
    }
    return _activityLabel;
}
- (UILabel *)shouldPayLabel {
    if (!_shouldPayLabel) {
        _shouldPayLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 640, 720, 32) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:28];
    }
    return _shouldPayLabel;
}
- (UIButton *)payAllBtn {
    if (!_payAllBtn) {
        _payAllBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(114, 636, 164, 45) title:@"支付全额" titleColor:kColorForfff titleFont:28 backgroundColor:nil tapAction:^(UIButton *button) {
            [self clickRefresh:button];
        }];
        [_payAllBtn setImage:[UIImage imageNamed:@"good_select_activity_p"] forState:UIControlStateSelected];
        [_payAllBtn setImage:[UIImage imageNamed:@"good_select_activity_gray"] forState:UIControlStateNormal];
    }
    return _payAllBtn;
}
- (UIButton *)payLittleBtn {
    if (!_payLittleBtn) {
        _payLittleBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(442, 636, 164, 45) title:@"支付押金" titleColor:kColorForfff titleFont:28 backgroundColor:nil tapAction:^(UIButton *button) {
            [self clickRefresh:button];
        }];
        [_payLittleBtn setImage:[UIImage imageNamed:@"good_select_activity_p"] forState:UIControlStateSelected];
        [_payLittleBtn setImage:[UIImage imageNamed:@"good_select_activity_gray"] forState:UIControlStateNormal];
    }
    return _payLittleBtn;
}
//- (UIView *)selectPayTypeView {
//    if (!_selectPayTypeView) {
//        _selectPayTypeView = [[UIView alloc]initWithFrame:CGRectMake720(0, 656, 720, 28)];
//    }
//    return _selectPayTypeView;
//}
@end
