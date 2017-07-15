//
//  OrderConfirmationViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "OrderConfirmationViewController.h"
#import "AddressViewController.h"
#import "PayViewController.h"
#import "OrderConfirmationView.h"
#import "AddressConfirmTableViewCell.h"
#import "NoAddressConfirmTableViewCell.h"
#import "StoreAddressTableViewCell.h"
#import "PersonalAddressModel.h"
#import "GoodsModel.h"
#import "ActivityModel.h"
#import "ShopAddressModel.h"
#import "QDAlphaWarnView.h"
@interface OrderConfirmationViewController ()<UITableViewDataSource,UITableViewDelegate,AddressViewControllerDelegate> {
    /** 个人收货地址*/
    NSMutableArray *_addressArrayM;
    /** 标记*/
    NSInteger _addressPage;
    
    /** 应该支付的金额*/
    __block NSString *_needPayMoney;
}
@property (nonatomic,strong) UITableView *tableView;
/** 应付款*/
@property (nonatomic,strong) UILabel *shouldPayLabel;

@property (nonatomic,strong) QDAlphaWarnView *alphaWarnView;
@end

@implementation OrderConfirmationViewController
static NSString *const kAddressConfirmTableViewCell = @"AddressConfirmTableViewCell";
static NSString *const kNoAddressConfirmTableViewCell = @"NoAddressConfirmTableViewCell";
static NSString *const kStoreAddressTableViewCell = @"StoreAddressTableViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kOrderConfirmation];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kOrderConfirmation];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTitleViewWithString:@"订单确认页"];
    _addressArrayM = @[].mutableCopy;
    _addressPage = 0;
    self.view.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
    [self.view addSubview:self.tableView];
    
    OrderConfirmationView *headerView = [[OrderConfirmationView alloc]initWithFrame:CGRectMake720(0, 0, 720, 746)];
    //自取
    if ([self.goodModel.pay_type isEqualToString:@"2"]) {
        headerView.height = 818*SizeScale;
    }
    headerView.activityModel = self.activityModel;
    if (!self.activityModel) {
        headerView.height -= 170*SizeScale;
    }
    headerView.colorPage = self.colorPage;
    
    headerView.goodModel = self.goodModel;
    
    headerView.color = self.colorStr;
    
    _needPayMoney = self.goodModel.price;
    
    headerView.clickSelectPayTypeBlock = ^(NSString *price) {
        _needPayMoney = price;
        NSString *needPay = [NSString stringWithFormat:@"应付金额 ￥%@",price];
        self.shouldPayLabel.attributedText = [NSString changFontWithString:needPay defaultFont:36*SizeScale specifyFont:24*SizeScale defaultColor:kColorForE60012 specifyColor:kColorForccc specifyRang:NSMakeRange(0, 4)];
    };
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerClass:[AddressConfirmTableViewCell class] forCellReuseIdentifier:kAddressConfirmTableViewCell];
    [self.tableView registerClass:[NoAddressConfirmTableViewCell class] forCellReuseIdentifier:kNoAddressConfirmTableViewCell];
    [self.tableView registerClass:[StoreAddressTableViewCell class] forCellReuseIdentifier:kStoreAddressTableViewCell];
    
    [self setupBottomView];
    
    [self getAddressData];
    
    // Do any additional setup after loading the view.
}
- (void)setupBottomView {
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 120)];
    blackView.top = self.view.height - 64 - 120*SizeScaleSubjectTo720;
    [self.view addSubview:blackView];
    NSString *needPay = [NSString stringWithFormat:@"应付金额 ￥%@",self.goodModel.price];
    self.shouldPayLabel.attributedText = [NSString changFontWithString:needPay defaultFont:36*SizeScale specifyFont:24*SizeScale defaultColor:kColorForE60012 specifyColor:kColorForccc specifyRang:NSMakeRange(0, 4)];
    [blackView addSubview:self.shouldPayLabel];
    
    UIButton *submitBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(340, 0, 380, 120) title:@"提交订单" titleColor:kColorForfff titleFont:34 backgroundColor:UIColorFromRGB_16(0xe60012) tapAction:^(UIButton *button) {
        if (_addressArrayM.count == 0 && [self.goodModel.pay_type isEqualToString:@"1"]) {
            [[MBProgressHUDManager instance] showTextOnlyWithView:kGetKeyWindow withText:@"请添加收货地址"];
            return ;
        }
        
        [self saveOrder];
    }];
    [blackView addSubview:submitBtn];
    
}
#pragma mark --- interface 
/** 获取收货地址*/
- (void)getAddressData {
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    
    //获取收货信息
    NSDictionary *param = @{@"userId":kUserId};
    [QDHttpTool getWithURL:kUrl_getGoodsAddress params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];

            _addressArrayM = [PersonalAddressModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            [self.tableView reloadData];
            
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];

}

- (void)saveOrder {
    //点击立即购买 activityId:参加活动id  addressId收货地址id(到店自取传-1)  storeId(店铺地址,必填)
    //shopId商品id
    
    NSString *addressId = @"-1";
    NSString *storeId = @"-1";
    if ([self.goodModel.pay_type isEqual: @"1"] && _addressArrayM.count > _addressPage) {
        PersonalAddressModel *model = _addressArrayM[_addressPage];
        addressId = model.id;
        
        if ([self.activityModel.shop_id isExist]) {
            storeId = self.activityModel.shop_id;
        }
    }
    NSString *activityId = @"-1";
    if ([self.activityModel.id isExist]) {
        activityId = self.activityModel.id;
    }
    
    NSString *refund = @"0";
    if ([self.activityModel.refund isExist]) {
        refund = self.activityModel.refund;
    }
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
//#warning --参数写死了//self.goodModel.price
    CGFloat price = [self.goodModel.price floatValue];
    
    if ([self.goodModel.pay_type isEqualToString:@"2"]) {
        price = [_needPayMoney floatValue];
    }
    
    //CGFloat price = 0.01;
    NSDictionary *brandParam = @{@"activityId":activityId,
                                 @"bonus":refund,
                                 @"addressId":addressId,
                                 @"color":self.colorStr,
                                 @"count":@"1",
                                 @"userInfoId":kUserId,
                                 @"shopId":self.goodModel.id,
                                 @"storeId":storeId,
                                 @"money":[NSString stringWithFormat:@"%.2f",price]};
    [QDHttpTool getWithURL:kUrl_saveOrder params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"保存订单---%@",responseObject);
        
        if (isSuccess) {
            NSNumber *success = [responseObject[@"data"] valueForKey:@"success"];
            if ([success  isEqual: @(0)] ) {
                //[[MBProgressHUDManager instance] requestSuccessWithMessage:[responseObject[@"data"] valueForKey:@"msg"] ];
                [[MBProgressHUDManager instance] hideHUD];
                
                [self.view addSubview:self.alphaWarnView];
                
                return ;
            }
            
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,0.5 * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                PayViewController *vc = [[PayViewController alloc]init];
//#warning ---改
                vc.isShopEnter = YES;
                //vc.orderID = [responseObject[@"data"] valueForKey:@"success"]
                vc.payType = self.goodModel.pay_type;
//                #warning ---price
                vc.needPayMoney = [NSString stringWithFormat:@"%.0f",price];
                vc.isBackBtnShow = YES;
                vc.orderID = [responseObject[@"data"] valueForKey:@"orderId"];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }

    } failure:^(NSError *error) {
        
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- AddressViewControllerDelegate
- (void)refreshAdressArrayWithArray:(NSArray *)array {
    if (_addressArrayM.count) {
        [_addressArrayM removeAllObjects];
    }
    [_addressArrayM addObjectsFromArray:array];
    //[self.tableView reloadData];
}
- (void)refeshAddressWithPage:(NSInteger)page {
    _addressPage = page;
    [self.tableView reloadData];
}
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.goodModel.pay_type isEqualToString:@"2"]) {
        StoreAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStoreAddressTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shopModel = self.shopModel;
        return cell;
    }
    if (_addressArrayM.count == 0) {
        NoAddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoAddressConfirmTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    AddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressConfirmTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_addressArrayM.count >= _addressPage) {
        cell.model = _addressArrayM[_addressPage];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_addressArrayM.count == 0) {
        return 140*SizeScaleSubjectTo720;
    } else {
        return 156*SizeScaleSubjectTo720;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self.goodModel.pay_type isEqualToString:@"2"]) {
        return;
    }
    AddressViewController *vc = [[AddressViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.addressArrayM = _addressArrayM.mutableCopy;
    vc.delegate = self;
    vc.addressPage = _addressPage;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
        _tableView.height = self.view.height - 64 - 120*SizeScaleSubjectTo720;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.rowHeight = 156*SizeScaleSubjectTo720;
    }
    return _tableView;
}
- (UILabel *)shouldPayLabel {
    if (!_shouldPayLabel) {
        _shouldPayLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 340, 120) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:28];
        _shouldPayLabel.backgroundColor = [UIColor blackColor];
    }
    return _shouldPayLabel;
}
- (QDAlphaWarnView *)alphaWarnView {
    if (!_alphaWarnView) {
        _alphaWarnView = [[QDAlphaWarnView alloc]initWithFrame:self.view.bounds];
    }
    return _alphaWarnView;
}
#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- private method
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
