//
//  UserInfoModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//
//  用户信息的model
#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

/** 用户Id---NSString*/
@property (copy, nonatomic) NSString *userId;

/** 手机号---NSString*/
@property (copy, nonatomic) NSString *phoneNo;

/** 邮箱---NSString*/
@property (copy, nonatomic) NSString *email;

/** 加密后的密码---NSString*/
@property (copy, nonatomic) NSString *password;

/** 昵称---NSString*/
@property (copy, nonatomic) NSString *nickName;

/** 性别---NSNumber*/
@property (strong, nonatomic) NSNumber *gender;

/** 身高---NSNumber*/
@property (strong, nonatomic) NSNumber *height;

/** 体重---NSNumber*/
@property (strong, nonatomic) NSNumber *weight;

/** 生日---NSNumber*/
@property (strong, nonatomic) NSNumber *birthday;

/** 头像地址---NSString*/
@property (copy, nonatomic) NSString *foreImg;

/** 自行车的品牌，已废弃---NSString*/
@property (copy, nonatomic) NSString *bicycleName;

/** 配件 ,已废除---NSString*/
@property (copy, nonatomic) NSString *fitting;

/** 自行车的图片，已废除---NSString*/
@property (copy, nonatomic) NSString *bicycleImg;

/** 词典转模型*/
-(id)initWithDictionary:(NSDictionary *)dic;

@end
