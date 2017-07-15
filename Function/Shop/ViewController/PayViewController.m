//
//  PayViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PayViewController.h"
#import "PaySuccessViewController.h"

#import "PayTableViewCell.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "PaymentManager.h"
#import "QDAlertView.h"
#import "AFNetworking.h"
#import "PaymentHandler.h"
#import "PaymentManager.h"
#import "PayFailureView.h"
#import "AppDelegate.h"
#import "WeChatManager.h"



@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate,WXApiManagerDelegate>
{
    /** 标记是支付宝还是微信*/
    NSInteger _page;
    
    NSInteger requestTimes;
}

@property (nonatomic,strong) UITableView *tableView;

/** 应付款*/
@property (nonatomic,strong) UILabel *shouldPayLabel;

/** 弹框*/
@property (nonatomic,strong) QDAlertView *alertVIew;
@end

@implementation PayViewController

static NSString *const kPayTableViewCell = @"PayTableViewCell";


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kPaymentCenter];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kPaymentCenter];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[PaymentManager sharedManager].delegate= self;
    
    [self creatTitleViewWithString:@"支付中心"];
    
    _page = 0;
    requestTimes = 0;
    
    
    //ui
    [self.view addSubview:self.tableView];
    
    [self setupHeaderView];
    
    [self setupFooterView];
    
    [self.tableView registerClass:[PayTableViewCell class] forCellReuseIdentifier:kPayTableViewCell];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kAliPaySuccessNotification object:nil];
//    // Do any additional setup after loading the view.
//    //kAliPayFailureNotification
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTheFailureView) name:kAliPayFailureNotification object:nil];
    
    [PaymentManager sharedManager].delegate = self;
    
}
#pragma mark --- ui
- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 274)];
    headerView.backgroundColor = [UIColor blackColor];
    
    UIImageView *shouldImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 71, 48, 38)];
    shouldImageView.image = [UIImage imageNamed:@"pay_should_icon"];
    [headerView addSubview:shouldImageView];
    UILabel *shouldLabel = [UILabel qd_labelWithFrame:CGRectMake720(106, 71, 150, 38) title:@"应付金额" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:30];
    [headerView addSubview:shouldLabel];

    self.shouldPayLabel.text = [NSString stringWithFormat:@"￥%.2f",self.needPayMoney.floatValue];
    [headerView addSubview:self.shouldPayLabel];
    
    UILabel *platformLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 180, 720, 94) title:@"    支付方式" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:24];
    platformLabel.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
    [headerView addSubview:platformLabel];
    
    
    self.tableView.tableHeaderView = headerView;
}
- (void)setupFooterView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 200)];
    bgView.backgroundColor = [UIColor blackColor];
    
    UIButton *payBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(35, 138, 650, 90) title:@"确认支付" titleColor:kColorForfff titleFont:34 backgroundColor:UIColorFromRGB_16(0xe60012) tapAction:^(UIButton *button) {

        if (_page == 0) {
            //[self clickPayBtn];
            [self payAliPay];
        } else if (_page == 1) {
            //[self jumpToBizPay];
            [self payWeChat];
        }
        
        //[self jumpToBizPay];
    }];
    payBtn.layer.cornerRadius = 8*SizeScale;
    [bgView addSubview:payBtn];
    
    self.tableView.tableFooterView = bgView;
}


// modify by manman   on 2016-10-29 这个方法 被废弃
/** 支付宝支付*/
- (void)clickPayBtn {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021186855969";
    NSString *seller = @"caiwu@7dbike.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAK3hasD6TmAflz4IeTava3PkoiV/fs61AgjTDh4LsqeZgtAyLYX/mmZpRyO2vHChJd3KEgBmy2nbopmPh2s9ijVBKuUiNJhM6apBBoRY9IFzlHxvXgKr2D87dXH38g3ckpHh4VyODpnPe580l+/JLuKnbpwIj86OphqnNe0ac6qTAgMBAAECgYAuUwPR7d27li8BA9jnTMzfz2Wzf8gU4fxsxW3Za1xpcmh7dyLRtEs6RYoCZcjGaOhhslgha0F+Llmfd7GoTHjpToNsYrhS+He/5WrieotX/qG/9nAN4c6deda8hiSqWDLBxYJJJEZ+YSIzs0o0ZwusaA50ac2Cu2Io8SIh+XC6IQJBAOKDdxoRAxTDxFY5+KUi/8Af2XcaL/00cw3tc0LT0G5OtvcpDU8rKpTsYy/CR8ytUWyYYSr836XwOwy1HWSW0r8CQQDEg/a1q0U2HTZ7nqAmVPWAo/yF5oI/fnL3kldP7qtEMrNxUSq6lUamSblUGWZIKU9BIP/rkA03lFJjgS0kuiEtAkA83y+GpcO6NNHyiimz1y/7pZN/Wl5DIXE58PHkp59/xU+OJE4bVHJhCxWso/0/l+Ql1t1l/AbuRRzZUWLQwWdpAkEAmGp5mOGjppr1vN+E+vX+C64kl333G2Ppq1bXXWmRcC2au5Lmfxx0VVjs4utoRyOzEqKTm5J4jdj+Jar05n1uaQJASi+SN7Y+gAi6pBIyEE4lK52pnlEdbMB+YKtUkIAOoFOgi3OMfPbKUTGQ8/pwE1YSayTWgUwLUjNCa6MCKU0FAg==";
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = self.orderID; //订单ID（由商家自行制定）
    order.subject = [NSString stringWithFormat:@"应支付%@",self.needPayMoney]; //商品标题
    order.body = [NSString stringWithFormat:@"应支付%@",self.needPayMoney]; //商品描述
    //order.totalFee = [NSString stringWithFormat:@"0.01"]; //商品价格
//#warning ---商品价格
    order.totalFee = self.needPayMoney; //商品价格
    //
    order.notifyURL = kUrl_payCallBack; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"QiDai";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        //NSLog(@"%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut aipay response  = %@",resultDic);
        }];
    }
    
    
    
//    //http://10.0.0.13:8080/7dbike/mall/alipay/createPrivateKey?payOrderNo=1011111&title=%E6%B5%8B%E8%AF%95&detai=%E6%B5%8B%E8%AF%95&totalAmount=0.01
//    //http://120.27.36.179:8080/q7bike/mall/alipay/createPrivateKey?payOrderNo=1466680539&title=%E6%B5%8B%E8%AF%95&detai=%E6%B5%8B%E8%AF%95&totalAmount=0.01
//    [QDHttpTool getWithURL:@"http://10.0.0.13:8080/q7bike/mall/alipay/createPrivateKey?payOrderNo=1466680539&title=ceshi&detail=ceshi&totalAmount=0.01" params:nil success:^(BOOL isSuccess, NSDictionary *responseObject) {
//        NSString *str = [responseObject valueForKey:@"data"];
//        NSLog(@"%@",str);
////        [[AlipaySDK defaultService] payOrder:str
////                                  fromScheme:@"QiDai"
////                                    callback:^(NSDictionary *resultDic){
////                                        NSLog(@"------%@",resultDic);
////                                    }];
//        [[AlipaySDK defaultService] payOrder:str fromScheme:@"QiDai" callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//    } failure:^(NSError *error) {
//        
//    }];
    
    
}


// 微信APP 支付  这个需要 更改  到payWeChat  以废弃
- (void)jumpToBizPay {
    NSDictionary *requestParamater = @{@"payOrderNo":self.orderID,
                                       @"title":[NSString stringWithFormat:@"骑待－订单编号%@",self.orderID],
                                       @"detail":[NSString stringWithFormat:@"应支付%@",self.needPayMoney],
                                       @"totalAmount":self.needPayMoney
                                       };
        [QDHttpTool getWithURL:kUrl_payWechat params:requestParamater success:^(BOOL isSuccess, NSDictionary *responseObject) {
                 //调起微信支付
            NSLog(@"%@",responseObject);
            
            NSDictionary *requestParamater = [[NSDictionary alloc]initWithObjectsAndKeys:
            [responseObject[@"data"] objectForKey:@"partnerid"],@"partnerId",
            [responseObject[@"data"] objectForKey:@"prepayid"],@"prepayId",
            [responseObject[@"data"] objectForKey:@"noncestr"],@"nonceStr",
            [responseObject[@"data"] objectForKey:@"sign"],@"sign",nil];
              
            NSMutableString *timeStamp = [responseObject[@"data"] objectForKey:@"timestamp"];
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = kWeChatAPPID;
            req.partnerId           = [requestParamater objectForKey:@"partnerId"];//@"1344449701";//1344449701
            req.prepayId            = [requestParamater objectForKey:@"prepayId"];
            req.nonceStr            = [requestParamater objectForKey:@"nonceStr"];
            req.timeStamp           = timeStamp.intValue;
            req.package             = @"Sign=WXPay";
            req.sign                = [requestParamater objectForKey:@"sign"];
            
             [WXApi sendReq:req];
            NSLog(@"appid=%@\npartnerId=%@\nprepayId=%@\nnonceStr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[responseObject [@"data"] objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
           
        } failure:^(NSError *error) {
            NSLog(@"kUrl_payWechat%@",error);
            
        }];
    

}


// 请求 支付中心  返回 失败
- (void)managerDidRecvFailureInfo:(NSString *)isFailure
{
    
    if ([isFailure isEqualToString:@"Failure1"]) {
        [self showTheFailureView];
    }else
    {
        //Failure2无操作
    }
   
    
    
    //[UIApplication.sharedApplication().keyWindow  addSubview:failureView];
    
}

- (void)managerDidRecvSuccessInfo:(NSString *)isSuccess
{
    [self paySuccess];
    NSLog(@" success ...");
    
}


- (void)showTheFailureView
{
    NSLog(@"wechat shibaile ");
    PayFailureView *failureView = [[PayFailureView alloc]initWithFrame:self.view.bounds];
    failureView.clickReturnBlock = ^{
        //[self.navigationController popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
        if (  tab.selectedIndex != 2) {
            tab.selectedIndex = 2;
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:failureView];
    
    
}


// 微信支付
- (void)payWeChat
{
    
    BOOL isInstall = [[WeChatManager instance] isWeChatInstalled];
    if (!isInstall) {
        [self showTheALertMessage:@"提示" andDescription:@"您未安装微信客户端"];
        return;
    }
    
#warning 这个方法 需要将返回的code码 做出相应的处理 
    /**
     * 现在需要 修改 错误的反悔参数
     */
    
    NSDictionary *requestParamater = @{@"payOrderNo":self.orderID,
                                       @"title":[NSString stringWithFormat:@"骑待－订单编号%@",self.orderID],
                                       @"detail":[NSString stringWithFormat:@"应支付%@",self.needPayMoney],
                                       @"totalAmount":self.needPayMoney
                                       };
    
    [PaymentHandler paymentWeChat:requestParamater andSuccessBlock:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"微信 预订单 生成 成功 ...");
    } andFailureBlock:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"微信 预订单 生成 失败 ...");
    }];
    
    
    
}

#warning  支付宝支付 在调用 支付之前 要先调用 order/checkOrder 检测是否 可以购买


- (void)payAliPay
{
    NSDictionary *requestParamater = @{@"payOrderNo":self.orderID,
                                       @"title":[NSString stringWithFormat:@"骑待－订单编号%@",self.orderID],
                                       @"detail":[NSString stringWithFormat:@"应支付%@",self.needPayMoney],
                                       @"totalAmount":self.needPayMoney
                                       };
    [PaymentHandler paymentAlipay:requestParamater andSuccessBlock:^(BOOL isSuccess, NSDictionary *responseObject) {
         NSLog(@"支付宝 预订单 生成 成功 ...");
    } andFailureBlock:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"支付宝 预订单 生成 失败 ...");
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickSelectBtnWithPage:(NSInteger)page {
    _page = page;
    [self.tableView reloadData];
}
- (void)paySuccess {
    //参数：payOrderNo 订单号
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"payOrderNo":self.orderID};
    [QDHttpTool getWithURL:kUrl_checkPaySuccess params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        BOOL isResult = NO;
        isResult = [responseObject objectForKey:@"data"];
        
        if (isSuccess) {
            if (isResult) {
              [self jumpPaySuccessView];
            }else {
                if (requestTimes <2) {
                    NSLog(@" request times %ld",(long)requestTimes);
                    
                    [weakSelf paySuccess];
                    requestTimes++;
                    
                    
                }else
                {
                    NSLog(@" show the Failure  request times %ld",(long)requestTimes);
                    requestTimes =0;
                    NSLog(@" request times %ld",(long)requestTimes);
                    [self showTheFailureView];
                    
                }
                
            }
            
        }
        //[[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
       
        
 
    } failure:^(NSError *error) {
        if (requestTimes <2) {
            NSLog(@" request times %ld",requestTimes);
            
            [weakSelf paySuccess];
            requestTimes++;
            
            
        }else
        {
            NSLog(@" show the Failure  request times %ld",requestTimes);
            requestTimes =0;
            NSLog(@" request times %ld",requestTimes);
            [self showTheFailureView];
            
        }
        
        
    }];
    
}
- (void)jumpPaySuccessView {
    PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
    vc.payType = self.payType;
    vc.isShopEnter = YES;
    vc.needPayMoney = self.needPayMoney;
    vc.orderID = self.orderID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayTableViewCell];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.page = indexPath.row;
    if (_page == indexPath.row) {
        cell.isSelect = YES;
    }else {
        cell.isSelect = NO;
    }
    cell.clickSelectBtnBlock = ^(NSInteger page) {
        [self clickSelectBtnWithPage:page];
    };
    return cell;
}


- (void)showTheALertMessage:(NSString *)titleStr andDescription:(NSString *)descriptionStr
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:titleStr message:descriptionStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}


#pragma mark --- lazy load
- (QDAlertView *)alertVIew {
    if (!_alertVIew) {
        _alertVIew = [[QDAlertView alloc]initWithFrame:self.view.bounds];
        _alertVIew.title = @"好机会稍纵即逝\n确定要放弃支付吗";
        _alertVIew.sureBtnTitle = @"继续支付";
        _alertVIew.cancleBtnTitle = @"放弃";
        _alertVIew.isContrary = YES;
        @weakify_self
        _alertVIew.clickSureBlock = ^ {
            @strongify_self
            [self.navigationController popViewControllerAnimated:YES];
        };
        [_alertVIew updateUIAutolayout];
    }
    return _alertVIew;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.height = self.view.height - 64 ;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120*SizeScaleSubjectTo720;
    }
    return _tableView;
}
- (UILabel *)shouldPayLabel {
    if (!_shouldPayLabel) {
        _shouldPayLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 70, 324, 40) title:@"baise" titleColor:UIColorFromRGB_16(0xe60012) textAlignment:NSTextAlignmentRight font:40];
    }
    return _shouldPayLabel;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --- super method
- (void)clickBackBtn {
    //[self.navigationController popViewControllerAnimated:YES];
    [self.view addSubview:self.alertVIew];
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
