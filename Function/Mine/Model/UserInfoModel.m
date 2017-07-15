//
//  UserInfoModel.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        id userInfo = dic[@"userInfo"];
        
        if ([userInfo isKindOfClass:[NSDictionary class]]) {
            if ( [userInfo[@"id"] isKindOfClass:[NSString class]]) {
                self.userId = userInfo[@"id"];
            } else {
                self.userId = @"";
            }
            if ( [userInfo[@"phoneNo"] isKindOfClass:[NSString class]]) {
                self.phoneNo = userInfo[@"phoneNo"];
            } else {
                self.phoneNo = @"";
            }
            
            if ( [userInfo[@"email"] isKindOfClass:[NSString class]]) {
                self.email = userInfo[@"email"];
            } else {
                self.email = @"";
            }
            
            if ( [userInfo[@"password"] isKindOfClass:[NSString class]]) {
                self.password = userInfo[@"password"];
            } else {
                self.password = @"";
            }
            
            if ( [userInfo[@"nickName"] isKindOfClass:[NSString class]]) {
                self.nickName = userInfo[@"nickName"];
            } else {
                self.nickName = @"";
            }
            
            if ([userInfo[@"gender"] isKindOfClass:[NSString class]]) {
                self.gender = userInfo[@"gender"];
            } else {
                self.gender = @0;
            }
            
            if ( [userInfo[@"height"] isKindOfClass:[NSString class]]) {
                self.height = userInfo[@"height"];
            } else {
                self.height = @165;
            }
            
            if ( [userInfo[@"weight"] isKindOfClass:[NSString class]]) {
                self.weight = userInfo[@"weight"];
            } else {
                self.weight = @60;
            }
            
            if ( [userInfo[@"birthday"] isKindOfClass:[NSString class]]) {
                self.birthday = userInfo[@"birthday"];
            } else {
                self.birthday = @0;
            }
            
            if ( [userInfo[@"foreImg"] isKindOfClass:[NSString class]]) {
                self.foreImg = userInfo[@"foreImg"];
            } else {
                self.foreImg = @"";
            }
            
        } else {
            
            self.userId     = @"";
            self.phoneNo    = @"";
            self.email      = @"";
            self.password   = @"";
            self.nickName   = @"";
            self.gender     = @0;
            self.height     = @165;
            self.weight     = @60;
            self.birthday   = @0;
            self.foreImg    = @"";
            
        }
        
        id bicycle = dic[@"bicycle"];
        
        if ([bicycle isKindOfClass:[NSDictionary class]]) {
            
            if ([bicycle[@"name"] isKindOfClass:[NSString class]]) {
                self.bicycleName = bicycle[@"name"];
            } else {
                self.bicycleName = @"";
            }
            
            if ([bicycle[@"fitting"] isKindOfClass:[NSString class]]) {
                self.fitting = bicycle[@"fitting"];
            } else {
                self.fitting = @"";
            }
            
            if ([bicycle[@"imgUrl"] isKindOfClass:[NSString class]]) {
                self.bicycleImg = bicycle[@"imgUrl"];
            } else {
                self.bicycleImg = @"";
            }
            
        } else {
            
            self.bicycleName    = @"";
            self.fitting        = @"";
            self.bicycleImg     = @"";
            
        }
    }
    return self;
}
@end
