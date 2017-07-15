//
//  ShopShowViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopShowViewController.h"
#import "ShopHomePageModel.h"
#import "ShopCollectionViewCell.h"
#import "NoSearchContentCollectionViewCell.h"
#import "GoodsDetailViewController.h"
#import "UpdateGoodsDetailViewController.h"

@interface ShopShowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UITextFieldDelegate>
{
    /** 综合排序的数组*/
    NSMutableArray *_synthesizeArrayM;
    
    /** 价格升序的数组*/
    NSMutableArray *_priceByAscArrayM;
    
    /** 价格降序的数组*/
    NSMutableArray *_priceByDescArrayM;
    
    /** 中间变量*/
    NSMutableArray *_tempArrayM;
}
@property (nonatomic,strong) UICollectionView *collectionView;
/** 导航栏中间的搜索框*/
@property (nonatomic,strong) UITextField *seachTextField;
/** 综合排序的按钮*/
@property (nonatomic,strong) UIButton *synthesizeBtn;
/** 价格排序的按钮*/
@property (nonatomic,strong) UIButton *priceBtn;
/** 判断价格下一次是否为降序，请求网络时，取反*/
@property (nonatomic,assign) BOOL isDesc;
/** 导航栏搜索的btn*/
@property (nonatomic,strong) UIButton *searchBtn;
/** 导航栏取消的btn*/
@property (nonatomic,strong) UIButton *cancleBtn;



@property (nonatomic,strong) NSArray *viewTypeDataSourcesArr;
@end

static NSString *const kShopCollectionViewCell = @"ShopCollectionViewCell";
static NSString *const kNoSearchContentCollectionViewCell = @"NoSearchContentCollectionViewCell";

@implementation ShopShowViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    QDShopShowCurrentPage choiceCurrentPage = 0;
    for (int i = 0; i <_viewTypeDataSourcesArr.count; i++) {
        if ([self.titleStr isEqualToString:_viewTypeDataSourcesArr[i]]) {
            choiceCurrentPage = i;
            break;
        }
    }
    
     NSString *currentPageTag = nil;
    switch (choiceCurrentPage) {
        case QDShopShowTypeSports:
            currentPageTag = kTypeSports;
            break;
        case QDShopShowTypeCity:
             currentPageTag = kTypeCity;
            break;
        case QDShopShowTypeChallenge:
             currentPageTag = kTypeChallenge;
            break;
        case QDShopShowTypeSmart:
             currentPageTag = kTypeSmart;
            break;
        case QDShopShowEventLevel1:
             currentPageTag = kEventLevel1;
            break;
        case QDShopShowEventLevel2:
             currentPageTag = kEventLevel2;
            break;
        case QDShopShowEventLevel3:
             currentPageTag = kEventLevel3;
            break;
        case QDShopShowEventLevel4:
             currentPageTag = kEventLevel4;
            break;
            
        default:
            break;
    }
   
    [MobClick beginLogPageView:currentPageTag];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QDShopShowCurrentPage choiceCurrentPage = 0;
    for (int i = 0; i <_viewTypeDataSourcesArr.count; i++) {
        if ([self.titleStr isEqualToString:_viewTypeDataSourcesArr[i]]) {
            choiceCurrentPage = i;
        }
    }
    
    NSString *currentPageTag = nil;
    switch (choiceCurrentPage) {
        case QDShopShowTypeSports:
            currentPageTag = kTypeSports;
            break;
        case QDShopShowTypeCity:
            currentPageTag = kTypeCity;
            break;
        case QDShopShowTypeChallenge:
            currentPageTag = kTypeChallenge;
            break;
        case QDShopShowTypeSmart:
            currentPageTag = kTypeSmart;
            break;
        case QDShopShowEventLevel1:
            currentPageTag = kEventLevel1;
            break;
        case QDShopShowEventLevel2:
            currentPageTag = kEventLevel2;
            break;
        case QDShopShowEventLevel3:
            currentPageTag = kEventLevel3;
            break;
        case QDShopShowEventLevel4:
            currentPageTag = kEventLevel4;
            break;
            
        default:
            break;
    }

    [MobClick endLogPageView:currentPageTag];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _synthesizeArrayM = @[].mutableCopy;
    _priceByAscArrayM = @[].mutableCopy;
    _priceByDescArrayM = @[].mutableCopy;
    _tempArrayM = @[].mutableCopy;
    _viewTypeDataSourcesArr = @[@"运动休闲",@"城市通勤",@"专业挑战",@"智能骑行",@"100 - 499元奖金",@"500 - 999元奖金",@"1000 - 1999元奖金",@"2000元以上"];
    
    [self.view addSubview:self.collectionView];
    
    [self setupTopView];
    
    [self setupNavigationView];
    
    //判断类型
    switch (self.status) {
        case ShopShowActivity:
            [self getActivityMessageSeachBySynthesize];
            break;
        case ShopShowSearch:
            self.synthesizeBtn.hidden = YES;
            self.priceBtn.hidden = YES;
            self.collectionView.height = self.view.height - 64;
            self.collectionView.top = 0;
            [self getSearchMessageSeachBySynthesize];
            break;
        case ShopShowType:
            [self getTypeMessageSeachBySynthesize];
            break;
        case ShopShowHot:
            [self getHotMessageSeachBySynthesize];
            break;
        default:
            break;
    }
    
    //[self getTypeMessageSeachBySynthesize];
    // Do any additional setup after loading the view.
}
#pragma mark --- ui
- (void)setupTopView {
    [self.view addSubview:self.synthesizeBtn];
    self.synthesizeBtn.selected = YES;
    [self.view addSubview:self.priceBtn];
}
- (void)setupNavigationView {
    if (self.status != ShopShowSearch) {
        [self creatTitleViewWithString:self.titleStr];
        return;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    self.seachTextField.text = self.searchTitle;
    self.navigationItem.titleView = self.seachTextField;
    
}
#pragma mark --- interface
#pragma mark --- 类型的网络请求
/** 请求综合排序的数据*/
- (void)getTypeMessageSeachBySynthesize {
    //综合排序 interId:2类型 4品牌  type:如果是类型是1 2 3 4 5  如果是品牌则是品牌id 页面上每个模块的id
    //count:0第一次访问 1其他访问
    NSDictionary *synthesizeParam = @{@"interId":@"2",
                                      @"city":kGetCityCode,
                                      @"start":@"0",
                                      @"type":self.index,
                                      @"count":@"0"};
    [QDHttpTool getWithURL:kUrl_getMessageSearch params:synthesizeParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _synthesizeArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
        [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    //价格排序 interId:2类型 4品牌  type:正确的是1 2 3 4 5   页面上每个模块的id
    //count:0第一次访问 1其他访问
    NSDictionary *ascParam = @{@"interId":@"2",
                               @"city":kGetCityCode,
                               @"start":@"0",
                               @"type":self.index,
                               @"orderBy":@"asc"};
    [QDHttpTool getWithURL:kUrl_getMessageSearchByPrice params:ascParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"asc---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _priceByAscArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
    //价格排序 interId:2类型 4品牌  type:正确的是1 2 3 4 5   页面上每个模块的id
    //count:0第一次访问 1其他访问
    NSDictionary *descParam = @{@"interId":@"2",
                                @"city":kGetCityCode,
                                @"start":@"0",
                                @"type":self.index,
                                @"orderBy":@"desc"};
    [QDHttpTool getWithURL:kUrl_getMessageSearchByPrice params:descParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"desc---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _priceByDescArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark --- 活动的网络请求
- (void)getActivityMessageSeachBySynthesize {
    
    //活动的综合排序   type:1~4   页面上每个模块的id
    //count:0第一次访问 1其他访问
    NSDictionary *synthesizeParam = @{@"count":@"0",
                                 @"city":kGetCityCode,
                                 @"start":@"0",
                                 @"type":self.index};
    [QDHttpTool getWithURL:kUrl_getActivity params:synthesizeParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _synthesizeArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
        [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {

    }];

    //价格升序排列
    //活动的价格排序   type:1~5  orderBy:1 升序 2 降序
    NSDictionary *ascParam = @{@"city":kGetCityCode,
                                 @"start":@"0",
                                 @"type":self.index,
                                 @"orderBy":@"1"};
    [QDHttpTool getWithURL:kUrl_getActivityBrderByPrice params:ascParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _priceByAscArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];

    //价格降序排列
    NSDictionary *descParam = @{@"city":kGetCityCode,
                                @"start":@"0",
                                @"type":self.index,
                                @"orderBy":@"2"};
    [QDHttpTool getWithURL:kUrl_getActivityBrderByPrice params:descParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (!isSuccess) {
            return ;
        }
        _priceByDescArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark --- 热门的网络请求
/** 请求热门排序的数据*/
- (void)getHotMessageSeachBySynthesize {
    //商城首页点击更多车款   type: 预热type = 1,进行中type = 2,完毕type = 3
    NSDictionary *synthesizeParam = @{@"city":kGetCityCode,
                                 @"start":@"0",
                                 @"type":self.index,
                                 @"count":@"0"};
    [QDHttpTool getWithURL:kUrl_getIndexDetail params:synthesizeParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _synthesizeArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
        [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    //热门商品价格排序   type: 预热type = 1,进行中type = 2,完毕type = 3 orderBy = 1 升序 2 降序
    NSDictionary *ascParam = @{@"city":kGetCityCode,
                               @"start":@"0",
                               @"type":self.index,
                               @"orderBy":@"1"};
    [QDHttpTool getWithURL:kUrl_indexOrderByPrice params:ascParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _priceByAscArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
    //价格降序排列
    NSDictionary *descParam = @{@"city":kGetCityCode,
                                @"start":@"0",
                                @"type":self.index,
                                @"orderBy":@"2"};
    [QDHttpTool getWithURL:kUrl_indexOrderByPrice params:descParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _priceByDescArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark --- 搜索
- (void)getSearchMessageSeachBySynthesize {
    [self getSearchMessageSeachBySynthesizeWithTitle:self.searchTitle];
}
- (void)getSearchMessageSeachBySynthesizeWithTitle:(NSString *)title {
    //搜索商品  title 标题 city 城市 start 开始的数量 type:1 价格 2 综合 orderby :asc 升序 desc 降序
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    NSDictionary *synthesizeParam = @{@"title":title,
                                      @"city":kGetCityCode,
                                      @"start":@"0",
                                      @"type":@"2",
                                      @"orderby":@"asc"};
    [QDHttpTool getWithURL:kUrl_search params:synthesizeParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        
        if (!isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
            return ;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        
        _tempArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
#pragma mark --- private method
/** 点击价格排序按钮*/
- (void)clickPriceBtn {
    self.synthesizeBtn.selected = NO;
    if (!self.priceBtn.selected) {
        self.priceBtn.selected = YES;
        self.isDesc = YES;
        if (_tempArrayM.count) {
            [_tempArrayM removeAllObjects];
        }
        //ARRAYM_REMOVW_ALLOBJECTS_(_tempArrayM);
        [_tempArrayM addObjectsFromArray:_priceByAscArrayM];
        [self.collectionView reloadData];
        return;
    }
    
    if (_tempArrayM.count) {
        [_tempArrayM removeAllObjects];
    }
    if (self.isDesc) {
        [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_desc"] forState:UIControlStateSelected];
        [_tempArrayM addObjectsFromArray:_priceByDescArrayM];
        
    } else {
        [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
        [_tempArrayM addObjectsFromArray:_priceByAscArrayM];
    }
    [self.collectionView reloadData];
    self.isDesc = !self.isDesc;
}
/** 点击综合排序按钮*/
- (void)clickSynthesizeBtn {
    self.synthesizeBtn.selected = YES;
    self.priceBtn.selected = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
    if (_tempArrayM.count) {
        [_tempArrayM removeAllObjects];
    }
    [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
    [self.collectionView reloadData];
    //请求数据然后重新刷新数据---设置数据源，如果有就不需要刷新
}


-(void)clickNewBuyButtonWithGoodsId:(NSString *)goodsId
{
    if (!QDDEBUGGOODSDETAIL) {
        [self intoGoodsDetailView:goodsId isActivityOver:NO];
    }else
    {
        [self intoUpdateGoodsDetailView:goodsId isActivityOver:NO];
        
    }
    
    
    
}


/** 点击首页的cell，进入商品详情*/
- (void)clickBuyButtonWithGoodsId:(NSString *)goodsId {
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
    vc.goodsId = goodsId;
    vc.cityCode = kGetCityCode;
    vc.isBackBtnShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 导航栏改变*/
- (void)textFieldDidChange {
    if (self.seachTextField.text.length > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancleBtn];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_tempArrayM.count == 0) {
        return 1;
    }
    return _tempArrayM.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //没有数据则显示为空页
    if (_tempArrayM.count == 0) {
        NoSearchContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNoSearchContentCollectionViewCell forIndexPath:indexPath];
        return cell;
    }
    
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCollectionViewCell forIndexPath:indexPath];
    cell.model = _tempArrayM[indexPath.row];
    cell.clickBuyBtnBlock = ^(NSString *modelId){
        //点击立即购买
        //[self clickBuyButtonWithGoodsId:modelId];
        [self clickNewBuyButtonWithGoodsId:modelId];
    };
    return cell;
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


#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_tempArrayM.count == 0) {
        return CGSizeMake(720*SizeScale, 650*SizeScale);
    }
    return CGSizeMake(332*SizeScale, 606*SizeScale);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (_tempArrayM.count == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(16*SizeScale, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
#pragma mark --- UITextField Delegate
/** 点击空白收键盘*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.seachTextField resignFirstResponder];
}
#pragma mark --- super method
- (void)clickBackBtn {
    
    if (self.status == ShopShowSearch) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/** 导航栏右边的按钮，点击搜索*/
- (void)clickRightBtn {
    if (![self.seachTextField.text isExist]) {
        [[MBProgressHUDManager instance] showTextOnlyWithView:kGetKeyWindow withText:@"请输入搜索内容"];
        return ;
    }
    [self getSearchMessageSeachBySynthesizeWithTitle:self.seachTextField.text];
}
#pragma mark --- private method
#pragma mark --- lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
        //flow.headerReferenceSize = CGSizeMake(100, 50);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flow];
        _collectionView.height = self.view.height - 90*SizeScaleSubjectTo720 - 64;
        _collectionView.top = 90*SizeScaleSubjectTo720;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:kShopCollectionViewCell];
        [_collectionView registerClass:[NoSearchContentCollectionViewCell class] forCellWithReuseIdentifier:kNoSearchContentCollectionViewCell];
    }
    return _collectionView;
}
- (UIButton *)synthesizeBtn {
    if (!_synthesizeBtn) {
        _synthesizeBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 0, 360, 90) title:@"综合" titleColor:kColorForccc titleFont:30 backgroundColor:UIColorFromRGB_16(0x252525) tapAction:^(UIButton *button) {
            [self clickSynthesizeBtn];
        }];
        [_synthesizeBtn setTitleColor:UIColorFromRGB_16(0xe60012) forState:UIControlStateSelected];
    }
    return _synthesizeBtn;
}
- (UIButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(360, 0, 360, 90) title:@"价格" titleColor:kColorForccc titleFont:30 backgroundColor:UIColorFromRGB_16(0x252525) tapAction:^(UIButton *button) {
            [self clickPriceBtn];
        }];
        _priceBtn.imageView.contentMode = UIViewContentModeRight;
        _priceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_priceBtn setTitleColor:UIColorFromRGB_16(0xe60012) forState:UIControlStateSelected];
        [_priceBtn setImage:[UIImage imageNamed:@"shop_arrow_common"] forState:UIControlStateNormal];
        [_priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
    }
    return _priceBtn;
}

- (UITextField *)seachTextField {
    if (!_seachTextField) {
        _seachTextField = [[UITextField alloc]initWithFrame:CGRectMake720(0, 0, 560, 60)];
        _seachTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 77, 60)];
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(20, 17, 26, 26)];
        leftImageView.image = [UIImage imageNamed:@"shop_seach_btn"];
        [paddingView addSubview:leftImageView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(63, 17, 2, 26)];
        lineView.backgroundColor = kColorFor666;
        [paddingView addSubview:lineView];
        _seachTextField.leftView = paddingView;
        _seachTextField.leftViewMode = UITextFieldViewModeAlways;
        _seachTextField.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
        _seachTextField.placeholder = @"输入搜索的内容";
        _seachTextField.layer.cornerRadius = 10*SizeScaleSubjectTo720;
        _seachTextField.delegate = self;
        _seachTextField.textAlignment = NSTextAlignmentLeft;
        _seachTextField.textColor = [UIColor whiteColor];
        _seachTextField.font = UIFontOfSize720(24);
        [_seachTextField setValue:UIColorFromRGB_16(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        UIFont *font = UIFontOfSize720(24);
        _seachTextField.font = font;
        [_seachTextField setValue:font forKeyPath:@"_placeholderLabel.font"];
        [_seachTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _seachTextField;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setFrame:CGRectMake720(0,0,80,54)];
        _searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26*SizeScale];
        [_searchBtn setContentMode:UIViewContentModeRight];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:kColorForfff forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setFrame:CGRectMake720(0,0,80,54)];
        _cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26*SizeScale];
        [_cancleBtn setContentMode:UIViewContentModeRight];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:kColorForfff forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

@end
