//
//  MineBillInfoTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/12/2.
//  Copyright © 2016年 manman. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "MineBillInfoTableViewCell.h"
#import "MJExtension.h"

@interface MineBillInfoTableViewCell()

@property (nonatomic,strong) UILabel *billNumLabel;

@property (nonatomic,strong) UILabel *orderStatusLabel;

@property (nonatomic,strong) UIImageView *bikeImageView;

@property (nonatomic,strong) UILabel *bikeNameLabel;

@property (nonatomic,strong) UILabel *colorLabel;

@property (nonatomic,strong) UILabel *orderMoneyLabel;


@property (nonatomic,strong) UIView *dateBackgroundView;
@property (nonatomic,strong) UILabel *dateTitleLabel;
@property (nonatomic,strong) UILabel *dateLabel;



@property (nonatomic,strong) UIButton *commentGoodsButton;

@property (nonatomic,strong) UIButton *commentActivityButton;

@property (nonatomic,strong) UIButton *checkLogisticsButton;

@property (nonatomic,strong) UIButton *returnPayButton;

@property (nonatomic,strong) UIButton *payButton;

@property (nonatomic,strong) UIButton *deleteBillButton;




@end

@implementation MineBillInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        [self registerNSNotificationCenter];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
    
}
- (void)loadCellView {
 
    /**
     *  订单编号 左上角
     */
   
    [self.contentView addSubview:self.billNumLabel];
    
    /**
     * 待付款 右上角
     */
    
    [self.contentView addSubview:self.orderStatusLabel];
    
    /**
     *  自行车 图片
     */
    [self.contentView addSubview:self.bikeImageView];
    
    
    /**
     *  自行车 名称 系列  型号
     */
    
    [self.contentView addSubview:self.bikeNameLabel];
    
    /**
     *  奖金
     */
   
    [self.contentView addSubview:self.orderMoneyLabel];
    
    /**
     *  实付 金额
     */
   
    [self.contentView addSubview:self.orderMoneyLabel];
    
    
    [self.contentView addSubview:self.colorLabel];
    
    
    /**
     *  添加商品评价
     */

    [self.contentView addSubview:self.commentGoodsButton];
    
    /**
     *  追加活动评价
     */
    
    [self.contentView addSubview:self.commentActivityButton];
    
    
    /**
     *  删除订单
     */
    [self.contentView addSubview:self.deleteBillButton];
    
    /**
     *  查看物流
     */
    [self.contentView addSubview:self.checkLogisticsButton];
    
    /**
     *  退款详情
     */
    [self.contentView addSubview:self.returnPayButton];
    
    /**
     *  去支付
     */
    [self.contentView addSubview:self.payButton];
    
    [self.contentView addSubview:self.dateBackgroundView];
    [self setDateBackgroundViewAutolayout];
    
    
}

- (void)setDateBackgroundViewAutolayout
{
    [self.dateBackgroundView addSubview:self.dateTitleLabel];
    [self.dateBackgroundView addSubview:self.dateLabel];
    
}



- (void)setOrderUpdateModel:(MyOrderModel *)orderUpdateModel
{
    _orderUpdateModel = orderUpdateModel;
    //[shopLogoImageView sd_setImageWithURL:[NSURL URLWithString:model.brandImg]];
    self.billNumLabel.text = [[NSString alloc]initWithFormat:@"订单编号:%@",orderUpdateModel.orderId];
    [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:orderUpdateModel.image] placeholderImage:[UIImage imageNamed:@"orders_bike_default_image"]];
    self.bikeNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",orderUpdateModel.brand,orderUpdateModel.series,orderUpdateModel.model];

    self.colorLabel.text = [NSString stringWithFormat:@"颜色:%@",orderUpdateModel.color];
    
    //self.rewardLabel.text = [NSString stringWithFormat:@"奖金:￥%@",model.bonus];
    self.orderMoneyLabel.text = [NSString stringWithFormat:@"实付金额:￥%.2f",orderUpdateModel.needPayMoney.floatValue];
    //shopNameLabel.text = model.shopName;
    
    self.status = [orderUpdateModel.status integerValue];
    NSLog(@" order state %@",orderUpdateModel.status);
    
    [self activityCountdownDate:_orderUpdateModel.c_time];
    //self.dateLabel = @"";
    
    
}


- (void)setStatus:(OrderStatus)status {
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    _returnPayButton.hidden = YES;
    _deleteBillButton.hidden = YES;
    _commentGoodsButton.hidden = YES;
    _commentActivityButton.hidden = YES;
    _payButton.hidden = YES;
    _checkLogisticsButton.hidden = YES;
    _dateBackgroundView.hidden = YES;
    switch (status) {
        case OrderWaitPay:
            _payButton.hidden = NO;
            _orderStatusLabel.text = @"待付款";
            _dateBackgroundView.hidden = NO;
            break;
        case OrderHavePay:
            _orderStatusLabel.text = @"备货中";
            _commentActivityButton.hidden = YES;
            _checkLogisticsButton.hidden = NO;
            break;
        case OrderRefund:
            _orderStatusLabel.text = @"退款中";
             _returnPayButton.hidden = NO;
            break;
        case OrderWaitComment:
            //orderStatusLabel.text = @"交易成功";
            //leftBtn.hidden = NO;
            _orderStatusLabel.text = @"交易成功";
            if ([self.orderUpdateModel.actiC integerValue] == 0 && ![self.orderUpdateModel.activity_id isEqualToString:@"-1"]) {
                _commentActivityButton.hidden = NO;
            } else {
                _commentGoodsButton.left = _commentActivityButton.left;
            }
            if ([self.orderUpdateModel.actiC integerValue] >=1) {
                [_commentActivityButton setTitle:@"追加活动评价" forState:UIControlStateNormal];
            }
            if ([self.orderUpdateModel.actiCItem integerValue] >= 1) {
                 [_commentGoodsButton setTitle:@"追加商品评价" forState:UIControlStateNormal];
            }
            _commentGoodsButton.hidden = NO;
            //rightBtn.hidden = NO;
            // 添加刷新运动页面
            [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
            break;
        case OrderHaveComment:
            _orderStatusLabel.text = @"交易成功";
            if ([self.orderUpdateModel.actiC integerValue] >= 1 && [self.orderUpdateModel.actiCItem integerValue] >=1) {
                
                _commentActivityButton.hidden = NO;
                [_commentActivityButton setTitle:@"追加活动评价" forState:UIControlStateNormal];
                _commentGoodsButton.hidden = NO;
                [_commentGoodsButton setTitle:@"追加商品评价" forState:UIControlStateNormal];
                
                _orderStatusLabel.text = @"交易成功";
            }
            // 添加刷新运动页面
            [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
            break;
        case OrderAgreeRefund:
            _orderStatusLabel.text = @"同意退款";
             _checkLogisticsButton.hidden = NO;
            break;
        case OrderHaveRefund:
            _orderStatusLabel.text = @"退款成功";
             _checkLogisticsButton.hidden = NO;
            break;
        case OrderPrepareGood:
            _orderStatusLabel.text = @"备货中";
            _checkLogisticsButton.hidden = NO;
            break;
        case OrderNeedExtract:
            _checkLogisticsButton.hidden = NO;
            _orderStatusLabel.text = @"可提取";
            break;
        case OrderHaveExtract:
            _orderStatusLabel.text = @"交易成功";
            if ([self.orderUpdateModel.actiC integerValue] == 0 && ![self.orderUpdateModel.activity_id isEqualToString:@"-1"]) {
                _commentActivityButton.hidden = NO;
                _commentGoodsButton.hidden = NO;
                //orderStatusLabel.text = @"未评价";
            } else {
                _commentGoodsButton.hidden = NO;
                _commentGoodsButton.left = _commentActivityButton.left;
                _commentActivityButton.hidden = YES;
            }
            break;
        case OrderHaveShipping:
            _checkLogisticsButton.hidden = NO;
            _orderStatusLabel.text = @"已发货";
            break;
        case OrderClose:
            _orderStatusLabel.text = @"交易关闭";
            _deleteBillButton.hidden = NO;
            break;
        case OrderPaySome:
            //orderStatusLabel.text = @"备货中";
            //logisticsBtn.hidden = NO;
            _payButton.hidden = NO;
            _dateBackgroundView.hidden = NO;
            _orderStatusLabel.text = @"待付款";
            break;
        case OrderCancel:
            _orderStatusLabel.text = @"取消订单";
            break;
        case OrderTemporary:
            //orderStatusLabel.text = @"取消订单";
            _payButton.hidden = NO;
            _dateBackgroundView.hidden = NO;
            break;
        default:
            break;
    }
}


#pragma --------lazyload--------start

- (void)PayButtonAction
{
    
    NSLog(@"点击 支付  ...");
    
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:kMineBillInfoPayAction,kMineBillInfoPayAction,nil];
    self.minBillInfoActin(requestDic,self.orderUpdateModel);
    
}


- (void)CommentGoodsButtonAction
{
    NSLog(@"点击 商品 评论  ...");
     NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:kMineBillInfoCommentGoodsAction,kMineBillInfoCommentGoodsAction,nil];
    self.minBillInfoActin(requestDic,self.orderUpdateModel);
}

- (void)CommentActivityButtonAction
{
    NSLog(@"点击 评价 活动 ...");
     NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:kMineBillInfoCommentActivityAction,kMineBillInfoCommentActivityAction,nil];
    self.minBillInfoActin(requestDic,self.orderUpdateModel);
}


- (void)checkLogisticsButtonAction
{
    NSLog(@"点击 查看物流 ...");
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:kMineBillInfoLogisticsButtonAction,kMineBillInfoLogisticsButtonAction,nil];
    self.minBillInfoActin(requestDic,self.orderUpdateModel);
    
    
    
}

- (void)DeleteBillButtonAction
{
    NSLog(@" 点击  删除  订单 ...");
     NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:kMineBillInfoDeleteBillAction,kMineBillInfoDeleteBillAction,nil];
    self.minBillInfoActin(requestDic,self.orderUpdateModel);
    
    
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_ORDERLIST_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ORDERLIST_TIME_CELL object:nil];
}


- (void)notificationCenterEvent:(id)sender {
    
    
   // NSLog(@" 更改 时间倒计时  ...  ");
    
    
    //    if (self.m_isDisplayed) {
    //        [self loadData:self.m_data indexPath:self.m_tmpIndexPath];
    //    }
    [self activityCountdownDate:_orderUpdateModel.c_time];
    
    
}


- (void)activityCountdownDate:(NSString *)endTime
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *taskfinishDateMonthStr = [NSString stringWithFormat:@"%@",endTime];
    NSDate *currentShowDate = [dateFormatter dateFromString:taskfinishDateMonthStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:currentShowDate];
    NSDate *localEndDate = [currentShowDate dateByAddingTimeInterval:interval];
    //NSLog(@"localDate :%@",localEndDate);
    
    NSTimeInterval secondsInterval =  [self compareSatrtDate:[NSDate date] andEndTime:localEndDate];
    
    //self.dateIntervalStr = [NSString stringWithFormat:@"%@",dateInterval];
    
    //[self.timekeeping fire];
    
    NSString *remainDateStr = [self lessSecondToDay:secondsInterval];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",remainDateStr];
    
    
    
}

- ( NSTimeInterval )compareSatrtDate:(NSDate *) startDate  andEndTime:(NSDate *) endDate
{
    
    
    
    NSTimeInterval startInterval =[startDate timeIntervalSince1970];
    
    NSTimeInterval endInterval =[endDate timeIntervalSince1970];
    
    NSTimeInterval secondsInterval =startInterval - endInterval;
    
    if (24*60*60 >= secondsInterval) {
        secondsInterval = 24 *60 *60 -secondsInterval;
    }else
    {
        secondsInterval = 0;
    }
    
    
    return secondsInterval;
    
}


- (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    //NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
   // NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@"%02lu时:%02lu分",(unsigned long)hour,(unsigned long)min];
    return time;
    
}








#pragma lazyload


- (UILabel *)billNumLabel
{
    if (!_billNumLabel) {
          _billNumLabel = [UILabel qd_labelWithFrame:CGRectMake750(20, 54,500, 26) title:@"订单编号:" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight font:28];
        _billNumLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _billNumLabel;

}

- (UILabel *)orderStatusLabel
{
    if (!_orderStatusLabel) {
         _orderStatusLabel = [UILabel qd_labelWithFrame:CGRectMake750(450, 54, 230, 26) title:@"待付款" titleColor:UIColorFromRGB_16(0x35a4da) textAlignment:NSTextAlignmentRight font:28];
    }
    return _orderStatusLabel;
}

- (UIImageView *)bikeImageView
{
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc] initWithFrame:CGRectMake750(36, 125, 168, 168)];
        _bikeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bikeImageView;
    
    
}

- (UILabel *)bikeNameLabel
{
    if (!_bikeNameLabel) {
        _bikeNameLabel = [UILabel qd_labelWithFrame:CGRectMake750(242, 145, 470, 26) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _bikeNameLabel;
}

- (UILabel *)colorLabel
{
    if (!_colorLabel) {
        _colorLabel = [UILabel qd_labelWithFrame:CGRectMake750(242, 175, 200, 26) title:@"颜色:白绿" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:24];
    }
    
    return _colorLabel;
    
}

- (UILabel *)orderMoneyLabel
{
    if (!_orderMoneyLabel) {
       _orderMoneyLabel = [UILabel qd_labelWithFrame:CGRectMake750(400, 210, 310, 29) title:@"实付金额:¥1288.00" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _orderMoneyLabel;
    
}

- (UIButton *)commentGoodsButton
{
    if (!_commentGoodsButton) {
        _commentGoodsButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(218, 300, 216, 56) title:@"发表商品评价" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            
            [self CommentGoodsButtonAction];
        }];
        [_commentGoodsButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _commentGoodsButton;
    
}

- (UIButton *)commentActivityButton
{
    if (!_commentActivityButton) {
        _commentActivityButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(468, 300, 216, 60) title:@"发表活动评价" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self CommentActivityButtonAction];
        }];
        [_commentActivityButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _commentActivityButton;
    
}


- (UIButton *)checkLogisticsButton
{
    if (!_checkLogisticsButton) {
        _checkLogisticsButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(468, 300, 216, 60) title:@"查看物流" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self checkLogisticsButtonAction];
        }];
        [_checkLogisticsButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _checkLogisticsButton;

}


- (UIButton *)returnPayButton
{
    if (!_returnPayButton) {
        _returnPayButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(468, 300, 216, 60) title:@"退款详情" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self checkLogisticsButtonAction];
        }];
        [_returnPayButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _returnPayButton;
    
}



- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(468, 300, 216, 60) title:@"去支付" titleColor:kColorForfff titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self PayButtonAction];
        }];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"order_red_btn"] forState:UIControlStateNormal];
    }
    return _payButton;
    
}


- (UIButton *)deleteBillButton
{
    if (!_deleteBillButton) {
        _deleteBillButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(468, 300, 216, 60) title:@"删除订单" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self DeleteBillButtonAction];
        }];
        [_deleteBillButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    
    return _deleteBillButton;
    
}


- (UIView *)dateBackgroundView
{
    if (!_dateBackgroundView) {
        _dateBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(234, 300, 210, 60)];
        _dateBackgroundView.backgroundColor = [UIColor blackColor];
        
        
    }
    return _dateBackgroundView;
    
}

- (UIView *)dateTitleLabel
{
    if (!_dateTitleLabel) {
        _dateTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,30,210,24)];
        _dateTitleLabel.textColor = [UIColor whiteColor];
        _dateTitleLabel.font = [UIFont systemFontOfSize:26*SizeScale750];
        _dateTitleLabel.text = @"订单自动取消";
    }
    return _dateTitleLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,0, 210,24)];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont systemFontOfSize:26*SizeScale750];
        _dateLabel.text = @"22小时23分后";
    }
    return _dateLabel;

}



- (void)dealloc
{
    
    [self removeNSNotificationCenter];
    
}

/**
 *@property (nonatomic,strong) UIView *dateBackgroundView;
 @property (nonatomic,strong) UILabel *dateTitleLabel;
 @property (nonatomic,strong) UILabel *dateLabel;
 */



@end
