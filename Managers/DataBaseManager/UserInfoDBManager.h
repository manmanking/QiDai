//
//  UserInfoDBManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfoModel,SportModel;
@interface UserInfoDBManager : NSObject
/**
 *  更新用户信息
 *
 *  @param userInfo 用户信息Model
 *
 *  @return 是否成功
 */
+ (BOOL)updateUserInfo:(UserInfoModel *)userInfo;


/**
 *  获取用户信息
 *
 *  @return 用户信息Model
 */
+ (UserInfoModel *)getUserInfoWithUserId:(NSString *)userId;

/**
 *  验证当前用户是否有存在未上传的数据
 *
 *  @param userId
 *
 *  @return
 */

+ (NSArray *)verifySportDataExistWillUploadWithUserId:(NSString *)userId;


/**
 *  检测帐号  删除 过期数据
 */
+ (void)deleteExpiredUserSportDataWithUserId:(NSString *)userId;

//获得最新的一条数据的信息
+ (NSArray *)verifyFreshSportDataExistWillUploadWithUserId:(NSString *)userId;

@end
