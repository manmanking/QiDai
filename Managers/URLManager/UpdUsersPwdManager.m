//
//  UpdUsersPwdManager.m
//  Leqi
//
//  Created by Tianyu on 15/2/1.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "UpdUsersPwdManager.h"
#import "AFNetworking.h"

#import "NSString+Encryption.h"
#import "LoginManager.h"

@implementation UpdUsersPwdManager

+ (void)updUsersPwdWithOldPassword:(NSString *)oldStr
                   withNewPassword:(NSString *)newStr
                  withNewPassword2:(NSString *)newStr2
                           compate:(void (^)(BOOL, NSString *, NSDictionary *))compate
{
    
    NSDictionary *parame = @{@"oldPassword":[oldStr md5DHexDigestString_Ext],
                             @"password":[newStr md5DHexDigestString_Ext],
                             @"confirmPassword":[newStr2 md5DHexDigestString_Ext],
                             @"userId":[[LoginManager instance] getUserId]
                             };
    [[AFHTTPSessionManager manager] GET:kUrl_updUsersPwd parameters:parame progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            if (compate) {
                compate(YES, nil, responseObject);
            }
        } else {
            if (compate) {
                compate(NO, responseObject[@"message"], nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (compate) {
            compate(NO, @"网络连接失败，请稍后再试", nil);
        }
    }];
}

@end
