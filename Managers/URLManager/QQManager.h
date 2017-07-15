//
//  QQManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDHttpTool.h"

typedef void(^LoginCompleteBlock)(BOOL isSuccess, NSString *errStr, NSDictionary *result);

@interface QQManager : QDHttpTool


+ (instancetype)instance;

/**
 *  判断是否安装qq
 *
 *  @return 是否安装
 */
- (BOOL)isQQInstalled;

/**
 *  判断是否是QQ登录
 *
 *  @return 是否
 */
- (BOOL)isQQLogin;

/**
 *  qq登录的方法
 */
- (void)qqLoginWithResponse:(NSDictionary *)response
                    compate:(LoginCompleteBlock)loginCompleteBlock;

/**
 *  qq退出的方法
 */
- (void)qqLogout;

@end
