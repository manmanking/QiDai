//
//  SynchronizeRidingRecordManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  同步数据

#import "SynchronizeRidingRecordManager.h"
#import "AFNetworking.h"
#import "LoginManager.h"
#import "ItemModel.h"
#import "SportModel.h"
#import "zip.h"
#import "ZipArchive.h"

@interface SynchronizeRidingRecordManager()

@property (nonatomic,assign) BOOL isSuccess;

@end


@implementation SynchronizeRidingRecordManager
+ (void)uploadRidingRecord:(SportModel *)sportModel pictureArray:(NSArray *)arr
                   success:(void(^)(NSDictionary *result))success
                   failure:(void(^)())failure{
    NSString *url = [NSString stringWithFormat:@"%@?",kUrl_addRidingRecord];
    
    for (int i= 0; i<arr.count; i++) {
        NSString *str = arr[i];
        NSArray *array = [str componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
        NSString *string = array[array.count -1];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@fileName=%@",url,string];
        }else{
            url = [NSString stringWithFormat:@"%@&fileName=%@",url,string];
        }
    }
    
    NSDictionary *dict = [sportModel dictionary];
    
    [[AFHTTPSessionManager manager] GET:url parameters:dict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"---%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"00"]) {
                Clog(@"uploadRidingRecord  success");
                if (success) {
                    //NSString *rideId = responseObject[@"id"];
                    success(responseObject);
                }
            } else {
                Clog(@"uploadRidingRecord  failure");
                if (failure) {
                    failure();
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        Clog(@"uploadRidingRecord  failure");
        if (failure) {
            failure();
        }
    }];
    
    //url = [NSString stringWithFormat:@"%@&%@",url,[sportModel string]];
    
//    NSString *url = [NSString stringWithFormat:@"%@/",kUrl_addRidingRecord];
//
//    for (int i= 0; i<arr.count; i++) {
//        NSString *str = arr[i];
//        NSArray *array = [str componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
//        NSString *string = array[array.count -1];
//        if (i == 0) {
//            url = [NSString stringWithFormat:@"%@fileName=%@",url,string];
//        }else{
//            url = [NSString stringWithFormat:@"%@/fileName=%@",url,string];
//        }
//    }
//
//    NSDictionary *dict = [sportModel dictionary];
//    
//    [[AFHTTPSessionManager manager] POST:kUrl_addRidingRecord parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            if ([responseObject[@"code"] isEqualToString:@"00"]) {
//                Clog(@"uploadRidingRecord  success");
//                if (success) {
//                    //NSString *rideId = responseObject[@"id"];
//                    success(responseObject);
//                }
//            } else {
//                Clog(@"uploadRidingRecord  failure");
//                if (failure) {
//                    failure();
//                }
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure();
//        }
//    }];
}

+ (void)loadRidingRecordWithUserId:(NSString *)userId
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endtime
                           success:(void(^)(NSArray *dataList))success
                           failure:(void(^)())failure{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if ([userId isExist]) {
        [dict setValue:userId forKey:@"userId"];
    }
    if ([startTime isExist]) {
        [dict setValue:startTime forKey:@"startTime"];
    }
    if ([endtime isExist]) {
        [dict setValue:endtime forKey:@"endTime"];
    }
    
    [[AFHTTPSessionManager manager] GET:kUrl_loadRidingRecord parameters:dict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([responseObject[@"code"] isEqualToString:@"00"]) {
                
                QDLog(@"loadRidingRecord  success");
                if (success) {
                    
                    if ([[responseObject objectForKey:@"dataList"] isKindOfClass:[NSArray class]]) {
                        NSArray *tempList = [responseObject objectForKey:@"dataList"];
                        if ([tempList count]>0) {
                            NSMutableArray *resultList = [[NSMutableArray alloc] init];
                            for (NSDictionary *dict in tempList) {
                                SportModel *sportModel = [[SportModel alloc] initWithDictionary:dict];
                                [resultList addObject:sportModel];
                            }
                            success(resultList);
                        }else{
                            success(nil);
                        }
                    }
                }
            } else {
                Clog(@"loadRidingRecord  failure");
                if (failure) {
                    failure();
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        Clog(@"loadRidingRecord  failure");
        if (failure) {
            failure();
        }
    }];
}


+ (void)loadAllRidingRecordWithUserId:(NSString *)userId success:(void (^)(NSArray *))success failure:(void (^)())failure{
    [SynchronizeRidingRecordManager loadRidingRecordWithUserId:userId startTime:nil endTime:nil success:success failure:failure];
}


/**
 *  更改  将kUrl_getAllRidingRecord 这个接口修改为kUrl_qqGetMyInfo 这个获取我的页面的信息
 *
 *  @param userId
 *  @param success
 *  @param failure 
 */
+ (void)getAllRidingRecordWithUserId:(NSString *)userId
                            success:(void(^)(NSDictionary *dataList))success
                            failure:(void(^)())failure{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if ([userId isExist]) {
        [dict setValue:userId forKey:@"userId"];
    }
    
    //kUrl_qqGetMyInfo   kUrl_getAllRidingRecord
    [[AFHTTPSessionManager manager] GET:kUrl_qqGetMyInfo parameters:dict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"qqGetMyInfo:%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([responseObject[@"code"] isEqualToString:@"00"]) {
                
                Clog(@"loadRidingRecord  success");
                if (success) {
                    
                    if ([[responseObject objectForKey:@"total"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *tempList = [responseObject objectForKey:@"total"];
                        success(tempList);
                    }
                }
            } else {
                Clog(@"loadRidingRecord  failure");
                if (failure) {
                    failure();
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        Clog(@"loadRidingRecord  failure");
        if (failure) {
            failure();
        }
    }];
    
}



@end
