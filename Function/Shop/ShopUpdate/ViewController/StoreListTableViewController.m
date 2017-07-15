//
//  StoreListTableViewController.m
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "StoreListTableViewController.h"
#import "GoodStoreTableViewCell.h"
#import "AddressInfoViewController.h"

@interface StoreListTableViewController ()<UITableViewDataSource,UITableViewDelegate,GoodStoreTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;



@end


static NSString *goodStoreTableViewCellIdentify = @"GoodStoreTableViewCell";
@implementation StoreListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
//    ShopAddressModel *model = [[ShopAddressModel alloc]init];
//    
//    model.address = @"北京市海淀区知春路锦秋家园";
//    model.phone = @"010-62372571";
//    model.distance = @"4104";
//    model.name = @"骑待商城";
//    model.id = @"100";
//    model.taskId = @"99972";
//    model.lng = @"116.349899";
//    model.lat = @"39.975636";
//    self.datasourcesArr = [[NSArray alloc]initWithObjects:model, nil];
    
    
    /**
     *
     *
     *
     color_price = "[{"color":"白(S)","price":100},{"color":"红(S)","price":100},{"color":"黄(S)","price":100},{"color":"黑色","price":100}]",
     openingTime = "00:00-24:00",
     */
    
    
    

    
}

#pragma mark --- GoodStoreTableViewCellDelegate
/** 选择店铺*/
- (void)clickStoreCellWithPage:(NSInteger)page {
    NSLog(@"选中店铺...");
//    _shopPage = page;
//    
//    if (_selectColorArrayM.count) {
//        [_selectColorArrayM removeAllObjects];
//    }
//    if (_shopArrayM.count >= page) {
//        ShopAddressModel *model = _shopArrayM[page];
//        NSArray *colorArray = [model.color_ios componentsSeparatedByString:@","];
//        if (colorArray.count) {
//            [_selectColorArrayM addObjectsFromArray:colorArray];
//        }
//        _colorStr = @"";
//    }
//    [self.tableView reloadData];
    
    
    self.shopListSelectedAction(page);
    
}
/** 点击店铺电话*/
- (void)clickPhoneBtnWithPage:(NSInteger)page {

    NSLog(@"点击 电话...");
        NSString *phone = @"";
    if (_datasourcesArr.count >= page) {
        ShopAddressModel *model = _datasourcesArr[page];
        phone = model.phone;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
/** 点击进入地址详情*/
- (void)clickAddressBtnWithPage:(NSInteger)page {
    
    NSLog(@"点击 地图 进入详细地址...");
    AddressInfoViewController *vc = [[AddressInfoViewController alloc]init];
    vc.isBackBtnShow = YES;
    if (_datasourcesArr.count >= page) {
        vc.model = _datasourcesArr[page];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 210*SizeScale750;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasourcesArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoodStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodStoreTableViewCellIdentify];
    cell.model = self.datasourcesArr[indexPath.row];
    cell.delegate = self;
    cell.page = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    NSLog(@"选中...");
//}




#pragma -------lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:kGetKeyWindow.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.backgroundColor = [UIColor blackColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GoodStoreTableViewCell class] forCellReuseIdentifier:goodStoreTableViewCellIdentify];
        
    }
    
    
    return _tableView;
    
    
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
