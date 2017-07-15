//
//  ShopHomePageViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/25.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopHomePageViewController.h"

#import "ShopHomePageHeaderView.h"
#import "ShopHomePageFooterView.h"
#import "ShopHomePageFirstReusableView.h"
#import "ShopCollectionViewCell.h"
#import "ShopBrandTableViewCell.h"
#import "ShopTypeTableViewCell.h"
#import "ShopActivityTableViewCell.h"
#import "ShopHomePageModel.h"
#import "BrandModel.h"
#import "MJExtension.h"
#import "GoodsDetailViewController.h"
#import "ShopShowViewController.h"
#import "ShopSearchViewController.h"
#import "BrandListViewController.h"
#import "AddressInfoViewController.h"
#import "MJRefresh.h"
#import "SYQRCodeViewController.h"
#import "UpdateGoodsDetailViewController.h"

@interface ShopHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    /** 页面标签,标记哪个view为中间*/
    NSInteger _tag;
    
    /** 时候加载完成*/
    BOOL _isLoadComplete;
}
/** 底层的scrollView,加载其他的4个视图*/
@property (nonatomic,strong) UIScrollView *scrollView;
/** topBtn的替代品*/
@property (nonatomic,strong) UIButton *tempBtn;
/** 存放顶部4个btn的数组*/
@property (nonatomic,strong) NSMutableArray *topBtnArrayM;
/** 红条*/
@property (nonatomic,strong) UIView *redBar;
/** 首页*/
@property (nonatomic,strong) UICollectionView *collectionView;
/** 品牌*/
@property (nonatomic,strong) UITableView *brandTableView;
/** 类型*/
@property (nonatomic,strong) UITableView *typeTableView;
/** 活动*/
@property (nonatomic,strong) UITableView *activityTableView;

//------------首页的数据源--------------//
/** 首页的 "惠"等你来 商品数据源*/
@property (nonatomic,strong) NSMutableArray *homePageIngDataArrayM;
/** 首页的 热门商品 数据源*/
@property (nonatomic,strong) NSMutableArray *homePageHotDataArrayM;
/** 首页的 任性购车 数据源*/
@property (nonatomic,strong) NSMutableArray *homePageOverDataArrayM;
//------------首页的数据源--------------//

/** 品牌的数据源*/
@property (nonatomic,strong) NSMutableArray *brandDataArrayM;
/** 类型的数据源*/
@property (nonatomic,strong) NSMutableArray *typeDataArrayM;
/** 活动的数据源*/
@property (nonatomic,strong) NSMutableArray *activityDataArrayM;

/** 轮播图的图片数组*/
@property (nonatomic,strong) NSMutableArray *imageArrayM;
/** 轮播图的图片对应的id的数组*/
@property (nonatomic,strong) NSMutableArray *imageIdArrayM;


/**
 *  当前显示的页面
 */
@property (nonatomic,strong)NSNumber *currentPageInteger;

/**
 *  上一个显示的页面
 */
@property (nonatomic,strong)NSNumber *previousPageInteger;

@end

@implementation ShopHomePageViewController

static NSString *const kShopCollectionViewCell = @"ShopCollectionViewCell";
static NSString *const kShopHomePageHeaderView = @"ShopHomePageHeaderView";
static NSString *const kShopHomePageFirstReusableView = @"ShopHomePageFirstReusableView";
static NSString *const kShopHomePageFooterView = @"ShopHomePageFooterView";
static NSString *const kShopBrandTableViewCell = @"ShopBrandTableViewCell";
static NSString *const kShopTypeTableViewCell = @"ShopTypeTableViewCell";
static NSString *const kShopActivityTableViewCell = @"ShopActivityTableViewCell";

#pragma mark --- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    QDLog(@"into shop viewWillAppear ... %p",self.view);
    NSString *startPageTag = nil;
    QDCurrentPage currentChoicePage = self.currentPageInteger.intValue;
    switch (currentChoicePage) {
        case QDShopHomePage:
            startPageTag = kShopHome;
            break;
        case QDBrandHomePage:
            startPageTag = kBrandHome;
            break;
        case QDTypeHomePage:
            startPageTag = kTypeHome;
            break;
        case QDEventHomePage:
            startPageTag = kEventHome;
            break;
            
        default:
            break;
    }
   [MobClick beginLogPageView:startPageTag];
    

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:@"OnePage"];
    QDLog(@"into  shop viewWillDisappear ... %p",self.view);
    
    NSString *endPageTag = nil;
    QDCurrentPage currentChoicePage = self.currentPageInteger.intValue;
    switch (currentChoicePage) {
        case QDShopHomePage:
            endPageTag = kShopHome;
            break;
        case QDBrandHomePage:
            endPageTag = kBrandHome;
            break;
        case QDTypeHomePage:
            endPageTag = kTypeHome;
            break;
        case QDEventHomePage:
            endPageTag = kEventHome;
            break;
            
        default:
            break;
    }
    [MobClick endLogPageView:endPageTag];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
     QDLog(@"into  shop viewDidLoad ... %p",self.view);
    [self setupNavigationView];
    self.view.backgroundColor = [UIColor blackColor];
    self.currentPageInteger = @0;
    self.previousPageInteger = @0;
    
    
    _topBtnArrayM = @[].mutableCopy;
    _homePageHotDataArrayM = @[].mutableCopy;
    _homePageOverDataArrayM = @[].mutableCopy;
    _homePageIngDataArrayM = @[].mutableCopy;
    _brandDataArrayM = @[].mutableCopy;
    _imageArrayM = @[].mutableCopy;
    _imageIdArrayM = @[].mutableCopy;
    _tag = 0;
    
    [self setupTopView];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getHomePageDataFromInterface];
    }];
    self.brandTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getBrandDataFromInterface];
    }];
    
    /** 添加tableView*/
    [self.scrollView addSubview:self.brandTableView];
    self.brandTableView.tableFooterView = [[UIView alloc]init];
    [self.scrollView addSubview:self.activityTableView];
    self.activityTableView.tableFooterView = [[UIView alloc]init];
    [self.scrollView addSubview:self.typeTableView];
    self.typeTableView.tableFooterView = [[UIView alloc]init];
    
    //请求所有的数据
    [self getAllShopHomePageDataFromInterface];
    
    //[self.scrollView addSubview:self.cycleScrollView];
    // Do any additional setup after loading the view.
}
#pragma mark --- ui
- (void)setupTopView {
    NSArray *titleArray = @[@"首页",@"品牌",@"类型",@"活动"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0 + 180*i, 0, 180, 90) title:titleArray[i] titleColor:UIColorFromRGB_16(0xcccccc) titleFont:30 backgroundColor:UIColorFromRGB_16(0x151515) tapAction:^(UIButton *button) {
            [self clickTopBtn:button];
        }];
        btn.userInteractionEnabled = YES;
        [btn setTitleColor:UIColorFromRGB_16(0xe60012) forState:UIControlStateSelected];
        btn.tag = 450 + i;
        [self.view addSubview:btn];
        if (i == 0) {
            self.tempBtn = btn;
            btn.selected = YES;
        }
        [_topBtnArrayM addObject:btn];
    }
    [self.view addSubview:self.redBar];
    
}
- (void)setupNavigationView {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    [self creatTitleViewWithString:@"商城"];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake720(0, 0, 40,50)];
    [rightBtn setContentMode:UIViewContentModeLeft];
    [rightBtn setImage:[UIImage imageNamed:@"shop_seach_btn"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickSeachBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake720(0, 0, 40,32)];
    [leftBtn setImage:[UIImage imageNamed:@"shop_scan_btn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickScanAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
#pragma mark --- interface
/** 获得所有的网络请求*/
- (void)getAllShopHomePageDataFromInterface {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MBProgressHUDManager instance] sendRequestShowHUD:kGetKeyWindow];
    });

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    /** 请求商城首页*/
    NSDictionary *params = @{@"city":kGetCityCode};
    //NSDictionary *params = @{@"city":@"95014"}; // 测试数据
    QDLog(@"position %@",params.mj_keyValues);
    QDLog(@" resuest URL :%@",kUrl_shop);
    [QDHttpTool getWithURL:kUrl_shop params:params success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject valueForKey:@"ing"]) {
           _homePageHotDataArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"ing"]];
        }
        if ([responseObject valueForKey:@"hot"]) {
         _homePageIngDataArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"hot"]];
        }
        if ([responseObject valueForKey:@"over"]) {
           _homePageOverDataArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"over"]];
        }
        
       
        [self.collectionView reloadData];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    /** 请求轮播图*/
    QDLog(@"banner request %@",kUrl_banner);
    [QDHttpTool getWithURL:kUrl_banner params:nil success:^(BOOL isSuccess, NSDictionary *responseObject) {
        QDLog(@"banner  response %@",responseObject);
        NSArray *array = [responseObject valueForKey:@"data"];
        if (array.count >0)
        {
            for (NSDictionary *dic in array) {
                [_imageArrayM addObject:[dic valueForKey:@"path"]];
                [_imageIdArrayM addObject:[dic valueForKey:@"item_id"]];
            }
        }
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    //请求品牌
    NSDictionary *brandParam = @{@"start":@0};
    QDLog(@" brand request %@",kUrl_brand);
    [QDHttpTool getWithURL:kUrl_brand params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        QDLog(@"brand response %@",responseObject);
        if ([responseObject valueForKey:@"data"]) {
            _brandDataArrayM = [BrandModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
        }
        [self.brandTableView reloadData];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
    });
    
}

/** 请求品牌的数据*/
- (void)getBrandDataFromInterface {
    [[MBProgressHUDManager instance] hideHUD];
    //请求品牌
    NSDictionary *brandParam = @{@"start":@0};
    [QDHttpTool getWithURL:kUrl_brand params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        
        if (!isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
            return ;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        
        if ([responseObject valueForKey:@"data"]){
           _brandDataArrayM = [BrandModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
        }
       
        [self.brandTableView.mj_header endRefreshing];
        [self.brandTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.brandTableView.mj_header endRefreshing];
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
- (void)getHomePageDataFromInterface {
    
    [[MBProgressHUDManager instance] hideHUD];
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    NSDictionary *params = @{@"city":kGetCityCode};
    [QDHttpTool getWithURL:kUrl_shop params:params success:^(BOOL isSuccess, NSDictionary *responseObject) {
        [self.collectionView.mj_header endRefreshing];
        if (!isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
            return ;
        }
        if ([responseObject valueForKey:@"ing"]) {
          _homePageHotDataArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"ing"]];
        }
        if ([responseObject valueForKey:@"hot"]) {
           _homePageIngDataArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"hot"]];
        }
        if ([responseObject valueForKey:@"over"]) {
            _homePageOverDataArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"over"]];
        }
        
        
        
        [self.collectionView reloadData];
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
    
}
/** 扫描后发起请求 ---然后发通知给任务模块，刷新ui*/
- (void)scanJoinTaskFromInterfaceWithTaskId:(NSString *)taskId {
    
    QDLog(@"扫描成功  正在 加入任务 ... ");
    NSDictionary *param = @{@"userId":kUserId,
                            @"taskId":taskId};
    [QDHttpTool getWithURL:kUrl_scanJoinTask params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
      //  QDLog(@"into here ... isSuccess %d",isSuccess);
        if (isSuccess)
        {
            if ([MBProgressHUDManager instance])
            {
                NSLog(@" instance  ....%@",responseObject[@"message"]);
                 [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:responseObject[@"message"]];
            }
           //modify by manman on 2016-09-20 扫描成功的提示信息 不出现 发送通知之后 这个单例被调走
            //[[MBProgressHUDManager  instance] showHUDWithView:self.navigationController.view string:@"扫描成功" andDisappearIn:3];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTaskNotification object:nil];
            // 保存刷新状态 任务页面需要刷新                      kAddTaskSuccessUpdateTaskHome
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kAddTaskSuccessUpdateTaskHome];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kAddTaskSuccessUpdateSportHome];
            QDLog(@"task home animated :%@",[[NSUserDefaults standardUserDefaults] objectForKey:kAddTaskSuccessUpdateTaskHome]);
            QDLog(@"sport home animated :%@",[[NSUserDefaults standardUserDefaults] valueForKey:kAddTaskSuccessUpdateSportHome]);
            // end of line
        }
        else
        {
            [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:responseObject[@"message"]];
        }

    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"请检查网络"];
    }];
    
}
#pragma mark --- private method
/** 点击搜索*/
- (void)clickSeachBtn {
    ShopSearchViewController *vc = [[ShopSearchViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击扫描二维码
- (void)clickScanAction {
    
    if (![[LoginManager instance] isLogin]) {
        [self showLoginViewController];
        return;
    }
    
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:qrcodevc];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        // modify by manman  demand 相册识别二维码  start of line
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        
       // [self.navigationController popViewControllerAnimated:YES];
        // end of line
        
        //self.bikeNumberTF.text = qrString;
        [self scanJoinTaskFromInterfaceWithTaskId:qrString];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:nav animated:YES completion:nil];
    qrcodevc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:qrcodevc animated:YES];
    /*
     
     UILabel  * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
     label1.text = @"qingjoin"; 
     [self.view addSubview:label1];   
     [UIView beginAnimations:nil context:nil];  
     [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
     [UIView setAnimationDuration:3.0];   
     [UIView setAnimationDelegate:self];   
     label1.alpha =0.0;   
     [UIView commitAnimations];
    
    
    */
    
}

- (void)clickTopBtn:(UIButton *)sender {
    if (self.tempBtn == sender) {
        return;
    }
    self.tempBtn.selected = NO;
    self.tempBtn = sender;
    self.tempBtn.selected = YES;
    [self refreshUIWithTag:self.tempBtn.tag-450];
}
- (void)refreshUIWithTag:(NSInteger)tag {
    //NSLog(@"refreshUIWithTag%ld",tag);
    _tag = tag;
    //NSLog(@"refreshUIWithTag--%ld",_tag);
    [self.scrollView setContentOffset:CGPointMake( (HCDW*_tag), 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.redBar.left = (35 + 180*_tag)*SizeScaleSubjectTo720;
    }];
}
/** 点击首页上的“更多车款”的按钮*/
- (void)clickMoreGoodsButtonWithSection:(NSInteger)section {
    ShopShowViewController *vc = [[ShopShowViewController alloc]init];
    vc.isBackBtnShow = YES;
    //vc.index = [NSString stringWithFormat:@"%ld",(section + 1)];
    vc.hidesBottomBarWhenPushed = YES;
    
    if (section == 0) {
        vc.titleStr = @"热门商品";
        vc.index = @"2";
    } else {
        vc.titleStr = @"“惠”等你来";
        vc.index = @"1";
    }
    vc.status = ShopShowHot;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 点击首页的cell，进入商品详情*/
- (void)clickBuyButtonWithGoodsId:(NSString *)goodsId isActivityOver:(BOOL)isOver{
  
    if (!QDDEBUGGOODSDETAIL) {
         [self intoGoodsDetailView:goodsId isActivityOver:isOver];
    }else
    {
        [self intoUpdateGoodsDetailView:goodsId isActivityOver:isOver];
        
    }
   
    
}



- (void)intoGoodsDetailView:(NSString *)goodsId isActivityOver:(BOOL)isOver
{
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.goodsId = goodsId;
    vc.isActivityOver = isOver;
    vc.cityCode = kGetCityCode;
    vc.isBackBtnShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)intoUpdateGoodsDetailView:(NSString *)goodsId isActivityOver:(BOOL)isOver
{
    UpdateGoodsDetailViewController *vc = [[UpdateGoodsDetailViewController alloc] init];
    vc.goodsId = goodsId;
    vc.isActivityOver = isOver;
    vc.cityCode = kGetCityCode;
    vc.isBackBtnShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}



/** 点击轮播图*/
- (void)clickCycleScrollViewWithIndex:(NSInteger)index {
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
    vc.goodsId = _imageIdArrayM[index];
    vc.cityCode = kGetCityCode;
    vc.isBackBtnShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = self.scrollView.contentOffset;
    if ((int)(point.x/self.view.width) == 0) {
        // add by manman on 2016-10-10 start of line
        self.currentPageInteger = @0;
        //第二页回到第一页   1关0开  逆向
        if (self.currentPageInteger<self.previousPageInteger) {
            //第1页关
            [MobClick endLogPageView:kBrandHome];
            //第0页开
            [MobClick beginLogPageView:kShopHome];
           
        }
        //没有操作  //正向
        // end of line
        _tag = 0;
    } else if ((int)(point.x/self.view.width) == 1) {
        // add by manman on 2016-10-10 start of line
        self.currentPageInteger = @1;
        //第二页回到第一页   2关1开 逆向
        if (self.currentPageInteger<self.previousPageInteger) {
            //第2页关
            [MobClick endLogPageView:kTypeHome];
            //第1页开
            [MobClick beginLogPageView:kBrandHome];
            
        }
        else //正向   第0页到第1页
        {
            //0关闭
            [MobClick endLogPageView:kShopHome];
            //1打开
            [MobClick beginLogPageView:kBrandHome];
            
            
        }
        
        
        // end of line
        _tag = 1;
    } else if ((int)(point.x/self.view.width) == 2) {
        // add by manman on 2016-10-10 start of line
        self.currentPageInteger = @2;
        //第二页回到第一页   3关2开 逆向
        if (self.currentPageInteger<self.previousPageInteger) {
            //第3页关
            [MobClick endLogPageView:kEventHome];
            //第2页开
            [MobClick beginLogPageView:kTypeHome];
          
        }
        else // 正向  第1页到第2页
        {
            //1关闭
            [MobClick endLogPageView:kBrandHome];
            //2打开
            [MobClick beginLogPageView:kTypeHome];
        }
        
        
        // end of line
        _tag = 2;
    }
    else if ((int)(point.x/self.view.width) == 3)
    {
        // add by manman on 2016-10-10 start of line
        self.currentPageInteger = @3;
        // 逆向无操作
        //第二页回到第三页   二关1开  正向
        if (self.currentPageInteger>self.previousPageInteger) {
            //2关闭
            [MobClick endLogPageView:kTypeHome];
            //3打开
            [MobClick beginLogPageView:kEventHome];
        }
        
        
        // end of line
        _tag = 3;
    }
     self.previousPageInteger = self.currentPageInteger;
    
    if (_topBtnArrayM.count >= _tag)
    {
        UIButton *btn = (UIButton *)_topBtnArrayM[_tag];
        [self clickTopBtn:btn];
    }
}

#pragma mark --- UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return _homePageHotDataArrayM.count;
            break;
        case 1:
            return _homePageIngDataArrayM.count;
            break;
        case 2:
            return _homePageOverDataArrayM.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning ---现在任性购不要了
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCollectionViewCell forIndexPath:indexPath];
    cell.noActivity = NO;
    switch (indexPath.section) {
        case 0:
            cell.model = _homePageHotDataArrayM[indexPath.row];
            break;
        case 1:
            cell.model = _homePageIngDataArrayM[indexPath.row];
            break;
        case 2:
            //任性购
            cell.noActivity = YES;
            cell.model = _homePageOverDataArrayM[indexPath.row];
            break;
        default:
            break;
    }
    
    cell.clickBuyBtnBlock = ^(NSString *modelId){
        if (indexPath.section == 2) {
           [self clickBuyButtonWithGoodsId:modelId isActivityOver:YES];
        } else {
            [self clickBuyButtonWithGoodsId:modelId isActivityOver:NO];
        }
    };
    return cell;
}
//添加collection HeaderView
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) {
            
            ShopHomePageFirstReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopHomePageFirstReusableView forIndexPath:indexPath];
            headerView.cycleScrollView.imageURLStringsGroup = _imageArrayM;
            //[headerView addSubview:self.cycleScrollView];
            headerView.clickCycleViewBlock = ^(NSInteger index){
                [self clickCycleScrollViewWithIndex:index];
            };
            reusableview = headerView;
            
        } else {
        
            ShopHomePageHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopHomePageHeaderView forIndexPath:indexPath];
            headerView.section = indexPath.section;
            reusableview = headerView;
            
        }
    }
    else if(kind == UICollectionElementKindSectionFooter) {
        ShopHomePageFooterView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kShopHomePageFooterView forIndexPath:indexPath];
        headerView.clickMoreBtnBlock = ^ {
            [self clickMoreGoodsButtonWithSection:indexPath.section];
        };
        reusableview = headerView;
    }

    return reusableview;
}
#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)/2;
    return CGSizeMake(332*SizeScale, (606 - 40)*SizeScale);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGSize size = {720 * SizeScale,634 * SizeScale};
        return size;
    }
    CGSize size = {720 * SizeScale,164 * SizeScale};
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size = {720 * SizeScaleSubjectTo720,110 * SizeScaleSubjectTo720};
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20*SizeScale, 5, 20*SizeScale);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --- tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.brandTableView) {
        return _brandDataArrayM.count;
    }
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.brandTableView) {
        ShopBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopActivityTableViewCell];
        if (cell == nil) {
            cell = [[ShopBrandTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShopActivityTableViewCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.model = _brandDataArrayM[indexPath.row];
        return cell;
    }
    if (tableView == self.activityTableView) {
        ShopActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopActivityTableViewCell];
        if (cell == nil) {
            cell = [[ShopActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShopActivityTableViewCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.row = indexPath.row;
        return cell;
    }
    ShopTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopTypeTableViewCell];
    if (cell == nil) {
        cell = [[ShopTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShopTypeTableViewCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.typeRow = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.brandTableView) {
        BrandListViewController *vc = [[BrandListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.brandModel = _brandDataArrayM[indexPath.row];
        vc.brandDataSourcesMarr = _brandDataArrayM.mutableCopy;
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    ShopShowViewController *vc = [[ShopShowViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.index = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
    vc.hidesBottomBarWhenPushed = YES;
    if (tableView == self.typeTableView) {
        NSArray *typeArray = @[@"运动休闲",@"城市通勤",@"专业挑战",@"智能骑行"];
        vc.titleStr = typeArray[indexPath.row];
        vc.status = ShopShowType;
    }  else {
        NSArray *activityArray = @[@"100 - 499元奖金",@"500 - 999元奖金",@"1000 - 1999元奖金",@"2000元以上"];
        vc.titleStr = activityArray[indexPath.row];
        vc.status = ShopShowActivity;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark --- super method
- (void)clickRightBtn {
    
}
#pragma mark --- lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake720(0, 0, 720, 0)];
        _scrollView.height = self.view.height - 90*SizeScaleSubjectTo720 - 64 -44;
        _scrollView.top = 90*SizeScaleSubjectTo720;
        _scrollView.contentSize = CGSizeMake(self.view.width * 4, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIView *)redBar {
    if (!_redBar) {
        _redBar = [[UIView alloc]initWithFrame:CGRectMake720(35, 86, 110, 4)];
        _redBar.backgroundColor = UIColorFromRGB_16(0xe60012);
    }
    return _redBar;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
        flow.headerReferenceSize = CGSizeMake(100, 50);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flow];
        _collectionView.height = self.view.height - 110*SizeScaleSubjectTo720 - 64 - 44 ;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        //给collectionView注册sectionHeaderView、cell
        [_collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:kShopCollectionViewCell];
        [_collectionView registerClass:[ShopHomePageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopHomePageHeaderView];
        [_collectionView registerClass:[ShopHomePageFirstReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopHomePageFirstReusableView];
        [_collectionView registerClass:[ShopHomePageFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kShopHomePageFooterView];
    }
    return _collectionView;
}
- (UITableView *)brandTableView {
    if (!_brandTableView) {
        _brandTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _brandTableView.left = HCDW;
        _brandTableView.height = self.view.height - 90*SizeScaleSubjectTo720 - 64 - 44;
        _brandTableView.backgroundColor = [UIColor blackColor];
        _brandTableView.delegate = self;
        _brandTableView.dataSource = self;
        _brandTableView.rowHeight = 162*SizeScaleSubjectTo720;
        _brandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _brandTableView;
}
- (UITableView *)typeTableView {
    if (!_typeTableView) {
        _typeTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _typeTableView.left = HCDW * 2;
        _typeTableView.height = self.view.height - 90*SizeScaleSubjectTo720 - 64 - 44;
        _typeTableView.backgroundColor = [UIColor blackColor];
        _typeTableView.delegate = self;
        _typeTableView.dataSource = self;
        _typeTableView.rowHeight = 346*SizeScale;
        _typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _typeTableView;
}
- (UITableView *)activityTableView {
    if (!_activityTableView) {
        _activityTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _activityTableView.left = HCDW * 3;
        _activityTableView.height = self.view.height - 90*SizeScaleSubjectTo720 - 64 - 44;
        _activityTableView.backgroundColor = [UIColor blackColor];
        _activityTableView.delegate = self;
        _activityTableView.dataSource = self;
        _activityTableView.rowHeight = 346*SizeScale;
        _activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _activityTableView.sectionFooterHeight = 6*SizeScaleSubjectTo720;
    }
    return _activityTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
