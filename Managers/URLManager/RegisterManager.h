//
//  RegisterManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  管理注册和发送验证码

#import <Foundation/Foundation.h>
#import "QDHttpTool.h"
typedef NS_ENUM(NSInteger,AccType) {
    AccType_EmailRegister = 1,  // 注册账户激活
    AccType_FindPassword = 2,    // 找回密码
    AccType_OrderItem = 3      //商品预定 
};

@interface RegisterManager : NSObject

/**
 *  发送验证码请求
 *
 *  @param telephone 手机号
 *  @param accType   手机验证码分类
 *  @param compate   block回调
 */
+ (void)sendCodeWithTelephone:(NSString *)telephone
                  withAccType:(AccType)accType
                      success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  注册新账户接口
 *
 *  @param telephone 手机号
 *  @param password  登录密码
 *  @param authCode  验证码
 *  @param compate   block回调
 */
+ (void)registerWithTelephone:(NSString *)telephone
                 withPassword:(NSString *)password
                 withAuthCode:(NSString *)authCode
                      success:(SuccessBlock)success failure:(FailureBlock)failure;


@end
