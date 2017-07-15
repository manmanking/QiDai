//
//  BrandListViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/8.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "BrandListViewController.h"
#import "ShopHomePageModel.h"
#import "BrandModel.h"
#import "ShopCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "GoodsDetailViewController.h"


//新添加
#import "MMKCollectionViewFlowLayout.h"
#import "BandListHeaderCollectionReusableView.h"
#import "BrandListSectionCollectionReusableView.h"


@interface BrandListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate>
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


@property (nonatomic,strong) UIScrollView *baseScrollView;


@property (nonatomic,strong) UICollectionView *collectionView;


@property (nonatomic,strong) UIView *customNavigationBar;



@property (nonatomic,strong) UILabel *titileLabel;
//
///** 综合排序的按钮*/
//@property (nonatomic,strong) UIButton *synthesizeBtn;
//
///** 价格排序的按钮*/
//@property (nonatomic,strong) UIButton *priceBtn;
//
///** 判断价格下一次是否为降序，请求网络时，取反*/
//@property (nonatomic,assign) BOOL isDesc;
//
///** 品牌logo*/
//@property (nonatomic,strong) UIImageView *brandImageView;
//
///** 品牌*/
//@property (nonatomic,strong) UILabel *brandLabel;
@end

@implementation BrandListViewController

static NSString *const kShopCollectionViewCell = @"ShopCollectionViewCell";

static NSString *const kShopBrandListHeaderCollectionViewCellId = @"ShopBrandListHeaderCollectionViewCellId";

static NSString *const kShopBrandListSectionCollectionViewCellId = @"ShopBrandListSectionCollectionViewCellId";



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i = 0; i <  _brandDataSourcesMarr.count; i++) {
        if ([self.brandModel.name isEqualToString:_brandDataSourcesMarr[i]]) {
              [MobClick beginLogPageView:self.brandModel.name];
        }
    }
  
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (int i = 0; i <  _brandDataSourcesMarr.count; i++) {
        if ([self.brandModel.name isEqualToString:_brandDataSourcesMarr[i]]) {
           [MobClick endLogPageView:self.brandModel.name];
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _synthesizeArrayM = @[].mutableCopy;
    _priceByAscArrayM = @[].mutableCopy;
    _priceByDescArrayM = @[].mutableCopy;
    _tempArrayM = @[].mutableCopy;
    _brandDataSourcesMarr = @[].mutableCopy;
    
    
    
    // add by manman start of line
    //[self.view addSubview:self.baseScrollView];
    
    // end of line
    
    //[self setupTopView];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:kShopCollectionViewCell];
    // add by manman start of line
    //[self.view addSubview:self.baseScrollView];
    
    [self.collectionView registerClass:[BandListHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopBrandListHeaderCollectionViewCellId];
    
    [self.collectionView registerClass:[BrandListSectionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopBrandListSectionCollectionViewCellId];
    
//    [self.collectionView registerClass:[BrandListSectionCollectionReusableView class] forCellWithReuseIdentifier:kShopBrandListSectionCollectionViewCellId];
    
    
    
    
    // end of line
    
    
    [self setupTopViewUpdate];
    
    
    [self getMessageSeachBySynthesize];
   // [self getMessageSeachByPrice];
    // Do any additional setup after loading the view.
}
//
//- (void)setupTopView {
//    
//    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 468)];
//    bgImageView.image = [UIImage imageNamed:@"brand_list_bg_image"];
//    [self.view addSubview:bgImageView];
//    
//    [bgImageView addSubview:self.brandImageView];
//    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:self.brandModel.photo]];
//    self.brandLabel.text = self.brandModel.name;
//    [bgImageView addSubview:self.brandLabel];
//    
//    [self.view addSubview:self.synthesizeBtn];
//    self.synthesizeBtn.selected = YES;
//    [self.view addSubview:self.priceBtn];
//    
//    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(18, 65, 18, 33) NormalImageString:@"reset_back_image" tapAction:^(UIButton *button) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [backBtn setEnlargeEdge:15];
//    [self.view addSubview:backBtn];
//    
//    
//}
//
- (void)setupTopViewUpdate {
    
    _customNavigationBar = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.width, 64)];
    _customNavigationBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_customNavigationBar];
    
    
    
    
    
    
    
    
    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(18,(_customNavigationBar.height/(SizeScale) - 18)/2, 18, 33) NormalImageString:@"reset_back_image" tapAction:^(UIButton *button) {
        NSLog(@"点击 返回按钮");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    //backBtn.backgroundColor = [UIColor redColor];
    [backBtn setEnlargeEdge:30];
    [_customNavigationBar addSubview:backBtn];
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 30, 100, 70)];
//    [button setTitle:@"测试" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor blueColor];
//    [button addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    _titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(backBtn.right/(SizeScale), 0, self.view.width - ((backBtn.right +18)/(SizeScale)), 64)];
    _titileLabel.backgroundColor = [UIColor clearColor];
    _titileLabel.textAlignment = UITextAlignmentCenter;
    //[_customNavigationBar addSubview:_titileLabel];
    _titileLabel.text = self.brandModel.name;
    _titileLabel.textColor = [UIColor clearColor];
    [self.view addSubview:_titileLabel];
    
    
    
    
}



#warning 

- (void)testButtonClick:(UIButton *)sender
{
    
    NSLog(@"testButton ...");
    
}


#pragma mark --- interface
/** 请求综合排序的数据*/
- (void)getMessageSeachBySynthesize {
    //综合排序 interId:2类型 4品牌  type:如果是类型是1 2 3 4 5  如果是品牌则是品牌id 页面上每个模块的id
    //count:0第一次访问 1其他访问
    
    NSDictionary *synthesizeParam = @{@"interId":@"4",
                                 @"city":kGetCityCode,
                                 @"start":@"0",
                                 @"type":self.brandModel.id,
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
    NSDictionary *ascParam = @{@"interId":@"4",
                                 @"city":kGetCityCode,
                                 @"start":@"0",
                                 @"type":self.brandModel.id,
                                 @"orderBy":@"asc"};
    [QDHttpTool getWithURL:kUrl_getMessageSearchByPrice params:ascParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _priceByAscArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
    //价格排序 interId:2类型 4品牌  type:正确的是1 2 3 4 5   页面上每个模块的id
    //count:0第一次访问 1其他访问
    NSDictionary *descParam = @{@"interId":@"4",
                                 @"city":kGetCityCode,
                                 @"start":@"0",
                                 @"type":self.brandModel.id,
                                 @"orderBy":@"desc"};
    [QDHttpTool getWithURL:kUrl_getMessageSearchByPrice params:descParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (!isSuccess) {
            return ;
        }
        _priceByDescArrayM = [ShopHomePageModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- private method
// 原来 的备份
/** 点击价格排序按钮*/
//- (void)clickPriceBtn {
//    self.synthesizeBtn.selected = NO;
//    if (self.priceBtn.selected) {
//        if (self.isDesc) {
//            [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_desc"] forState:UIControlStateSelected];
//            if (_tempArrayM.count) {
//                [_tempArrayM removeAllObjects];
//            }
//            [_tempArrayM addObjectsFromArray:_priceByDescArrayM];
//            [self.collectionView reloadData];
//        } else {
//            [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
//            if (_tempArrayM.count) {
//                [_tempArrayM removeAllObjects];
//            }
//            [_tempArrayM addObjectsFromArray:_priceByAscArrayM];
//            [self.collectionView reloadData];
//        }
//        self.isDesc = !self.isDesc;
//    } else {
//        self.priceBtn.selected = YES;
//        self.isDesc = YES;
//        if (_tempArrayM.count) {
//            [_tempArrayM removeAllObjects];
//        }
//        [_tempArrayM addObjectsFromArray:_priceByAscArrayM];
//        [self.collectionView reloadData];
//    }
////#warning -- 请求数据然后重新刷新数据--标记升降序
//}
///** 点击综合排序按钮*/
//- (void)clickSynthesizeBtn {
//    self.synthesizeBtn.selected = YES;
//    self.priceBtn.selected = NO;
//    [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
//    if (_tempArrayM.count) {
//        [_tempArrayM removeAllObjects];
//    }
//    [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
//    [self.collectionView reloadData];
//    //请求数据然后重新刷新数据---设置数据源，如果有就不需要刷新
//}
//


// modify by manman
//
///** 点击价格排序按钮*/
//- (void)clickPriceBtn {
//    self.synthesizeBtn.selected = NO;
//    if (self.priceBtn.selected) {
//        if (self.isDesc) {
//            [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_desc"] forState:UIControlStateSelected];
//            if (_tempArrayM.count) {
//                [_tempArrayM removeAllObjects];
//            }
//            [_tempArrayM addObjectsFromArray:_priceByDescArrayM];
//            [self.collectionView reloadData];
//        } else {
//            [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
//            if (_tempArrayM.count) {
//                [_tempArrayM removeAllObjects];
//            }
//            [_tempArrayM addObjectsFromArray:_priceByAscArrayM];
//            [self.collectionView reloadData];
//        }
//        self.isDesc = !self.isDesc;
//    } else {
//        self.priceBtn.selected = YES;
//        self.isDesc = YES;
//        if (_tempArrayM.count) {
//            [_tempArrayM removeAllObjects];
//        }
//        [_tempArrayM addObjectsFromArray:_priceByAscArrayM];
//        [self.collectionView reloadData];
//    }
//    //#warning -- 请求数据然后重新刷新数据--标记升降序
//}
///** 点击综合排序按钮*/
//- (void)clickSynthesizeBtn {
//    self.synthesizeBtn.selected = YES;
//    self.priceBtn.selected = NO;
//    [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
//    if (_tempArrayM.count) {
//        [_tempArrayM removeAllObjects];
//    }
//    [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
//    [self.collectionView reloadData];
//    //请求数据然后重新刷新数据---设置数据源，如果有就不需要刷新
//}


// end of line

/** 点击首页的cell，进入商品详情*/
- (void)clickBuyButtonWithGoodsId:(NSString *)goodsId {
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
    
    vc.goodsId = goodsId;
    vc.cityCode = kGetCityCode;
    vc.isBackBtnShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.isPresent = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
        
    }else
    {
        return _tempArrayM.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCollectionViewCell forIndexPath:indexPath];
    cell.model = _tempArrayM[indexPath.row];
    cell.clickBuyBtnBlock = ^(NSString *modelId){
        [self clickBuyButtonWithGoodsId:modelId];
    };
    return cell;
}

//添加 headerview
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    //UICollectionReusableView *reusableview = nil;
    
    if (indexPath.section == 0)
    {
        BandListHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopBrandListHeaderCollectionViewCellId forIndexPath:indexPath];
        if (self.brandModel.name.length >0 &&self.brandModel.photo.length >0 ) {
          [headerView setBrandTitle:self.brandModel.name AndBrandImageURL:[NSURL URLWithString:self.brandModel.photo]];
        }
        
        
        //reusableview = headerView;
        return headerView;
    }
   
    
        BrandListSectionCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopBrandListSectionCollectionViewCellId forIndexPath:indexPath];
        
        // @weakify_self
        //_headerView.clickBtnBlock = ^(NSInteger page){
            //@strongify_self
            
//            self.synthesizeBtn.selected = YES;
//            self.priceBtn.selected = NO;
//            [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
//            if (_tempArrayM.count) {
//                [_tempArrayM removeAllObjects];
//            }
//            [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
//            [self.collectionView reloadData];
        @weakify_self
        headerView.synthesizeBtnClick = ^{
        @strongify_self
            if (_tempArrayM.count) {
                [_tempArrayM removeAllObjects];
            }
            [_tempArrayM addObjectsFromArray:_synthesizeArrayM];
            [self.collectionView reloadData];
        };
       
        //价格按钮
        headerView.priceBtnClick = ^(NSString *upAndDown){
            if (_tempArrayM.count) [_tempArrayM removeAllObjects];
            if ([upAndDown isEqualToString:@"UP"]) [_tempArrayM addObjectsFromArray:_priceByAscArrayM];
            else [_tempArrayM addObjectsFromArray:_priceByDescArrayM];
            [self.collectionView reloadData];

            
        };
    return headerView;
}





#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(332*SizeScaleSubjectTo720, 606*SizeScaleSubjectTo720);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16*SizeScaleSubjectTo720, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size;
    if (section == 0) {
        size = CGSizeMake (self.view.frame.size.width * (SizeScaleSubjectTo720), 468 *(SizeScaleSubjectTo720));
    }else
    {
        size = CGSizeMake (self.view.frame.size.width * (SizeScaleSubjectTo720), 90 *(SizeScaleSubjectTo720));
    }
    
    return size;
}


#pragma mark ---- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >468 *(SizeScaleSubjectTo720)) {
        
        _customNavigationBar.backgroundColor = [UIColor blackColor];
//        _titileLabel.backgroundColor = [UIColor blackColor];
        _titileLabel.textColor = [UIColor whiteColor];
        
    }
    else{
        _customNavigationBar.backgroundColor = [UIColor clearColor];
        //_titileLabel.backgroundColor = [UIColor clearColor];
        _titileLabel.textColor = [UIColor clearColor];
    }
    
    
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y >64) {
//        
//        //_customNavigationBar.backgroundColor = [UIColor blackColor];
//        _titileLabel.backgroundColor = [UIColor blackColor];
//        _titileLabel.textColor = [UIColor whiteColor];
//        
//    }
//    else{
//        _titileLabel.backgroundColor = [UIColor clearColor];
//        _titileLabel.textColor = [UIColor blackColor];
//    }
//    
//    
//    
//}

#pragma mark --- lazy load


// add by manman on 2016-09-29  start of line
- (UIScrollView *)baseScrollView
{
    if (_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _baseScrollView.delegate = self;
        _baseScrollView.backgroundColor = [UIColor blackColor];
        
    }
    return _baseScrollView;
    
}

// end of line


//原来 备份
//- (UICollectionView *)collectionView {
//    if (!_collectionView) {
//        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
//        [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
//        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flow];
//        _collectionView.height = self.view.height - (90+468)*SizeScaleSubjectTo720 ;
//        _collectionView.top = (90+468)*SizeScaleSubjectTo720;
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor blackColor];
//    }
//    return _collectionView;
//}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        MMKCollectionViewFlowLayout *flow = [[MMKCollectionViewFlowLayout alloc]init];
        [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flow];
//        _collectionView.height = self.view.height - (90+468)*SizeScaleSubjectTo720 ;
//        _collectionView.top = (90+468)*SizeScaleSubjectTo720;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blackColor];
    }
    return _collectionView;
}

//
//- (UIButton *)synthesizeBtn {
//    if (!_synthesizeBtn) {
//        _synthesizeBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 468, 360, 90) title:@"综合" titleColor:kColorForccc titleFont:30 backgroundColor:UIColorFromRGB_16(0x252525) tapAction:^(UIButton *button) {
//            [self clickSynthesizeBtn];
//        }];
//        [_synthesizeBtn setTitleColor:UIColorFromRGB_16(0xe60012) forState:UIControlStateSelected];
//    }
//    return _synthesizeBtn;
//}
//- (UIButton *)priceBtn {
//    if (!_priceBtn) {
//        _priceBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(360, 468, 360, 90) title:@"价格" titleColor:kColorForccc titleFont:30 backgroundColor:UIColorFromRGB_16(0x252525) tapAction:^(UIButton *button) {
//            [self clickPriceBtn];
//        }];
//        _priceBtn.imageView.contentMode = UIViewContentModeRight;
//        _priceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [_priceBtn setTitleColor:UIColorFromRGB_16(0xe60012) forState:UIControlStateSelected];
//        [_priceBtn setImage:[UIImage imageNamed:@"shop_arrow_common"] forState:UIControlStateNormal];
//        [_priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
//    }
//    return _priceBtn;
//}
//- (UIImageView *)brandImageView {
//    if (!_brandImageView) {
//        _brandImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(295, 170, 130, 130)];
//        [_brandImageView setRoundedCorners:UIRectCornerAllCorners radius:(65*SizeScaleSubjectTo720)];
//    }
//    return _brandImageView;
//}
//- (UILabel *)brandLabel {
//    if (!_brandLabel) {
//        _brandLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 342, 720, 30) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
//    }
//    return _brandLabel;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
