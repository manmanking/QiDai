//
//  PublishCommentViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PublishCommentViewController.h"
#import "CWStarRateView.h"
#import "UIImageView+WebCache.h"
#import "QDTextView.h"
#import "QDLineView.h"
#import "UploadImageManager.h"
#import "UserInfoDBManager.h"
#import "UserInfoModel.h"
#import "MyOrderModel.h"
#import "UIScrollView+UITouch.h"
@interface PublishCommentViewController ()<CWStarRateViewDelegate,UITextViewDelegate>
{
    /** 是否匿名*/
    BOOL _isShow;
}

@property (nonatomic,strong) UIScrollView *scrollView;

/** 星星星*/
@property (strong, nonatomic) CWStarRateView *starRateView;

/** 活动：一个奖章的logo,商品：车的图片*/
@property (nonatomic,strong) UIImageView *bikeImageView;

@property (nonatomic,strong) UILabel *bikeLabel;

@property (nonatomic,strong) QDTextView *commentTextVIew;
/** 字数*/
@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation PublishCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShow = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupNavigationView];
    [self setupUI];
    
    /**
     *  依次设置
     */
    self.LQPhotoPicker_superView = _scrollView;
    
    self.LQPhotoPicker_imgMaxCount = 5;
    
    [self LQPhotoPicker_initPickerView];
    
    [self LQPhotoPicker_updatePickerViewFrameY:697*SizeScale];
    
    QDLineView *lineView1 = [[QDLineView alloc]initWithFrame:CGRectMake720(34, 695+306, 652, 2)];
    [self.scrollView addSubview:lineView1];
    // Do any additional setup after loading the view.
}
- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    if (self.isActivity) {
        [self setupTitleViewWithTitle:@"活动评价"];
        self.bikeImageView.image = [UIImage imageNamed:@"order_medal_image"];
        self.bikeLabel.text = self.myOrderModel.information;
    } else {
        [self setupTitleViewWithTitle:@"商品评价"];
        self.bikeImageView.left = 24*SizeScale;
        self.bikeImageView.width = 220*SizeScale;
        [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:self.bikeImageUrl]];
        self.bikeLabel.text = self.bikeInfo;
    }
    [self.scrollView addSubview:self.bikeImageView];
    
    
    [self.scrollView addSubview:self.bikeLabel];
    UILabel *starLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 276, 100, 40) title:@"评分" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    [self.scrollView addSubview:starLabel];
    [self.scrollView addSubview:self.starRateView];
    UILabel *commentTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 404, 100, 40) title:@"评价" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:26];
    [self.scrollView addSubview:commentTextLabel];
    [self.scrollView addSubview:self.commentTextVIew];
    
    QDLineView *lineView = [[QDLineView alloc]initWithFrame:CGRectMake720(34, 695, 652, 2)];
    [self.scrollView addSubview:lineView];

    //匿名评价
    UIButton *showNameBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(34,1004 + 56, 36, 36) NormalImageString:@"comment_show_select_btn" tapAction:^(UIButton *button) {
        button.selected = !_isShow;
        _isShow = button.selected;
    }];
    [showNameBtn setEnlargeEdge:10];
    [showNameBtn setImage:[UIImage imageNamed:@"comment_show_common_btn"] forState:UIControlStateSelected];
    [self.scrollView addSubview:showNameBtn];
    UILabel *showNameLabel = [UILabel qd_labelWithFrame:CGRectMake720(92, 1004 + 56, 200, 36) title:@"匿名评价" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:28];
    [self.scrollView addSubview:showNameLabel];
    
}
- (void)setupTitleViewWithTitle:(NSString *)str {
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake720(0,0,300,54)];
    textLabel.text = str;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:36*SizeScale];
    textLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = textLabel;
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB_10(22, 25, 33);
}
- (void)setupNavigationView {
    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 0, 60, 60) NormalBackgroundImageString:@"" tapAction:^(UIButton *button) {
        [self clickBackBtn];
    }];
    [backBtn setEnlargeEdge:20*SizeScaleSubjectTo720];
    [backBtn setImage:[UIImage imageNamed:@"reset_back_image"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *btn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 0, 100, 60) title:@"提交" titleColor:kColorForE60012 titleFont:30 backgroundColor:nil tapAction:^(UIButton *button) {
        button.enabled = NO;
        [self saveComment];
    }];
    [btn setTitleColor:kColorForccc forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)saveComment {
    if (![self.commentTextVIew.text isExist]) {
        [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"请输入评价"];
    }
    
    UserInfoModel *userInfoModel = [UserInfoDBManager getUserInfoWithUserId:kUserId];
    NSMutableString *nickName = userInfoModel.nickName.mutableCopy;
    if (_isShow) {
        //匿名操作
        if (nickName.length <= 1) {
            nickName = [NSString stringWithFormat:@"%@***-",nickName].mutableCopy;
        } else {
            NSRange rang = NSMakeRange(1, nickName.length - 2);
            [nickName replaceCharactersInRange:rang withString:@"***"];
        }
    }
    //type:1为活动评价，2为商品评价    modelId为商品评价为商品id，活动为活动id
    NSString *typeStr = @"1";
    NSString *modelID = @"";
    if (!self.isActivity) {
        typeStr = @"2";
        modelID = self.myOrderModel.modelId;
    } else {
        modelID = self.myOrderModel.activity_id;
    }
    
//#warning ------
    NSMutableDictionary *param = @{@"userinfoId":kUserId,
                                 @"userName":nickName,
                                 @"common":self.commentTextVIew.text,
                                 @"color":self.myOrderModel.color,
                                 @"level":[NSString stringWithFormat:@"%.0f",self.starRateView.scorePercent*5],
                                 @"type":typeStr,
                                 @"modelId":modelID,
                                 @"orderId":self.myOrderModel.orderId}.mutableCopy;
    //@"image":newUrl,
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    //小图数据
    NSMutableArray *smallImageDataArray = [self LQPhotoPicker_smallImageArray];
    
    if (smallImageDataArray.count == 0) {
        [param setValue:@"" forKey:@"image"];
        [self postCommentDataSourceWithParam:param];
        return;
    }
    
    [UploadImageManager uploadCommentImageWithArray:smallImageDataArray compate:^(BOOL isSuccess, NSString *errStr, NSString *newUrl) {
        
        if (isSuccess) {
            [param setValue:newUrl forKey:@"image"];
        }
        [self postCommentDataSourceWithParam:param];
        
    }];
    
}
- (void)postCommentDataSourceWithParam:(NSDictionary *)param {

    //kUrl_saveCommon  param
    [QDHttpTool getWithURL:kUrl_saveComment params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"提交评价成功"];
            self.refreshDataSourceBlock();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clickBackBtn];
            });
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
        }
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- private method
#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 5000) {
        textView.text = [textView.text substringToIndex:500];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/500", (unsigned long)textView.text.length];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark --- lazy laod
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    }
    return _scrollView;
}
- (UIImageView *)bikeImageView {
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(74, 56, 108, 140)];
    }
    return _bikeImageView;
}
- (CWStarRateView *)starRateView {
    if (!_starRateView) {
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake720(136, 276, 300, 40) numberOfStars:5];
        _starRateView.scorePercent = 1;
        _starRateView.allowIncompleteStar = NO;
        _starRateView.hasAnimation = YES;
        _starRateView.delegate = self;
    }
    return _starRateView;
}
- (UILabel *)bikeLabel {
    if (!_bikeLabel) {
        _bikeLabel = [UILabel qd_labelWithFrame:CGRectMake720(272, 100, 400, 36) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:30];
    }
    return _bikeLabel;
}
- (QDTextView *)commentTextVIew {
    if (!_commentTextVIew) {
        _commentTextVIew = [[QDTextView alloc]initWithFrame:CGRectMake720(136, 404, 526, 294)];
        _commentTextVIew.delegate = self;
        _commentTextVIew.backgroundColor = [UIColor blackColor];
        _commentTextVIew.textColor = kColorForfff;
        _commentTextVIew.myPlaceholderColor = kColorForccc;
        _commentTextVIew.font = UIFontOfSize720(24);
        _commentTextVIew.myPlaceholder = @"(请输入您对商品的评价,您的评论对于其他童鞋非常重要哦)";
        [_commentTextVIew addSubview:self.countLabel];
    }
    return _commentTextVIew;
}
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake720(390, 263, 120, 24)];
        _countLabel.font = UIFontOfSize720(24);
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.text = @"0/500";
        _countLabel.textColor = kColorForccc;
    }
    return _countLabel;
}


@end
