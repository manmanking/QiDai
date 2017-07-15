//
//  WeChatManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "WeChatManager.h"
#import "AFNetworking.h"
#import "UserInfoDBManager.h"
#import "AFNetworking.h"
#import "UserInfoModel.h"
#import "UserDefaultConstant.h"
#import "WXApi.h"

#define WEIXIN_DESCRIPTION  @"ThirdLoginShareDemo"
#define WEIXIN_SCOPE        @"snsapi_userinfo"
#define WEIXIN_STATE        @"WEIXIN_STATUS"


#define kNSUSERDEFAULT_ACCESSTOKEN  @"weixin_accesstoken"
#define kNSUSERDEFAULT_REFRESHTOKEN @"weixin_refreshtoken"
#define kNSUSERDEFAULT_EXPIRES      @"weixin_expires_in"
#define kNSUSERDEFAULT_OPENID       @"weixin_openid"

@implementation WeChatManager

+ (instancetype)instance {
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc]init];
    });
    return pRet;
}


- (BOOL)isWeChatInstalled {
    //return NO;
    return [WXApi isWXAppInstalled];
}


- (BOOL)isWeChatLogin {
    NSString *openid = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_OPENID];
    NSString *token = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_ACCESSTOKEN];
    NSString *expirationdata = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_EXPIRES];
    
    return [@(openid.length > 0 && token.length > 0 && expirationdata) boolValue];
}


- (void)weChatLoginWithResponse:(NSDictionary *)response
                    compate:(LoginCompleteBlock)loginCompleteBlock {
    //NSString *nickname = [response[@"nickname"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *param = @{@"openId":response[@"usid"],
                            @"nickName":response[@"nickname"],
                            @"imagePath":response[@"iconURL"],
                            @"openType":@"weixin"};
    [[AFHTTPSessionManager manager] GET:kUrl_openLogin parameters:param progress:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
        //Clog(@"weixin登录:%@",responseObject);
        //NSLog(@"%@",task.response.URL.absoluteString);
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            
            NSDictionary *dic = @{@"userId":responseObject[@"userId"]};
            
            [[AFHTTPSessionManager manager] GET:kUrl_getUserInfo parameters:dic  progress:nil success:^(NSURLSessionDataTask *task, id result) {
                
                if ([result[@"code"] isEqualToString:@"00"]) {
                    
                    [kNSUSERDEFAULE setObject:responseObject[@"userId"] forKey:kNSUSERDEFAULT_WECHATLOGIN_USERID];
                    
                    [kNSUSERDEFAULE setObject:response[@"usid"] forKey:kNSUSERDEFAULT_OPENID];
                    [kNSUSERDEFAULE setObject:response[@"accessToken"] forKey:kNSUSERDEFAULT_ACCESSTOKEN];
                    [kNSUSERDEFAULE setObject:response[@"expirationDate"] forKey:kNSUSERDEFAULT_EXPIRES];
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
- (void)weChatLogout {
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_QQLOGIN_USERID];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_OPENID];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_ACCESSTOKEN];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_EXPIRES];
    [kNSUSERDEFAULE synchronize];
}


@end
