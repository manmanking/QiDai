//
//  BillConfirmViewController.m
//  QiDai
//
//  Created by manman'swork on 16/11/30.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "BillConfirmViewController.h"
#import "BillDetailInfoView.h"
#import "ExpressAssembleTableViewCell.h"
#import "StoreDetailInfoTableViewCell.h"
#import "StoreAssembleTableViewCell.h"
#import "StoreListTableViewController.h"
#import "NoAddressConfirmTableViewCell.h"
#import "AddressConfirmTableViewCell.h"
#import "BillFeeInfoView.h"
#import "PersonalAddressModel.h"
#import "PayViewController.h"
#import "AddressViewController.h"
#import "QDAlphaWarnView.h"
#import "UIButton+AcceptEvent.h"



@interface BillConfirmViewController ()<UITableViewDelegate,UITableViewDataSource,AddressViewControllerDelegate>
{
    /**
     *  1 个人  2 店铺  3 默认信息
     */
    NSString *_deliveryTypeStr;
    
    
}

/**
 *  标记 快递选择
 */
@property (nonatomic,strong) NSString *deliveryTypeAssembleExpressSelectedFlagStr;

/**
 *  标记是否选择店铺
 */
@property (nonatomic,strong) NSString *deliveryTypeAssembleStoreSelectedFlagStr;


/**
 *  标记是否选择收货地址
 */
@property (nonatomic,strong) NSString *deliveryTypeAssemblePersonalAddressSelectedFlagStr;

/**
 *  选择的商店地址
 */
@property (nonatomic,assign) NSString *shopAddressSelectedFlagStr;


@property (nonatomic,strong) NSString *deliveryTypeAssembleAfterStr;

@property (nonatomic,strong) NSString *deliveryTypeAssembleStoreStr;

@property (nonatomic,strong) NSString *deliveryTypeUnassembleStr;

@property (nonatomic,strong) BillDetailInfoView *bikeDetailInfoView;

@property (nonatomic,strong) UITableView *billConfirmTableView;

@property (nonatomic,strong) UILabel * actuallypaidTitleLabel;

@property (nonatomic,strong) UILabel * actuallypaidLabel;

@property (nonatomic,strong) UIButton *buyButton;

@property (nonatomic,strong) UIView *bottomBackgroundView;


@property (nonatomic,strong) BillFeeInfoView *billFeeInfoView;


/**
 *  快递地址
 */
@property (nonatomic,strong)NSMutableArray *personalAddressMArr;


@property (nonatomic,strong)NSMutableArray *deliveryTypeExpressMArr;



@property (nonatomic,strong)QDAlphaWarnView *alphaWarnView;




@end


static NSString *expressAssembleTableViewCellIdentify =  @"expressAssembleTableViewCellIdentify";
static NSString *expressTableViewCellIdentify =  @"expressTableViewCellIdentify";
static NSString *storeAssembleTableViewCellIdentify =  @"storeAssembleTableViewCellIdentify";
static NSString *storeDetailInfoTableViewCellIdentify = @"storeDetailInfoTableViewCellIdentify";


static NSString *noAddressConfirmTableViewCellIdentify =  @"noAddressConfirmTableViewCellIdentify";
static NSString *AddressConfirmTableViewCellIdentify = @"AddressConfirmTableViewCellIdentify";

static NSString *generallyTableViewCellIdentify = @"generallyTableViewCellIdentify";

@implementation BillConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDefaultParameter];
    NSArray *assembleArr = [self.billConfirmActivityModel.type componentsSeparatedByString:@","];
    for (NSString *tmpStr in assembleArr) {
        if ([tmpStr isEqualToString:@"0"]) {
            self.deliveryTypeAssembleAfterStr = @"0";
            [self.deliveryTypeExpressMArr addObject:self.deliveryTypeAssembleAfterStr];
        }
        if ([tmpStr isEqualToString:@"1"]) {
            self.deliveryTypeUnassembleStr = @"1";
            [self.deliveryTypeExpressMArr addObject:self.deliveryTypeUnassembleStr];
        }
        if ([tmpStr isEqualToString:@"2"]) {
            self.deliveryTypeAssembleStoreStr = @"2";
        }
        
    }
    
    
    
  
    [self.view addSubview:self.billConfirmTableView];
    self.billConfirmTableView.tableHeaderView = self.bikeDetailInfoView;
    self.bikeDetailInfoView.selectedImageViewUrlStr = self.selectedBikeImageViewUrlStr;
    self.bikeDetailInfoView.billDetailActivityModel = self.billConfirmActivityModel;
    self.bikeDetailInfoView.selectedColorStr = self.colorStr;
    self.bikeDetailInfoView.billDetailGoodsModel = self.billConfirmGoodsModel;
    
    self.billConfirmTableView.tableFooterView = self.billFeeInfoView;
    
   
    
    NSLog(@"sel %ld",(long)self.shopAddressSelectedFlagStr.integerValue);
    NSLog(@"sel %@",self.shopAddressSelectedFlagStr);
    
    
    [self.billConfirmTableView registerClass:[ExpressAssembleTableViewCell class] forCellReuseIdentifier:expressAssembleTableViewCellIdentify];
    [self.billConfirmTableView registerClass:[StoreAssembleTableViewCell class] forCellReuseIdentifier:storeAssembleTableViewCellIdentify];
    [self.billConfirmTableView registerClass:[StoreDetailInfoTableViewCell class] forCellReuseIdentifier:storeDetailInfoTableViewCellIdentify];
    [self.billConfirmTableView registerClass:[NoAddressConfirmTableViewCell class] forCellReuseIdentifier:noAddressConfirmTableViewCellIdentify];
    [self.billConfirmTableView registerClass:[AddressConfirmTableViewCell class] forCellReuseIdentifier:AddressConfirmTableViewCellIdentify];
    [self.billConfirmTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:generallyTableViewCellIdentify];
    [self setupNavigationView];
    
    
    
    [self.view addSubview:self.bottomBackgroundView];
    
    [self setBillFeeInfoViewDatasourcesAssembleDefaultFee];
    [self getAddressData];
    
    
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
   
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [self clearTheTmpDatasource];
    
    
}


- (void)setupNavigationView {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    
    // modify by manman on start of line
    
    self.navigationItem.title = @"订单确认页";
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



- (void)setDefaultParameter
{
    _deliveryTypeStr = @"3";
    self.shopAddressSelectedFlagStr = @"0";
    self.deliveryTypeAssemblePersonalAddressSelectedFlagStr = @"0";
    self.deliveryTypeAssembleExpressSelectedFlagStr = @"0";
    self.deliveryTypeAssembleStoreSelectedFlagStr = @"3";
    self.deliveryTypeAssembleStoreStr = @"5";// 不存在默认数据
    self.deliveryTypeUnassembleStr = @"5";
    self.deliveryTypeAssembleAfterStr = @"5";
    
    
    
}

- (void)clearTheTmpDatasource
{
    
    
    
}

- (void)setTableViewBottomUIViewAutolayout
{
    
    
    
    
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
            
            self.personalAddressMArr = [PersonalAddressModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            [self.billConfirmTableView reloadData];
            
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
    
}



- (void)setBillFeeInfoViewDatasourcesAssembleDefaultFee
{
    
    if ([self.deliveryTypeAssembleExpressSelectedFlagStr isEqualToString:@"0"]&&
        [self.deliveryTypeAssembleAfterStr isEqualToString:@"0"]) {
        [self setBillFeeInfoViewDatasourcesAssembleFee:self.billConfirmActivityModel.assembled_type andExpressFee:self.billConfirmActivityModel.luggage andGoodsPrice:self.billConfirmGoodsModel.price];
        CGFloat actuallpaid = self.billConfirmGoodsModel.price.floatValue + self.billConfirmActivityModel.assembled_type.floatValue+ self.billConfirmActivityModel.luggage.floatValue;

        self.actuallypaidLabel.text = [NSString stringWithFormat:@"%.2f",actuallpaid];
        
    }
    if ([self.deliveryTypeUnassembleStr isEqualToString:@"1"]&&
        [self.deliveryTypeAssembleExpressSelectedFlagStr isEqualToString:@"1"]) {
        
        NSInteger assemble = self.billConfirmActivityModel.assembled_type.integerValue -self.billConfirmActivityModel.refundLoadingCharge.integerValue;
        
        [self setBillFeeInfoViewDatasourcesAssembleFee:[NSString stringWithFormat:@"%ld",assemble] andExpressFee:self.billConfirmActivityModel.luggage andGoodsPrice:self.billConfirmGoodsModel.price];
        
        CGFloat actuallpaid = self.billConfirmGoodsModel.price.floatValue + self.billConfirmActivityModel.assembled_type.floatValue - self.billConfirmActivityModel.refundLoadingCharge.floatValue +self.billConfirmActivityModel.luggage.floatValue;
        self.actuallypaidLabel.text = [NSString stringWithFormat:@"%.2f",actuallpaid];
    }

    
    
}


- (void)setBillFeeInfoViewDatasourcesAssembleFee:(NSString *)assembleFeeStr
                                   andExpressFee:(NSString *)expressFeeStr
                                   andGoodsPrice:(NSString *)goodsPrices
{

    NSDictionary *parameter = [[NSDictionary alloc]initWithObjectsAndKeys:assembleFeeStr,@"assembleFee",
                               expressFeeStr,@"expressFee",goodsPrices,@"goodsPrices",nil];
    
    self.billFeeInfoView.billFeeParameter = parameter;
    
    
    
}

//self.saveBtn.qd_acceptEventInterval = 2.0f;
- (void)buyButtonClick:(UIButton *)sender
{
    NSLog(@"点击  提交订单 ...");
    [self saveOrder];
    
}





- (void)saveOrder {
    //点击立即购买 activityId:参加活动id  addressId收货地址id(到店自取传-1)  storeId(店铺地址,必填)
    //shopId商品id
     NSString *deliveryType = @"0";
    NSString  *assembleCharges = self.billConfirmActivityModel.assembled_type;
    // 店铺组装
    if ([self.deliveryTypeAssembleStoreSelectedFlagStr isEqualToString:@"0"] &&
        [self.deliveryTypeAssembleStoreStr isEqualToString:@"2"]) {
        deliveryType= @"2";
    }
    // 组装后 发货
    if ([self.deliveryTypeAssembleAfterStr isEqualToString:@"0"])// 组装后
    {
        if ([self.deliveryTypeAssembleExpressSelectedFlagStr isEqualToString:@"0"]) {
       
            deliveryType= @"0";
        }
        
    }
    
    // 散装
    if ([self.deliveryTypeUnassembleStr isEqualToString:@"1"])
    {
        if ([self.deliveryTypeAssembleExpressSelectedFlagStr isEqualToString:@"1"]) {
            deliveryType= @"1";
             assembleCharges = [NSString stringWithFormat:@"%.2lf",self.billConfirmActivityModel.assembled_type.floatValue - self.billConfirmActivityModel.refundLoadingCharge.floatValue];
        }
    }
   
    /**
     *  activityId  
        userInfoId
     bonus
     addressId
     color
     count 默认 为1
     shopId
     money 支付金额
     assembleCharges 组装费
     type  1快递 2自提
     taskDetailId
     */
    
    NSString *refund = self.billConfirmActivityModel.refund;
    
    if (self.personalAddressMArr.count == 0 &&([deliveryType isEqualToString:@"0"]||[deliveryType isEqualToString:@"1"]))
    {
        
        [self setAlertViewTitle:@"提示" andSubMessage:@"请选择收获地址"];
        return;
    }
    
    PersonalAddressModel *personalAddressModel = self.personalAddressMArr[self.deliveryTypeAssemblePersonalAddressSelectedFlagStr.integerValue];
    
    NSString *addressId = personalAddressModel.id;
//    NSInteger sele = self.shopAddressSelectedFlagStr;
   ShopAddressModel *shopTmpModel = self.shopAddressMArr[self.shopAddressSelectedFlagStr.integerValue];
    
    NSDictionary *brandParam = @{@"activityId":self.billConfirmActivityModel.id,// 默认传递－1
                                 @"bonus":refund,
                                 @"addressId":addressId,
                                 @"color":self.colorStr,
                                 @"count":@"1",
                                 @"userInfoId":kUserId,
                                 @"shopId":self.billConfirmGoodsModel.id,
                                 @"storeId":shopTmpModel.id,
                                 @"type":deliveryType,
                                 @"assembleCharges":assembleCharges,
                                 @"freight":self.billConfirmActivityModel.luggage,
                                 @"taskDetailId":self.billConfirmActivityModel.taskDetailId,
                                 @"money":[NSString stringWithFormat:@"%.2f",self.actuallypaidLabel.text.floatValue]};
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
                vc.orderID = [responseObject[@"data"] valueForKey:@"orderId"];
                vc.payType = self.billConfirmGoodsModel.pay_type;
                //                #warning ---price
                vc.needPayMoney = [NSString stringWithFormat:@"%.0f",self.actuallypaidLabel.text.floatValue];
                vc.isBackBtnShow = YES;
                vc.orderID = [responseObject[@"data"] valueForKey:@"orderId"];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
        NSLog(@"saveOrder %@",error.localizedDescription);
        
    }];
}



/**
 *  快递 选择
 *
 *  @param parameter
 */
- (void)ExpressAssembleAction:(NSDictionary *)parameter
{
    
    NSString *key = [parameter objectForKey:@"key"];
    NSString *indexRow = [parameter objectForKey:@"indexRow"];
    self.deliveryTypeAssembleExpressSelectedFlagStr = indexRow;
    self.deliveryTypeAssembleStoreSelectedFlagStr = @"3";
    
    
    NSLog(@"选中  快递方式 ...");
    
    /**
     *  现在 快递  组装后 选择
     */
    if ([key isEqualToString:@"组装后发货"]) {
          [self setBillFeeInfoViewDatasourcesAssembleFee:self.billConfirmActivityModel.assembled_type andExpressFee:self.billConfirmActivityModel.luggage andGoodsPrice:self.billConfirmGoodsModel.price];
        NSInteger actuallpaid = self.billConfirmGoodsModel.price.integerValue + self.billConfirmActivityModel.assembled_type.integerValue +self.billConfirmActivityModel.luggage.integerValue;
        self.actuallypaidLabel.text = [NSString stringWithFormat:@"%ld",actuallpaid];
        
    }
    //散装 自行组装
    if ([key isEqualToString:@"散装 自行组装"]) {
        
        NSInteger assemble = self.billConfirmActivityModel.assembled_type.integerValue -self.billConfirmActivityModel.refundLoadingCharge.integerValue;
        
         [self setBillFeeInfoViewDatasourcesAssembleFee:[NSString stringWithFormat:@"%ld",assemble] andExpressFee:self.billConfirmActivityModel.luggage andGoodsPrice:self.billConfirmGoodsModel.price];
        
        NSInteger actuallpaid = self.billConfirmGoodsModel.price.integerValue + self.billConfirmActivityModel.assembled_type.integerValue - self.billConfirmActivityModel.refundLoadingCharge.integerValue +self.billConfirmActivityModel.luggage.integerValue;
        self.actuallypaidLabel.text = [NSString stringWithFormat:@"%ld",actuallpaid];
    }

    [self.billConfirmTableView reloadData];
    
    
    
}


/**
 *  店铺 选择
 *
 *  @param parameter
 */
- (void)storeAssembleSelctedAcction:(NSDictionary *)parameter
{
//    NSString *indexRow = [parameter objectForKey:@"indexRow"];
   // self.shopAddressSelectedFlagInt = [NSNumber numberWithInteger:indexRow.integerValue];
    self.deliveryTypeAssembleExpressSelectedFlagStr = @"3";
    self.deliveryTypeAssembleStoreSelectedFlagStr = @"0";
    
    if ([self.deliveryTypeAssembleStoreStr isEqualToString:@"2"])
    {
        [self setBillFeeInfoViewDatasourcesAssembleFee:self.billConfirmActivityModel.assembled_type andExpressFee:self.billConfirmActivityModel.luggage andGoodsPrice:self.billConfirmGoodsModel.price];
        NSInteger actuallpaid = self.billConfirmGoodsModel.price.integerValue + self.billConfirmActivityModel.assembled_type.integerValue + self.billConfirmActivityModel.luggage.integerValue;
        self.actuallypaidLabel.text = [NSString stringWithFormat:@"%ld",actuallpaid];
        
    }
    NSLog(@"选中 店铺方式 ...");
    
    [self.billConfirmTableView reloadData];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 1;
    if ([self.deliveryTypeAssembleAfterStr isEqualToString:@"0"] ||
        [self.deliveryTypeAssembleAfterStr isEqualToString:@"1"]) {
        section ++;
        
    }
    if ([self.deliveryTypeAssembleStoreStr isEqualToString:@"2"]) {
        section ++;
    }
    
    return section;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.deliveryTypeExpressMArr.count;
       
    }else if (section == 1)
    {
        return 1;
    }else if (section == 2)
    {
        return 1;
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section %ld   row %ld",(long)indexPath.section,(long)indexPath.row);
    if ([self.deliveryTypeAssembleStoreStr isEqualToString:@"2"]&&
        ([self.deliveryTypeUnassembleStr isEqualToString:@"1"]||
         [self.deliveryTypeAssembleAfterStr isEqualToString:@"0"])) {
            if (indexPath.section == 2) return 150*SizeScale750;
    }
    if (![self.deliveryTypeAssembleStoreStr isEqualToString:@"2"]) {
        if (indexPath.section == 1) {
            return 150*SizeScale750;
        }
    }
    
    return 44;
    
    
}



//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"快递:";
//    }
//    if (section == 1) {
//        return @"到店自提:";
//    }
//    return @"";
//}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake750(0, 0, 750,30)];
    sectionView.backgroundColor = [UIColor blackColor];
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 750,23)];
    [sectionView addSubview:sectionLabel];
    if (section == 0) {
        sectionLabel.text = @"快递:";
    }
    if (section == 1) {
        sectionLabel.text = @"到店自提:";
        
    }
    sectionLabel.textColor = [UIColor grayColor];
    sectionLabel.font = [UIFont systemFontOfSize:23*SizeScale750];
    return sectionView;
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        ExpressAssembleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expressAssembleTableViewCellIdentify];
        
        if ([self.deliveryTypeAssembleAfterStr isEqualToString:self.deliveryTypeExpressMArr[indexPath.row]]) {
            if (self.deliveryTypeAssembleExpressSelectedFlagStr.integerValue == indexPath.row) {
                cell.isSelectedSuccess = YES;
            }else
            {
                cell.isSelectedSuccess = NO;
            }
            cell.titleLabel.text = @"组装后发货";
            cell.subtitleLabel.text = [NSString stringWithFormat:@"需支付%@元组装费",self.billConfirmActivityModel.assembled_type];
            if (self.billConfirmActivityModel.assembled_type.integerValue == 0) {
                cell.subtitleLabel.hidden = YES;
            }
            else
            {
                cell.subtitleLabel.hidden = NO;
            }
            cell.indexRowStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            @weakify_self
            cell.selectedExpressAssembleAction = ^(NSDictionary *parameter){
                @strongify_self
                [self ExpressAssembleAction:parameter];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if ([self.deliveryTypeUnassembleStr isEqualToString:self.deliveryTypeExpressMArr[indexPath.row]]) {
            
            if (self.deliveryTypeAssembleExpressSelectedFlagStr.integerValue == indexPath.row) {
                cell.isSelectedSuccess = YES;
            }else
            {
                cell.isSelectedSuccess = NO;
            }
            cell.titleLabel.text = @"散装 自行组装";
            
            cell.subtitleLabel.text = [NSString stringWithFormat:@"骑待提供%.1f元组装费",fabs(self.billConfirmActivityModel.assembled_type.floatValue - self.billConfirmActivityModel.refundLoadingCharge.floatValue)];
            if ((self.billConfirmActivityModel.assembled_type.integerValue - self.billConfirmActivityModel.refundLoadingCharge.integerValue) == 0) {
                cell.subtitleLabel.hidden = YES;
            }
            else
            {
                cell.subtitleLabel.hidden = NO;
            }
            cell.indexRowStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            @weakify_self
            cell.selectedExpressAssembleAction = ^(NSDictionary *parameter){
                @strongify_self
                [self ExpressAssembleAction:parameter];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
      
        
        
        
    }
    if (indexPath.section == 1) {
        if ([self.deliveryTypeAssembleStoreStr isEqualToString:@"2"]) {
            StoreAssembleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeAssembleTableViewCellIdentify];
            @weakify_self
            cell.storeAssembleSelctedAcction = ^(NSDictionary *parameter){
                @strongify_self
                
                [self storeAssembleSelctedAcction:parameter];
            };
            if (self.deliveryTypeAssembleStoreSelectedFlagStr.integerValue == indexPath.row) {
                cell.isSelectedSuccess = YES;
            }else
            {
                cell.isSelectedSuccess = NO;
            }
            //fabs
            
            cell.subtitleLabel.text = [NSString stringWithFormat:@"需支付%@元组装费",self.billConfirmActivityModel.assembled_type];
            if (self.billConfirmActivityModel.assembled_type.integerValue == 0) {
                cell.subtitleLabel.hidden = YES;
            }
            else
            {
                cell.subtitleLabel.hidden = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
      
    }
    
    
    //现在 先将店铺 信息 放在这  后面 逻辑 在判断 个人收获地址
    if ([self.deliveryTypeAssembleStoreStr isEqualToString:@"2"]) {
        if (indexPath.section == 2)
        {
            if (self.deliveryTypeAssembleStoreSelectedFlagStr.integerValue == indexPath.row) {
                
          
            StoreDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeDetailInfoTableViewCellIdentify];
//                NSInteger selectedShop = ;
                cell.isEnable = YES;
                cell.storeDetailInfoShopAddressModel = self.shopAddressMArr[self.shopAddressSelectedFlagStr.integerValue];
                
            
            @weakify_self
            cell.choiceMoreStoreAction = ^ (NSString *parameter){
                @strongify_self
                [self choiceMoreStoreAction:nil];
                
                
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            }
            
        }
    }
//    }else if([self.deliveryTypeAssembleStoreStr isEqualToString:@"5"])
//    {
//        if (indexPath.section == 1)
//        {
//            StoreDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeDetailInfoTableViewCellIdentify];
//            
//            @weakify_self
//            cell.choiceMoreStoreAction = ^ (NSString *parameter){
//                @strongify_self
//                [self choiceMoreStoreAction:nil];
//                
//                
//            };
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
//            
//            
//        }
//    }
   

    if ([self.deliveryTypeAssembleStoreStr isEqualToString:@"2"])
    {
        if (indexPath.section == 2)
        {
            if (self.personalAddressMArr.count == 0) {
                NoAddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noAddressConfirmTableViewCellIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            AddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressConfirmTableViewCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.personalAddressMArr.count >= self.deliveryTypeAssemblePersonalAddressSelectedFlagStr.integerValue) {
                cell.model = self.personalAddressMArr[self.deliveryTypeAssemblePersonalAddressSelectedFlagStr.integerValue];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }
        
    }else if([self.deliveryTypeAssembleStoreStr isEqualToString:@"5"])
    {
        if (indexPath.section == 1)
        {
            if (self.personalAddressMArr.count == 0) {
                NoAddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noAddressConfirmTableViewCellIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            AddressConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressConfirmTableViewCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.personalAddressMArr.count >= self.deliveryTypeAssemblePersonalAddressSelectedFlagStr.integerValue) {
                cell.model = self.personalAddressMArr[self.deliveryTypeAssemblePersonalAddressSelectedFlagStr.integerValue];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:generallyTableViewCellIdentify];
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([self.deliveryTypeUnassembleStr isEqualToString:@"1"] || [self.deliveryTypeAssembleAfterStr isEqualToString:@"0"] ) {
        
        if ([self.deliveryTypeAssembleStoreStr isEqualToString:@"2"]) {
            if (indexPath.section == 2) {
                if ([self.deliveryTypeAssembleExpressSelectedFlagStr isEqualToString:@"3"]) {
                    return;
                }
                AddressViewController *vc = [[AddressViewController alloc]init];
                vc.isBackBtnShow = YES;
                vc.addressArrayM = _personalAddressMArr.mutableCopy;
                vc.delegate = self;
                //vc.addressPage = _addressPage;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.section == 1 )
        {
            if ([self.deliveryTypeAssembleExpressSelectedFlagStr isEqualToString:@"3"]) {
                return;
            }
            AddressViewController *vc = [[AddressViewController alloc]init];
            vc.isBackBtnShow = YES;
            vc.addressArrayM = _personalAddressMArr.mutableCopy;
            vc.delegate = self;
            //vc.addressPage = _addressPage;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
//    if (![self.deliveryTypeAssembleExpressSelectedFlagStr isEqualToString:@"3"]) {
//     
//    }
   
    
    
    
    
}



- (void)choiceMoreStoreAction:(NSString *)parameter
{
    
    NSLog(@"选择  更多的店铺");
    
    StoreListTableViewController *vc = [[StoreListTableViewController alloc]init];
    vc.datasourcesArr = [self.shopAddressMArr copy];
    @weakify_self;
    vc.shopListSelectedAction = ^(NSInteger selectShopNum)
    {
        @strongify_self
        self.shopAddressSelectedFlagStr = [NSString stringWithFormat:@"%ld",(long)selectShopNum];
        [self.billConfirmTableView reloadData];
 
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



#pragma ---------- AddressViewControllerDelegate  start of line

/**
 *  地址选择
 *
 *  @param page
 */
- (void)refeshAddressWithPage:(NSInteger)page
{
    NSLog(@"地址选择 ... ");
    NSString *selectedAddressStr = [NSString stringWithFormat:@"%ld",(long)page];
    self.deliveryTypeAssemblePersonalAddressSelectedFlagStr = selectedAddressStr;
    [self.billConfirmTableView reloadData];
    
    
    
    
    
    
}


- (void)refreshAdressArrayWithArray:(NSArray *)array
{
    NSLog(@"更新地址 ...");
    if (self.personalAddressMArr.count >0) {
        [self.personalAddressMArr removeAllObjects];
    }
    
    self.personalAddressMArr = [NSMutableArray arrayWithArray:array];
    
    
    
}


#pragma ---------- AddressViewControllerDelegate  end of line


#pragma ----lazyload

- (UITableView *)billConfirmTableView
{
    if (!_billConfirmTableView) {
        _billConfirmTableView = [[UITableView alloc]initWithFrame:CGRectMake750(0,0, 750, 1135) style:UITableViewStylePlain];
        _billConfirmTableView.backgroundColor = [UIColor blackColor];
        _billConfirmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _billConfirmTableView.delegate = self;
        _billConfirmTableView.dataSource = self;
        
    }
    return _billConfirmTableView;
    
}

- (BillDetailInfoView *)bikeDetailInfoView
{
    if (!_bikeDetailInfoView) {
        _bikeDetailInfoView = [[BillDetailInfoView alloc]initWithFrame:CGRectMake750(0,20, 750,360)];
        _bikeDetailInfoView.backgroundColor = [UIColor blackColor];
        
    }
    return _bikeDetailInfoView;

}

- (BillFeeInfoView *)billFeeInfoView
{
    if (!_billFeeInfoView) {
        _billFeeInfoView = [[BillFeeInfoView alloc]initWithFrame:CGRectMake750(0, 0, 750, 242)];
        _billFeeInfoView.useInViewStr = kBillConfirmView;
        
    }
    return _billFeeInfoView;
    
}


- (UIView *)bottomBackgroundView
{
    if (!_bottomBackgroundView) {
        _bottomBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0,0, 750, 100)];
        _bottomBackgroundView.top =  self.view.height - 110*SizeScaleSubjectTo720 - 64;
        _bottomBackgroundView.backgroundColor = [UIColor blackColor];
        _actuallypaidTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20,55,150,26)];
        _actuallypaidTitleLabel.text = @"实付金额:";
        _actuallypaidTitleLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _actuallypaidTitleLabel.textColor = [UIColor whiteColor];
        _actuallypaidTitleLabel.textAlignment = NSTextAlignmentRight;
        [_bottomBackgroundView addSubview:_actuallypaidTitleLabel];
        
        _actuallypaidLabel = [[UILabel alloc]initWithFrame:CGRectMake750(170,55, 200, 30)];
        _actuallypaidLabel.text = @"¥8888";
        _actuallypaidLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _actuallypaidLabel.textAlignment = NSTextAlignmentLeft;
        _actuallypaidLabel.textColor = [UIColor redColor];
        [_bottomBackgroundView addSubview:_actuallypaidLabel];
        
        
        _buyButton = [[UIButton alloc]initWithFrame:CGRectMake750(355,20,345,90)];
        _buyButton.qd_acceptEventInterval = 2.f;
        [_buyButton setImage:[UIImage imageNamed:@"ShopUpdateBuyButtonImageView"] forState:UIControlStateNormal];
        
        [_buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBackgroundView addSubview:_buyButton];
        
    }
    
    return _bottomBackgroundView;
    
}


- (NSMutableArray *)personalAddressMArr
{
    if (!_personalAddressMArr) {
        _personalAddressMArr = [[NSMutableArray alloc]initWithCapacity:5];
        
    }
    return _personalAddressMArr;
}


- (NSMutableArray *)shopAddressMArr
{
    if (!_shopAddressMArr) {
        _shopAddressMArr = [[NSMutableArray alloc]initWithCapacity:5];
        
    }
    return _shopAddressMArr;
}


- (NSMutableArray *)deliveryTypeExpressMArr
{
    if (!_deliveryTypeExpressMArr) {
        _deliveryTypeExpressMArr = [[NSMutableArray alloc]initWithCapacity:2];
        
    }
    return _deliveryTypeExpressMArr;
}



- (QDAlphaWarnView *)alphaWarnView{
    if (!_alphaWarnView) {
        _alphaWarnView = [[QDAlphaWarnView alloc]initWithFrame:self.view.bounds];
    }
    return _alphaWarnView;
}

- (void)setAlertViewTitle:(NSString *)titleStr andSubMessage:(NSString *)submessage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:titleStr message:submessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
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
