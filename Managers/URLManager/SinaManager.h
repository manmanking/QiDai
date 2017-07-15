//
//  SinaManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDHttpTool.h"

@interface SinaManager : QDHttpTool

+ (instancetype)instance;

/**
 *  判断是否安装sina
 *
 *  @return 是否安装
 */
- (BOOL)isSinaInstalled;

/**
 *  判断是否是sina登录
 *
 *  @return 是否
 */
- (BOOL)isSinaLogin;

/**
 *  sina登录的方法
 */
- (void)sinaLoginWithResponse:(NSDictionary *)responseObject
                    compate:(LoginCompleteBlock)loginCompleteBlock;

/**
 *  sina退出的方法
 */
- (void)sinaLogout;

@end
