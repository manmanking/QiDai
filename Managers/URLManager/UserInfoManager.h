//
//  UserInfoManager.h
//  QiDai
//
//  Created by manman'swork on 16/10/24.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfoModel;

@interface UserInfoManager : NSObject

+ (void)saveUserBaseInfo:(NSString *)userIdStr;

@end
