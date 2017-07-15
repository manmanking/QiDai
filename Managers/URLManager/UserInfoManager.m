//
//  UserInfoManager.m
//  QiDai
//
//  Created by manman'swork on 16/10/24.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "UserInfoManager.h"
#import "LoginManager.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "UserInfoModel.h"
#import "UserInfoDBManager.h"

@implementation UserInfoManager




+ (void)saveUserBaseInfo:(NSString *)userIdStr
{
    
    NSDictionary *requestParameter = [[NSDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userId",nil];
    [[AFHTTPSessionManager manager] GET:kUrl_getUserInfo parameters:requestParameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"00"]) {
            UserInfoModel *userInfoModel = [UserInfoModel mj_objectWithKeyValues:[responseObject objectForKey:@"userInfo"]];
            userInfoModel.userId = userIdStr;
            [UserInfoDBManager updateUserInfo:userInfoModel];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"Error: %@", error);
    }];
    
   
    
}

@end
