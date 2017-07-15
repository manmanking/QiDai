//
//  RegisterManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "RegisterManager.h"
#import "AFNetworking.h"
#import "NSString+Encryption.h"
@implementation RegisterManager

+ (void)sendCodeWithTelephone:(NSString *)telephone
                  withAccType:(AccType)accType
                      success:(SuccessBlock)success failure:(FailureBlock)failure {
//    //NSDictionary *parame = @{@"phoneNo":telephone,
//                             @"accType":@(accType)};
    NSString *acctypeStr = [NSString stringWithFormat:@"0%ld",accType];
    NSDictionary *parame = @{@"phoneNo":telephone,
                             @"accType":acctypeStr};
    
    // 设置超时时间
    [[AFHTTPSessionManager manager].requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 10.f;
    [[AFHTTPSessionManager manager].requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [[AFHTTPSessionManager manager] GET:kUrl_sendCode parameters:parame  progress:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([responseObject[@"code"] isEqualToString:@"00"]) {
                if (success) {
                    success(YES,responseObject);
                }
            } else {
                if (failure) {
                    success(NO, responseObject);
                }
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];

}

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
                      success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSDictionary *parame = @{@"phoneNo":telephone,
                             @"passWord":[password md5DHexDigestString_Ext],
                             @"confirmPassWord":[password md5DHexDigestString_Ext],
                             @"authCode":authCode};
    
    [[AFHTTPSessionManager manager] GET:kUrl_addUser parameters:parame  progress:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([responseObject[@"code"] isEqualToString:@"00"]) {
                if (success) {
                    success(YES,responseObject);
                }
            } else {
                if (failure) {
                    success(NO, responseObject);
                }
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
