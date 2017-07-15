//
//  ResetViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ResetViewController.h"

#import "FirstResetView.h"
#import "SecondResetView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "RegisterManager.h"
#import "MBProgressHUDManager.h"
#import "NSString+Encryption.h"
@interface ResetViewController ()

@property (nonatomic,strong) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic,strong) FirstResetView *firstView;

@property (nonatomic,strong) SecondResetView *secondView;

@end

static const CGFloat kAnimationDuration = 0.5;

@implementation ResetViewController
#pragma mark --- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    [self setupNavigationView];
    
//    [self.scrollView addSubview:self.secondView];
//    self.secondView.left = 0;
    [self setupFirstView];
    // Do any additional setup after loading the view.
}

#pragma mark --- ui

- (void)setupNavigationView {
    
    UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(285, 87, 150, 40) title:@"重置密码" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self.scrollView addSubview:titleLabel];
    
    //上面的返回按钮
    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(20, 67, 60, 60) NormalBackgroundImageString:@"" tapAction:^(UIButton *button) {
        [self clickBackBtn];
    }];
    [backBtn setEnlargeEdge:20*SizeScaleSubjectTo720];
    [backBtn setImage:[UIImage imageNamed:@"reset_back_image"] forState:UIControlStateNormal];
    backBtn.centerY = titleLabel.centerY;
    [self.scrollView addSubview:backBtn];
}

- (void)setupFirstView {
    self.firstView = [[FirstResetView alloc]initWithFrame:CGRectMake720(0, 128, 720, 720)];
    [self.firstView.phoneTextField becomeFirstResponder];
    @weakify_self
    self.firstView.clickNextBtn = ^ {
        @strongify_self
        [self.scrollView addSubview:self.secondView];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.secondView.phone = self.firstView.phoneTextField.text;
            
            self.firstView.left = -720*SizeScaleSubjectTo720;
            self.secondView.left = 0;
        } completion:^(BOOL finished) {
            [self.firstView removeFromSuperview];
            [self clickGetCodeBtnWithTelephone:self.secondView.phone];
            [self.secondView timerCountDown];
        }];
    };
    [self.scrollView addSubview:self.firstView];
}

#pragma mark --- private method
- (void)clickBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickGetCodeBtnWithTelephone:(NSString *)telephone {
    [[MBProgressHUDManager instance] showHUDLoadingView:self.view];
    [RegisterManager sendCodeWithTelephone:telephone withAccType:AccType_EmailRegister success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"发送成功");
        [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
    }];
}
- (void)clickSureBtnWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code {
    
    if (![password judgePassWordLegal]) {
        [[MBProgressHUDManager instance] showTextOnlyWithView:self.view withText:@"请输入6位字母和数组组合的密码"];
        return;
    }
    
    NSDictionary *parame = @{@"phoneNo":phone,
                             @"password":[password md5DHexDigestString_Ext],
                             @"confirmPassword":[password md5DHexDigestString_Ext],
                             @"authCode":code};
    [QDHttpTool getWithURL:kUrl_resetPassword params:parame success:^(BOOL isSuccess, NSDictionary *responseObject) {
        
        if (isSuccess) {
            [[MBProgressHUDManager instance]showHUDWithView:self.view string:@"修改密码成功" andDisappearIn:1];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [[MBProgressHUDManager instance]showHUDWithView:self.view string:responseObject[@"message"] andDisappearIn:1];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark --- lazy load
- (SecondResetView *)secondView {
    if (!_secondView) {
        _secondView = [[SecondResetView alloc]initWithFrame:CGRectMake720(720, 128, 720, 720)];
        @weakify_self
        _secondView.clickGetCodeBtn = ^(NSString *phone){
            @strongify_self
            [self clickGetCodeBtnWithTelephone:phone];
        };
        
        _secondView.clickSureBtnBlock = ^(NSString *phone,NSString *password,NSString *code){
            @strongify_self
            [self clickSureBtnWithPhone:phone password:password code:code];
        };
    }
    return _secondView;
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
