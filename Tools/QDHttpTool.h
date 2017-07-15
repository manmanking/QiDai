//
//  QDHttpTool.h
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

//成功的回调
typedef void(^SuccessBlock)(BOOL isSuccess,NSDictionary *responseObject);
//失败的回调
typedef void(^FailureBlock)(NSError *error);

//登录
typedef void(^IsLoginSuccess)(BOOL success);
//退出登录
typedef void(^IsLogoutBlock)(BOOL isLogout);

//第三方登录
typedef void(^LoginCompleteBlock)(BOOL isSuccess, NSString *errStr, NSDictionary *result);
@interface QDHttpTool : NSObject

/** 
 *********************** 基本 *****************************
 */

/**
 *  get请求
 *
 *  @param url     请求地址
 *  @param parameter  请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)parameter  success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param parameter  请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)parameter success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *********************** 详细 *****************************
 */

/**
 *  post请求上传头像
 *
 *  @param imgPath  图片路径
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
//+ (void)uploadImageWithImagePath:(NSString *)imgPath success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
