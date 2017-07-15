//
//  GoodsDetailViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import <MeiQiaSDK/MQManager.h>
#import "MQChatViewManager.h"
#import "UserInfoDBManager.h"
#import "UserInfoModel.h"
#import "GoodsActivityTableViewCell.h"
#import "GoodStoreTableViewCell.h"
#import "CommentTableViewCell.h"
#import "SelectColorTableViewCell.h"
#import "ActivityRulesViewController.h"
#import "OrderConfirmationViewController.h"
#import "GoodCommentsViewController.h"
#import "AddressInfoViewController.h"
#import "SDCycleScrollView.h"
#import "GoodsModel.h"
#import "ActivityModel.h"
#import "ShopAddressModel.h"
#import "CommentModel.h"
#import "MJExtension.h"
#import "QDAlphaWarnView.h"
#import "CommentUtil.h"
#import "UIButton+AcceptEvent.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "UIImage+Tools.h"
#import "UITableView+ZFTableViewSnapshot.h"
#import "MJRefresh.h"
#import "QDHttpTool.h"

@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,SelectColorTableViewCellDelegate,GoodsActivityTableViewCellDelegate,GoodStoreTableViewCellDelegate,SelectColorTableViewCellDelegate,UMSocialUIDelegate>
{
    /** 1:快递 2:到店自取*/
    NSInteger _payType;
    /** 标记*/
    NSInteger _activityPage;
    NSInteger _shopPage;
    NSString *_colorStr;
    NSInteger _colorPage;
    /** 评论数*/
    NSString *_commentCount;
    /** 好评率*/
    NSString *_goodRate;
    /** 默认的地铺地址*/
    ShopAddressModel *_defaultShopModel;
    
    /** 颜色的数组*/
    NSMutableArray *_colorArrayM;
    /** 车店拥有的颜色,与车的所有颜色可能有出入,该颜色然后变灰色按钮*/
    NSMutableArray *_selectColorArrayM;
    /** 活动拥有的颜色,与车的所有颜色可能有出入,该颜色然后变灰色按钮*/
    NSMutableArray *_activityColorArrayM;
    /** 活动的数组*/
    NSMutableArray *_activityArrayM;
    /** 车店的数组*/
    NSMutableArray *_shopArrayM;
    /** 车的图片的数组，用做轮播图*/
    NSMutableArray *_photoArrayM;
    /** 评论的数组*/
    NSMutableArray *_commentArrayM;
    
    //nav
    /** nav商品的btn*/
    UIButton *_goodsBtn;
    /** nav详情的btn*/
    UIButton *_detailBtn;
    /** nav的红条*/
    UIView *_redAnimationView;
    /** 第一次加载详情的图片*/
    BOOL _firstLoadImage;
    
    /**背景scrollview */
    //UIScrollView *_bgScrollView;
    
    //被选中的活动
    ActivityModel *_selectActivityModel;
    
    
    
}
/** 上下垂直的view --- 用于下拉到商品详情*/
@property (nonatomic,strong) UIScrollView *verticalScrollView;

/** 底部的scrollView*/
@property (nonatomic,strong) UIScrollView *rootScrollView;
/** 详情的scrollView,放上去一张图片*/
@property (nonatomic,strong) UIScrollView *detailScrollView;
/** 详情的scrollView,放上去一张图片 ---用于下拉*/
@property (nonatomic,strong) UIScrollView *detailScrollView1;
/** 详情的img*/
@property (nonatomic,strong) UIImageView *detailImageView;
/** 详情的img      ------用于下拉*/
@property (nonatomic,strong) UIImageView *detailImageView1;
/** 商品的tableView*/
@property (nonatomic,strong) UITableView *tableView;
/** 现价*/
@property (nonatomic,strong) UILabel *priceLabel;
/** 原价，这个参数可能没有*/
@property (nonatomic,strong) UILabel *originalPrice;
/** 车辆详情*/
@property (nonatomic,strong) UILabel *detailLabel;
/** 轮播图*/
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
/** 商品的model*/
@property (nonatomic,strong) GoodsModel *goodsModel;
/** 要分享的图片*/
@property (nonatomic,strong) UIImage *shareImage;


@property (nonatomic,strong) QDAlphaWarnView  *alphaWarnView;


@property (nonatomic,strong)UILabel *alertViewLabel;


@property (nonatomic,strong)NSTimer *customTimer;




//nav
/** 商品导航栏的titleView*/
@property (nonatomic,strong) UIView *titleView;


@property (nonatomic,strong)UILabel *titleLabelView;

/** 商品详情导航栏的titleView*/
@property (nonatomic,strong) UILabel *goodDetailLabel;
@end

@implementation GoodsDetailViewController

static NSString *const kGoodsActivityTableViewCell = @"GoodsActivityTableViewCell";
static NSString *const kGoodStoreTableViewCell = @"GoodStoreTableViewCell";
static NSString *const kSelectColorTableViewCell = @"SelectColorTableViewCell";
static NSString *const kCommentTableViewCell = @"CommentTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activityPage   = 0;
    _shopPage       = 2147483647;// 现在是暂时的 以后更改这个逻辑
    _firstLoadImage = YES;
    _colorPage = 0;
    //初始化一些数组
    _colorArrayM    = @[].mutableCopy;
    _selectColorArrayM = @[].mutableCopy;
    _activityColorArrayM = @[].mutableCopy;
    _photoArrayM    = @[].mutableCopy;
    _activityArrayM = @[].mutableCopy;
    _shopArrayM     = @[].mutableCopy;
    _commentArrayM  = @[].mutableCopy;
    
    //ui
    [self.view addSubview:self.verticalScrollView];
    self.verticalScrollView.bounces = NO;
    [self.verticalScrollView addSubview:self.tableView];
    
    //[self.rootScrollView addSubview:self.tableView];
    
    
    [self.detailScrollView1 addSubview:self.detailImageView1];
    //[self.detailScrollView addSubview:self.detailImageView];
    
    [self.verticalScrollView addSubview:self.detailScrollView1];
    
    //[self.verticalScrollView addSubview:self.detailScrollView];
    
    self.detailScrollView1.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.verticalScrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            self.navigationItem.titleView = self.titleView;
            //结束加载
            [self.detailScrollView1.mj_header endRefreshing];
        }];
    }];
    //
    UILabel *label = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 720, 90) title:@"继续上拉,查看详情" titleColor:kColorFor666 textAlignment:NSTextAlignmentCenter font:24];
    self.tableView.tableFooterView = label;
    
    //建立轮播图
    [self setupCycleScrollView];
    //固定的bottom
    [self setupBottomView];
    //nav
    [self setupNavigationView];
    
    //注册cell
    [self.tableView registerClass:[GoodsActivityTableViewCell class] forCellReuseIdentifier:kGoodsActivityTableViewCell];
    [self.tableView registerClass:[GoodStoreTableViewCell class] forCellReuseIdentifier:kGoodStoreTableViewCell];
    [self.tableView registerClass:[SelectColorTableViewCell class] forCellReuseIdentifier:kSelectColorTableViewCell];
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:kCommentTableViewCell];

    //请求商品详情的数据
    
    [self getGoodsDetailDataSource];
    
    //在请求商品详情的数据完成后，再请求getShopsDataSource，如果快递，则隐藏
    //[self getShopsDataSource];
    
    //请求商品评论的数据
    [self getCommentDataSource];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self clearTheExpireData];
    [MobClick beginLogPageView:kGoodsDetails];
    
    [self getGoodsDetailDataSource];
    
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
     [MobClick endLogPageView:kGoodsDetails];
     [self clearTheExpireData];
    [self timeInvalidate];
}


/*
    清除过期的数据
 
**/
-(void)clearTheExpireData
{
    _colorStr = @"";//记录选中的颜色
    _shopPage = 2147483647;
    // 0 是活动  1是店铺  2 是颜色
    
//    if (_payType == 1) {
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//    else
//    {
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
    
    
   
    
    
}



#pragma mark --- ui
- (void)setupNavigationView {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    
    // modify by manman on start of line
    
    self.navigationItem.title = @"商品";
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;

    //self.navigationItem.titleView = self.titleView;
   
    // end of line
    [self creatShareBtn];
    
    //self.navigationController.navigationItem.titleView =self.titleView;
    
}

/** 轮播图*/
- (void)setupCycleScrollView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 782)];
    headerView.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    //[self.view addSubview:headerView];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake720(0, 0, 720, 606) delegate:self placeholderImage:[UIImage imageNamed:@"goods_detail_default_image"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    self.cycleScrollView.autoScrollTimeInterval = 4.0;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [headerView addSubview:self.cycleScrollView];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake720(0, 606, 720, 176)];
    [headerView addSubview:detailView];
    [detailView addSubview:self.priceLabel];
    [detailView addSubview:self.originalPrice];
    [detailView addSubview:self.detailLabel];
    if (self.isActivityOver) {
        self.originalPrice.hidden = YES;
    }
    
    self.tableView.tableHeaderView = headerView;
}
- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 120)];
    bottomView.top = self.view.height - 120*SizeScaleSubjectTo720 - 64;
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    //在线客服
    UIButton *serviceBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(38, 28, 95, 70) NormalBackgroundImageString:@"good_services_image" tapAction:^(UIButton *button) {
        [self clickServiceBtn];
    }];
    [bottomView addSubview:serviceBtn];
    //电话咨询
    UIButton *consultingBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(188, 28, 95, 70) NormalBackgroundImageString:@"good_consulting_image" tapAction:^(UIButton *button) {
        [self clickBottomPhoneBtn];
    }];
    consultingBtn.qd_acceptEventInterval = 1.0f;
    [bottomView addSubview:consultingBtn];
    
    UIButton *buyBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(340, 0, 380, 120) title:@"立即购买" titleColor:kColorForfff titleFont:34 backgroundColor:UIColorFromRGB_16(0xe60012) tapAction:^(UIButton *button) {
        
        BOOL isSuccess = [_colorStr isExist];
        NSLog(@"isSuccess %@",isSuccess== YES ?@"Yes":@"NO");
        if (_colorStr != nil && _colorStr.length >0)NSLog(@"colorStr %@",_colorStr);
//        if ((_colorStr != nil || _colorStr.length >0)) {
//            [[MBProgressHUDManager instance] showTextOnlyWithView:kGetWindow withText:@"请选择颜色"];
//            return ;
//        }
        // modify by manman on 2016-10-31
        // BUG 318 BUG 330
        
       
        // _payType 1 为快递  2 为到店自取
        if (_payType == 2) {
            // 判断颜色和店铺
            if (_shopPage == 2147483647 ||_colorStr == nil || _colorStr.length == 0) {
                
                [self.view addSubview:self.alertViewLabel];
                [self setAlertViewLabelTitle:@"请选择店铺和颜色"];
            }else
            {
                 [self clickOrderConfirmation];
            }
   
        }else
        {
            // 只判断颜色
            if(_colorStr != nil && _colorStr.length >0 )
                [self clickOrderConfirmation];
            else [self.view addSubview:self.alertViewLabel];
        }
        
        
//        if(_colorStr != nil && _colorStr.length >0 )
//        [self clickOrderConfirmation];
//        else [self.view addSubview:self.alertViewLabel];
            //[[MBProgressHUDManager instance] showTextOnlyWithView:kGetWindow withText:@"请选择颜色"];
    }];
    buyBtn.qd_acceptEventInterval = 3.f;
    [bottomView addSubview:buyBtn];
}
#pragma mark --- interface
/** 获取商品详情的信息*/
- (void)getGoodsDetailDataSource {
    //pay_type  1到取,2快递
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    });
    
    NSString *cityCode = [kNSUSERDEFAULE valueForKey:kFind_cityCode];
    NSString *lat = [kNSUSERDEFAULE valueForKey:kFind_latitude];
    NSString *lng = [kNSUSERDEFAULE valueForKey:kFind_longitude];
    
    NSDictionary *brandParam = @{@"city":cityCode,
                                 @"id":self.goodsId,
                                 @"lat":lat,
                                 @"lng":lng};
    [QDHttpTool getWithURL:kUrl_detail_index params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        //获得商品的详细信息
        self.goodsModel = [GoodsModel mj_objectWithKeyValues:[responseObject[@"data"] valueForKey:@"item"]];
        
        NSArray *defaultShopArray = [ShopAddressModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] valueForKey:@"defaultShop"]];
        if (defaultShopArray.count) {
            _defaultShopModel = defaultShopArray[0];
        }
        // 商品 颜色
        NSArray *colorArray = [self.goodsModel.color componentsSeparatedByString:@","];
//        if (colorArray.count) {
//            _colorStr = colorArray[0];
//        }
        if (_colorArrayM.count >0) {
            [_colorArrayM removeAllObjects];
        }
        [_colorArrayM addObjectsFromArray:colorArray];
        
        
        
        NSArray *photoArray = [self.goodsModel.photo componentsSeparatedByString:@","];
        [_photoArrayM addObjectsFromArray:photoArray];
    
        self.cycleScrollView.imageURLStringsGroup = _photoArrayM;
        
//        // 活动信息
        NSArray *activityArray = [ActivityModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] valueForKey:@"activity"]];
        if (_activityArrayM.count>0) {
            [_activityArrayM removeAllObjects];
        }
        [_activityArrayM addObjectsFromArray:activityArray];
        
        // add by manman 2016-10-26 BUG 302
        // 店铺信息
        // 自行车可以无活动 
        if (activityArray.count >0) {
             _selectActivityModel = [_activityArrayM[0] copy];
        }
       
        if (_shopArrayM.count>0) {
            [_shopArrayM removeAllObjects];
            
        }
        [_shopArrayM addObjectsFromArray:[ShopAddressModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] valueForKey:@"newShopLists"]]];
        
        // end of line
        
        //刷新header的数据
        self.priceLabel.text = self.goodsModel.price;
        if (_activityArrayM.count) {
            ActivityModel *activityModel = _activityArrayM[0];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%d",[self.goodsModel.price intValue] - [activityModel.refund intValue] ];
            _payType = [self.goodsModel.pay_type integerValue];
            if (_payType == 1) {
                ARRAYM_REMOVW_ALLOBJECTS_(_activityColorArrayM);
                NSArray *colorArray = [activityModel.color componentsSeparatedByString:@","];
                if (colorArray.count) {
                    [_activityColorArrayM addObjectsFromArray:colorArray];
                }
                _colorStr = @"";
                
            }
            
        }
        
        
        
        NSString *originalPrice = [NSString stringWithFormat:@"￥%@",self.goodsModel.price];
        self.originalPrice.attributedText = [NSString addHorizontalLineWithString:originalPrice color:kColorForccc];
        
        self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.goodsModel.brand,self.goodsModel.series,self.goodsModel.model,self.goodsModel.title];
        
        //商品评论
        _commentCount = [responseObject[@"data"] valueForKey:@"commentTotal"];
        NSInteger goodCount = [[responseObject[@"data"] valueForKey:@"good"] floatValue];
        NSString *rate = [NSString stringWithFormat:@"%.2f",goodCount/[_commentCount floatValue]];
        _goodRate = [NSString stringWithFormat:@"%.0f%%",[rate floatValue]*100];
        
        
        
        [self.tableView reloadData];
        
        // modify by manman on 2016-10-26  BUG 302
        // 现在的状态是 店铺有这个活动则显示 否则不显示
        // 修改为 店铺 有没有活动都要显示 但是 店铺没有这个活动 店铺为不可选状态
        
       // _payType == 1 是快递  2 到店自取
//        if (_payType == 2) {
//            [[MBProgressHUDManager instance] hideHUD];
//            [self getShopsDataSource];
//        } else {
//            [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
//        }
        
         [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        //end of line
        
        
        
        // 商品图片
        [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.detail] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat imageHeight = self.view.width/image.size.width * image.size.height;
                self.detailImageView.height = imageHeight;
                self.detailImageView1.height = imageHeight;
                self.detailImageView1.image = image;
                self.detailScrollView.contentSize = CGSizeMake(0, imageHeight);
                self.detailScrollView.alwaysBounceVertical = YES;
                self.detailScrollView1.contentSize = CGSizeMake(0, imageHeight);
                self.detailScrollView1.alwaysBounceVertical = YES;
            }
        }];
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
/** 获取车店的数据源，（先选定活动，然后在请求这个接口）*/
- (void)getShopsDataSource {
    if (_shopArrayM.count) {
        [_shopArrayM removeAllObjects];
    }
    
    if (_activityArrayM.count == 0) {
        
        if (!_defaultShopModel) {
            return;
        }
        [_shopArrayM addObject:_defaultShopModel];
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    ActivityModel *model = _activityArrayM[_activityPage];
    NSString *activityId = model.id;
    
    NSString *cityCode = [kNSUSERDEFAULE valueForKey:kFind_cityCode];
    NSString *lat = [kNSUSERDEFAULE valueForKey:kFind_latitude];
    NSString *lng = [kNSUSERDEFAULE valueForKey:kFind_longitude];
    
    NSDictionary *brandParam = @{@"city":cityCode,
                                 @"id":self.goodsId,
                                 @"activityId":activityId,
                                 @"lat":lat,
                                 @"lng":lng};
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    
    [QDHttpTool getWithURL:kUrl_detail_activity params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        QDLog(@"---%@",responseObject);
        
        NSArray *shopArray = [ShopAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [_shopArrayM addObjectsFromArray:shopArray];
        
//#warning ---
        if (_selectColorArrayM.count) {
            [_selectColorArrayM removeAllObjects];
        }
        if (_shopArrayM.count) {
            ShopAddressModel *model = _shopArrayM[0];
            NSArray *colorArray = [model.color_ios componentsSeparatedByString:@","];
            if (colorArray.count) {
                [_selectColorArrayM addObjectsFromArray:colorArray];
            }
            _colorStr = @"";
        }
        [self.tableView reloadData];
        [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
/** 获取评论的数据源*/
- (void)getCommentDataSource {
    //查询评价    status：1好评，2中评，3差评，4图，0也可为空    type:2为商品评价，1为活动评价
    NSDictionary *brandParam = @{@"type":@"2",
                                 @"modelId":self.goodsId,
                                 @"start":@"0",
                                 @"status":@"0"};
    [QDHttpTool getWithURL:kUrl_getComment params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        NSArray *commentArray = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (commentArray.count == 0) {
            return ;
        }
        [_commentArrayM addObjectsFromArray:commentArray];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        
    }];
}
/** 检查订单*/
//- (void)getCheckOrder {
//    
//}
#pragma mark --- private method
/** 点击nav商品btn*/
- (void)clickNavigationGoodsBtn {
    if (_goodsBtn.selected) {
        return;
    }
    _goodsBtn.selected = YES;
    _detailBtn.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        //[self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.tableView.left = 0;
        self.detailScrollView.left = HCDW;
        _redAnimationView.left = 0;
    }];
}
/** 点击nav详情btn*/
- (void)clickNavigationDetailBtn {
    if (_detailBtn.selected) {
        return;
    }
//    if (_firstLoadImage) {
//        _firstLoadImage = NO;
//        [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.detail] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                CGFloat imageHeight = self.view.width/image.size.width * image.size.height;
//                self.detailImageView.height = imageHeight;
//                self.detailScrollView.contentSize = CGSizeMake(0, imageHeight);
//            }
//        }];
//    }
    _goodsBtn.selected = NO;
    _detailBtn.selected = YES;
    [UIView animateWithDuration:0.5 animations:^{
        //[self.rootScrollView setContentOffset:CGPointMake(HCDW, 0) animated:YES];
        self.tableView.left = -HCDW;
        self.detailScrollView.left = 0;
        _redAnimationView.left = 168*SizeScale;
    }];
}
/** 点击底部的电话咨询*/
- (void)clickBottomPhoneBtn {
    //固定的电话
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000656717"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
/** 点击在线客服，进入聊天页面*/
- (void)clickServiceBtn {
    //在开发者需要调出聊天界面的位置，增加如下代码
    //设置头像
    UserInfoModel *userInfoModel = [UserInfoDBManager getUserInfoWithUserId:[[LoginManager instance] getUserId]];
    
    NSDictionary* clientCustomizedAttrs = @{@"name"        : userInfoModel.nickName,
                                            @"avatar"      : userInfoModel.foreImg};
    [MQManager setClientInfo:clientCustomizedAttrs completion:^(BOOL success, NSError *error) {
        
    }];
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}
/** 点击进入活动详情页面*/
- (void)clickActivityRuleViewControllerWtihPage:(NSInteger)page {
    ActivityRulesViewController *vc = [[ActivityRulesViewController alloc]init];
    //vc.activityId
    if (_activityArrayM.count >= page) {
        ActivityModel *model = _activityArrayM[page];
        vc.activityId = model.taskDetailId;
        vc.activityCommentId = model.id;
    }
    vc.isBackBtnShow = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 点击进入订单确认页*/
- (void)clickOrderConfirmation {
    
    if (![[LoginManager instance] isLogin]) {
        [self showLoginViewController];
        return;
    }
    
    
  
#warning 在本页面检测帐号活动于购买的车辆活动是否冲突 本次上线 不上 记得修改
    //[self pushTheNextView];
    // add by manman on 2016-10-25 start of line
    // 在本页面检测帐号活动于购买的车辆活动是否冲突
    if (_activityArrayM.count>0) {
        
        [self verifyActivitiesConflict];
    }else
    {
        [self pushTheNextView];
        
    }
  
    // end of line
   
}


- (void)pushTheNextView
{
    
    
    OrderConfirmationViewController *vc = [[OrderConfirmationViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.goodModel = self.goodsModel;
    vc.colorStr = _colorStr;
    vc.colorPage = _colorPage;
    if (_activityArrayM.count >= _activityPage && _activityArrayM.count != 0) {
        vc.activityModel = _activityArrayM[_activityPage];
    }
    if (_shopArrayM.count >= _shopPage && _shopArrayM.count != 0) {
        vc.shopModel = _shopArrayM[_shopPage];
    } else {
        vc.shopModel = _defaultShopModel;
        
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  验证活动是否冲突
 */
- (void)verifyActivitiesConflict
{
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic  setObject:kUserId forKey:@"userInfoId"];
    
    ActivityModel *activityModel = [[ActivityModel alloc]init];
    //CGFloat price = 0.01;
    if (_activityArrayM.count >= _activityPage && _activityArrayM.count != 0) {
        activityModel = _activityArrayM[_activityPage];
        [requestDic setObject:activityModel.id forKey:@"activityId"];
    }
    // 车可以没有活动 可以没有店铺

    
    
    /**
     *  end of line
     */
    
    [QDHttpTool getWithURL:kUrl_checkOrder params:requestDic success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"response verify conflict %@",responseObject);
    
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            
            NSNumber *isTrue = (NSNumber*)[responseObject[@"data"] valueForKey:@"success"];
            if ([isTrue  isEqual: @1]) {
                [self pushTheNextView];
                
            }else
            {
                [[MBProgressHUDManager instance] hideHUD];
                [self.view addSubview:self.alphaWarnView];
                //[[MBProgressHUDManager instance] requestSuccessWithMessage:[responseObject[@"data"] valueForKey:@"msg"]];
            }
        }else
        {
            [[MBProgressHUDManager instance] hideHUD];
        }
        
        
        
    } failure:^(NSError *error) {
       [[MBProgressHUDManager instance] requestFailAndHideHUD]; 
    }];

}



- (void)verifyActivitiesConflictAndOrder
{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MBProgressHUDManager instance] sendRequestShowHUD:kGetKeyWindow];
    });
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic  setObject:kUserId forKey:@"userInfoId"];
    
    ActivityModel *activityModel = [[ActivityModel alloc]init];
    //CGFloat price = 0.01;
    if (_activityArrayM.count >= _activityPage && _activityArrayM.count != 0) {
        activityModel = _activityArrayM[_activityPage];
        [requestDic setObject:activityModel.id forKey:@"activityId"];
    }
    // 车可以没有活动 可以没有店铺
    
    [QDHttpTool getWithURL:kUrl_checkOrder params:requestDic success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"response verify conflict %@",responseObject);
        
        if ([responseObject[@"code"] isEqualToString:@"00"])
        {
            
            BOOL isTrue = [responseObject[@"data"] valueForKey:@"success"];
            if (isTrue) {
                [self pushTheNextView];
                
            }else
            {
                [[MBProgressHUDManager instance] hideHUD];
                [self.view addSubview:self.alphaWarnView];
                //[[MBProgressHUDManager instance] requestSuccessWithMessage:[responseObject[@"data"] valueForKey:@"msg"]];
            }
            
        }else
        {
            [[MBProgressHUDManager instance] hideHUD];
        }
        
        dispatch_group_leave(group);
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [QDHttpTool getWithURL:kUrl_checkOrder params:requestDic success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"response verify conflict %@",responseObject);
        
        if ([responseObject[@"code"] isEqualToString:@"00"])
        {
            
            BOOL isTrue = [responseObject[@"data"] valueForKey:@"success"];
            if (isTrue) {
                [self pushTheNextView];
                
            }else
            {
                [[MBProgressHUDManager instance] hideHUD];
                [self.view addSubview:self.alphaWarnView];
                //[[MBProgressHUDManager instance] requestSuccessWithMessage:[responseObject[@"data"] valueForKey:@"msg"]];
            }
            
        }else
        {
            [[MBProgressHUDManager instance] hideHUD];
        }
        
        dispatch_group_leave(group);
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
        dispatch_group_leave(group);
    }];
    
    
}


#pragma mark --- super method
- (void)clickBackBtn {

    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickShareBtn {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:nil
                                     shareImage:self.shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
}
#pragma mark --- SelectColorTableViewCellDelegate
//- (void)clickColorCellWithColor:(NSString *)color {
//    _colorStr = color;
//}
- (void)clickColorCellWithColor:(NSString *)color page:(NSInteger)page {
    _colorStr = color;
    _colorPage = page;
    
}
#pragma mark --- GoodStoreTableViewCellDelegate
/** 选择店铺*/
- (void)clickStoreCellWithPage:(NSInteger)page {
    _shopPage = page;
    
    if (_selectColorArrayM.count) {
        [_selectColorArrayM removeAllObjects];
    }
    if (_shopArrayM.count >= page) {
        ShopAddressModel *model = _shopArrayM[page];
        NSArray *colorArray = [model.color_ios componentsSeparatedByString:@","];
        if (colorArray.count) {
            [_selectColorArrayM addObjectsFromArray:colorArray];
        }
        _colorStr = @"";
    }
    [self.tableView reloadData];
}
/** 点击店铺电话*/
- (void)clickPhoneBtnWithPage:(NSInteger)page {
    NSString *phone = @"";
    if (_shopArrayM.count >= page) {
        ShopAddressModel *model = _shopArrayM[page];
        phone = model.phone;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
/** 点击进入地址详情*/
- (void)clickAddressBtnWithPage:(NSInteger)page {
    AddressInfoViewController *vc = [[AddressInfoViewController alloc]init];
    vc.isBackBtnShow = YES;
    if (_shopArrayM.count >= page) {
        vc.model = _shopArrayM[page];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- GoodsActivityTableViewCellDelegate
- (void)clickActivityCellWithPage:(NSInteger)page {
    _activityPage = page;
    _shopPage = 2147483647;
    NSLog(@"选中活动...");
    
    if (_activityArrayM.count >= page && _activityArrayM.count) {
        ActivityModel *activityModel = _activityArrayM[page];
        _selectActivityModel = [_activityArrayM[page] copy];
        self.priceLabel.text = [NSString stringWithFormat:@"￥%d",[self.goodsModel.price intValue] - [activityModel.refund intValue] ];
        if (_payType == 1) {
            ARRAYM_REMOVW_ALLOBJECTS_(_activityColorArrayM);
            NSArray *colorArray = [activityModel.color componentsSeparatedByString:@","];
            if (colorArray.count) {
                [_activityColorArrayM addObjectsFromArray:colorArray];
            }
            _colorStr = @"";
        }

    }
    [self.tableView reloadData];
//    if (_payType == 2) {
//        [self getShopsDataSource];
//    }
}
#pragma mark --- UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    QDLog(@"into here scroll view ... x%f y%f ",scrollView.contentOffset.x,scrollView.contentOffset.y);
    CGPoint point = scrollView.contentOffset;
    if ((int)(point.x/self.view.width) == 0) {
        _goodsBtn.selected = YES;
        _detailBtn.selected = NO;
    } else {
        _goodsBtn.selected = NO;
        _detailBtn.selected = YES;
        
        // modify by manman start of line
//        if (_firstLoadImage) {
//            _firstLoadImage = NO;
//            [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.detail] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (image) {
//                    CGFloat imageHeight = self.view.width/image.size.width * image.size.height;
//                    self.detailImageView.height = imageHeight;
//                    self.detailScrollView.contentSize = CGSizeMake(0, imageHeight);
//                }
//                
//            }];
//        }
        
        // end of line
    }
    //红色线条的指示表示的变化
    [UIView animateWithDuration:0.5 animations:^{
        if ((int)(point.x/self.view.width) == 0) {
            _redAnimationView.left = 0;
        } else {
            _redAnimationView.left = 168*SizeScale;
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    QDLog(@" into scrollViewDidScroll ... ");
    if (scrollView == self.tableView) {
        
        //NSLog(@"%f",scrollView.contentOffset.y);
        //NSLog(@"---%f",self.tableView.contentSize.height - self.tableView.height );
        NSInteger height = scrollView.contentOffset.y;
        
        if (height >= self.tableView.contentSize.height - self.tableView.height + 80) {
            
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                self.verticalScrollView.contentOffset = CGPointMake(0, self.view.height );
            } completion:^(BOOL finished) {
                
                //结束加载
                //[self.tableView.mj_footer endRefreshing];
            }];
        }
        
    }
    
    // modify by manman on 2016-09-28 start of line
    // 现在 本页标题不再变化
//    if (scrollView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.height + 80) {
//        self.navigationItem.titleView = self.goodDetailLabel;
//    } else {
//        self.navigationItem.titleView = self.titleView;
//    }
    
    // end of line
    
}
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //活动
    if (section == 0) {
        return _activityArrayM.count;
    }
    //商店
    if (section == 1) {
        if (_payType == 1) {
            return 0;
        }
        return _shopArrayM.count;
    }
    //颜色
    if (section == 2) {
        return 1;
    }
    //评论
    if (_commentArrayM.count == 0) {
        return 0;
    }
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GoodsActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsActivityTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clickDetailBlock = ^(NSInteger page) {
            [self clickActivityRuleViewControllerWtihPage:page];
        };
        if (_activityArrayM.count >= indexPath.row) {
            cell.activityModel = _activityArrayM[indexPath.row];
        }
        if (_activityPage == indexPath.row) {
            cell.isSelect = YES;
        }else {
            cell.isSelect = NO;
        }
        cell.delegate = self;
        cell.page = indexPath.row;
        return cell;
    }
    else if (indexPath.section == 1) {
        
        // modify by manman on 2016-10-26 // BUG 302  start of line 
        GoodStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodStoreTableViewCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_shopArrayM.count >= indexPath.row && _shopArrayM.count) {
            
            cell.activityId = _selectActivityModel.id;
            cell.model = _shopArrayM[indexPath.row];
//            if (_shopPage == 2147483647) {
//                if (_selectActivityModel.id == cell.model.taskId) {
//                    _shopPage = indexPath.row;
//                    cell.isSelect = YES;
//                    NSLog(@"0  index row %ld   shopPage %ld",indexPath.row,_shopPage);
////                    if (_shopPage == indexPath.row) {
////                       
////                    }else {
////                        cell.isSelect = NO;
////                    }
//                    
//                }
//            }else
//            {
//                if (_shopPage == indexPath.row) {
//                    cell.isSelect = YES;
//                    NSLog(@"index row %ld   shopPage %ld",indexPath.row,_shopPage);
//                }else {
//                    cell.isSelect = NO;
//                }
//            }
            
            if (_shopPage == indexPath.row) {
                cell.isSelect = YES;
                NSLog(@"index row %ld   shopPage %ld",indexPath.row,_shopPage);
            }else {
                cell.isSelect = NO;
            }
            
        }
        
        
        
        
        cell.delegate = self;
        cell.page = indexPath.row;
        return cell;
        
       
        // 替换上面 修改302 BUG
//        GoodStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodStoreTableViewCell];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        if (_shopArrayM.count >= indexPath.row && _shopArrayM.count) {
//            cell.model = _shopArrayM[indexPath.row];
//        }
//        if (_shopPage == indexPath.row) {
//            cell.isSelect = YES;
//        }else {
//            cell.isSelect = NO;
//        }
//        cell.delegate = self;
//        cell.page = indexPath.row;
//        return cell;
        
        
        // end of line
    }
    else if (indexPath.section == 2) {
        SelectColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectColorTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        //原来的颜色显示
//        //车应该有的颜色
//        if (_colorArrayM.count) {
//           [cell setupSelectColorViewWithArray:_colorArrayM];
//        }
//        //店铺的颜色
//        if (_selectColorArrayM.count) {
//            _colorStr = @"";
//            [cell compareColorArray:_selectColorArrayM totalArray:_colorArrayM];
//        }
//        //活动的颜色
//        if (_activityColorArrayM.count) {
//            _colorStr = @"";
//            [cell compareColorArray:_activityColorArrayM totalArray:_colorArrayM];
//        }
        
        // modify by manman 2016-09-12 start of line
        
        //车应该有的颜色
        if (_colorArrayM.count) {
            
            [cell setupSelectColorViewWithArray:_colorArrayM];
        }
          
        //店铺的颜色
        if (_selectColorArrayM.count) {
            if (_colorStr.length>0) cell.selectedColour = _colorStr;
            [cell compareColorArray:_selectColorArrayM totalArray:_colorArrayM];
        }
        //活动的颜色
        if (_activityColorArrayM.count) {
         if (_colorStr.length>0) cell.selectedColour = _colorStr;
            [cell compareColorArray:_activityColorArrayM totalArray:_colorArrayM];
            
            
        }
        
        
        // end of line
        
        
        
        
        
        return cell;
    }
    //评论
    if (indexPath.row == 0) {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentTableViewCell];
        cell.model = _commentArrayM[0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
        cell.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake720(239, 18, 242, 33)];
        imageView.image = [UIImage imageNamed:@"comment_click_more_image"];
        [cell addSubview:imageView];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //活动
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 192*SizeScaleSubjectTo720;
    }
    //颜色
    if (indexPath.section == 2) {
        CGFloat height = (174 + 110*( (_colorArrayM.count - 1)/3 ) )*SizeScale;
        if (_colorArrayM.count == 0) {
            height = 0;
        }
        return height;
    }
    //评论
    if (indexPath.section == 3) {
        if (indexPath.row == 1) {
            return 70*SizeScaleSubjectTo720;
        }
        CommentUtil *util = [[CommentUtil alloc]init];
        util.model = _commentArrayM[0];
        return util.cellHeight;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    //提车店铺 如果paytype = 1 则隐藏
    if (section == 1 && _payType == 1) {
        return 0;
    }
    
    if (section == 3 ) {
        if ( _commentArrayM.count == 0) {
            return 0;
        }
        return 88*SizeScale;
    }

    return 108*SizeScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 108)];
    grayView.backgroundColor = kColorFor1c;
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake720(0, 20, 720, 88)];
    blackView.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    [grayView addSubview:blackView];
    UILabel *leftLabel = [UILabel qd_labelWithFrame:CGRectMake720(24, 20, 120, 88) title:@"" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:28];
    [grayView addSubview:leftLabel];
    
    UILabel *scaleLabel = [UILabel qd_labelWithFrame:CGRectMake720(396, 20, 290, 88) title:@"" titleColor:UIColorFromRGB_16(0x35a4da) textAlignment:NSTextAlignmentRight font:22];
    scaleLabel.hidden = YES;
    [grayView addSubview:scaleLabel];
    switch (section) {
        case 1:
            leftLabel.text = @"提车店铺";
            break;
        case 2:
            leftLabel.text = @"颜色分类";
            
            break;
        case 3:
            leftLabel.text = [NSString stringWithFormat:@"评价(%@)",_commentCount];
            scaleLabel.hidden = NO;
            scaleLabel.text = [NSString stringWithFormat:@"好评率%@",_goodRate];
            break;
        default:
            break;
    }
    
    return grayView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 1) {
        //NSLog(@"点击了评价");
        GoodCommentsViewController *vc = [[GoodCommentsViewController alloc]init];
        vc.isBackBtnShow = YES;
        vc.commentArray = _commentArrayM.copy;
        vc.totalComment = _commentCount;
        vc.goodRate = _goodRate;
        vc.bikeUrl = self.goodsModel.image;
        vc.modelId = self.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- lazy load
- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _rootScrollView.contentSize = CGSizeMake(HCDW, 0);
        _rootScrollView.pagingEnabled = YES;
        // add by manman  DEBUG start of line
        //_rootScrollView.backgroundColor = [UIColor greenColor];// debug
        // end of line
        _rootScrollView.delegate = self;
    }
    return _rootScrollView;
}
- (UIScrollView *)verticalScrollView {
    if (!_verticalScrollView) {
        _verticalScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _verticalScrollView.contentSize = CGSizeMake(0, HCDH * 2);
        _verticalScrollView.pagingEnabled = YES;
        _verticalScrollView.backgroundColor = [UIColor blackColor];
        _verticalScrollView.delegate = self;
    }
    return _verticalScrollView;
}

/**
 *  右侧商品详情
 *
 *  @return
 */

- (UIScrollView *)detailScrollView {
    if (!_detailScrollView) {
        _detailScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _detailScrollView.left = HCDW;
        // add by manman  DEBUG start of line
       // _verticalScrollView.backgroundColor = [UIColor yellowColor];// debug
        // end of line
        _detailScrollView.contentSize = CGSizeMake(0, HCDH);
        _detailScrollView.alwaysBounceHorizontal = NO;
        //_detailScrollView.backgroundColor = [UIColor redColor];
        //_detailScrollView.height -= 190*SizeScale ;
        _detailScrollView.height -= kNavigationViewHeight ;
    }
    return _detailScrollView;
}
/**
 *  底部 商品详情
 *
 *  @return 
 */
- (UIScrollView *)detailScrollView1 {
    if (!_detailScrollView1) {
        _detailScrollView1 = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        //_detailScrollView1.backgroundColor = [UIColor blueColor];
        // add by manman  DEBUG start of line
        //_detailScrollView1.backgroundColor = [UIColor blueColor];// debug
        // end of line
        _detailScrollView1.top = HCDH;
        _detailScrollView1.contentSize = CGSizeMake(0, HCDH);
         _detailScrollView1.alwaysBounceHorizontal = NO;
        _detailScrollView1.alwaysBounceVertical = YES;
        _detailScrollView1.height -= 190*SizeScale;
        
    }
    return _detailScrollView1;
}
- (UIImageView *)detailImageView {
    if (!_detailImageView) {
        _detailImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    }
    return _detailImageView;
}
- (UIImageView *)detailImageView1 {
    if (!_detailImageView1) {
        _detailImageView1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    }
    return _detailImageView1;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.height = self.view.height - 64 - 120*SizeScaleSubjectTo720;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.rowHeight = 140*SizeScaleSubjectTo720;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 50, 170, 39) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:40];
    }
    return _priceLabel;
}
- (UILabel *)originalPrice {
    if (!_originalPrice) {
        _originalPrice = [UILabel qd_labelWithFrame:CGRectMake720(215, 60, 170, 24) title:@"0" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    }
    return _originalPrice;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 116, 600, 28) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _detailLabel;
}
- (UIImage *)shareImage {
    if (!_shareImage) {
        //_shareImage = [self.tableView screenshot];
        // modify by manman BUG218 将店铺图片作处理 然后添加到分享页面 start of line
         UIImageView *shareCodeView = [[UIImageView alloc]initWithFrame:CGRectMake720(-740, 0, 720, 160)];
        shareCodeView.image = [UIImage imageNamed:@"share_code_image"];
        UIImage *QRCodeImage = [UIImage imageFromView:shareCodeView];
        // end of line
        _shareImage = [UIImage addImage:[self.tableView screenshot] toImage:QRCodeImage];// 修改分享图片 下面的店铺信息的图片
    }
    
    return _shareImage;
}
//nav
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake720(0, 0, 255, 88)];
        _titleView.backgroundColor = [UIColor blackColor];
        
        _goodsBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 0, 88, 88) title:@"商品" titleColor:kColorForfff titleFont:30 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            [self clickNavigationGoodsBtn];
        }];
        [_goodsBtn setTitleColor:kColorForE60012 forState:UIControlStateSelected];
        _goodsBtn.selected = YES;
        [_titleView addSubview:_goodsBtn];
        
        _detailBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(168, 0, 88, 88) title:@"详情" titleColor:kColorForfff titleFont:30 backgroundColor:[UIColor blackColor] tapAction:^(UIButton *button) {
            [self clickNavigationDetailBtn];
        }];
        [_detailBtn setTitleColor:kColorForE60012 forState:UIControlStateSelected];
        [_titleView addSubview:_detailBtn];
        
        _redAnimationView = [[UIView alloc]initWithFrame:CGRectMake720(0, 84, 88, 4)];
        _redAnimationView.backgroundColor = kColorForE60012;
        [_titleView addSubview:_redAnimationView];
    }
    return _titleView;
}

- (UIView *)titleLabelView
{
    if (_titleLabelView) {
        _titleLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 88, 88)];
        _titleLabelView.text = @"商品";
        _titleLabelView.textColor = kColorForE60012;
    }
    
    return _titleLabelView;
    
}
- (QDAlphaWarnView *)alphaWarnView {
    if (!_alphaWarnView) {
        _alphaWarnView = [[QDAlphaWarnView alloc]initWithFrame:self.view.bounds];
    }
    return _alphaWarnView;
}

- (UILabel *)goodDetailLabel {
    if (!_goodDetailLabel) {
        _goodDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake720(0,0,300,54)];
        _goodDetailLabel.text = @"商品详情";
        _goodDetailLabel.textColor = [UIColor whiteColor];
        _goodDetailLabel.font = [UIFont boldSystemFontOfSize:36*SizeScale];
        _goodDetailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodDetailLabel;
}


- (UILabel *)alertViewLabel
{
    if (!_alertViewLabel) {
        _alertViewLabel = [[UILabel alloc]initWithFrame:CGRectMake720((self.view.frame.size.width - 300)/2,self.view.frame.size.height/2, 300, 50)];
        _alertViewLabel.centerX = self.view.centerX;
        _alertViewLabel.centerY = self.view.centerY;
        _alertViewLabel.layer.cornerRadius = 3;
        _alertViewLabel.text = @"请选择颜色";
        _alertViewLabel.layer.masksToBounds = YES;
        _alertViewLabel.textColor = [UIColor whiteColor];
        _alertViewLabel.backgroundColor = [UIColor blackColor];
        _alertViewLabel.font = [UIFont boldSystemFontOfSize:36*SizeScale];
        _alertViewLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
   self.customTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(alertViewLabelDismiss) userInfo:nil repeats:NO];
    
    return _alertViewLabel;
    
    
}

//
- (void)timeInvalidate
{
    
    if (_customTimer.isValid) {
        [_customTimer invalidate];
    }
    _customTimer = nil;
}


- (void)setAlertViewLabelTitle:(NSString *)titileStr
{
    self.alertViewLabel.text = titileStr;
    
}



- (void)alertViewLabelDismiss
{
    
    [self.alertViewLabel removeFromSuperview];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
