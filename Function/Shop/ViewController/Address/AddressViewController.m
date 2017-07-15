//
//  AddressViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AddressViewController.h"
#import "AddAddressViewController.h"
#import "AddressListTableViewCell.h"
#import "PersonalAddressModel.h"
#import "AddressListDefaultTableViewCell.h"
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,AddressListTableViewCellDelegate>{
    
    //NSInteger _addressPage;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation AddressViewController
static NSString *const kAddressListTableViewCell = @"AddressListTableViewCell";
static NSString *const kAddressListDefaultTableViewCell = @"AddressListDefaultTableViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.whereFromFlagStr isEqualToString:kWHEREFROMSETTINGVIEW]) {
        
        [self getAddressData];
    }
    [MobClick beginLogPageView:kReceiptAddress];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    
   
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kReceiptAddress];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTitleViewWithString:@"收货地址"];
    //_addressPage = 0;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerClass:[AddressListTableViewCell class] forCellReuseIdentifier:kAddressListTableViewCell];
    
    [self.tableView registerClass:[AddressListDefaultTableViewCell class] forCellReuseIdentifier:kAddressListDefaultTableViewCell];
    
    [self setupBottomView];
    // Do any additional setup after loading the view.
}
- (void)setupBottomView {
    //添加地址按钮
    UIButton *btn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 0, 720, 120) NormalBackgroundImageString:@"address_add_image" tapAction:^(UIButton *button) {
        AddAddressViewController *vc = [[AddAddressViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.refreshAddressBlock = ^ {
            [self refreshAddressDataSource];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    btn.top = self.tableView.bottom;
    [self.view addSubview:btn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/** 获取收货地址*/
- (void)getAddressData {
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    
    //获取收货信息
    NSDictionary *param = @{@"userId":kUserId};
    [QDHttpTool getWithURL:kUrl_getGoodsAddress params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"getAddressData %@",responseObject);
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
            
            self.addressArrayM = [PersonalAddressModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            [self.tableView reloadData];
            
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
    
}




#pragma mark --- private method
- (void)refreshAddressDataSource {
    //获取收货信息
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    NSDictionary *param = @{@"userId":kUserId};
    [QDHttpTool getWithURL:kUrl_getGoodsAddress params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
            if (_addressArrayM.count) {
                [_addressArrayM removeAllObjects];
            }
            _addressArrayM = [PersonalAddressModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            [self.tableView reloadData];
            [self.delegate refreshAdressArrayWithArray:_addressArrayM.copy];
            if (!_addressPage) {
                _addressPage = 0;
            }
            [self.delegate refeshAddressWithPage:_addressPage];
            
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }
   
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- AddressListTableViewCellDelegate
- (void)clickEditBtnWithIndex:(NSInteger)index {
    AddAddressViewController *vc = [[AddAddressViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.isEdit = YES;
    vc.model = _addressArrayM[index];
    vc.refreshAddressBlock = ^ {
        [self refreshAddressDataSource];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)clickSelectBtnWithIndex:(NSInteger)index {
    _addressPage = index;
    [self.delegate refeshAddressWithPage:index];
    [self.tableView reloadData];
}
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_addressArrayM && _addressArrayM.count == 0) {
        return 1;
    }
    return _addressArrayM.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_addressArrayM && _addressArrayM.count == 0) {
        AddressListDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressListDefaultTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressListTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _addressArrayM[indexPath.row];
    cell.index = indexPath.row;
    cell.isSelect = NO;
    if (_addressPage == indexPath.row) {
        cell.isSelect = YES;
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_addressArrayM && _addressArrayM.count == 0) {
        return 600*SizeScale;
    }
    return 156*SizeScale;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//
//}
#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
        _tableView.height = self.view.height - 64 - 120*SizeScaleSubjectTo720;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        //_tableView.rowHeight = 156*SizeScaleSubjectTo720;
    }
    return _tableView;
}

@end
