//
//  RegistViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/22.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TermsViewController.h"
#import "RegisterManager.h"

#import "AlertViewManager.h"
#import "SportDataBaseManager.h"
#import "SynchronizeRidingRecordManager.h"
#import "UploadFileManager.h"
@interface RegistViewController ()<RegistViewDelegate>

{
    /** 点击返回按钮 是否弹出 取消   确认*/
    BOOL _isPush;
}

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    
    RegistView *registView = [[RegistView alloc]initWithFrame:self.view.bounds];
    registView.delegate = self;
    [scrollView addSubview:registView];
    // Do any additional setup after loading the view.
}
#pragma mark --- private method
- (void)loginWithPhone:(NSString *)phone password:(NSString *)password {
    [[LoginManager instance] telePhoneLoginWithTelephone:phone withPassword:password compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"注册成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kREFRESHDATA_NOTIFICATION object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self initRelateData];
        } else {
            
        }
    }];
}
-(void)initRelateData{
    NSLog(@"同步数据");
    NSString *userId = [[LoginManager instance] getUserId];
    //同步数据
    if ([SportDataBaseManager getTotalTimesWithUserId:userId]==0) {
        
        [SynchronizeRidingRecordManager loadAllRidingRecordWithUserId:userId
                                                              success:^(NSArray *dataList) {
                                                                  if ([dataList count]>0) {
                                                                      [SportDataBaseManager insertSportDataArray:dataList];
                                                                  }
                                                              }
                                                              failure:^{
                                                                  
                                                                  
                                                              }];
        
    }
    
    [UploadFileManager createUserFolder:userId];
    
}
#pragma mark --- RegistView Delegate
- (void)clickBackBtn {
    
    if (_isPush) {
        
        [[AlertViewManager instance] showAlertView:@"确认要放弃注册吗？" withMessage:@"" withFirstBtnAction:^{

        } withSecondBtnAction:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)clickTermsBtn {
    TermsViewController *vc = [[TermsViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)clickGetCodeBtnWithTelephone:(NSString *)telephone {
    _isPush = YES;
    [[MBProgressHUDManager instance] showHUDLoadingView:self.view];
    [RegisterManager sendCodeWithTelephone:telephone withAccType:AccType_EmailRegister success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"发送成功");
        [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
    }];
}
- (void)clickCompleteBtnWithTelephone:(NSString *)telephone withPassword:(NSString *)password withAuthCode:(NSString *)code {
    //NSLog(@"%@,%@,%@",telephone,password,code);
    
    if (![password judgePassWordLegal]) {
        [[MBProgressHUDManager instance]showTextOnlyWithView:self.view withText:@"请输入6位字母和数字组合的密码"];
        return;
    }
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:kGetKeyWindow];
    [RegisterManager registerWithTelephone:telephone withPassword:password withAuthCode:code success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"注册成功"];
            
            //[self loginWithPhone:telephone password:password];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } else {

            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"注册失败，请重新注册"];
        }
    } failure:^(NSError *error) {
        NSLog(@"注册失败");
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}


- (void)showErrorWithMessage:(NSString *)message {
    [[MBProgressHUDManager instance] showTextOnlyWithView:self.view withText:message];
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
