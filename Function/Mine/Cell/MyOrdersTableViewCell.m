//
//  MyOrdersTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  不是本人写的，勿喷

#import "MyOrdersTableViewCell.h"
#import "MyOrderModel.h"
#import "UIImageView+WebCache.h"
@implementation MyOrdersTableViewCell
{
    /** 品牌的logo*/
    UIImageView *shopLogoImageView;
    /** 商店的名字*/
    UILabel *shopNameLabel;
    /** 订单的状态*/
    UILabel *orderStatusLabel;
    /** 车的图片*/
    UIImageView *bikeImageView;
    UILabel *bickNameLabel;
    /** 奖金*/
    UILabel *rewardLabel;
    /** 实际付款*/
    UILabel *oderMoneyLabel;
    //-----评价------//
    /** 右边的按钮*/
    UIButton *rightBtn;
    /** 左边的按钮*/
    UIButton *leftBtn;
    //-----支付------//
    UIButton *payBtn;
    //-----物流------//
    UIButton *logisticsBtn;
    
    
    UILabel *billNumLabel;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x838383).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1*SizeScaleSubjectTo720));
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
//    shopLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake720(36, 46, 110, 35)];
//    shopLogoImageView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:shopLogoImageView];
//    
//    shopNameLabel = [UILabel qd_labelWithFrame:CGRectMake720(156, 46, 350, 35) title:@"" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:24];
//    [self addSubview:shopNameLabel];
    

    /**
     *  订单编号 左上角
     */
    billNumLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 54,400, 26) title:@"订单编号:" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight font:28];
    [self addSubview:billNumLabel];
    
    /**
     * 待付款 右上角
     */
    orderStatusLabel = [UILabel qd_labelWithFrame:CGRectMake720(450, 54, 230, 26) title:@"待付款" titleColor:UIColorFromRGB_16(0x35a4da) textAlignment:NSTextAlignmentRight font:28];
    [self addSubview:orderStatusLabel];
    
    /**
     *  自行车 图片
     */
    
    bikeImageView = [[UIImageView alloc] initWithFrame:CGRectMake720(36, 125, 168, 168)];
    bikeImageView.contentMode = UIViewContentModeScaleAspectFit;
    //bikeImageView.backgroundColor = [UIColor brownColor];
    [self addSubview:bikeImageView];
    
    
    /**
     *  自行车 名称 系列  型号
     */
    bickNameLabel = [UILabel qd_labelWithFrame:CGRectMake720(242, 145, 470, 26) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    [self addSubview:bickNameLabel];
    
    /**
     *  奖金
     */
    rewardLabel = [UILabel qd_labelWithFrame:CGRectMake720(242, 210, 259, 29) title:@"奖金: " titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    [self addSubview:rewardLabel];
    
    /**
     *  实付 金额
     */
    oderMoneyLabel = [UILabel qd_labelWithFrame:CGRectMake720(468, 210, 210, 29) title:@"奖金: " titleColor:kColorForccc textAlignment:NSTextAlignmentRight font:26];
    [self addSubview:oderMoneyLabel];
    

    /**
     *  添加商品评价
     */
    leftBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(218, 300, 216, 56) title:@"追加商品评价" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
        [self clickAddGoodComment];
    }];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    [self addSubview:leftBtn];
    
    /**
     *  追加活动评价
     */
    rightBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(468, 300, 216, 56) title:@"追加活动评价" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
        [self clickAddActivityComment];
    }];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    [self addSubview:rightBtn];

    /**
     *  查看物流
     */
    logisticsBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(468, 300, 216, 56) title:@"查看物流" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
        [self clickCheckLogistics];
    }];
    [logisticsBtn setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    logisticsBtn.hidden = YES;
    [self addSubview:logisticsBtn];
    
    /**
     *  去支付
     */
    payBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(468, 300, 216, 56) title:@"去支付" titleColor:kColorForfff titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
        [self clickPay];
    }];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"order_red_btn"] forState:UIControlStateNormal];
    payBtn.hidden = YES;
    [self addSubview:payBtn];
}


#pragma mark --- set
- (void)setModel:(MyOrderModel *)model {
    _model = model;
    //[shopLogoImageView sd_setImageWithURL:[NSURL URLWithString:model.brandImg]];
    billNumLabel.text = [[NSString alloc]initWithFormat:@"订单编号:%@",model.orderId];
    [bikeImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"orders_bike_default_image"]];
    bickNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.brand,model.series,model.model,model.color];
    rewardLabel.text = [NSString stringWithFormat:@"奖金:￥%@",model.bonus];
    oderMoneyLabel.text = [NSString stringWithFormat:@"实付:￥%@",model.needPayMoney];
    //shopNameLabel.text = model.shopName;
    
    self.status = [model.status integerValue];
}

- (void)setStatus:(OrderStatus)status {
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    leftBtn.hidden = YES;
    rightBtn.hidden = YES;
    payBtn.hidden = YES;
    logisticsBtn.hidden = YES;
    switch (status) {
        case OrderWaitPay:
            payBtn.hidden = NO;
            orderStatusLabel.text = @"待付款";
            break;
        case OrderHavePay:
            orderStatusLabel.text = @"备货中";
            rightBtn.hidden = YES;
            logisticsBtn.hidden = NO;
            break;
        case OrderRefund:
            orderStatusLabel.text = @"退款中";
            break;
        case OrderWaitComment:
            //orderStatusLabel.text = @"交易成功";
            //leftBtn.hidden = NO;
            orderStatusLabel.text = @"交易成功";
            if ([self.model.actiC integerValue] == 0 && ![self.model.activity_id isEqualToString:@"-1"]) {
                rightBtn.hidden = NO;
            } else {
                leftBtn.left = rightBtn.left;
            }
            leftBtn.hidden = NO;
            //rightBtn.hidden = NO;
            // 添加刷新运动页面
            [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
            break;
        case OrderHaveComment:
            orderStatusLabel.text = @"交易成功";
            if ([self.model.actiC integerValue] == 0 && ![self.model.activity_id isEqualToString:@"-1"]) {
                rightBtn.hidden = NO;
                orderStatusLabel.text = @"交易成功";
            }
            // 添加刷新运动页面
            [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
            break;
        case OrderAgreeRefund:
            orderStatusLabel.text = @"同意退款";
            break;
        case OrderHaveRefund:
            orderStatusLabel.text = @"退款成功";
            break;
        case OrderPrepareGood:
            orderStatusLabel.text = @"备货中";
            logisticsBtn.hidden = NO;
            break;
        case OrderNeedExtract:
            logisticsBtn.hidden = NO;
            orderStatusLabel.text = @"可提取";
            break;
        case OrderHaveExtract:
            orderStatusLabel.text = @"交易成功";
            if ([self.model.actiC integerValue] == 0 && ![self.model.activity_id isEqualToString:@"-1"]) {
                rightBtn.hidden = NO;
                leftBtn.hidden = NO;
                //orderStatusLabel.text = @"未评价";
            } else {
                leftBtn.hidden = NO;
                leftBtn.left = rightBtn.left;
                rightBtn.hidden = YES;
            }
            break;
        case OrderHaveShipping:
            logisticsBtn.hidden = NO;
            orderStatusLabel.text = @"已发货";
            break;
        case OrderClose:
            orderStatusLabel.text = @"交易关闭";
            break;
        case OrderPaySome:
            //orderStatusLabel.text = @"备货中";
            //logisticsBtn.hidden = NO;
            payBtn.hidden = NO;
            orderStatusLabel.text = @"待付款";
            break;
        case OrderCancel:
            orderStatusLabel.text = @"取消订单";
            break;
        case OrderTemporary:
            //orderStatusLabel.text = @"取消订单";
            payBtn.hidden = NO;
            break;
        default:
            break;
    }
}

/** 添加商品评价*/
- (void)clickAddGoodComment {
    [self.delegate clickAddGoodCommentWithModel:self.model];
}
/** 添加活动评价*/
- (void)clickAddActivityComment {
    [self.delegate clickAddActivityCommentWithModel:self.model];
}
#pragma mark --- private method
- (void)clickPay {
    [self.delegate clickPayWithModel:self.model];
}
- (void)clickCheckLogistics {
    [self.delegate clickCheckLogisticsWithModel:self.model];
}

@end
