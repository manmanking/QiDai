//
//  LoginManager.m
//  Leqi
//
//  Created by Tianyu on 14/12/29.
//  Copyright (c) 2014年 com.hoolai. All rights reserved.
//

#import "LoginManager.h"
#import "AFNetworking.h"
#import "NSString+Encryption.h"

#import "UserDefaultConstant.h"
//#import "DataBaseManager.h"
#import "UserInfoDBManager.h"
#import "UserInfoModel.h"
#import "SinaManager.h"
#import "QQManager.h"
#import "WeChatManager.h"
@implementation LoginManager

+ (instancetype)instance
{
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc] init];
    });
    return pRet;
}

- (BOOL)isLogin
{
#warning 登录
    return [self isTelePhoneLogin] || [[SinaManager instance] isSinaLogin] || [[QQManager instance] isQQLogin] || [[WeChatManager instance]isWeChatLogin];
}

- (NSString *)getUserId {
    switch ([self LoginTypeStatus]) {
        case telephoneType:{
            NSString *userID = [kNSUSERDEFAULE objectForKey:kLOGIN_TELEPHONE_USERID];
            return ([userID isEqualToString:@"-1"] ? nil : userID);
        }
            break;
        case sinaType:
            return [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_SINALOGIN_USERID];
            break;
        case qqType:
            return [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_QQLOGIN_USERID];
            break;
        case weChatType:
            return [kNSUSERDEFAULE objectForKey:kNSUSERDEFAULT_WECHATLOGIN_USERID];
            break;
        default:
            return @"-1";
            break;
    }
}

- (LoginType)LoginTypeStatus
{
    if ([self isTelePhoneLogin]) {
        return telephoneType;
    }
  
    if ([[SinaManager instance] isSinaLogin]) {
        return sinaType;
    }
    if ([[QQManager instance] isQQLogin]) {
        return qqType;
    }
    if ([[WeChatManager instance] isWeChatLogin]) {
        return weChatType;
    }
    return errType;
}

- (BOOL)isTelePhoneLogin
{
    NSString *userId = [kNSUSERDEFAULE objectForKey:kLOGIN_TELEPHONE_USERID];
    if (userId.length > 0 && ![userId isEqualToString:@"-1"]) {
        return YES;
    }
    return  NO;
}

- (void)telephoneLogout
{
    [kNSUSERDEFAULE removeObjectForKey:kLOGIN_TELEPHONE_USERID];
}

- (void)telePhoneLoginWithTelephone:(NSString *)telephone
                       withPassword:(NSString *)password
                            compate:(void (^)(BOOL, NSString *, NSDictionary *))compate
{
    NSDictionary *parame = @{@"phoneNo":telephone,
                             @"password":[password md5DHexDigestString_Ext]};
    
    [[AFHTTPSessionManager manager] GET:kUrl_login parameters:parame progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = responseObject[@"code"];
            if ([code isEqualToString:@"00"]) {
                [self saveUserIdWithLoginResault:responseObject];
                [self getUserInfoWithTelephone:responseObject[@"userId"] compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                    if (isSuccess) {
                        if (compate) {
                            compate(YES, nil, responseObject);
                        }
                    } else {
                        if (compate) {
                            compate(NO, errStr, nil);
                        }
                    }
                }];
            } else {
            
                if (compate) {
                    compate(NO, responseObject[@"message"], nil);
                }
                
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (compate) {
            compate(NO, @"网络连接失败，请稍后再试", nil);
        }
        
    }];
    
}

- (void)getUserInfoWithTelephone:(NSNumber *)userId
                         compate:(void (^)(BOOL, NSString *, NSDictionary *))compate
{
    NSDictionary *parame = @{@"userId":userId};
    [[AFHTTPSessionManager manager] POST:kUrl_getUserInfo parameters:parame progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = responseObject[@"code"];
            if ([code isEqualToString:@"00"]) {
                [self getUserInfoWithResault:responseObject];
                if (compate) {
                    compate(YES, nil, responseObject);
                }
            } else {
                if (compate) {
                    compate(NO, responseObject[@"message"], nil);
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (compate) {
            compate(NO, @"网络连接失败，请稍后再试", nil);
        }

        
    }];
}

+ (void)getUserInfoWithUserId:(NSString *)userId{
    NSDictionary *parame = @{@"userId":userId};
    [[AFHTTPSessionManager manager] POST:kUrl_getUserInfo parameters:parame progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = responseObject[@"code"];
            if ([code isEqualToString:@"00"]) {
                //[self getUserInfoWithResault:responseObject];
                UserInfoModel *userInfo = [[UserInfoModel alloc] initWithDictionary:responseObject];
                if ([[LoginManager instance] LoginTypeStatus] == telephoneType) {
                    
                    
                    UserInfoModel *userInfo = [[UserInfoModel alloc] initWithDictionary:responseObject];
                    [UserInfoDBManager updateUserInfo:userInfo];
                }else {
                    [UserInfoDBManager updateUserInfo:userInfo];
                }
                
                
            } else {
                
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 储存用户Id
- (void)saveUserIdWithLoginResault:(NSDictionary *)resault
{
    NSString *message   = resault[@"message"];  // 返回信息
    NSString *userId    = resault[@"userId"];   // 用户ID
    NSString *phoneNo   = resault[@"phoneNo"];  // 手机号
    NSString *userName  = resault[@"userName"]; // 用户昵称
    NSString *sex       = resault[@"sex"];      // 性别 01——帅哥 02——美女
    NSString *height    = resault[@"height"];   // 身高
    
    
    [kNSUSERDEFAULE setValue:userId forKey:kLOGIN_TELEPHONE_USERID];
    [kNSUSERDEFAULE synchronize];
    
    NSLog(@"save userID = %@",[kNSUSERDEFAULE objectForKey:kLOGIN_TELEPHONE_USERID]);
    Clog(@"message:%@",message);
    Clog(@"userId:%@",userId);
    Clog(@"手机号:%@",phoneNo);
    Clog(@"昵称%@",userName);
    Clog(@"性别:%@",sex);
    Clog(@"身高:%@",height);
}

- (void)getUserInfoWithResault:(NSDictionary *)resault
{
    
    UserInfoModel *userInfo = [[UserInfoModel alloc] initWithDictionary:resault];
    [UserInfoDBManager updateUserInfo:userInfo];
}

@end
