//
//  QQManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QQManager.h"
#import "AFNetworking.h"
#import "UserInfoDBManager.h"
#import "AFNetworking.h"
#import "UserInfoModel.h"
#import "UserDefaultConstant.h"
#import <TencentOpenAPI/TencentOAuth.h>

#define IMAGEDATA_COMPRESSED 0.8

#define QQ_APPID                            @"1104369944"
#define kNSUSERDEFAULT_QQ_OPENID            @"QQ_OPENID"
#define kNSUSERDEFAULT_QQ_TOKEN             @"QQ_TOKEN"
#define kNSUSERDEFAULT_QQ_EXPIRATIONDATA    @"QQ_EXPIRATIONDATA"
@implementation QQManager

+ (instancetype)instance {
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc]init];
    });
    return pRet;
}

/**
 *  判断是否安装qq
 *
 *  @return 是否安装
 */
- (BOOL)isQQInstalled {
    //return YES;
    return [TencentOAuth iphoneQQInstalled];
}

/**
 *  判断是否是QQ登录
 *
 *  @return 是否
 */
- (BOOL)isQQLogin {
    NSString *openid = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_QQ_OPENID];
    NSString *token = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_QQ_TOKEN];
    NSString *expirationdata = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_QQ_EXPIRATIONDATA];
    
    return [@(openid.length > 0 && token.length > 0 && expirationdata) boolValue];
}

/**
 *  qq登录的方法
 */
- (void)qqLoginWithResponse:(NSDictionary *)response
                    compate:(LoginCompleteBlock)loginCompleteBlock {
    

    NSDictionary *param = @{@"openId":response[@"usid"],
                            @"nickName":response[@"nickname"],
                            @"imagePath":response[@"iconURL"],
                            @"openType":@"QQ"};
    [[AFHTTPSessionManager manager] GET:kUrl_openLogin parameters:param progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",task.response.URL.absoluteString);
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            
            NSDictionary *dic = @{@"userId":responseObject[@"userId"]};
            
            [[AFHTTPSessionManager manager] GET:kUrl_getUserInfo parameters:dic progress:nil success:^(NSURLSessionDataTask *task, id result) {
                
                if ([result[@"code"] isEqualToString:@"00"]) {
                    
                    [kNSUSERDEFAULE setObject:responseObject[@"userId"] forKey:kNSUSERDEFAULT_QQLOGIN_USERID];
                    
                    [kNSUSERDEFAULE setObject:response[@"usid"] forKey:kNSUSERDEFAULT_QQ_OPENID];
                    [kNSUSERDEFAULE setObject:response[@"accessToken"] forKey:kNSUSERDEFAULT_QQ_TOKEN];
                    [kNSUSERDEFAULE setObject:response[@"expirationDate"] forKey:kNSUSERDEFAULT_QQ_EXPIRATIONDATA];
                    [kNSUSERDEFAULE synchronize];
                    
                    UserInfoModel *userInfo = [[UserInfoModel alloc] initWithDictionary:result];
                    [UserInfoDBManager updateUserInfo:userInfo];
                    
                    loginCompleteBlock(YES,@"",result);
                    
                } else {
                    loginCompleteBlock(NO,@"",result);
                    
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                loginCompleteBlock(NO,@"",nil);
            }];
            
            
            
        } else {
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}

/**
 *  qq退出的方法
 */
- (void)qqLogout {
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_QQLOGIN_USERID];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_QQ_OPENID];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_QQ_TOKEN];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_QQ_EXPIRATIONDATA];
    [kNSUSERDEFAULE synchronize];
}
@end
