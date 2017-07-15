//
//  QDHttpTool.m
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDHttpTool.h"
#import "AFNetworking.h"
@implementation QDHttpTool

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)parameter  success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    if (!url) {
        return;
    }
//    [AFHTTPSessionManager manager].requestSerializer = [AFHTTPRequestSerializer serializer];
//    [AFHTTPSessionManager manager].responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [[AFHTTPSessionManager manager].requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 10.0f;
    [[AFHTTPSessionManager manager].requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    [AFHTTPSessionManager manager].responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html,text/plain"];
    [AFHTTPSessionManager manager].responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [[AFHTTPSessionManager manager] GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            success(YES,responseObject);
        }else {
            success(NO,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)parameter success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    if (!url) {
        return;
    }
    // 设置超时时间
    [[AFHTTPSessionManager manager].requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 10.f;
    [[AFHTTPSessionManager manager].requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [[AFHTTPSessionManager manager] POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"00"]) {
            success(YES,responseObject);
        }else {
            success(NO,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
}
@end
