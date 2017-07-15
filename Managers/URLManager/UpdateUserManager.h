//
//  UpdateUserManager.h
//  Leqi
//
//  Created by Tianyu on 15/1/27.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfoModel;
@interface UpdateUserManager : NSObject

+ (void)updateUser:(UserInfoModel *)userInfoModel
           compate:(void(^)(BOOL isSuccess, NSString *errStr, NSDictionary *result))compate;

@end
