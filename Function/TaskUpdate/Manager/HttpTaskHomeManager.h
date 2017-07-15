//
//  HttpTaskHomeManager.h
//  QiDai
//
//  Created by manman'swork on 16/11/7.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetSuccessBlock)(BOOL isSuccess,NSDictionary *response);

typedef void(^NetFailureBlock)(BOOL isSuccess,NSDictionary *response);



@interface HttpTaskHomeManager : NSObject


+ (void)netGetTaskdataSources:(NSString *)userId andSuccessResponse:(NetSuccessBlock)successBlock andFailureResponse:(NetFailureBlock)failureBlcok;


+ (void)netGetTaskDetaildataSources:(NSDictionary *)requestparamater andSuccessResponse:(NetSuccessBlock)successBlock andFailureResponse:(NetFailureBlock)failureBlcok;

+ (void)netGetBillStatus:(NSString *)userId andSuccessResponse:(NetSuccessBlock)successBlock andFailureResponse:(NetFailureBlock)failureBlcok;

@end
