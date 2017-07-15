//
//  BillFeeInfoView.m
//  QiDai
//
//  Created by manman'swork on 16/12/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "BillFeeInfoView.h"
#import "MJExtension.h"

@interface BillFeeInfoView()


@property (nonatomic,strong) NSString *takeNumStr;

@property (nonatomic,strong) NSString *turnoverDateStr;

@property (nonatomic,strong) NSString *createBillDateStr;

@property (nonatomic,strong) NSString *actuallypaidStr;

@property (nonatomic,strong) NSString *paymentTypeStr;

@property (nonatomic,strong) NSString *goodsPrices;

@property (nonatomic,strong) NSString *expressFeeStr;

@property (nonatomic,strong) NSString *assembleFeeStr;



@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong)UILabel *billFeeTitleLabel;

/**
 *  组装费
 */
@property (nonatomic,strong) UIImageView *assembleFlageImageView;

@property (nonatomic,strong) UILabel *assembleTitleLable;

@property (nonatomic,strong) UILabel *assembleLable;


/**
 *  快递费
 */
@property (nonatomic,strong) UIImageView *expressFlageImageView;

@property (nonatomic,strong) UILabel *expressTitleLable;

@property (nonatomic,strong) UILabel *expressLable;


/**
 *  商品价格
 */
@property (nonatomic,strong) UIImageView *goodsPriceFlageImageView;

@property (nonatomic,strong) UILabel *goodsPriceTitleLable;

@property (nonatomic,strong) UILabel *goodsPriceLable;


/**
 *  实付金额
 */
@property (nonatomic,strong) UIImageView *actuallypaidFlageImageView;

@property (nonatomic,strong) UILabel *actuallypaidTitleLabel;

@property (nonatomic,strong) UILabel *actuallypaidLabel;


/**
 *  支付类别
 */
@property (nonatomic,strong) UIImageView *paymentTypeFlageImageView;

@property (nonatomic,strong) UILabel *paymentTypeTitleLable;

@property (nonatomic,strong) UILabel *paymentTypeLable;



/**
 *  下单 时间  成交 时间
 */


@property (nonatomic,strong) UILabel *createBillDateTitleLable;

@property (nonatomic,strong) UILabel *createBillDateLable;


/**
 *  成交 时间
 */
@property (nonatomic,strong) UILabel *turnoverTitleLable;

@property (nonatomic,strong) UILabel *turnoverLable;


/**
 *  取货码
 */
@property (nonatomic,strong) UILabel *takeNumTitleLable;

@property (nonatomic,strong) UILabel *takeNumLable;





@end



@implementation BillFeeInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self customUIViewAutolayout];
        //[self updateUIViewAutolayout];
    }
    return self;
    
    
    
    
}


- (void)customUIViewAutolayout
{
    [self addSubview:self.backgroundView];
    
    [self addSubview:self.assembleFlageImageView];
    [self addSubview:self.assembleTitleLable];
    [self addSubview:self.assembleLable];
    
    [self addSubview:self.expressFlageImageView];
    [self addSubview:self.expressTitleLable];
    [self addSubview:self.expressLable];
    
    [self addSubview:self.goodsPriceFlageImageView];
    [self addSubview:self.goodsPriceTitleLable];
    [self addSubview:self.goodsPriceLable];
    
    [self addSubview:self.paymentTypeFlageImageView];
    [self addSubview:self.paymentTypeTitleLable];
    [self addSubview:self.paymentTypeLable];
    
    [self addSubview:self.actuallypaidFlageImageView];
    [self addSubview:self.actuallypaidTitleLabel];
    [self addSubview:self.actuallypaidLabel];
    
    
    [self addSubview:self.createBillDateLable];
    
    [self addSubview:self.createBillDateTitleLable];
    
    [self addSubview:self.turnoverLable];
    self.turnoverLable.hidden = YES;
    [self addSubview:self.turnoverTitleLable];
    self.turnoverTitleLable.hidden = YES;
    
    [self addSubview:self.takeNumTitleLable];
    self.takeNumTitleLable.hidden = YES;
    [self addSubview:self.takeNumLable];
    self.takeNumLable.hidden = YES;
    
  
}



- (void)setBillFeeParameter:(NSDictionary *)billFeeParameter
{
    
    /**
     *  填充数据  之后  设置页面  视图
     */
    if ([self.useInViewStr isEqualToString:kBillConfirmView]) {
        [self FillBillConfirmDatasources:billFeeParameter];
        
    }
    
    if ([self.useInViewStr isEqualToString:kBillDetailInfoView]) {
        [self FillBillDetailInfoDatasource:billFeeParameter];
        
    }
    
  
    
}

/**
 *  订单确认页面
 *
 *  @param datasourcesDic
 */

- (void)FillBillConfirmDatasources:(NSDictionary *)datasourcesDic
{
    [self updateUIViewAutolayout];
    NSString *assembleFeeStr = [datasourcesDic objectForKey:@"assembleFee"];
    NSString *expressFeeStr = [datasourcesDic objectForKey:@"expressFee"];
    NSString *goodsPrices = [datasourcesDic objectForKey:@"goodsPrices"];
    
    self.assembleLable.text = [NSString stringWithFormat:@"¥%.2f",assembleFeeStr.floatValue];
    self.expressLable.text = [NSString stringWithFormat:@"¥%.2f",expressFeeStr.floatValue];
    self.goodsPriceLable.text = [NSString stringWithFormat:@"¥%.2f",goodsPrices.floatValue];
    
}

/**
 *  订单详情
 *
 *  @param datasourcesDic
 */
- (void)FillBillDetailInfoDatasource:(NSDictionary *)datasourcesDic
{
    
       /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款
        6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 
        12 支付一部分 13 取消订单*/
    
    [self updateUIViewAutolayout];
    
    self.assembleFeeStr = [datasourcesDic objectForKey:@"assembleFee"];
    self.expressFeeStr = [datasourcesDic objectForKey:@"expressFee"];
    self.goodsPrices = [datasourcesDic objectForKey:@"goodsPrices"];
    self.paymentTypeStr = [datasourcesDic objectForKey:@"paymentType"];
    self.actuallypaidStr = [datasourcesDic objectForKey:@"actuallypaid"];
    self.createBillDateStr = [datasourcesDic objectForKey:@"createBillDate"];
    self.turnoverDateStr = [datasourcesDic objectForKey:@"turnoverDate"];
    self.takeNumStr = [datasourcesDic objectForKey:@"takeNum"];//takeNum
    NSLog(@"take num %@",[datasourcesDic objectForKey:@"takeNum"]);
    
    
    
    self.paymentTypeLable.text = _paymentTypeStr;
    self.actuallypaidLabel.text = [NSString stringWithFormat:@"¥%.2f",_actuallypaidStr.floatValue];
    self.takeNumLable.text = _takeNumStr;
    self.assembleLable.text = [NSString stringWithFormat:@"¥%.2f",_assembleFeeStr.floatValue] ;
    self.expressLable.text = [NSString stringWithFormat:@"¥%.2f",_expressFeeStr.floatValue];
    self.goodsPriceLable.text = [NSString stringWithFormat:@"¥%.2f",_goodsPrices.floatValue];
    
   
   
    /**
     *  下单时间 显示
     */
    if ([self.orderStateStr isEqualToString:@"0"]) {
        self.turnoverLable.hidden = YES;
        self.takeNumLable.hidden = YES;
        self.takeNumTitleLable.hidden = YES;
        self.createBillDateLable.text = self.createBillDateStr;
    }else
    {
        /**
         *  成交时间的显示
         */
        self.createBillDateLable.text = self.createBillDateStr;
        self.turnoverLable.text = self.turnoverDateStr;
        self.turnoverTitleLable.hidden = NO;
        self.turnoverLable.hidden = NO;
        self.takeNumLable.hidden = NO;
        self.takeNumTitleLable.hidden = NO;
    }
    if ([self.orderStateStr isEqualToString:@"8"]) {
        self.takeNumLable.text = self.takeNumStr;
        self.takeNumTitleLable.hidden = NO;
        self.takeNumLable.hidden = NO;
        
        
    }else
    {
        self.takeNumTitleLable.hidden = YES;
        self.takeNumLable.hidden = YES;
    }
    
    
    // [self setStatus:orderState];
    
    
}


- (void)setStatus:(NSInteger )status {
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
   
    switch (status) {
        case 0:
            
            break;
       
        default:
            
            break;
    }
}






/**
 *   现在  这个界面 需要在多个界面 使用  
     需要 在这个方法中 将每个界面的 使用 分开
 */
- (void)updateUIViewAutolayout
{
    if ([self.useInViewStr isEqualToString:kBillConfirmView]) {
        [self billConfirmUIViewAutolayout];
        
    }
    
    if ([self.useInViewStr isEqualToString:kBillDetailInfoView]) {
        [self billDetailInfoUIViewAutolayout];
        
    }
    
    
    
    
}


/**
 *  订单确认页面
 */
- (void)billConfirmUIViewAutolayout
{
    /**
     *
     * 默认设置 既可以
     *
     */
    
    [self addSubview:self.backgroundView];
    
    [self addSubview:self.assembleFlageImageView];
    [self addSubview:self.assembleTitleLable];
    [self addSubview:self.assembleLable];
    
    [self addSubview:self.expressFlageImageView];
    [self addSubview:self.expressTitleLable];
    [self addSubview:self.expressLable];
    
    [self addSubview:self.goodsPriceFlageImageView];
    [self addSubview:self.goodsPriceTitleLable];
    [self addSubview:self.goodsPriceLable];
    
  
    
    
}


/**
 *  订单  详情页
 */
- (void)billDetailInfoUIViewAutolayout
{
    CGRect backgroundViewFrame = self.backgroundView.frame;
    backgroundViewFrame.size.height = 830 *SizeScale750;
    self.backgroundView.frame = backgroundViewFrame;
    
    [self addSubview:self.billFeeTitleLabel];
    
    
    
    CGRect paymentTypeFlageImageViewFrame = self.paymentTypeFlageImageView.frame;
    paymentTypeFlageImageViewFrame.origin.y = 106 *SizeScale750;
    self.paymentTypeFlageImageView.frame = paymentTypeFlageImageViewFrame;
    
    CGRect paymentTypeTitleLableFrame = self.paymentTypeTitleLable.frame;
    paymentTypeTitleLableFrame.origin.y = 106 *SizeScale750;
    self.paymentTypeTitleLable.frame = paymentTypeTitleLableFrame;
    
    CGRect paymentTypeLableFrame = self.paymentTypeLable.frame;
    paymentTypeLableFrame.origin.y = 106 *SizeScale750;
    self.paymentTypeLable.frame = paymentTypeLableFrame;
    
    
    CGRect goodsPriceFlageImageViewFrame = self.goodsPriceFlageImageView.frame;
    goodsPriceFlageImageViewFrame.origin.y = 193 *SizeScale750;
    self.goodsPriceFlageImageView.frame = goodsPriceFlageImageViewFrame;
    
    CGRect goodsPriceTitleLableFrame = self.goodsPriceTitleLable.frame;
    goodsPriceTitleLableFrame.origin.y = 193 *SizeScale750;
    self.goodsPriceTitleLable.frame = goodsPriceTitleLableFrame;
    
    CGRect goodsPriceLableFrame = self.goodsPriceLable.frame;
    goodsPriceLableFrame.origin.y = 193 *SizeScale750;
    self.goodsPriceLable.frame = goodsPriceLableFrame;
    
    
    CGRect assembleFlageImageViewFrame = self.assembleFlageImageView.frame;
    assembleFlageImageViewFrame.origin.y = 280 *SizeScale750;
    self.assembleFlageImageView.frame = assembleFlageImageViewFrame;
    
    CGRect assembleTitleLableFrame = self.assembleTitleLable.frame;
    assembleTitleLableFrame.origin.y = 280 *SizeScale750;
    self.assembleTitleLable.frame = assembleTitleLableFrame;
    
    CGRect assembleLableFrame = self.assembleLable.frame;
    assembleLableFrame.origin.y = 280 *SizeScale750;
    self.assembleLable.frame = assembleLableFrame;
    
    
    
    CGRect expressFlageImageViewFrame = self.expressFlageImageView.frame;
    expressFlageImageViewFrame.origin.y = 366 *SizeScale750;
    self.expressFlageImageView.frame = expressFlageImageViewFrame;
    
    CGRect expressTitleLableFrame = self.expressTitleLable.frame;
    expressTitleLableFrame.origin.y = 366 *SizeScale750;
    self.expressTitleLable.frame = expressTitleLableFrame;
    
    CGRect expressLableFrame = self.expressLable.frame;
    expressLableFrame.origin.y = 366 *SizeScale750;
    self.expressLable.frame = expressLableFrame;
    
    
    
    CGRect actuallypaidFlageImageViewFrame = self.actuallypaidFlageImageView.frame;
    actuallypaidFlageImageViewFrame.origin.y = 452 *SizeScale750;
    self.actuallypaidFlageImageView.frame = actuallypaidFlageImageViewFrame;
    
    CGRect actuallypaidTitleLabelFrame = self.actuallypaidTitleLabel.frame;
    actuallypaidTitleLabelFrame.origin.y = 452 *SizeScale750;
    self.actuallypaidTitleLabel.frame = actuallypaidTitleLabelFrame;
    
    CGRect actuallypaidLabelFrame = self.actuallypaidLabel.frame;
    actuallypaidLabelFrame.origin.y = 452 *SizeScale750;
    self.actuallypaidLabel.frame = actuallypaidLabelFrame;
    
    
    /**
     *
        通过订单 状态   是否显示 下单时间   成交时间
     */
    
    CGRect createBillDateTitleLableFrame = self.createBillDateTitleLable.frame;
    createBillDateTitleLableFrame.origin.y = 553 *SizeScale750;
    self.createBillDateTitleLable.frame = createBillDateTitleLableFrame;
    
    CGRect createBillDateLableFrame = self.createBillDateLable.frame;
    createBillDateLableFrame.origin.y = 553 *SizeScale750;
    self.createBillDateLable.frame = createBillDateLableFrame;
    
    CGRect turnoverTitleLableFrame = self.turnoverTitleLable.frame;
    turnoverTitleLableFrame.origin.y = 620 *SizeScale750;
    self.turnoverTitleLable.frame = turnoverTitleLableFrame;
    
    CGRect turnoverLableFrame = self.turnoverLable.frame;
    turnoverLableFrame.origin.y = 620 *SizeScale750;
    self.turnoverLable.frame = turnoverLableFrame;
    
    CGRect takeNumTitleLableFrame = self.takeNumTitleLable.frame;
    takeNumTitleLableFrame.origin.y = 660 *SizeScale750;
    self.takeNumTitleLable.frame = takeNumTitleLableFrame;
    
    CGRect takeNumLableFrame = self.takeNumLable.frame;
    takeNumLableFrame.origin.y = 730 *SizeScale750;
    self.takeNumLable.frame = takeNumLableFrame;
    
    
    
   
    
}




#pragma --------lazyload


- (UILabel *)billFeeTitleLabel
{
    if (!_billFeeTitleLabel) {
        _billFeeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20,20, 750,25)];
        _billFeeTitleLabel.text = @"支付信息";
        _billFeeTitleLabel.font = [UIFont systemFontOfSize:26*SizeScale750];
        _billFeeTitleLabel.textColor = [UIColor grayColor];
    }
    
    return _billFeeTitleLabel;
    
    
    
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 0, 750, 270)];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;

}

- (UIImageView *)assembleFlageImageView
{
    if (!_assembleFlageImageView) {
        _assembleFlageImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20, 36,24,24)];
        _assembleFlageImageView.image = [UIImage imageNamed:@"ShopUpdateAssembleFeeImageView"];
    }
    
    return _assembleFlageImageView;
}

- (UILabel *)assembleTitleLable
{
    
    if (!_assembleTitleLable) {
        _assembleTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(50, 36, 100,26)];
        _assembleTitleLable.text = @"组装费";
        _assembleTitleLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _assembleTitleLable.textColor = [UIColor whiteColor];
    }
    return _assembleTitleLable;
}


- (UILabel *)assembleLable
{
    if (!_assembleLable) {
        _assembleLable = [[UILabel alloc]initWithFrame:CGRectMake750(600,36, 150, 26)];
        _assembleLable.text = @"¥888";
        _assembleLable.textAlignment = NSTextAlignmentRight;
        _assembleLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _assembleLable.textColor = [UIColor whiteColor];
    }
    return _assembleLable;
    
    
}


- (UIImageView *)expressFlageImageView
{
    if (!_expressFlageImageView) {
        _expressFlageImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20, 80,24,24)];
        _expressFlageImageView.image = [UIImage imageNamed:@"ShopUpdateExpressFlagImageView"];
        
    }
    
    return _expressFlageImageView;
}

- (UILabel *)expressTitleLable
{
    
    if (!_expressTitleLable) {
        _expressTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(50, 80, 100,26)];
        _expressTitleLable.text = @"快递费";
        _expressTitleLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _expressTitleLable.textColor = [UIColor whiteColor];
    }
    return _expressTitleLable;
}


- (UILabel *)expressLable
{
    if (!_expressLable) {
        _expressLable = [[UILabel alloc]initWithFrame:CGRectMake750(600,80, 150,26)];
        _expressLable.text = @"¥888";
        _expressLable.textAlignment = NSTextAlignmentRight;
        _expressLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _expressLable.textColor = [UIColor whiteColor];
    }
    return _expressLable;
    
    
}


- (UIImageView *)goodsPriceFlageImageView
{
    if (!_goodsPriceFlageImageView) {
        _goodsPriceFlageImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20,120,24,24)];
        _goodsPriceFlageImageView.image = [UIImage imageNamed:@"ShopUpdatePriceFlagImageView"];
    }
    
    return _goodsPriceFlageImageView;
}

- (UILabel *)goodsPriceTitleLable
{
    
    if (!_goodsPriceTitleLable) {
        _goodsPriceTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(50, 120, 150,26)];
        _goodsPriceTitleLable.text = @"商品金额";
        _goodsPriceTitleLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _goodsPriceTitleLable.textColor = [UIColor whiteColor];
    }
    return _goodsPriceTitleLable;
}


- (UILabel *)goodsPriceLable
{
    if (!_goodsPriceLable) {
        _goodsPriceLable = [[UILabel alloc]initWithFrame:CGRectMake750(600,120, 150,26)];
        _goodsPriceLable.text = @"¥888";
        _goodsPriceLable.textAlignment = NSTextAlignmentRight;
        _goodsPriceLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _goodsPriceLable.textColor = [UIColor whiteColor];
    }
    return _goodsPriceLable;
    
    
}




/**
 *  实付金额
 *
 */
- (UIImageView *)actuallypaidFlageImageView
{
    if (!_actuallypaidFlageImageView) {
        _actuallypaidFlageImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20,120,24,24)];
        _actuallypaidFlageImageView.image = [UIImage imageNamed:@"ShopUpdateActuallypaidFlagImageView"];
    }
    
    return _actuallypaidFlageImageView;
}

- (UILabel *)actuallypaidTitleLabel
{
    
    if (!_actuallypaidTitleLabel) {
        _actuallypaidTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(50, 120, 150, 27)];
        _actuallypaidTitleLabel.text = @"实付金额";
        _actuallypaidTitleLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _actuallypaidTitleLabel.textColor = [UIColor whiteColor];
    }
    return _actuallypaidTitleLabel;
}


- (UILabel *)actuallypaidLabel
{
    if (!_actuallypaidLabel) {
        _actuallypaidLabel = [[UILabel alloc]initWithFrame:CGRectMake750(600,120, 150,27)];
        _actuallypaidLabel.text = @"¥888";
        _actuallypaidLabel.textAlignment = NSTextAlignmentRight;
        _actuallypaidLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _actuallypaidLabel.textColor = [UIColor whiteColor];
    }
    return _actuallypaidLabel;
    
    
}

/**
 *
 *  支付类别
 */
- (UIImageView *)paymentTypeFlageImageView
{
    if (!_paymentTypeFlageImageView) {
        _paymentTypeFlageImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20,120,24,24)];
        _paymentTypeFlageImageView.image = [UIImage imageNamed:@"ShopUpdatePaymentTypeFlagImageView"];
    }
    
    return _paymentTypeFlageImageView;
}

- (UILabel *)paymentTypeTitleLable
{
    
    if (!_paymentTypeTitleLable) {
        _paymentTypeTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(50, 120, 150,27)];
        _paymentTypeTitleLable.text = @"支付类别";
        _paymentTypeTitleLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _paymentTypeTitleLable.textColor = [UIColor whiteColor];
    }
    return _paymentTypeTitleLable;
}


- (UILabel *)paymentTypeLable
{
    if (!_paymentTypeLable) {
        _paymentTypeLable = [[UILabel alloc]initWithFrame:CGRectMake750(550,120, 150, 27)];
        _paymentTypeLable.text = @"支付宝";
        _paymentTypeLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _paymentTypeLable.textColor = [UIColor whiteColor];
    }
    return _paymentTypeLable;
    
    
}


/**
 *  @property (nonatomic,strong) UILabel *createBillDateTitleLable;
 
 @property (nonatomic,strong) UILabel *createBillDateLable;
 
 
 
 @property (nonatomic,strong) UILabel *turnoverTitleLable;
 
 @property (nonatomic,strong) UILabel *turnoverLable;
 */


- (UILabel *)createBillDateTitleLable
{
    
    if (!_createBillDateTitleLable) {
        _createBillDateTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(50, 120, 150,27)];
        _createBillDateTitleLable.text = @"下单时间:";
        _createBillDateTitleLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _createBillDateTitleLable.textColor = [UIColor whiteColor];
    }
    return _createBillDateTitleLable;
}


- (UILabel *)createBillDateLable
{
    if (!_createBillDateLable) {
        _createBillDateLable = [[UILabel alloc]initWithFrame:CGRectMake750(220,120, 300, 27)];
        _createBillDateLable.text = @"2016－11-27 15:08:08";
        _createBillDateLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _createBillDateLable.textColor = [UIColor whiteColor];
    }
    return _createBillDateLable;
    
    
}


- (UILabel *)turnoverTitleLable
{
    
    if (!_turnoverTitleLable) {
        _turnoverTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(50, 180, 150, 27)];
        _turnoverTitleLable.text = @"成交时间:";
        _turnoverTitleLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _turnoverTitleLable.textColor = [UIColor whiteColor];
    }
    return _turnoverTitleLable;
}


- (UILabel *)turnoverLable
{
    if (!_turnoverLable) {
        _turnoverLable = [[UILabel alloc]initWithFrame:CGRectMake750(220,180, 300,27)];
        _turnoverLable.text = @"2016－11-27 15:08:08";
        _turnoverLable.font = [UIFont systemFontOfSize:28*SizeScale750];
        _turnoverLable.textColor = [UIColor whiteColor];
    }
    return _turnoverLable;
    
    
}


- (UILabel *)takeNumTitleLable
{
    
    if (!_takeNumTitleLable) {
        _takeNumTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(0, 240, 750,50)];
        _takeNumTitleLable.text = @"取货码";
        _takeNumTitleLable.font = [UIFont systemFontOfSize:50*SizeScale750];
        _takeNumTitleLable.textAlignment = NSTextAlignmentCenter;
        _takeNumTitleLable.textColor = [UIColor whiteColor];
    }
    return _takeNumTitleLable;
}


- (UILabel *)takeNumLable
{
    if (!_takeNumLable) {
        _takeNumLable = [[UILabel alloc]initWithFrame:CGRectMake750(0,300, 750,50)];
        _takeNumLable.text = @"0123456789";
        _takeNumLable.font = [UIFont systemFontOfSize:50*SizeScale750];
        _takeNumLable.textAlignment = NSTextAlignmentCenter;
        _takeNumLable.textColor = [UIColor whiteColor];
    }
    return _takeNumLable;
    
    
}


@end
