//
//  OrderPayViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "OrderPayViewController.h"
#import "PayViewController.h"
#import "OrderPayView.h"
#import "OrderAddressView.h"
#import "OrderPayFooterView.h"
#import "MyOrderModel.h"
#import "OrderDetailModel.h"
#import "ShopAddressModel.h"
#import "AddressConfirmTableViewCell.h"
#import "StoreAddressTableViewCell.h"
#import "PersonalAddressModel.h"
#import "AddressViewController.h"
#import "QDAlphaWarnView.h"
@interface OrderPayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    /** 个人收货地址*/
    NSMutableArray *_addressArrayM;
    
    /** 是否快递*/
    BOOL _isExpress;
    
    OrderDetailModel *_orderDetailModel;
    
    PersonalAddressModel *_addressModel;
    
    ShopAddressModel *_shopAddressModel;
    
    OrderAddressView *_addressView;
    
    UILabel *_needPayLabel;

}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) OrderPayView *orderView;

@property (nonatomic,strong) OrderPayFooterView *footerView;


@property (nonatomic,strong) QDAlphaWarnView *alertViewImageView;

@end

@implementation OrderPayViewController
static NSString *const kAddressConfirmTableViewCell = @"AddressConfirmTableViewCell";
static NSString *const kStoreAddressTableViewCell = @"StoreAddressTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    _addressArrayM = @[].mutableCopy;
    [self setupUI];
    
    [self.tableView registerClass:[AddressConfirmTableViewCell class] forCellReuseIdentifier:kAddressConfirmTableViewCell];
    [self.tableView registerClass:[StoreAddressTableViewCell class] forCellReuseIdentifier:kStoreAddressTableViewCell];
    // Do any additional setup after loading the view.
    [self getOrderDetailData];
    // Do any additional setup after loading the view.
}

#pragma mark --- ui
- (void)setupUI {
    
    [self creatTitleViewWithString:@"订单详情"];
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 476)];

    UIImageView *statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 38, 44, 44)];
    statusImageView.image = [UIImage imageNamed:@"order_need_pay_image"];
    [headerView addSubview:statusImageView];
    
    UILabel *statusLabel = [UILabel qd_labelWithFrame:CGRectMake720(100, 38, 120, 44) title:@"待付款" titleColor:kColorForE60012 textAlignment:NSTextAlignmentLeft font:32];
    [headerView addSubview:statusLabel];
    
    self.orderView.model = self.model;
    [headerView addSubview:self.orderView];
    
    
    self.tableView.tableHeaderView = headerView;
    
    self.footerView.needPay = self.model.needPayMoney;
    
    self.tableView.tableFooterView = self.footerView;
    self.footerView.orderModel = self.model;
}

#pragma mark --- interface
- (void)getOrderDetailData {
    
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    NSDictionary *brandParam = @{@"id":self.model.orderId};
    [QDHttpTool getWithURL:kUrl_getOrderById params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        _orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];

        _addressModel = [PersonalAddressModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"] ];
        
        _shopAddressModel = [ShopAddressModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"] ];
        
        self.orderView.money = _orderDetailModel.price;
        
        self.footerView.orderDetailModel = _orderDetailModel;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- private method
- (void)clickPayBtn {
    
    // start of line
    // 添加14 状态码
    if ([self.model.status isEqualToString:@"14"]) {
        [self.view addSubview:self.alertViewImageView];
        self.alertViewImageView.whereFromStr = @"OrderTemporary";
        return;
    }
    
    
    //end of line
    
    PayViewController *vc = [[PayViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.payType = self.model.pay_type;
    vc.needPayMoney = self.model.needPayMoney;
    vc.orderID = self.model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_addressModel || _shopAddressModel) {
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
        cell.shopModel = _shopAddressModel;
        return cell;
    }
    AddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressConfirmTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _addressModel;
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
        _orderView = [[OrderPayView alloc]initWithFrame:CGRectMake720(0, 120, 720, 356)];
    }
    return _orderView;
}
- (OrderPayFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[OrderPayFooterView alloc]initWithFrame:CGRectMake720(0, 0, 720, 500)];
        @weakify_self
        _footerView.clickPayBtnBlock = ^ {
            @strongify_self
            [self clickPayBtn];
        };
    }
    return _footerView;
}


- (QDAlphaWarnView *)alertViewImageView
{
    if (!_alertViewImageView) {
        _alertViewImageView = [[QDAlphaWarnView alloc]initWithFrame:self.view.bounds];
    }
    return _alertViewImageView;
    
    
    
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
