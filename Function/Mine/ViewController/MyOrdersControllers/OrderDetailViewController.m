//
//  OrderDetailViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderPayView.h"
#import "OrderAddressView.h"
#import "MyOrderModel.h"
#import "AddressConfirmTableViewCell.h"
#import "NoAddressConfirmTableViewCell.h"
#import "StoreAddressTableViewCell.h"
#import "PersonalAddressModel.h"
#import "AddressViewController.h"
#import "OrderDetailModel.h"
#import "LogisticsViewController.h"
#import "QDAlertView.h"
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_needPayLabel;
    
    OrderDetailModel *_orderDetailModel;
    
    PersonalAddressModel *_addressModel;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) OrderPayView *orderView;

/** 订单编号*/
@property (nonatomic,strong) UILabel *orderNumberLabel;

/** 手机号码*/
@property (nonatomic,strong) UILabel *phoneLabel;

/** 查看物流*/
@property (nonatomic,strong) UIButton *logisticsBtn;
/** 取消订单*/
@property (nonatomic,strong) UIButton *cancelOrderBtn;
/** 退款*/
@property (nonatomic,strong) UIButton *refundBtn;

/** 弹框*/
@property (nonatomic,strong) QDAlertView *alertVIew;
@end

@implementation OrderDetailViewController
static NSString *const kAddressConfirmTableViewCell = @"AddressConfirmTableViewCell";
static NSString *const kNoAddressConfirmTableViewCell = @"NoAddressConfirmTableViewCell";
static NSString *const kStoreAddressTableViewCell = @"StoreAddressTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTitleViewWithString:@"订单详情"];
    [self setupUI];

    [self.tableView registerClass:[AddressConfirmTableViewCell class] forCellReuseIdentifier:kAddressConfirmTableViewCell];
    [self.tableView registerClass:[NoAddressConfirmTableViewCell class] forCellReuseIdentifier:kNoAddressConfirmTableViewCell];
    [self.tableView registerClass:[StoreAddressTableViewCell class] forCellReuseIdentifier:kStoreAddressTableViewCell];
    //[self getAddressData];
    [self getOrderDetailData];
}
#pragma mark --- ui
- (void)setupUI {
    [self.view addSubview:self.tableView];

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 526)];
    UIImageView *statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 38, 44, 44)];
    statusImageView.image = [UIImage imageNamed:@"order_need_pay_image"];
    [headerView addSubview:statusImageView];

    //已提取,已收货-->交易成功
    NSArray *array = @[@"未支付",@"已支付",@"退款中", @"交易成功", @"已评价", @"同意退款", @"退款成功",@"备货中",@"可提取", @"已提取", @"已发货", @"交易关闭", @"未支付", @"取消订单",@"未支付"];
    NSArray *imageArray = @[@"order_need_pay_image",@"order_stock_image",@"order_refund_image",@"order_success_image",@"order_close_image",@"order_refund_image",@"order_refund_image",@"order_stock_image",@"order_wait_take_image",@"order_success_image",@"order_success_image",@"交易关闭",@"order_need_pay_image",@"order_refund_image",@"order_need_pay_image",@""];
    NSInteger status = [self.model.status integerValue];
    statusImageView.image = [UIImage imageNamed:imageArray[status] ];
    UILabel *statusLabel = [UILabel qd_labelWithFrame:CGRectMake720(100, 38, 250, 44) title:@"" titleColor:kColorForE60012 textAlignment:NSTextAlignmentLeft font:32];
    statusLabel.text = array[status];
    if ([statusLabel.text isEqualToString:@"已提取"] || [statusLabel.text isEqualToString:@"已收货"]) {
        statusLabel.text = @"交易成功";
        statusImageView.image = [UIImage imageNamed:@"order_success_image"];
    }
    if ([self.model.status integerValue] == 4) {
        statusLabel.text = @"交易成功";
        statusImageView.image = [UIImage imageNamed:@"order_success_image"];
        if ([self.model.actiC integerValue] == 0) {
            //statusLabel.text = @"未评价";
        }
    }
//    #warning ---status
//    statusLabel.text = [NSString stringWithFormat:@"%@-%@",statusLabel.text,self.model.status];
    
    [headerView addSubview:statusLabel];
    
    [headerView addSubview:self.orderNumberLabel];
    
    self.orderView.model = self.model;
    [headerView addSubview:self.orderView];
    
    self.tableView.tableHeaderView = headerView;
    

    
}
/** 一定要在请求完成后建立*/
- (void)setupFooterView {
    //576
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 750)];
    //footerView.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
    [footerView addSubview:self.phoneLabel];
    
    UILabel *phoneTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 120, 720, 30) title:@"取货号码" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
    [footerView addSubview:phoneTextLabel];
    
    
    // BUG 341
    UILabel *leftLabel1 = [UILabel qd_labelWithFrame:CGRectMake720(20, 188, 200, 110) title:@"支付类别" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    [footerView addSubview:leftLabel1];
    
    UILabel *leftLabel2 = [UILabel qd_labelWithFrame:CGRectMake720(20, 298, 200, 110) title:@"商品总额" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    [footerView addSubview:leftLabel2];
    
    UILabel *rightLabel = [UILabel qd_labelWithFrame:CGRectMake720(500, 188, 200, 110) title:@"支付全额" titleColor:kColorForfff textAlignment:NSTextAlignmentRight font:26];
    
    self.orderView.money = _orderDetailModel.price;
    
    if (![_orderDetailModel.needPayMoney isEqualToString:_orderDetailModel.price]) {
        rightLabel.text = @"支付押金";
        leftLabel2.text = @"押金支付";
    }
    
    //modify by manman  on2016-11-02
    // BUG 341
    if (!([_orderDetailModel.threePay rangeOfString:@"支付宝"].location == NSNotFound) ) {
        rightLabel.text = [NSString stringWithFormat:@"支付宝%@",rightLabel.text];
    }
    [footerView addSubview:rightLabel];
    
    //end of line
    
    _needPayLabel = [UILabel qd_labelWithFrame:CGRectMake720(500, 298, 200, 110) title:@"￥0" titleColor:kColorForE60012 textAlignment:NSTextAlignmentRight font:26];
    _needPayLabel.text = [NSString stringWithFormat:@"￥%@",self.model.needPayMoney];
    [footerView addSubview:_needPayLabel];
    
    [footerView addSubview:self.logisticsBtn];//物流按钮
    [footerView addSubview:self.cancelOrderBtn];//取消按钮
    [footerView addSubview:self.refundBtn];//取消订单
    
    self.logisticsBtn.hidden = YES;
    self.cancelOrderBtn.hidden = YES;
    self.refundBtn.hidden = YES;
    //快递和退货
    NSInteger status = [self.model.status integerValue];
    if ([_orderDetailModel.payType isEqualToString:@"1"] || status == 5 || status == 2 || status == 13) {
        phoneTextLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        CGFloat height = 188*SizeScale;
        footerView.height -= height;
        //leftLabel1.top -= height;
        leftLabel2.top -= height;
        rightLabel.top -= height;
        _needPayLabel.top -= height;
        self.logisticsBtn.top -= height;
        self.cancelOrderBtn.top -= height;
        self.refundBtn.top -= height;
    }
    //NSInteger status = [_orderDetailModel.status integerValue];
    if (status == 2 || status == 5 || status == 6 || status == 13) {
        self.refundBtn.hidden = NO;
    }
    else if (status == 3 || status == 4 || status == 7 || status == 8 || status == 9 || status == 10 || status == 11 ) {
        self.logisticsBtn.left = 480*SizeScale;
        self.logisticsBtn.hidden = NO;
    }
    else {
        self.logisticsBtn.hidden = NO;
        self.cancelOrderBtn.hidden = NO;
    }
    
    //备货中、可提取 可以取消订单
    if (status == 7 || status == 8) {
        self.logisticsBtn.left = 230*SizeScale;
        self.logisticsBtn.hidden = NO;
        self.cancelOrderBtn.hidden = NO;
    }
    
    self.tableView.tableFooterView = footerView;
}
#pragma mark --- interface

- (void)getOrderDetailData {

    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    NSDictionary *brandParam = @{@"id":self.model.orderId,
                                 @"lat":kGetLat,
                                 @"lng":kGetLng};
    [QDHttpTool getWithURL:kUrl_getOrderById params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        _orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号: %@",_orderDetailModel.orderId];
    
        [PersonalAddressModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"address" : @"userAddress"};
        }];
        
        _addressModel = [PersonalAddressModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"] ];
        
        
        
        [self.tableView reloadData];
        if ([_orderDetailModel.payType isEqualToString:@"1"]) {
            self.phoneLabel.text = _orderDetailModel.orderId;
        } else {
            self.phoneLabel.text = _orderDetailModel.orderId;
        }
        
        [self setupFooterView];
    } failure:^(NSError *error) {
        
    }];
}
/** 取消订单*/
- (void)getCancelOrderData {
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    NSDictionary *params = @{@"userInfoId":kUserId,
                             @"orderId":self.model.orderId,
                             @"type":@"1"};
    [QDHttpTool getWithURL:kUrl_cancelOrderByOrderId params:params success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (!isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
            return ;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@"取消订单成功"];
        self.refreshDataSourceBlock();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self clickBackBtn];
        });
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- private method
- (void)clickCheckLogistics {
    LogisticsViewController *vc = [[LogisticsViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)clickCancelOrderBtn {
    [self.view addSubview:self.alertVIew];
    
}
#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_orderDetailModel) {
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_orderDetailModel.payType isEqualToString:@"2"]) {
        StoreAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreAddressTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _orderDetailModel;
        return cell;
    }
    
    AddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressConfirmTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_addressModel) {
        cell.model = _addressModel;
    }
    cell.isArrowShow = NO;
    return cell;
    
}


#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.rowHeight = 156*SizeScale;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (OrderPayView *)orderView {
    if (!_orderView) {
        _orderView = [[OrderPayView alloc]initWithFrame:CGRectMake720(0, 170, 720, 356)];
    }
    return _orderView;
}

- (UILabel *)orderNumberLabel {
    if (!_orderNumberLabel) {
        _orderNumberLabel = [UILabel qd_labelWithFrame:CGRectMake720(100, 100, 600, 24) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _orderNumberLabel;
}
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 46, 720, 38) title:@"" titleColor:kColorForE60012 textAlignment:NSTextAlignmentCenter font:48];
    }
    return _phoneLabel;
}
- (UIButton *)logisticsBtn {
    if (!_logisticsBtn) {
        _logisticsBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(230, 470, 215, 76) title:@"查看物流" titleColor:kColorForccc titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self clickCheckLogistics];
        }];
        [_logisticsBtn setBackgroundImage:[UIImage imageNamed:@"order_white_border_btn"] forState:UIControlStateNormal];
    }
    return _logisticsBtn;
}
- (UIButton *)cancelOrderBtn {
    if (!_cancelOrderBtn) {
        _cancelOrderBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(480, 470, 215, 76) title:@"取消订单" titleColor:kColorForccc titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self clickCancelOrderBtn];
        }];
        [_cancelOrderBtn setBackgroundImage:[UIImage imageNamed:@"order_white_border_btn"] forState:UIControlStateNormal];
    }
    return _cancelOrderBtn;
}
- (UIButton *)refundBtn {
    if (!_refundBtn) {
        _refundBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(480, 470, 215, 76) title:@"退款详情" titleColor:kColorForccc titleFont:24 backgroundColor:nil tapAction:^(UIButton *button) {
            [self clickCheckLogistics];
        }];
        [_refundBtn setBackgroundImage:[UIImage imageNamed:@"order_white_border_btn"] forState:UIControlStateNormal];
    }
    return _refundBtn;
}
- (QDAlertView *)alertVIew {
    if (!_alertVIew) {
        _alertVIew = [[QDAlertView alloc]initWithFrame:self.view.bounds];
        _alertVIew.title = @"取消订单后,优惠活动\n也会随之取消,是否继续";
        _alertVIew.isContrary = YES;
        _alertVIew.sureBtnTitle = @"否";
        _alertVIew.cancleBtnTitle = @"是";
        [_alertVIew updateUIAutolayout];
        
        @weakify_self
        _alertVIew.clickSureBlock = ^ {
            @strongify_self
            [self getCancelOrderData];
        };
    }
    return _alertVIew;
}
@end
