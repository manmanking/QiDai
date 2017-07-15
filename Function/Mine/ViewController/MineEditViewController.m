//
//  MineEditViewController.m
//  Leqi
//
//  Created by 张汇丰 on 16/1/11.
//  Copyright © 2016年 com.hoolai. All rights reserved.
//

#import "MineEditViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ChangePasswordView.h"
#import "UserInfoModel.h"
#import "ReactiveCocoa.h"
#import "UpdUsersPwdManager.h"
#import "UpdateUserManager.h"
#import "UserInfoDBManager.h"
#import "UserInfoManager.h"
@interface MineEditViewController ()
{
    /** 背景view,作用处理键盘收缩*/
    TPKeyboardAvoidingScrollView *_bgScrollView;
}

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UITextField *nameTextField;

/** 字数的label 名字的话有字数限制*/
@property (nonatomic,strong) UILabel *wordNumberLabel;
@end

@implementation MineEditViewController
#pragma mark --- life cycle
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self.view removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //名字有字数限制
    if ([_leftKey isEqualToString:@"昵称"]) {
        self.wordNumberLabel.hidden = NO;
    } else {
        self.wordNumberLabel.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB_16(0x171717);
    [self creatTitleViewWithString:@"编辑"];
    [self setupUI];
    // Do any additional setup after loading the view.
    //[self getUserBaseInfoFormNetwork];
    
    
}
//- (void)getUserBaseInfoFormNetwork
//{
//    [UserInfoManager getUserBaseInfo:[[LoginManager instance] getUserId]];
//    
//    
//}




#pragma mark --- ui
- (void)setupUI {
    _bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_bgScrollView];
#pragma mark --- 修改密码
    if (self.editType == EditPassword) {
        ChangePasswordView *changPasswordView = [[ChangePasswordView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:changPasswordView];
        
        UIButton *completeButton = [ UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 0, 80, 40) title:@"确认" titleColor:UIColorFromRGB_16(0xffffff) titleFont:30 backgroundColor:nil tapAction:^(UIButton *button) {
            //NSLog(@"完成");
            
            if (![changPasswordView.changePasswordTF.text judgePassWordLegal]) {
                [[MBProgressHUDManager instance]showTextOnlyWithView:self.view withText:@"请输入6位字母和数字组合的密码"];
                return;
            }
            
            NSString *newPassword = changPasswordView.changePasswordTF.text;
            NSString *newPassword2 = changPasswordView.changePasswordTF2.text;
            NSString *oldPassword = changPasswordView.oldPasswordTF.text;
            if (![newPassword isEqualToString:newPassword2]) {
                
                [[MBProgressHUDManager instance]showTextOnlyWithView:self.view withText:@"两次密码输入不一致，请重试"];
                return;
            }
            if (newPassword.length < 6 || newPassword2.length < 6) {
                
                [[MBProgressHUDManager instance]showTextOnlyWithView:self.view withText:@"密码需要大于6位数"];
                return;
            }
            [UpdUsersPwdManager updUsersPwdWithOldPassword:oldPassword withNewPassword:newPassword withNewPassword2:newPassword2 compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                if (isSuccess) {
                    [[MBProgressHUDManager instance]showTextOnlyWithView:self.navigationController.view withText:result[@"message"]];
                    [self clickBackBtn];
                } else {
                    [[MBProgressHUDManager instance]showTextOnlyWithView:self.navigationController.view withText:errStr];
                }
                
            }];
            
        } ];
        
        [completeButton setTitleColor:UIColorFromRGB_16(0xd4d4d4) forState:UIControlStateDisabled];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
        RAC(completeButton, enabled) = [RACSignal combineLatest:@[changPasswordView.oldPasswordTF.rac_textSignal,changPasswordView.changePasswordTF.rac_textSignal,changPasswordView.changePasswordTF2.rac_textSignal] reduce:^id(NSString *text, NSString *text1, NSString *text2){
            return @(text.length >= 6 && text1.length >= 6 && text2.length >= 6);
        }];
        
        return;
    }
    
#pragma mark --- 修改其他事项
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 20, 720, 110)];;
    bgView.backgroundColor = UIColorFromRGB_16(0x000000);
    [_bgScrollView addSubview:bgView];
    
    [bgView addSubview:self.leftLabel];
    self.leftLabel.centerY = 65*SizeScaleSubjectTo720;
    
    [bgView addSubview:self.nameTextField];
    self.nameTextField.centerY = 65*SizeScaleSubjectTo720;
    [_nameTextField becomeFirstResponder];
    
    [bgView addSubview:self.wordNumberLabel];
    self.wordNumberLabel.text = [NSString stringWithFormat:@"%ld/10",(unsigned long)_leftKey.length];
    
    
    UIButton *completeButton = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0, 0, 80, 40) title:@"完成" titleColor:UIColorFromRGB_16(0xffffff) titleFont:30 backgroundColor:nil tapAction:^(UIButton *button) {
        //NSLog(@"完成");
        [self clickChangeName];
    }];
    [completeButton setTitleColor:UIColorFromRGB_16(0xd4d4d4) forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
    RAC(completeButton, enabled) = [RACSignal combineLatest:@[_nameTextField.rac_textSignal] reduce:^id(NSString *str){
        self.wordNumberLabel.text = [NSString stringWithFormat:@"%ld/10",(unsigned long)str.length];
        
        if (str.length > 10) {
            self.wordNumberLabel.textColor = [UIColor redColor];
        } else {
            self.wordNumberLabel.textColor = UIColorFromRGB_16(0Xd4d4d4);
        }
        
        return @(![str isEqualToString:self.rightValue]);
    }];
    
    
    
}

#pragma mark --- private methed
- (void)clickChangeName {
    [_nameTextField resignFirstResponder];
    if ([_leftKey isEqualToString:@"昵称"]) {
        if (_nameTextField.text.length > 10) {
            [[MBProgressHUDManager instance]showTextOnlyWithView:self.navigationController.view withText:@"昵称最多为10字符"];
            return;
        }
        self.userInfoModel.nickName = _nameTextField.text;
        
    } else if ([_leftKey isEqualToString:@"手机"]) {
        self.userInfoModel.phoneNo = _nameTextField.text;
        if (![self.userInfoModel.phoneNo isMobileNumberClassification]) {
            [[MBProgressHUDManager instance]showTextOnlyWithView:self.navigationController.view withText:@"请输入正确的手机号"];
            return;
        }
    } else if ([_leftKey isEqualToString:@"邮箱"]) {
        self.userInfoModel.email = _nameTextField.text;
        if (![self.userInfoModel.email isValidateEmail]) {
            [[MBProgressHUDManager instance]showTextOnlyWithView:self.navigationController.view withText:@"请输入正确的邮箱"];
            return;
        }
        
    }
    if (![[LoginManager instance] isLogin]) {
        return;
    }
    
    self.userInfoModel.userId = [[LoginManager instance] getUserId];
    [UserInfoDBManager updateUserInfo:self.userInfoModel];
    //[[LoadingViewManager instance] showLoadingView];
    
    [UpdateUserManager updateUser:self.userInfoModel
                          compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                              //[[LoadingViewManager instance] hideLoadingView];
                              if (isSuccess) {
                                  //[[AlertViewManager instance] showAlertView:@"成功" withMessage:@"数据保存成功" withCompate:nil];
                                  [[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"保存成功"];
                                  [self clickBackBtn];
                              } else {
                                  //[[AlertViewManager instance] showAlertView:@"提示" withMessage:errStr withCompate:nil];
                                  [[MBProgressHUDManager instance] showTextOnlyWithView:self.view withText:@"保存失败"];
                              }
                          }];
    
    //[UserInfoDBManager updateUserInfo:self.userInfoModel];
}

#pragma mark --- set
- (void)setLeftKey:(NSString *)leftKey {
    _leftKey = leftKey;
    self.leftLabel.text = leftKey;
}

- (void)setRightValue:(NSString *)rightValue {
    _rightValue = rightValue;
    //self.nameTextField.text = rightValue;
    
    if ([ [NSString stringWithFormat:@"%@",rightValue] isEqualToString:@"" ]) {
        self.nameTextField.text = @"未知";
    } else {
        //手机号
        self.nameTextField.text = [NSString stringWithFormat:@"%@",rightValue];
    }

}

#pragma mark --- get
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 190, 25) title:@"昵称" titleColor:UIColorFromRGB_16(0Xd4d4d4) textAlignment:NSTextAlignmentCenter font:24];
    }
    return _leftLabel;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake720(190, 0, 500, 40)];
        _nameTextField.centerY = 65*SizeScaleSubjectTo720;
        //_nameTextField.text = @"昵称1";
        _nameTextField.textColor = UIColorFromRGB_16(0xffffff);
        _nameTextField.font = UIFontOfSize720(30);
    }
    return _nameTextField;
}

- (UILabel *)wordNumberLabel {
    if (!_wordNumberLabel) {
        _wordNumberLabel = [UILabel qd_labelWithFrame:CGRectMake720(530, 130, 190, 25) title:@"1/10" titleColor:UIColorFromRGB_16(0Xd4d4d4) textAlignment:NSTextAlignmentCenter font:24];
    }
    return _wordNumberLabel;
}
- (void)clickBackBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
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
