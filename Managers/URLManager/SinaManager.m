//
//  SinaManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SinaManager.h"
#import "AFNetworking.h"
#import "UserInfoDBManager.h"
#import "AFNetworking.h"
#import "UserInfoModel.h"
#import "UserDefaultConstant.h"
#import "WeiboSDK.h"
#define kSINA_APPKEY @"2094968841"
#define kREDIRECTURL @"http://api.weibo.com/oauth2/default.html"

#define kNSUSERDEFAULT_SINA_ACCESSTOKEN     @"sina_accesstoken"
#define kNSUSERDEFAULT_SINA_USERID          @"sina_userId"
#define kNSUSERDEFAULT_SINA_EXPIRATIONDATE  @"sian_expirationDate"

@implementation SinaManager
+ (instancetype)instance
{
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc] init];
    });
    return pRet;
}

- (BOOL)isSinaInstalled
{
    //return YES;
    return [WeiboSDK isWeiboAppInstalled];
}


- (BOOL)isSinaLogin {
    NSString *accessToken = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_SINA_ACCESSTOKEN];
    NSString *expirationDate = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_SINA_EXPIRATIONDATE];
    NSString *userId = [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_SINA_USERID];
    
    return [@(accessToken.length > 0 && expirationDate && userId.length > 0) boolValue];
}


- (void)sinaLoginWithResponse:(NSDictionary *)response
                        compate:(LoginCompleteBlock)loginCompleteBlock {
    
    
    NSDictionary *param = @{@"openId":response[@"usid"],
                            @"nickName":response[@"nickname"],
                            @"imagePath":response[@"iconURL"],
                            @"openType":@"weibo"};
    [[AFHTTPSessionManager manager] GET:kUrl_openLogin parameters:param progress:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            
            NSDictionary *dic = @{@"userId":responseObject[@"userId"]};
            
            [[AFHTTPSessionManager manager] GET:kUrl_getUserInfo parameters:dic  progress:nil success:^(NSURLSessionDataTask *task, id result) {
                
                if ([result[@"code"] isEqualToString:@"00"]) {
                    
                    [kNSUSERDEFAULE setObject:responseObject[@"userId"] forKey:kNSUSERDEFAULT_SINALOGIN_USERID];
                    
                    [kNSUSERDEFAULE setObject:response[@"usid"] forKey:kNSUSERDEFAULT_SINA_USERID];
                    [kNSUSERDEFAULE setObject:response[@"accessToken"] forKey:kNSUSERDEFAULT_SINA_ACCESSTOKEN];
                    [kNSUSERDEFAULE setObject:response[@"expirationDate"] forKey:kNSUSERDEFAULT_SINA_EXPIRATIONDATE];
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
- (void)sinaLogout {
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_SINALOGIN_USERID];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_SINA_ACCESSTOKEN];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_SINA_USERID];
    [kNSUSERDEFAULE removeObjectForKey:kNSUSERDEFAULT_SINA_EXPIRATIONDATE];
    [kNSUSERDEFAULE synchronize];
}

@end
