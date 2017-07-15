//
//  QDRootViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDRootViewController.h"
#import "LoginViewController.h"
@interface QDRootViewController ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation QDRootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[MBProgressHUDManager instance] hideHUD];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[[MBProgressHUDManager instance] hideHUD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.isBackBtnShow) {
        [self creatBackBtn];
    }
    // Do any additional setup after loading the view.
}
- (void)creatBackBtn {

    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 0, 40, 60) NormalBackgroundImageString:@"" tapAction:^(UIButton *button) {
        [self clickBackBtn];
    }];
    [backBtn setEnlargeEdge:10*SizeScale];
    [backBtn setImage:[UIImage imageNamed:@"reset_back_image"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)creatTitleViewWithString:(NSString *)str {
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake720(0,0,300,44)];
    textLabel.text = str;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:40*SizeScale750];
    textLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = textLabel;
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB_10(22, 25, 33);
    
}


/**
 *  是否隐藏视图标题
 *  无任务页面 有标题   有任务页面无标题
 *  @param isTrue
 */
- (void)showTheTitleView:(BOOL)isTrue
{
    self.navigationItem.titleView.hidden = isTrue;
    
    
}

- (void)creatShareBtn {
    UIButton *shareBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(670, 65, 31, 36) NormalImageString:@"task_share_btn" tapAction:^(UIButton *button) {
        [self clickShareBtn];
    }];
    [shareBtn setEnlargeEdge:10*SizeScale];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
}

- (void)creatRightBtnWithString:(NSString *)str {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake720(0,0,100,54)];
    if (str.length > 2) {
        [btn setFrame:CGRectMake720(0,0,150,54)];
    }
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:30*SizeScale];
    [btn setContentMode:UIViewContentModeRight];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)creatRightBtnWithString:(NSString *)str btnWidth:(NSInteger)width{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake720(0,0,width,54)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:30*SizeScale];
    [btn setContentMode:UIViewContentModeRight];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:kColorForfff forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)creatRightBtnWithImage:(NSString *)imageStr {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake720(0, 0, 40,50)];
    [btn setContentMode:UIViewContentModeLeft];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark --- click method
/** 点击导航栏右边按钮*/
- (void)clickRightBtn {
    NSLog(@"未重写导航条右边按钮点击方法 %s  %d",__FUNCTION__,__LINE__);
}
/** 点击导航栏左边按钮*/
- (void)clickLeftBtn {
    NSLog(@"未重写导航条左边边按钮点击方法 %s  %d",__FUNCTION__,__LINE__);
}
- (void)clickShareBtn {
    NSLog(@"未重写导航条分享按钮点击方法 %s %d",__FUNCTION__,__LINE__);
}
/** 点击导航栏返回按钮*/
- (void)clickBackBtn {
    //[self popoverPresentationController];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showLoginViewController {
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)showLoginViewControllerWithTransferMainWindows:(BOOL ) isMain {
    
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.isMain = isMain;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)creatOglFlipTransitionAnimation {
//    CATransition *animation = [CATransition animation];
//    //动画时间
//    animation.duration = 0.8;
//    //显示模式,缓慢开始和结束
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    //过渡效果
//    animation.type = @"oglFlip";
//    //过渡方向
//    animation.subtype = kCATransitionFromTop;
//     //添加动画
//    [self.view.window.layer addAnimation:animation forKey:nil];
}
- (void)creatRippleEffectTransitionAnimation {
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.8;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = @"rippleEffect";
//    animation.subtype = kCATransitionFromTop;
//    [self.view.window.layer addAnimation:animation forKey:nil];
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
