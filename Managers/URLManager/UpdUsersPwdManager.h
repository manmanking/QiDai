//
//  UpdUsersPwdManager.h
//  Leqi
//
//  Created by Tianyu on 15/2/1.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdUsersPwdManager : NSObject

+ (void)updUsersPwdWithOldPassword:(NSString *)oldStr
                   withNewPassword:(NSString *)newStr
                  withNewPassword2:(NSString *)newStr2
                           compate:(void(^)(BOOL isSuccess, NSString *errStr, NSDictionary *result))compate;

@end
