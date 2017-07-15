//
//  MyOrdersViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "OrderDetailViewController.h"
#import "PublishCommentViewController.h"
#import "LogisticsViewController.h"
#import "OrderPayViewController.h"
#import "MyOrdersTableViewCell.h"
#import "MyOrderModel.h"
#import "PayViewController.h"
#import "QDAlphaWarnView.h"
#import "NoOrdersTableViewCell.h"
#import "MJRefresh.h"
#import "UploadImageManager.h"
#import "MineBillInfoTableViewCell.h"
#import "UpdateBillDetailInfoViewController.h"

@interface MyOrdersViewController ()<UITableViewDelegate,UITableViewDataSource,MyOrdersTableViewCellDelegate>
{
    /** 全部*/
    NSMutableArray *_allArrayM;
    /** 待付款*/
    NSMutableArray *_waitPayArrayM;
    /** 待取货*/
    NSMutableArray *_waitPickArrayM;
    /** 待收货*/
    NSMutableArray *_waitTakeArrayM;
    /** 待评价*/
    NSMutableArray *_waitEvaluateArrayM;
    
    /** 中间变量，tableView根据这个来判断*/
    NSMutableArray *_tempArrayM;
    
    NSInteger _tag;
}
@property (nonatomic, strong) UITableView *orderListTableView;
/** 白线*/
@property (nonatomic, strong) UIView *anmationLine;
/** tempBtn*/
@property (nonatomic, strong) UIButton *tempBtn;


@property (nonatomic,strong) NSTimer *stopwatchOrderListTime;


@property (nonatomic,strong) QDAlphaWarnView  *alertViewImageView;


@end

static NSString *const kNoOrdersTableViewCell = @"NoOrdersTableViewCell";

static NSString *const kMineBillInfoTableViewCellIdentify = @"MineBillInfoTableViewCell";

@implementation MyOrdersViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // add by manman on 2016-11-03
    // BUG 350 进入自动刷新 
    [self refreshDataSource];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    [self creatTitleViewWithString:@"我的订单"];
    //初始化数据
    _allArrayM = @[].mutableCopy;
    _waitPayArrayM = @[].mutableCopy;
    _waitPickArrayM = @[].mutableCopy;
    _waitTakeArrayM = @[].mutableCopy;
    _waitEvaluateArrayM = @[].mutableCopy;
    _tempArrayM = @[].mutableCopy;
    _tag = -1;
    [self createViews];
    
    [self.orderListTableView registerClass:[NoOrdersTableViewCell class] forCellReuseIdentifier:kNoOrdersTableViewCell];
    
    [self.orderListTableView registerClass:[MineBillInfoTableViewCell class] forCellReuseIdentifier:kMineBillInfoTableViewCellIdentify];
    @weakify_self
    self.orderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify_self
        [self refreshDataSource];
    }];
    //[self getDataSource];
    
    
    // Do any additional setup after loading the view.
}
- (void)createViews {
    NSArray *array = @[@"全部",@"待付款",@"待取货",@"待收货",@"待评价"];
    for ( int i = 0; i < array.count; i++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(i*HCDW/5, 0,HCDW/5, 90*SizeScale);
        selectBtn.tag = i;
        selectBtn.titleLabel.font = UIFontOfSize720(26);
        [selectBtn setTitle:array[i] forState:UIControlStateNormal];
        [selectBtn setTitleColor:kColorForccc forState:UIControlStateNormal];
        [selectBtn setTitleColor:kColorForfff forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(moveLine:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectBtn];
        if (i == 0) {
            self.tempBtn = selectBtn;
        }
    }
    [self.view addSubview:self.orderListTableView];
    self.orderListTableView.tableFooterView = [[UIView alloc]init];
    self.orderListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    self.anmationLine = [[UIView alloc] initWithFrame:CGRectMake(0, 90*SizeScaleSubjectTo720, HCDW/5, 2)];
    self.anmationLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.anmationLine];
}



- (void)createTimer {
    
    
    self.stopwatchOrderListTime = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.stopwatchOrderListTime forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    
    //    for (int count = 0; count < _stopwatchTimeDatasourcesMArr.count; count++) {
    ////
    ////        TimeModel *model = _m_dataArray[count];
    ////        [model countDown];
    //    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ORDERLIST_TIME_CELL object:nil];
}



#pragma mark --- interface
/** 刷新数据*/
- (void)refreshDataSource {
    switch (_tag) {
        case -1:
            ARRAYM_REMOVW_ALLOBJECTS_(_allArrayM);
            break;
        case 0:
            ARRAYM_REMOVW_ALLOBJECTS_(_waitPayArrayM);
            break;
        case 1:
            ARRAYM_REMOVW_ALLOBJECTS_(_waitPickArrayM);
            break;
        case 8:
            ARRAYM_REMOVW_ALLOBJECTS_(_waitTakeArrayM);
            break;
        case 3:
            ARRAYM_REMOVW_ALLOBJECTS_(_waitEvaluateArrayM);
            break;
        default:
            break;
    }
    [self getOrderDataSourceWithPage:_tag];
}
/** 一进去就请求总的*/
- (void)getDataSource {
    [self getOrderDataSourceWithPage:-1];
}
/**
 *  请求网络
 *
 *  @param page 标记
 */
- (void)getOrderDataSourceWithPage:(NSInteger)page {
    
    
    NSDictionary *brandParam = @{@"start":@"0",
                                 @"status":@(page),
                                 @"userInfoId":kUserId};
    if (_tempArrayM.count) {
        [_tempArrayM removeAllObjects];
    }
    switch (page) {
        case -1:
            if (_allArrayM.count) {
                [_tempArrayM addObjectsFromArray:_allArrayM];
                [self.orderListTableView reloadData];
                return;
            }
            break;
        case 0:
            if (_waitPayArrayM.count) {
                [_tempArrayM addObjectsFromArray:_waitPayArrayM];
                [self.orderListTableView reloadData];
                return;
            }
            break;
        case 1:
            if (_waitPickArrayM.count) {
                [_tempArrayM addObjectsFromArray:_waitPickArrayM];
                [self.orderListTableView reloadData];
                return;
            }
            break;
        case 8:
            if (_waitTakeArrayM.count) {
                [_tempArrayM addObjectsFromArray:_waitTakeArrayM];
                [self.orderListTableView reloadData];
                return;
            }
            break;
        case 3:
            if (_waitEvaluateArrayM.count) {
                [_tempArrayM addObjectsFromArray:_waitEvaluateArrayM];
                [self.orderListTableView reloadData];
                return;
            }
            break;
        default:
            break;
    }
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    [QDHttpTool getWithURL:kUrl_getOrderByStatus params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (!isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
            return ;
        }
        if (_tempArrayM.count) {
            [_tempArrayM removeAllObjects];
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        NSLog(@"%@",responseObject);
        switch (page) {
            case -1:
                _allArrayM = [MyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [_tempArrayM addObjectsFromArray:_allArrayM];
                break;
            case 0:
                _waitPayArrayM = [MyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [_tempArrayM addObjectsFromArray:_waitPayArrayM];
                break;
            case 8:
                _waitPickArrayM = [MyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [_tempArrayM addObjectsFromArray:_waitPickArrayM];
                break;
            case 10:
                _waitTakeArrayM = [MyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [_tempArrayM addObjectsFromArray:_waitTakeArrayM];
                break;
            case 9:
                _waitEvaluateArrayM = [MyOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [_tempArrayM addObjectsFromArray:_waitEvaluateArrayM];
                // 添加刷新运动页面
                [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
                break;
            default:
                break;
        }
        [self.orderListTableView.mj_header endRefreshing];
        [self.orderListTableView reloadData];
    } failure:^(NSError *error) {
        [self.orderListTableView.mj_header endRefreshing];
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
#pragma mark --- private method
- (void)moveLine:(UIButton *)btn {
    if (self.tempBtn == btn) {
        return;
    }
    NSInteger page = -1;
    //后台规定好的,勿动
    switch (btn.tag) {
        case 0:
            page = -1;
            break;
        case 1:
            page = 0;
            break;
        case 2:
            page = 8;
            break;
        case 3:
            page = 10;
            break;
        case 4:
            page = 9;
            break;
        default:
            break;
    }
    _tag = page;
    [self getOrderDataSourceWithPage:page];
    [UIView animateWithDuration:0.3f animations:^{
        self.tempBtn.titleLabel.font = UIFontOfSize720(26);
        btn.titleLabel.font = UIFontOfSize720(30);
        self.anmationLine.frame = CGRectMake(btn.tag*HCDW/5, 90*SizeScaleSubjectTo720, HCDW/5, 2);
    }];
    self.tempBtn.selected = NO;
    self.tempBtn = btn;
    self.tempBtn.selected = YES;
    
}
#pragma mark --- MyOrdersTableViewCellDelegate
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
    vc.payType = model.pay_type;
    vc.orderID = model.orderId;
    vc.needPayMoney = model.needPayMoney;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 查看物流*/
- (void)clickCheckLogisticsWithModel:(MyOrderModel *)model {
    LogisticsViewController *vc = [[LogisticsViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 添加商品评价*/
- (void)clickAddGoodCommentWithModel:(MyOrderModel *)model {
    PublishCommentViewController *vc = [[PublishCommentViewController alloc]init];
    //vc.isBackBtnShow = YES;
    vc.myOrderModel = model;
    vc.isActivity = NO;
    vc.bikeInfo = [NSString stringWithFormat:@"%@ %@ %@ %@",model.brand,model.series,model.model,model.color];
    vc.bikeImageUrl = model.itemImg;
    vc.refreshDataSourceBlock = ^{
        ARRAYM_REMOVW_ALLOBJECTS_(_waitEvaluateArrayM);
        ARRAYM_REMOVW_ALLOBJECTS_(_allArrayM);
        [self getOrderDataSourceWithPage:_tag];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
/** 添加活动评价*/
- (void)clickAddActivityCommentWithModel:(MyOrderModel *)model {
    PublishCommentViewController *vc = [[PublishCommentViewController alloc]init];
    //vc.isBackBtnShow = YES;
    vc.myOrderModel = model;
    vc.isActivity = YES;
    vc.bikeInfo = [NSString stringWithFormat:@"%@ %@ %@ %@",model.brand,model.series,model.model,model.color];
    vc.refreshDataSourceBlock = ^{
        ARRAYM_REMOVW_ALLOBJECTS_(_waitEvaluateArrayM);
        ARRAYM_REMOVW_ALLOBJECTS_(_allArrayM);
        [self getOrderDataSourceWithPage:_tag];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma --------newOrder ---start


- (void)MineBillInfoClickAction:(NSDictionary *) parameter
                  andOrderModel:(MyOrderModel *) minOrderModel
{
    if ([[parameter valueForKey:kMineBillInfoPayAction]
         isEqualToString:kMineBillInfoPayAction]) {
        
        [self MineBillInfoPayAction:parameter andOrderModel:minOrderModel];
    }
    
    if ([[parameter valueForKey:kMineBillInfoCommentGoodsAction]
         isEqualToString:kMineBillInfoCommentGoodsAction]) {
        
        [self MineBillInfoCommentGoodsAction:parameter andOrderModel:minOrderModel];
    }
    
    if ([[parameter valueForKey:kMineBillInfoCommentActivityAction]
         isEqualToString:kMineBillInfoCommentActivityAction]) {
        
        [self MineBillInfoCommentActivityAction:parameter andOrderModel:minOrderModel];
    }
    
    if ([[parameter valueForKey:kMineBillInfoLogisticsButtonAction]
         isEqualToString:kMineBillInfoLogisticsButtonAction]) {
        
        [self MineBillInfoCommentLogisticsButtonAction:parameter andOrderModel:minOrderModel];
    }
    
    if ([[parameter valueForKey:kMineBillInfoDeleteBillAction]
         isEqualToString:kMineBillInfoDeleteBillAction]) {
        
        [self MineBillInfoDeleteBillAction:parameter andOrderModel:minOrderModel];
    }
    
    
}

/**
 *  点击 支付
 *
 *  @param parameter
 */
- (void)MineBillInfoPayAction:(NSDictionary *)parameter
                andOrderModel:(MyOrderModel *) mineOrderModel
{
    NSLog(@"控制器中 点击  去支付 ...");
    
    [self clickPayWithModel:mineOrderModel];
    
    
    
}


/**
 *  点击  评论商品
 *
 *  @param parameter
 */
- (void)MineBillInfoCommentGoodsAction:(NSDictionary *)parameter
                         andOrderModel:(MyOrderModel *) mineOrderModel
{
    NSLog(@"控制器中 点击  评论 商品   ...");
    [self clickAddGoodCommentWithModel:mineOrderModel];
    
    
    
}


/**
 *  点击  评论活动
 *
 *  @param parameter
 */
- (void)MineBillInfoCommentActivityAction:(NSDictionary *)parameter
                            andOrderModel:(MyOrderModel *) mineOrderModel
{
    NSLog(@"控制器中 点击  评论  活动 ...");
    
    [self clickAddActivityCommentWithModel:mineOrderModel];
    
}


/**
 *  点击 查询物流
 *
 *  @param parameter
 */

- (void)MineBillInfoCommentLogisticsButtonAction:(NSDictionary *)parameter
                                   andOrderModel:(MyOrderModel *) mineOrderModel
{
    
     NSLog(@"控制器中 点击  查看物流  ...");
    [self clickCheckLogisticsWithModel:mineOrderModel];
    
}


/**
 *  点击  删除  订单
 *
 *  @param parameter
 */
- (void)MineBillInfoDeleteBillAction:(NSDictionary *)parameter
                       andOrderModel:(MyOrderModel *) mineOrderModel
{
    NSLog(@"控制器中 点击  删除 订单 ...");
    [self cancleBillNetWork:mineOrderModel];
    [self refreshDataSource];
    
}


- (void)cancleBillNetWork:(MyOrderModel *) mineOrderModel
{
 
    NSDictionary *brandParam = @{@"orderId":mineOrderModel.orderId,
                                 @"userInfoId":kUserId,
                                 @"type":@"0"};
    [QDHttpTool getWithURL:kNewUrl_cancelOrderByOrderId params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        /**
         *  {"code":"00","data":{"msg":"取消订单成功","success":true},"message":"请求成功"}
         
         */
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            NSString *message = [responseObject[@"data"] objectForKey:@"msg"];
            [self setAlertViewTitle:@"提示" andSubMessage:message];
//            [self canaleBillOperation];
            
        }else
        {
            NSString *message = [responseObject[@"data"] objectForKey:@"msg"];
            [self setAlertViewTitle:@"提示" andSubMessage:message];
        }
        
        
    }failure:^(NSError *error) {
        NSLog(@"getOrderDetailData %@",error.localizedDescription);
    }];
    
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





#pragma --------newOrder ---end








#pragma mark --- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tempArrayM && _tempArrayM.count == 0) {
        return 1;
    }
    return _tempArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tempArrayM && _tempArrayM.count == 0) {
        NoOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoOrdersTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (!QDDEBUGGOODSDETAIL) {
        MyOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[MyOrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.model = _tempArrayM[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        MineBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineBillInfoTableViewCellIdentify];
        
        cell.orderUpdateModel = _tempArrayM[indexPath.row];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        @weakify_self
        
        cell.minBillInfoActin = ^(NSDictionary *parameter,MyOrderModel *mineOrderModel)
        {
            @strongify_self
            [self MineBillInfoClickAction:parameter andOrderModel:mineOrderModel];
            
        };
        return cell;
    }
    
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (_tempArrayM.count == 0 || _tempArrayM.count < indexPath.row) {
        return;
    }
    
    if (!QDDEBUGGOODSDETAIL) {
        
        MyOrderModel *model = _tempArrayM[indexPath.row];
        if ([model.status isEqualToString:@"0"] ||[model.status isEqualToString:@"14"]) {
            OrderPayViewController *vc = [[OrderPayViewController alloc]init];
            vc.isBackBtnShow = YES;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.model = model;
        vc.refreshDataSourceBlock = ^ {
            ARRAYM_REMOVW_ALLOBJECTS_(_allArrayM);
            [self getOrderDataSourceWithPage:_tag];
        };
         [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        UpdateBillDetailInfoViewController *vc = [[UpdateBillDetailInfoViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.updateBillDetailModel = _tempArrayM[indexPath.row];
        vc.refreshDataSourceBlock = ^ {
            ARRAYM_REMOVW_ALLOBJECTS_(_allArrayM);
            [self getOrderDataSourceWithPage:_tag];
        };
         [self.navigationController pushViewController:vc animated:YES];
        
    }
   
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tempArrayM && _tempArrayM.count == 0) {
        return 1100*SizeScale;
    } else {
        return 396*SizeScale;
    }
}
#pragma mark --- super method
- (void)clickBackBtn {
    if (self.isShopEnter) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- lazy load
- (UITableView *)orderListTableView {
    if (!_orderListTableView) {
        _orderListTableView = [[UITableView alloc] init];
        _orderListTableView.frame = CGRectMake(0, 90*SizeScale, HCDW, HCDH-90*SizeScale);
        _orderListTableView.height -= kNavigationViewHeight;
        _orderListTableView.backgroundColor = [UIColor blackColor];
        //_orderListTableView.rowHeight = 396*SizeScale;
        _orderListTableView.delegate = self;
        _orderListTableView.dataSource = self;
        _orderListTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _orderListTableView;
}

- (QDAlphaWarnView *)alertViewImageView
{
    if (!_alertViewImageView) {
        _alertViewImageView = [[QDAlphaWarnView alloc]initWithFrame:self.view.bounds];
    }
    return _alertViewImageView;
    
    
    
}

- (void)dealloc
{
    
    [_stopwatchOrderListTime invalidate];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
