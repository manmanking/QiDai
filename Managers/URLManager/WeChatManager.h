//
//  WeChatManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDHttpTool.h"

@interface WeChatManager : QDHttpTool

+ (instancetype)instance;

/**
 *  判断是否安装WeChat
 *
 *  @return 是否安装
 */
- (BOOL)isWeChatInstalled;

/**
 *  判断是否是WeChat登录
 *
 *  @return 是否
 */
- (BOOL)isWeChatLogin;

/**
 *  WeChat登录的方法
 */
- (void)weChatLoginWithResponse:(NSDictionary *)response
                    compate:(LoginCompleteBlock)loginCompleteBlock;

/**
 *  WeChat退出的方法
 */
- (void)weChatLogout;

@end
