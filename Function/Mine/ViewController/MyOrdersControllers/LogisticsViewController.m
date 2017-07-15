//
//  LogisticsViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsHeaderView.h"
#import "LogisticsTableViewCell.h"
#import "OrderDetailModel.h"
#import "MyOrderModel.h"
@interface LogisticsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) LogisticsHeaderView *headerView;

@end

static NSString *const kLogisticsTableViewCell = @"LogisticsTableViewCell";

@implementation LogisticsViewController
{
    OrderDetailModel *_orderDetailModel;
    
    /** 时间数组*/
    NSMutableArray *_dateArrayM;
    
    /** 状态数组*/
    NSMutableArray *_statusArrayM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger status = [self.model.status integerValue];
    if (status == 5 || status == 2 || status == 13) {
        [self creatTitleViewWithString:@"退款详情"];
    } else {
        [self creatTitleViewWithString:@"物流详情"];
    }

    _dateArrayM = @[].mutableCopy;
    _statusArrayM = @[].mutableCopy;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[LogisticsTableViewCell class] forCellReuseIdentifier:kLogisticsTableViewCell];
    
    [self getOrderDetailData];
    // Do any additional setup after loading the view.
}
- (void)getOrderDetailData {
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    
    /** 状态 0 未支付 1 已支付 2 退款 3 未评价 4 已评价 5 同意退款 6 退款成功 7 备货中 8 可提取 9 已提取 10 已发货 11交易关闭 12 支付一部分 13 取消订单*/
    NSDictionary *brandParam = @{@"id":self.model.orderId};
    [QDHttpTool getWithURL:kUrl_getOrderById params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@" 查看物流信息---%@",responseObject);
        
        if (!isSuccess) {
            [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:responseObject[@"message"] ];
            return ;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        _orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.headerView.model = _orderDetailModel;
        
        if ([_orderDetailModel.payType isEqualToString:@"2"]) {
            self.headerView.payType = 2;
        }
        NSInteger status = [_orderDetailModel.status integerValue];
        if (status == 2 || status == 5 || status == 6 || status == 13) {
            self.headerView.isRefund = YES;
        }
        if (![_orderDetailModel.date isExist]) {
            return ;
        }
        
        NSArray *dateArray = [_orderDetailModel.date componentsSeparatedByString:@"|"];
        NSArray *statusArray = [_orderDetailModel.recordList componentsSeparatedByString:@"|"];
        
        [_dateArrayM addObjectsFromArray:dateArray];
        [_statusArrayM addObjectsFromArray:statusArray];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dateArrayM.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogisticsTableViewCell];
    cell.status = _statusArrayM[indexPath.row];
    cell.date = _dateArrayM[indexPath.row];
    cell.row = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark --- lazy load
- (LogisticsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LogisticsHeaderView alloc]initWithFrame:CGRectMake720(0, 0, 720, 356)];
    }
    return _headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.rowHeight = 90*SizeScale;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
