//
//  UpdateBillDetailInfoViewController.m
//  QiDai
//
//  Created by manman'swork on 16/12/4.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "UpdateBillDetailInfoViewController.h"
#import "BillFeeInfoView.h"
#import "BillDetailInfoView.h"
#import "ExpressAssembleTableViewCell.h"
#import "StoreDetailInfoTableViewCell.h"
#import "LogisticsViewController.h"
#import "UpdateBillDetailInfoModel.h"
#import "GoodsModel.h"
#import "ActivityModel.h"
#import "PersonalAddressModel.h"
#import "ShopAddressModel.h"
#import "AddressConfirmTableViewCell.h"
#import "PayViewController.h"
#import "QDAlphaWarnView.h"
#import "CancleActionAlertView.h"




@interface UpdateBillDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong) QDAlphaWarnView *alertViewImageView;

@property (nonatomic,strong) NSString *isExpressTypeStr;

@property (nonatomic,strong) GoodsModel *updateBillDetailGoodsModel;

@property (nonatomic,strong) ActivityModel *updateBillDetailActivityModel;


@property (nonatomic,strong) PersonalAddressModel *updateBillDetailPersonalAddressModel;

@property (nonatomic,strong) ShopAddressModel *updateBillDetailShopAddressModel;



/**
 *      订单状态信息
 */
@property (nonatomic,strong) UIView *billStateBackgroundView;

@property (nonatomic,strong) UIImageView *billStateFlageImageView;

@property (nonatomic,copy) NSString *billStateStr;

@property (nonatomic,strong) UILabel *billStateTitleLabel;

@property (nonatomic,strong) UILabel *billStateNumTitleLabel;

@property (nonatomic,strong) UILabel *billStateNumLabel;



/**
 *  订单  自行车信息
 */
@property (nonatomic,strong) BillDetailInfoView *billDetailInfoView;


/**
 *  订单  费用信息
 */
@property (nonatomic,strong) BillFeeInfoView *billFeeInfoView;


@property (nonatomic,strong) UITableView *tableView;



@property (nonatomic,strong) UIView *billOperationBackgroundView;

//@property (nonatomic,strong) UILabel *takedeliveryNumTitleLabel;
//
//@property (nonatomic,strong) UILabel *takedeliveryNumLabel;

@property (nonatomic,strong) UIButton *cancleBillButton;

@property (nonatomic,strong) UIButton *payBillButton;

/**
 *  退款信息
 */
@property (nonatomic,strong) UIButton *returnpayButton;

/**
 *  删除订单
 */
@property (nonatomic,strong) UIButton *deleteBillButton;

@property (nonatomic,strong) UIButton *checkLogisticsBillButton;

@property (nonatomic,strong) UIButton *confirmBillButton;

@property (nonatomic,strong) UILabel *remainTimeTitleLabel;

@property (nonatomic,strong) UILabel *remainTimeLabel;



@property (nonatomic,strong) UpdateBillDetailInfoModel *updateBillDetailInfoModel;





@property (nonatomic,strong) UIView *receiveBabySuccessBackgroundView;

@property (nonatomic,strong) UIImageView *receiveBabySuccessImageView;

@property (nonatomic,strong) UIButton *closeReceiveBabySuccessImageViewButton;



@property (nonatomic,strong) NSTimer *stopwatchOrderDetailTime;



/**
 *  取消 提示框
 */
@property (nonatomic,strong)CancleActionAlertView *cancleActionAlertView;


@end


static NSString *addressConfirmTableViewCellIdentifyStr = @"addressConfirmTableViewCellIdentifyStr";
static NSString *storeDetailInfoTableViewCellIdentifyStr = @"storeDetailInfoTableViewCellIdentifyStr";


@implementation UpdateBillDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.billStateBackgroundView];
    
    [self setbillStateBackgroundViewUIViewAutolayout];
    
    [self.view addSubview:self.billOperationBackgroundView];
    
    [self setBillOperationBackgroundViewUIViewAutolayout];
    
    self.tableView.tableHeaderView = self.billDetailInfoView;
    self.tableView.tableFooterView = self.billFeeInfoView;
    [self createTimer];
    //这个方法 用真实 数据代替
    //[self.billFeeInfoView fillDatasources];
    
    [self getOrderDetailData];
    
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)getOrderDetailData {
    
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    NSDictionary *brandParam = @{@"id":self.updateBillDetailModel.orderId,
                                 @"lat":kGetLat,
                                 @"lng":kGetLng};
    [QDHttpTool getWithURL:kUrl_getOrderById params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        
        self.updateBillDetailInfoModel = [UpdateBillDetailInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
         NSNumber *payType = [[responseObject objectForKey:@"data"] objectForKey:@"payType"];
        self.isExpressTypeStr = [NSString stringWithFormat:@"%@",payType];
        /**
         *  店铺
         */
        if ([payType  isEqual: @2]) {
            self.updateBillDetailShopAddressModel = [ShopAddressModel mj_objectWithKeyValues:[responseObject[@"data"] objectForKey:@"addressIOS"]];
        }else
        {
            /**
             *  个人
             */
             self.updateBillDetailPersonalAddressModel = [PersonalAddressModel mj_objectWithKeyValues:[responseObject[@"data"] objectForKey:@"addressIOS"]];
            
            
        }
        
        [self activityCountdownDate:self.updateBillDetailInfoModel.c_time];
        
        /**
         *  活动信息
         */
        self.updateBillDetailActivityModel = [ActivityModel mj_objectWithKeyValues:[responseObject[@"data"] objectForKey:@"task"]];
        self.updateBillDetailGoodsModel = [GoodsModel mj_objectWithKeyValues:[responseObject[@"data"] objectForKey:@"item"]];
        
        
        self.billStateStr = [self.updateBillDetailInfoModel.status copy];
        [self fillBillStateDatasource];
        [self fillBillFeeInfoViewDatasourcesAssembleFee];
        
        self.billDetailInfoView.selectedImageViewUrlStr  = self.updateBillDetailGoodsModel.image;
        self.billDetailInfoView.billDetailActivityModel = self.updateBillDetailActivityModel;
        self.billDetailInfoView.selectedColorStr = self.updateBillDetailInfoModel.itemColor;
        self.billDetailInfoView.billDetailGoodsModel = self.updateBillDetailGoodsModel;
        [self customBillOperationBackgroundViewUIViewAutolayout];
        

        [self.tableView reloadData];
        
        
//        _orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
//        
//        self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@",_orderDetailModel.orderId];
//        
//        [PersonalAddressModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//            return @{@"address" : @"userAddress"};
//        }];
//        
//        _addressModel = [PersonalAddressModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"] ];
//        
//        
//        
//        [self.tableView reloadData];
//        if ([_orderDetailModel.payType isEqualToString:@"1"]) {
//            self.phoneLabel.text = _orderDetailModel.orderId;
//        } else {
//            self.phoneLabel.text = _orderDetailModel.orderId;
//        }
        
        //[self setupFooterView];
    } failure:^(NSError *error) {
        NSLog(@"getOrderDetailData %@",error.localizedDescription);
    }];
}


- (void)setupNavigationView {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    
    // modify by manman on start of line
    
    self.navigationItem.title = @"订单详情";
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //self.navigationItem.titleView = self.titleView;
    
    // end of line
    //[self creatShareBtn];
    
    //self.navigationController.navigationItem.titleView =self.titleView;
    
}

/**
 *   填写 上部分  订单 状态 信息
 */

- (void)fillBillStateDatasource
{
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    NSArray *array = @[@"未支付",@"已支付",@"退款中", @"交易成功", @"已评价", @"同意退款", @"退款成功",@"备货中",@"可提取", @"已提取", @"已发货", @"交易关闭", @"未支付", @"取消订单",@"未支付"];
    NSArray *imageArray = @[@"order_need_pay_image",@"order_stock_image",@"order_refund_image",@"order_success_image",@"order_close_image",@"order_refund_image",@"order_refund_image",@"order_stock_image",@"order_wait_take_image",@"order_success_image",@"order_success_image",@"交易关闭",@"order_need_pay_image",@"order_refund_image",@"order_need_pay_image",@""];
    self.billStateFlageImageView.image = [UIImage imageNamed:imageArray[self.billStateStr.integerValue]];
    self.billStateTitleLabel.text = array[self.billStateStr.integerValue];
    self.billStateNumLabel.text = self.updateBillDetailInfoModel.orderId;
    
    
    
    
}
/**
 *   上部分  订单 状态 信息
 */

- (void)setbillStateBackgroundViewUIViewAutolayout
{
    [self.billStateBackgroundView addSubview:self.billStateFlageImageView];
    [self.billStateBackgroundView addSubview:self.billStateTitleLabel];
    [self.billStateBackgroundView addSubview:self.billStateNumTitleLabel];
    [self.billStateBackgroundView addSubview:self.billStateNumLabel];
    
    
}






/**
 *  订单 显示  可以操作的信息
 */
- (void)setBillOperationBackgroundViewUIViewAutolayout
{
     /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    
//    [self.billOperationBackgroundView addSubview:self.takedeliveryNumTitleLabel];
//    [self.billOperationBackgroundView addSubview:self.takedeliveryNumLabel];
    [self.billOperationBackgroundView addSubview:self.remainTimeTitleLabel];
    [self.billOperationBackgroundView addSubview:self.remainTimeLabel];
    [self.billOperationBackgroundView addSubview:self.cancleBillButton];
    [self.billOperationBackgroundView addSubview:self.payBillButton];
    [self.billOperationBackgroundView addSubview:self.deleteBillButton];
    [self.billOperationBackgroundView addSubview:self.returnpayButton];
    [self.billOperationBackgroundView addSubview:self.checkLogisticsBillButton];
    [self.billOperationBackgroundView addSubview:self.confirmBillButton];
    
    
    
    
    
}


- (void)customBillOperationBackgroundViewUIViewAutolayout
{
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    
    self.remainTimeTitleLabel.hidden = YES;
    self.remainTimeLabel.hidden = YES;
    self.cancleBillButton.hidden =YES;
    self.payBillButton.hidden =YES;
    self.deleteBillButton.hidden = YES;
    self.returnpayButton.hidden = YES;
    self.checkLogisticsBillButton.hidden = YES;
    self.confirmBillButton.hidden = YES;
    
    if ([self.billStateStr isEqualToString:@"0"]) {
        self.remainTimeTitleLabel.hidden = NO;
        self.remainTimeLabel.hidden = NO;
        self.cancleBillButton.hidden =NO;
        self.payBillButton.hidden =NO;
        
    }
    if ([self.billStateStr isEqualToString:@"2"]) {
         self.returnpayButton.hidden = NO;
    }
    
    if ([self.billStateStr isEqualToString:@"3"]) {
        self.checkLogisticsBillButton.hidden = NO;
    }
    
    
   
    if ([self.billStateStr isEqualToString:@"6"]) {
        self.returnpayButton.hidden = NO;
        
    }
    if ([self.billStateStr isEqualToString:@"7"]) {
        self.cancleBillButton.hidden = NO;
        self.checkLogisticsBillButton.hidden = NO;
        CGRect cancleFrame = self.cancleBillButton.frame;
        cancleFrame.origin.x = 20 *SizeScale750;
        cancleFrame.size.width = 345 *SizeScale750;
        self.cancleBillButton.frame = cancleFrame;
        
        CGRect checkLogisticsBillFrame = self.checkLogisticsBillButton.frame;
        checkLogisticsBillFrame.origin.x = 385 *SizeScale750;
        checkLogisticsBillFrame.size.width = 345 *SizeScale750;
        self.checkLogisticsBillButton.frame = checkLogisticsBillFrame;
        
        
    }
    
    if ([self.billStateStr isEqualToString:@"8"]) {
        
//        CGRect frame = self.billFeeInfoView.frame;
//        frame.size.height =
        
        
        self.cancleBillButton.hidden = NO;
        CGRect cancleFrame = self.cancleBillButton.frame;
        cancleFrame.origin.x = 20;
        cancleFrame.size.width = 200*SizeScale750;
        self.cancleBillButton.frame = cancleFrame;
        
        self.checkLogisticsBillButton.hidden = NO;
        CGRect checkLogisticsBillButtonFrame = self.checkLogisticsBillButton.frame;
        checkLogisticsBillButtonFrame.origin.x = 240*SizeScale750;
        checkLogisticsBillButtonFrame.size.width = 200*SizeScale750;
        self.checkLogisticsBillButton.frame = checkLogisticsBillButtonFrame;
        
        self.confirmBillButton.hidden = NO;
        CGRect confirmBillButtonFrame = self.confirmBillButton.frame;
        confirmBillButtonFrame.origin.x = 500 *SizeScale750;
        confirmBillButtonFrame.size.width = 200*SizeScale750;
        self.confirmBillButton.frame = confirmBillButtonFrame;
        
    }
    if ([self.billStateStr isEqualToString:@"10"]) {
        self.checkLogisticsBillButton.hidden = NO;
        CGRect checkLogisticsBillButtonFrame = self.checkLogisticsBillButton.frame;
        checkLogisticsBillButtonFrame.origin.x = 20*SizeScale750;
        checkLogisticsBillButtonFrame.size.width = 300*SizeScale750;
        self.checkLogisticsBillButton.frame = checkLogisticsBillButtonFrame;
        
        self.confirmBillButton.hidden = NO;
        CGRect confirmBillButtonFrame = self.confirmBillButton.frame;
        confirmBillButtonFrame.origin.x = 350 *SizeScale750;
        confirmBillButtonFrame.size.width = 300*SizeScale750;
        self.confirmBillButton.frame = confirmBillButtonFrame;
    }
    if ([self.billStateStr isEqualToString:@"11"]) {
    
        
        self.deleteBillButton.hidden = NO;
        CGRect checkLogisticsBillButtonFrame = self.deleteBillButton.frame;
        checkLogisticsBillButtonFrame.origin.x = 20*SizeScale750;
        checkLogisticsBillButtonFrame.size.width = 345*SizeScale750;
        self.deleteBillButton.frame = checkLogisticsBillButtonFrame;
        
        self.returnpayButton.hidden = NO;
        CGRect confirmBillButtonFrame = self.returnpayButton.frame;
        confirmBillButtonFrame.origin.x = 385 *SizeScale750;
        confirmBillButtonFrame.size.width = 345*SizeScale750;
        self.returnpayButton.frame = confirmBillButtonFrame;
        
        
        
    }
    
    
    
    
    
    
    
    
}


- (void)fillBillFeeInfoViewDatasourcesAssembleFee
{
    
    self.billFeeInfoView.orderStateStr = self.billStateStr;
    
    
    [self setBillFeeInfoViewDatasourcesAssembleFee:self.updateBillDetailInfoModel.assembleCharges andExpressFee:self.updateBillDetailInfoModel.freight andGoodsPrice:self.updateBillDetailInfoModel.price andPaymentType:self.updateBillDetailInfoModel.paymentCategory andActuallypaid:self.updateBillDetailInfoModel.needPayMoney andCreateBillDate:self.updateBillDetailInfoModel.c_time andTurnoverDate:self.updateBillDetailInfoModel.pay_time andTakeNum:self.updateBillDetailInfoModel.orderId];
    
}

- (void)setBillFeeInfoViewDatasourcesAssembleFee:(NSString *)assembleFeeStr
                                   andExpressFee:(NSString *)expressFeeStr
                                   andGoodsPrice:(NSString *)goodsPrices
                                   andPaymentType:(NSString *)paymentType
                                   andActuallypaid:(NSString *)actuallypaid
                                   andCreateBillDate:(NSString *)createBillDate
                                   andTurnoverDate:(NSString *)turnoverDate
                                   andTakeNum:(NSString *)takeNum
{
    
    NSDictionary *parameter = [[NSDictionary alloc]initWithObjectsAndKeys:assembleFeeStr,@"assembleFee",
                               expressFeeStr,@"expressFee",goodsPrices,@"goodsPrices",paymentType,@"paymentType",actuallypaid,@"actuallypaid",createBillDate,@"createBillDate",turnoverDate,@"turnoverDate",takeNum,@"takeNum",nil];
    
    self.billFeeInfoView.billFeeParameter = parameter;
    
    
    
}



- (void)createTimer {
    
    
    self.stopwatchOrderDetailTime = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.stopwatchOrderDetailTime forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    
    //    for (int count = 0; count < _stopwatchTimeDatasourcesMArr.count; count++) {
    ////
    ////        TimeModel *model = _m_dataArray[count];
    ////        [model countDown];
    //    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ORDERLIST_TIME_CELL object:nil];
    
    [self activityCountdownDate:self.updateBillDetailInfoModel.c_time];
    
    
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
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%@",remainDateStr];
    
    
    
}

- ( NSTimeInterval )compareSatrtDate:(NSDate *) startDate  andEndTime:(NSDate *) endDate
{
    NSTimeInterval startInterval =[startDate timeIntervalSince1970];
    
    NSTimeInterval endInterval =[endDate timeIntervalSince1970];
    
    NSTimeInterval secondsInterval =startInterval - endInterval;
    
    NSLog(@"secondsInterval %f",secondsInterval);
    if (24*60*60 >= secondsInterval) {
        secondsInterval = 24 *60 *60 -secondsInterval;
    }else
    {
        secondsInterval = 0;
    }
    NSLog(@" start date %@ endDate %@  interval %f",startDate,endDate,secondsInterval);
    
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





#pragma ------UITableViewDataSource ------start of line 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150 *SizeScale750;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  店铺信息
     */
    if ([self.isExpressTypeStr isEqualToString:@"2"]) {
        StoreDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeDetailInfoTableViewCellIdentifyStr];
        cell.isEnable = NO;
        cell.storeDetailInfoShopAddressModel = self.updateBillDetailShopAddressModel;
        cell.backgroundColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    AddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressConfirmTableViewCellIdentifyStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.updateBillDetailPersonalAddressModel != nil) {
        cell.model = self.updateBillDetailPersonalAddressModel;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;

    
}




#pragma ------UITableViewDataSource ------end of line


- (void)cancleBillNetWork
{
    // 取消订单   type  默认是0
    NSString *typeStr = @"0";
    // 订单状态  7 取消为 退款
    if ([self.updateBillDetailModel.status isEqualToString:@"7"]) {
    typeStr = @"1";
    }
    
    NSDictionary *brandParam = @{@"orderId":self.updateBillDetailModel.orderId,
                                 @"userInfoId":kUserId,
                                 @"type":typeStr};
    [QDHttpTool getWithURL:kNewUrl_cancelOrderByOrderId params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        /**
         *  {"code":"00","data":{"msg":"取消订单成功","success":true},"message":"请求成功"}

         */
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            NSString *message = [responseObject[@"data"] objectForKey:@"msg"];
            [self setAlertViewTitle:@"提示" andSubMessage:message];
            [self canaleBillOperation];
            
        }else
        {
            NSString *message = [responseObject[@"data"] objectForKey:@"msg"];
            [self setAlertViewTitle:@"提示" andSubMessage:message];
        }
        
        
    }failure:^(NSError *error) {
        NSLog(@"getOrderDetailData %@",error.localizedDescription);
    }];
    
}


- (void)confirmBillNetWork
{
    NSDictionary *brandParam = @{@"orderId":self.updateBillDetailInfoModel.orderId,
                                 @"taskDetailId":self.updateBillDetailInfoModel.taskDetailId};
    [QDHttpTool getWithURL:kNewUrl_confirmReceipt params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        NSNumber *dataNum = responseObject[@"data"];
        if ([dataNum  isEqual: @1]) {
            [kGetKeyWindow addSubview:self.receiveBabySuccessBackgroundView];
           
        }else
        {
            [self setAlertViewTitle:@"提示" andSubMessage:responseObject[@"message"]];
            
        }
        
        
    }failure:^(NSError *error) {
        NSLog(@"getOrderDetailData %@",error.localizedDescription);
        [self setAlertViewTitle:@"提示" andSubMessage:error.localizedDescription];
    }];
    
    
    
}


/** 查看物流*/
- (void)clickCheckLogisticsWithModel:(MyOrderModel *)model {
    LogisticsViewController *vc = [[LogisticsViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 去支付*/
- (void)clickPayWithModel:(MyOrderModel *)model {
    
    // add by manman  on 2016-11-18
    // 添加  一个验证   一个提示
    if ([model.status isEqualToString:@"14"]) {
        
        [self.view addSubview:self.alertViewImageView];
        self.alertViewImageView.whereFromStr = @"OrderTemporary";
        return;
        
    }
    // end of line
    
    PayViewController *vc = [[PayViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.payType = self.updateBillDetailInfoModel.pay_type;
    vc.orderID = self.updateBillDetailInfoModel.orderId;
    vc.needPayMoney = self.updateBillDetailInfoModel.needPayMoney;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payBillButtonAction
{
    NSLog(@"去支付订单...");
    [self clickPayWithModel:nil];
}


- (void)CancleBillButtonAction
{
    
    NSLog(@"取消订单...");
    /**
     *  备货中取消订单
     */
    if ([self.updateBillDetailInfoModel.status isEqualToString:@"7"]) {
        
        /**
         *  添加 取消 提示
         */
        [kGetKeyWindow addSubview:self.cancleActionAlertView];
        
    }else
    {
        [self cancleBillNetWork];
    }
    
    
    
}

- (void)cancleActionAlertViewConfirmAction:(NSDictionary *)parameter
{
    
    [self.cancleActionAlertView removeFromSuperview];
    [self cancleBillNetWork];
    
    
}



- (void)deleteBillButtonAction
{
    
    NSLog(@"删除订单...");
    [self cancleBillNetWork];
    
}

- (void)canaleBillOperation
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
 
}



- (void)returnpayButtonAction
{
    NSLog(@"退款详情...");
    MyOrderModel *tmpOrderModel = [[MyOrderModel alloc]init];
    tmpOrderModel.orderId = self.updateBillDetailInfoModel.orderId;
    [self clickCheckLogisticsWithModel:tmpOrderModel];
}


- (void)checkLogisticsBillButtonAction
{
    
    NSLog(@"查看物流...");
    MyOrderModel *tmpOrderModel = [[MyOrderModel alloc]init];
    tmpOrderModel.orderId = self.updateBillDetailInfoModel.orderId;
    [self clickCheckLogisticsWithModel:tmpOrderModel];
    
}


- (void)confirmBillButtonAction
{
    NSLog(@"确认订单...");
    [self confirmBillNetWork];
}


- (void)closeReceiveBabySuccessImageViewButtonAction
{
    NSLog(@"点击 收获成功  关闭  ...");
    [self.receiveBabySuccessBackgroundView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma lazyload -----start 


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake750(0,130, 750, 1000)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor blackColor];
        
        [_tableView registerClass:[AddressConfirmTableViewCell class] forCellReuseIdentifier:addressConfirmTableViewCellIdentifyStr];
        [_tableView registerClass:[StoreDetailInfoTableViewCell class] forCellReuseIdentifier:storeDetailInfoTableViewCellIdentifyStr];
        
    }
    
    return _tableView;
    
    
}

- (BillFeeInfoView *)billFeeInfoView
{
    if (!_billFeeInfoView) {
        _billFeeInfoView = [[BillFeeInfoView alloc]initWithFrame:CGRectMake750(0, 0, 750,880)];
        _billFeeInfoView.useInViewStr = kBillDetailInfoView;
        
    }
    return _billFeeInfoView;
    
    
    
    
}

- (BillDetailInfoView *)billDetailInfoView
{
    if (!_billDetailInfoView) {
        _billDetailInfoView = [[BillDetailInfoView alloc]initWithFrame:CGRectMake750(0, 130, 750, 400)];
        
    }
    return _billDetailInfoView;
    
}


- (UIView *)billStateBackgroundView
{
    if (!_billStateBackgroundView) {
        _billStateBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 0, 750, 140)];
        _billStateBackgroundView.backgroundColor = [UIColor blackColor];
        
    }
    return _billStateBackgroundView;
    
    
}


- (UIImageView *)billStateFlageImageView
{
    if (!_billStateFlageImageView) {
        _billStateFlageImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20,56,44,44)];
        _billStateFlageImageView.image = [UIImage imageNamed:@""];
    }
    
    return _billStateFlageImageView;
 
}


- (UILabel *)billStateTitleLabel
{
    if (!_billStateTitleLabel) {
        _billStateTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(100,30, 200, 30)];
        _billStateTitleLabel.text = @"退款中";
        _billStateTitleLabel.font = [UIFont systemFontOfSize:32*SizeScale750];
        _billStateTitleLabel.textColor = [UIColor redColor];
    }
    return _billStateTitleLabel;
    
}

- (UILabel *)billStateNumTitleLabel
{
    if (!_billStateNumTitleLabel) {
        _billStateNumTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(100,80, 120, 23)];
        _billStateNumTitleLabel.text = @"订单编号:";
        _billStateNumTitleLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _billStateNumTitleLabel.textColor = [UIColor whiteColor];
    }
    return _billStateNumTitleLabel;
    
}


- (UILabel *)billStateNumLabel
{
    if (!_billStateNumLabel) {
        _billStateNumLabel = [[UILabel alloc]initWithFrame:CGRectMake750(220,80, 300,23)];
        _billStateNumLabel.text = @"11234567890";
        _billStateNumLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _billStateNumLabel.textColor = [UIColor whiteColor];
    }
    
    return _billStateNumLabel;
    
}


- (UIView *)billOperationBackgroundView
{
    if (!_billOperationBackgroundView) {
        _billOperationBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 0,750, 120)];
        CGRect frame = _billOperationBackgroundView.frame;
        frame.origin.y = (kGetKeyWindow.frame.size.height - 120);
        _billOperationBackgroundView.frame = frame;
        
        _billOperationBackgroundView.backgroundColor = [UIColor blackColor];
    }
    return _billOperationBackgroundView;
    
}


//- (UILabel *)takedeliveryNumTitleLabel
//{
//    if (!_takedeliveryNumTitleLabel) {
//        _takedeliveryNumTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0, 0, 750, 40)];
//        _takedeliveryNumTitleLabel.text = @"取货码";
//        _takedeliveryNumTitleLabel.textColor = [UIColor whiteColor];
//    }
//    
//    return _takedeliveryNumTitleLabel;
//    
//    
//}
//
//- (UILabel *)takedeliveryNumLabel
//{
//    if (!_takedeliveryNumLabel) {
//        _takedeliveryNumLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,50, 750, 40)];
//        _takedeliveryNumLabel.text = @"0123456789";
//        _takedeliveryNumLabel.textColor = [UIColor whiteColor];
//    }
//    
//    return _takedeliveryNumLabel;
//    
//    
//}

- (UIButton *)cancleBillButton
{
    if (!_cancleBillButton) {
        @weakify_self
        _cancleBillButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(208, 20, 247,80) title:@"取消订单" titleColor:kColorForE60012 titleFont:24 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            @strongify_self
            //[self CommentGoodsButtonAction];
            [self CancleBillButtonAction];
            
        }];
        [_cancleBillButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _cancleBillButton;
    
    
}

- (UIButton *)payBillButton
{
    
    if (!_payBillButton) {
        @weakify_self
        _payBillButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(470, 20, 247,80) title:@"去支付" titleColor:[UIColor whiteColor] titleFont:24 backgroundColor:[UIColor redColor] tapAction:^(UIButton *button) {
            @strongify_self
            [self payBillButtonAction];
            
            
        }];
        //[_payBillButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    _payBillButton.layer.cornerRadius = 5.f;
    
    return _payBillButton;
    
    
}



- (UIButton *)returnpayButton
{
    
    if (!_returnpayButton) {
        @weakify_self
        _returnpayButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(470, 20, 247,80) title:@"退款详情" titleColor:[UIColor whiteColor] titleFont:24 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            @strongify_self
            [self returnpayButtonAction];
            
            
        }];
        [_returnpayButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _returnpayButton;
    
    
}


- (UIButton *)deleteBillButton
{
    
    if (!_deleteBillButton) {
        @weakify_self
        _deleteBillButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(470, 20, 247, 80) title:@"删除订单" titleColor:[UIColor whiteColor] titleFont:24 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            @strongify_self
            [self deleteBillButtonAction];
            
            
        }];
        [_deleteBillButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _deleteBillButton;
    
    
}


- (UIButton *)checkLogisticsBillButton
{
    if (!_checkLogisticsBillButton) {
        @weakify_self
        _checkLogisticsBillButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(470, 20, 247, 80) title:@"查看物流" titleColor:kColorForE60012 titleFont:24 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            @strongify_self
            [self checkLogisticsBillButtonAction];
            
            
            //[self CommentGoodsButtonAction];
        }];
        [_checkLogisticsBillButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _checkLogisticsBillButton;
    
    
}

- (UIButton *)confirmBillButton
{
    if (!_confirmBillButton) {
        @weakify_self
        _confirmBillButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(218, 20, 216,80) title:@"确认订单" titleColor:kColorForE60012 titleFont:24 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            @strongify_self
            [self confirmBillButtonAction];
            
        }];
        [_confirmBillButton setBackgroundImage:[UIImage imageNamed:@"order_red_border_btn"] forState:UIControlStateNormal];
    }
    return _confirmBillButton;
    
    
}

- (UILabel *)remainTimeTitleLabel
{
    if (!_remainTimeTitleLabel) {
        _remainTimeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0, 47, 750,27)];
        _remainTimeTitleLabel.text = @"订单自动取消";
        _remainTimeTitleLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _remainTimeTitleLabel.textColor = [UIColor whiteColor];
    }
    
    return _remainTimeTitleLabel;
    
    
}

- (UILabel *)remainTimeLabel
{
    if (!_remainTimeLabel) {
        _remainTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,20, 750,27)];
        _remainTimeLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _remainTimeLabel.text = @"22小时23分后";
        _remainTimeLabel.textColor = [UIColor whiteColor];
    }
    
    return _remainTimeLabel;
    
    
}

- (UIView *)receiveBabySuccessBackgroundView
{
    if (!_receiveBabySuccessBackgroundView) {
        _receiveBabySuccessBackgroundView = [[UIView alloc]initWithFrame:kGetKeyWindow.frame];
        [_receiveBabySuccessBackgroundView addSubview:self.receiveBabySuccessImageView];
        [_receiveBabySuccessBackgroundView addSubview:self.closeReceiveBabySuccessImageViewButton];
    }
    return _receiveBabySuccessBackgroundView;
    
}



- (UIImageView *)receiveBabySuccessImageView
{
    
    if (!_receiveBabySuccessImageView) {
        _receiveBabySuccessImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(65, 641, 620, 142)];
        _receiveBabySuccessImageView.image = [UIImage imageNamed:@"updateBillDetailJoinTaskImageView"];
        
    }
    return _receiveBabySuccessImageView;
    
}


- (UIButton *)closeReceiveBabySuccessImageViewButton
{
    if (!_closeReceiveBabySuccessImageViewButton)
    {
        @weakify_self
        _closeReceiveBabySuccessImageViewButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake750(620, 650, 40,40) title:@"" titleColor:kColorForE60012 titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            @strongify_self
            [self closeReceiveBabySuccessImageViewButtonAction];
            
            
            //[self CommentGoodsButtonAction];
        }];
        [_closeReceiveBabySuccessImageViewButton setBackgroundImage:[UIImage imageNamed:@"closeNew"] forState:UIControlStateNormal];
    }
    return _closeReceiveBabySuccessImageViewButton;
    
    
}

- (void)setAlertViewTitle:(NSString *) titleStr andSubMessage:(NSString *) messageStr
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:titleStr message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
      [self performSelector:@selector(dimissAlert:) withObject:alertView afterDelay:2.0];
 
}

- (void)dimissAlert:(UIAlertView *) alertView
{
    if(alertView)     {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
        //[alertView release];
    }
    
}

- (CancleActionAlertView *)cancleActionAlertView
{
    if (!_cancleActionAlertView) {
        _cancleActionAlertView = [[CancleActionAlertView alloc]initWithFrame:kGetKeyWindow.frame];
        @weakify_self
        _cancleActionAlertView.confirmAction = ^(NSDictionary *parameter)
        {
            @strongify_self
            [self cancleActionAlertViewConfirmAction:parameter];
            
            
        };

    }
    return _cancleActionAlertView;
 
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
