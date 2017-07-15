//
//  GoodsDetailViewController.m
//  QiDai
//
//  Created by manman on 16/11/28.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "UpdateGoodsDetailViewController.h"
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
#import "BillConfirmViewController.h"
#import "ShopUpdateGoodsDetailCommentTableViewCell.h"
#import "ShopUpdateGoodsDetailActivityTableViewCell.h"
#import "ChoiceBikeColorView.h"

@interface UpdateGoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,SelectColorTableViewCellDelegate,GoodsActivityTableViewCellDelegate,GoodStoreTableViewCellDelegate,SelectColorTableViewCellDelegate,UMSocialUIDelegate>
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


/**
 *  评论信息 评论总数  好评总数
 */
@property (nonatomic,strong) NSString *commentTotalNumUpdateStr;

@property (nonatomic,strong) NSString *commentPerfectNumUpdateStr;


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

/** 活动内容 显示*/
@property (nonatomic,strong) UILabel *activityTitleFlagLabel;

/** 车辆重点描述*/
@property (nonatomic,strong) UILabel *detailRedLabel;

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



@property (nonatomic,strong) ChoiceBikeColorView *choiceBikeColorView;

/**
 *  计时器
 */
@property (nonatomic,strong) NSTimer *stopwatchTime;


@property (nonatomic,strong) NSMutableArray *stopwatchTimeDatasourcesMArr;


@end

@implementation UpdateGoodsDetailViewController

static NSString *const kShopUpdateGoodsDetailActivityTableViewCell = @"ShopUpdateGoodsDetailActivityTableViewCell";
static NSString *const kShopUpdateGoodsDetailCommentTableViewCell = @"ShopUpdateGoodsDetailCommentTableViewCell";

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
    
//    self.detailScrollView1.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//            self.verticalScrollView.contentOffset = CGPointMake(0, 0);
//        } completion:^(BOOL finished) {
//            self.navigationItem.titleView = self.titleView;
//            //结束加载
//            [self.detailScrollView1.mj_header endRefreshing];
//        }];
//    }];
    //
    UILabel *label = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 720, 90) title:@"继续上拉,查看详情" titleColor:kColorFor666 textAlignment:NSTextAlignmentCenter font:24];
    label.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = label;
    
    //建立轮播图
    [self setupCycleScrollView];
    //固定的bottom
    [self setupBottomView];
    //nav
    [self setupNavigationView];
    
    //注册cell
    [self.tableView registerClass:[ShopUpdateGoodsDetailActivityTableViewCell class] forCellReuseIdentifier:kShopUpdateGoodsDetailActivityTableViewCell];
//    [self.tableView registerClass:[GoodStoreTableViewCell class] forCellReuseIdentifier:kGoodStoreTableViewCell];
//    [self.tableView registerClass:[SelectColorTableViewCell class] forCellReuseIdentifier:kSelectColorTableViewCell];
    [self.tableView registerClass:[ShopUpdateGoodsDetailCommentTableViewCell class] forCellReuseIdentifier:kShopUpdateGoodsDetailCommentTableViewCell];

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




- (void)createTimer {
    

    self.stopwatchTime = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.stopwatchTime forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    
//    for (int count = 0; count < _stopwatchTimeDatasourcesMArr.count; count++) {
////        
////        TimeModel *model = _m_dataArray[count];
////        [model countDown];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOODSDETAIL_TIME_CELL object:nil];
}

/*
    清除过期的数据
 
**/
-(void)clearTheExpireData
{
    _colorStr = @"";//记录选中的颜色
    _shopPage = 2147483647;
    _activityPage = 0;
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
    
    self.navigationItem.title = @"商品详情";
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;

    //self.navigationItem.titleView = self.titleView;
   
    // end of line
   // [self creatShareBtn];
    
    //self.navigationController.navigationItem.titleView =self.titleView;
    
}

/** 轮播图*/
- (void)setupCycleScrollView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 890)];
    headerView.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    //[self.view addSubview:headerView];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake720(0, 0, 720, 606) delegate:self placeholderImage:[UIImage imageNamed:@"goods_detail_default_image"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    self.cycleScrollView.autoScrollTimeInterval = 4.0;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [headerView addSubview:self.cycleScrollView];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake720(0, 606, 720, 294)];
    [headerView addSubview:detailView];
    [detailView addSubview:self.priceLabel];
    [detailView addSubview:self.originalPrice];
    [detailView addSubview:self.detailRedLabel];
    [detailView addSubview:self.detailLabel];
    [detailView addSubview:self.activityTitleFlagLabel];
    
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
        
         [self clickOrderConfirmation];
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
        NSLog(@"商品详情---%@",responseObject);
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
        
      
        [self stopwatchTimeDatasource];
        
        
        // add by manman 2016-10-26 BUG 302
        // 店铺信息
        // 自行车可以无活动 
        if (activityArray.count >0) {
             _selectActivityModel = [_activityArrayM[0] copy];
        }
       
        if (_shopArrayM.count>0) {
            [_shopArrayM removeAllObjects];
            
        }
        [_shopArrayM addObjectsFromArray:[ShopAddressModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] valueForKey:@"defaultShop"]]];
        
        // end of line
        
        //刷新header的数据
        self.priceLabel.text = self.goodsModel.price;
        if (_activityArrayM.count) {
            ActivityModel *activityModel = _activityArrayM[0];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.goodsModel.price floatValue] - [activityModel.refund floatValue] ];
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
        
        
        
        NSString *originalPrice = [NSString stringWithFormat:@"￥%.2f",self.goodsModel.price.floatValue];
        self.originalPrice.attributedText = [NSString addHorizontalLineWithString:originalPrice color:kColorForccc];
        
        self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.goodsModel.brand,self.goodsModel.series,self.goodsModel.model,self.goodsModel.title];
        self.detailRedLabel.text = self.goodsModel.title;
        
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
        NSLog(@"comment ---%@",responseObject);
        NSArray *commentArray = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (commentArray.count == 0) {
            return ;
        }
        [_commentArrayM addObjectsFromArray:commentArray];
        
        
        /**
         *  totalComment":2,
         "code":"00",
         "data":Array[1],
         "message":"请求成功",
         "open":"1",
         "goodComment":1
         */
        self.commentTotalNumUpdateStr = [responseObject objectForKey:@"totalComment"];
        self.commentPerfectNumUpdateStr = [responseObject objectForKey:@"goodComment"];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        NSLog(@"error %@",error.localizedDescription);
    }];
}
/** 检查订单*/
//- (void)getCheckOrder {
//    
//}




- (void)stopwatchTimeDatasource
{
    [self createTimer];
}


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
//    if (_activityArrayM.count>0)
//    {
//        [self verifyActivitiesConflict];
//    }
    
  
#warning 在本页面检测帐号活动于购买的车辆活动是否冲突 本次上线 不上 记得修改

    
    [self choiceBikeColor];
    
   
}


- (void)choiceBikeColor
{
    
    ActivityModel *tmpActivityModel = _activityArrayM[_activityPage];
    //添加 活动颜色
    self.choiceBikeColorView.activityColorSetStr = tmpActivityModel.color;
    // 图片数组
    self.choiceBikeColorView.bikeImageViewStr = self.goodsModel.share_image;
    // 价格
    self.choiceBikeColorView.bikePriceStr = self.goodsModel.price;
    // 商品颜色
    self.choiceBikeColorView.colorSetStr = self.goodsModel.color;
    
    
    [kGetKeyWindow addSubview:self.choiceBikeColorView];
    
    
    
    
    
    
}

- (void)ConfirmBuy:(NSDictionary *)parameter
{
    NSString *selectedColorStr = [parameter objectForKey:@"color"];
    
    NSLog(@"点击 确认购买  ");
    [self.choiceBikeColorView removeFromSuperview];
    [self pushTheNextView:parameter];
    
}


- (void)pushTheNextView:(NSDictionary *) parameter
{

    BillConfirmViewController *vc = [[BillConfirmViewController alloc]init];
    vc.billConfirmGoodsModel = self.goodsModel;
    vc.selectedBikeImageViewUrlStr = [parameter objectForKey:@"bikeImageViewUrl"];
    vc.shopAddressMArr = [_shopArrayM copy];
    vc.billConfirmActivityModel = _activityArrayM[_activityPage];
    vc.colorStr = [parameter objectForKey:@"color"];
    vc.isBackBtnShow = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    OrderConfirmationViewController *vc = [[OrderConfirmationViewController alloc]init];
//    vc.isBackBtnShow = YES;
//    vc.goodModel = self.goodsModel;
//    vc.colorStr = _colorStr;
//    vc.colorPage = _colorPage;
//    if (_activityArrayM.count >= _activityPage && _activityArrayM.count != 0) {
//        vc.activityModel = _activityArrayM[_activityPage];
//    }
//    if (_shopArrayM.count >= _shopPage && _shopArrayM.count != 0) {
//        vc.shopModel = _shopArrayM[_shopPage];
//    } else {
//        vc.shopModel = _defaultShopModel;
//        
//    }
//    [self.navigationController pushViewController:vc animated:YES];
//    
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
                [self pushTheNextView:nil];
                
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
                [self pushTheNextView:nil];
                
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
                [self pushTheNextView:nil];
                
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

- (void)selectedActivityDetailAction:(NSDictionary *) parameter{
    
   
    NSLog(@"选中 查看 活动 详情 ...");
    NSString *taskDetailId = [parameter objectForKey:@"taskDetailId"];
    
    
    ActivityRulesViewController *vc = [[ActivityRulesViewController alloc]init];

    vc.activityId = taskDetailId;
    vc.isBackBtnShow = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (void)selectedActivityAction:(NSDictionary *) parameter
{
    NSLog(@"选中  活动");
    NSString *indexRow = [parameter objectForKey:@"indexRow"];
    _activityPage = indexRow.integerValue;
    ActivityModel *tmpActivityModel = _activityArrayM[_activityPage];
     self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.goodsModel.price floatValue] - [tmpActivityModel.refund floatValue] ];
    
    [self.tableView reloadData];
    
    
    
    
}


- (void)CommentForAllButtonAction:(NSDictionary *) parameter
{
    NSLog(@"查看 全部 评论 ");
    
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


#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //活动
    
    if (_activityArrayM.count >0) {
        if (section == 0) {
            return _activityArrayM.count;
        }
        
    }
    if (_commentArrayM.count >0) {
        if (section == 1) {
            return 1;
        }
    }

    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
        cell.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    }
    
    
    
    if (indexPath.section == 0)
    {
        if(_activityArrayM.count >0)
        {
            ShopUpdateGoodsDetailActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopUpdateGoodsDetailActivityTableViewCell];
            cell.indexRow = [[NSString alloc]initWithFormat:@"%ld",indexPath.row];
            @weakify_self
            cell.activityDetailSelectedAction = ^(NSDictionary *parameter){
                @strongify_self
                [self selectedActivityDetailAction:parameter];
            };
            cell.activitySelectedAction = ^(NSDictionary *parameter){
                @strongify_self
                [self selectedActivityAction:parameter];
            };
            cell.activityUpdateModel = _activityArrayM[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_activityPage == indexPath.row) {
                cell.selectedIsSuccess = YES;
            }else
            {
                cell.selectedIsSuccess = NO;
                
            }

            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (_commentArrayM.count >0 ) {
            // modify by manman on 2016-10-26 // BUG 302  start of line
            ShopUpdateGoodsDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopUpdateGoodsDetailCommentTableViewCell];
            cell.commentPerfectNumUpdateStr = [NSString stringWithFormat:@"%@",self.commentPerfectNumUpdateStr];
            cell.commentTotalNumUpdateStr = [NSString stringWithFormat:@"%@",self.commentTotalNumUpdateStr];
            cell.commentUpdateModel = _commentArrayM[indexPath.row];
            @weakify_self
            cell.commentForAllButtonAction = ^(NSDictionary *parameter)
            {
                @strongify_self
                [self CommentForAllButtonAction:parameter];
                
            };
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
      
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //活动
    if (indexPath.section == 0) {
        return 190*SizeScaleSubjectTo750;
    }
    if (indexPath.section == 1) {
        return 470*SizeScaleSubjectTo750;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
  
}


///**
// *  倒计时方法
// */
//
//- (void)startTimer
//{
//    self.stopwatchTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
//    
//    //如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
//    [[NSRunLoop currentRunLoop] addTimer:self.stopwatchTime forMode:UITrackingRunLoopMode];
//    
//}


//- (void)refreshLessTime
//{
////    NSUInteger time;
////    for (int i = 0; i < totalLastTime.count; i++) {
////        time = [[[totalLastTime objectAtIndex:i] objectForKey:@"lastTime"] integerValue];
////        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:[[[totalLastTime objectAtIndex:i] objectForKey:@"indexPath"] integerValue]];
////        ShopUpdateGoodsDetailActivityTableViewCell *cell = (ShopUpdateGoodsDetailActivityTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
////        cell.remainingTimeLabel.text = [NSString stringWithFormat:@"剩余支付时间：%@",[self lessSecondToDay:--time]];
////        NSDictionary *dic = @{@"indexPath": [NSString stringWithFormat:@"%i",indexPath.section],@"lastTime": [NSString stringWithFormat:@"%i",time]};
////        [totalLastTime replaceObjectAtIndex:i withObject:dic];
////    }
//}






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
        //_tableView.rowHeight = 140*SizeScaleSubjectTo720;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel qd_labelWithFrame:CGRectMake720(20,40,710,31) title:@"Tern 燕鸥折叠自行车" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _detailLabel;
}


- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 150,216, 30) title:@"¥888" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:40];
    }
    return _priceLabel;
}
- (UILabel *)originalPrice {
    if (!_originalPrice) {
        _originalPrice = [UILabel qd_labelWithFrame:CGRectMake720(256,150,216,30) title:@"999" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    }
    return _originalPrice;
}


- (UILabel *)detailRedLabel {
    if (!_detailRedLabel) {
        _detailRedLabel = [UILabel qd_labelWithFrame:CGRectMake720(20,91, 710, 31) title:@"专为中国人制造" titleColor:[UIColor redColor] textAlignment:NSTextAlignmentLeft font:24];
    }
    return _detailRedLabel;
}
- (UILabel *)activityTitleFlagLabel {
    if (!_activityTitleFlagLabel) {
        _activityTitleFlagLabel = [UILabel qd_labelWithFrame:CGRectMake720(20,260, 170, 24) title:@"活动内容" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    }
    return _activityTitleFlagLabel;
}

//activityTitleFlagLabel



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
    
    /**
     *  定时器 未被销毁   以后需要更改 优化
     */
    [_stopwatchTime invalidate];
    _stopwatchTime = nil;
}


- (void)setAlertViewLabelTitle:(NSString *)titileStr
{
    self.alertViewLabel.text = titileStr;
    
}



- (void)alertViewLabelDismiss
{
    
    [self.alertViewLabel removeFromSuperview];
    
    
}


- (ChoiceBikeColorView *)choiceBikeColorView
{
    if (!_choiceBikeColorView) {
        _choiceBikeColorView = [[ChoiceBikeColorView alloc]initWithFrame:kGetKeyWindow.frame];
        @weakify_self
        _choiceBikeColorView.okayAction = ^(NSDictionary *parameter)
        {
           @strongify_self
            
            [self ConfirmBuy:parameter];
            
            
        };
    }
    return _choiceBikeColorView;
  
}



- (NSMutableArray *)stopwatchTimeDatasourcesMArr
{
    if (!_stopwatchTimeDatasourcesMArr) {
        _stopwatchTimeDatasourcesMArr = [[NSMutableArray alloc]initWithCapacity:5];
        
    }
    return _stopwatchTimeDatasourcesMArr;
    
    
    
}

- (void)dealloc
{
    NSLog(@"dealloc ...");
     [_stopwatchTime setFireDate:[NSDate distantFuture]];
    //[_stopwatchTime invalidate];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
