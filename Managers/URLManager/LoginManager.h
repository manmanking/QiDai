//
//  LoginManager.h
//  Leqi
//
//  Created by Tianyu on 14/12/29.
//  Copyright (c) 2014年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger,LoginType) {
    telephoneType = 0,
    sinaType = 1,
    qqType = 2,
    weChatType = 3,
    errType = -1
};

@interface LoginManager : NSObject
/** 单例模式*/
+ (instancetype)instance;

/** 判断是否登录*/
- (BOOL)isLogin;

/** 获取userID ---返回类型NSString*/
- (NSString *)getUserId;

/** 判断是否是手机登录*/
- (BOOL)isTelePhoneLogin;

/** 获取登录类型*/
- (LoginType)LoginTypeStatus;


/** 手机号登录*/
- (void)telePhoneLoginWithTelephone:(NSString *)telephone
                       withPassword:(NSString *)password
                            compate:(void(^)(BOOL isSuccess, NSString *errStr, NSDictionary *result))compate;

/** 根据手机号获取用户信息*/
- (void)getUserInfoWithTelephone:(NSString *)telephone
                         compate:(void(^)(BOOL isSuccess, NSString *errStr, NSDictionary *result))compate;

/** 根据userID获取用户信息*/
+ (void)getUserInfoWithUserId:(NSString *)userId;

/** 手机号登录的退出*/
- (void)telephoneLogout;

//存储已经连接过的蓝牙设备 暂时放这里
@property (strong, nonatomic) CBPeripheral *peripheral;

@end
