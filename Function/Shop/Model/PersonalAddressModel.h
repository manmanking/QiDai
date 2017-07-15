//
//  PersonalAddressModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/8.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  个人地址

#import <Foundation/Foundation.h>

@interface PersonalAddressModel : NSObject

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *phone;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *userinfo_id;
/** 是否是默认地址*/
@property (nonatomic,copy) NSString *is_def;

@property (nonatomic,copy) NSString *address;
@end
