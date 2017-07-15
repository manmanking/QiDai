//
//  LoginView.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/5.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

- (void)clickBackBtn;

- (void)clickRegisterBtn;

- (void)clickForgetPasswordBtn;

- (void)clickLoginBtnWithPhone:(NSString *)phone password:(NSString *)password;

- (void)clickQQBtn;

- (void)clickWeChatBtn;

- (void)clickSinaBtn;

@end

@interface LoginView : UIView

@property (nonatomic,weak) id<LoginViewDelegate>delegate;

@end
