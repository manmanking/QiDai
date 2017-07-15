//
//  PaySuccessViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "UpdateBillDetailInfoViewController.h"
#import "PaySuccessOnlineView.h"
#import "PaySuccessOfflineView.h"
#import "MyOrdersViewController.h"
#import "MyOrderModel.h"
#import "GoodsModel.h"
#import "WXApi.h"
@interface PaySuccessViewController ()<WXApiDelegate>

@end

@implementation PaySuccessViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kReceiptAddress];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
     [MobClick beginLogPageView:kReceiptAddress];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //快递
//#warning ---支付成功逻辑判断
    if ([self.payType isEqualToString:@"1"]) {
        PaySuccessOnlineView *onlineView = [[PaySuccessOnlineView alloc]initWithFrame:self.view.bounds];
        onlineView.needPayMoney = [NSString stringWithFormat:@"%.2f",self.needPayMoney.floatValue];
        onlineView.clickReturnBlock = ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        onlineView.clickCheckOrderBlock = ^{
            
             //[self jumpMyOrderViewController];
            if (!QDDEBUGGOODSDETAIL) {
                [self jumpMyOrderViewController];
            }else
            {
                [self jumpMyOrderDetailViewController];
            }
            
        };
        [self.view addSubview:onlineView];
        return;
    }
    
    PaySuccessOfflineView *offlineView = [[PaySuccessOfflineView alloc]initWithFrame:self.view.bounds];
    //offlineView.orderModel = self.orderModel;
    offlineView.needPayMoney = self.needPayMoney;
    offlineView.orderID = self.orderID;
    offlineView.clickReturnBlock = ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    offlineView.clickCheckOrderBlock = ^{
        //[self jumpMyOrderViewController];
        //[self jumpMyOrderViewController];
        if (!QDDEBUGGOODSDETAIL) {
            [self jumpMyOrderViewController];
        }else
        {
            [self jumpMyOrderDetailViewController];
        }
    };
    [self.view addSubview:offlineView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)jumpMyOrderViewController {
    MyOrdersViewController *vc = [[MyOrdersViewController alloc]init];
    vc.isBackBtnShow = YES;
    //vc.navigationController.navigationBarHidden = NO;
    vc.isShopEnter = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)jumpMyOrderDetailViewController {
    UpdateBillDetailInfoViewController *vc = [[UpdateBillDetailInfoViewController alloc]init];
    vc.isBackBtnShow = YES;
    MyOrderModel *tmpMyOrderModel = [[MyOrderModel alloc]init];
    vc.navigationController.navigationBarHidden = NO;
    tmpMyOrderModel.orderId = self.orderID;
    vc.updateBillDetailModel = [tmpMyOrderModel copy];
    [self.navigationController pushViewController:vc animated:YES];
    
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
