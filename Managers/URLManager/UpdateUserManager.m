//
//  UpdateUserManager.m
//  Leqi
//
//  Created by Tianyu on 15/1/27.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "UpdateUserManager.h"
#import "LoginManager.h"
#import "AFNetworking.h"

#import "UserInfoModel.h"
#import "NSString+Tools.h"

@implementation UpdateUserManager

+ (void)updateUser:(UserInfoModel *)userInfoModel
           compate:(void (^)(BOOL, NSString *, NSDictionary *))compate
{
    [UpdateUserManager updateUserWithTelephone:userInfoModel.phoneNo
                                     withEmail:userInfoModel.email
                                  withNickName:userInfoModel.nickName
                                    withGender:userInfoModel.gender
                                    withHeight:userInfoModel.height
                                    withWeight:userInfoModel.weight
                                  withBirthday:userInfoModel.birthday
                                     foreImage:userInfoModel.foreImg
                               withBicycleName:userInfoModel.bicycleName
                                   withFitting:userInfoModel.fitting
                                withBicycleImg:userInfoModel.bicycleImg
                                       compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                                           
                                           if (isSuccess) {
                                               
                                               if (compate) {
                                                   compate(YES, nil, result);
                                               }
                                               
                                           } else {
                                           
                                               if (compate) {
                                                   compate(NO, errStr, nil);
                                               }
                                               
                                           }
                                           
                                       }];
}

+ (void)updateUserWithTelephone:(NSString *)telephone
                      withEmail:(NSString *)email
                   withNickName:(NSString *)nickName
                     withGender:(NSNumber *)gender
                     withHeight:(NSNumber *)height
                     withWeight:(NSNumber *)weight
                   withBirthday:(NSNumber *)birthday
                      foreImage:(NSString *)foreImg
                withBicycleName:(NSString *)bicycleName
                    withFitting:(NSString *)fitting
                 withBicycleImg:(NSString *)bicycleImg
                        compate:(void (^)(BOOL, NSString *, NSDictionary *))compate
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[[LoginManager instance] getUserId] forKey:@"id"];
    if ([telephone isExist]) {
        [userInfo setObject:telephone forKey:@"phoneNo"];
    }
    if ([email isExist]) {
        [userInfo setObject:email forKey:@"email"];
    }
    if ([nickName isExist]) [userInfo setObject:nickName forKey:@"nickName"];
    if ([foreImg isExist]) [userInfo setObject:foreImg forKey:@"foreImg"];
    [userInfo setObject:[gender stringValue] forKey:@"gender"];
    [userInfo setObject:[height stringValue] forKey:@"height"];
    [userInfo setObject:[weight stringValue] forKey:@"weight"];
    [userInfo setObject:[birthday stringValue] forKey:@"birthday"];
    
    NSMutableDictionary *bicycle = [[NSMutableDictionary alloc] init];
    if ([bicycleName isExist]) [bicycle setObject:bicycleName forKey:@"name"];
    if ([fitting isExist]) [bicycle setObject:fitting forKey:@"fitting"];
    if ([bicycleImg isExist]) [bicycle setObject:bicycleImg forKey:@"imgUrl"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"userInfo":userInfo,
                                 @"bicycle":bicycle}];
    
    
    //NSDictionary *parame = @{@"enString":[dic JSONString]};
    
    
//    NSError *error = nil;
//    NSData *parame = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parame = @{@"enString":jsonString};
    
    [[AFHTTPSessionManager manager] GET:kUrl_updUser parameters:parame progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"00"]) {
                if (compate) {
                    compate(YES, nil, responseObject);
                }
            } else {
                if (compate) {
                    compate(NO, responseObject[@"message"], nil);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (compate) {
            compate(NO, @"网络连接失败，请稍后再试", nil);
        }
    }];
}

@end
