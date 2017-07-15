//
//  HttpTaskHomeManager.m
//  QiDai
//
//  Created by manman'swork on 16/11/7.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "HttpTaskHomeManager.h"
#import "MJExtension.h"
#import "QDHttpTool.h"
#import "OverTaskModel.h"
#import "OngoingTaskModel.h"
#import "UnstartTaskModel.h"
#import "NewTaskDetailModel.h"

@implementation HttpTaskHomeManager

+ (void)netGetTaskdataSources:(NSString *)userId andSuccessResponse:(NetSuccessBlock)successBlock andFailureResponse:(NetFailureBlock)failureBlcok
{
    
    
    //8a237a345787ea230157ad71748101a7 DEBUG
    NSDictionary *requestParamater = @{@"userInfoId":userId};
    
    [QDHttpTool getWithURL:kNewUrl_taskHome params:requestParamater success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"netGetTaskdataSources %@",responseObject);
        if ([responseObject[@"code" ] isEqualToString:@"00"]) {
            NSDictionary *taskData = responseObject[@"data"];
            NSArray *taskOverDataSource = nil;
            if ([taskData[@"over"] count] >0) {
               taskOverDataSource = [OverTaskModel mj_objectArrayWithKeyValuesArray:taskData[@"over"]];
            }
            NSArray *taskUnstartDataSource  = nil;
            if ([taskData[@"begin"] count] >0) {
                taskUnstartDataSource = [UnstartTaskModel  mj_objectArrayWithKeyValuesArray:taskData[@"begin"]];
            }
            NSArray *taskOngoingDataSource = nil;
            if ([taskData[@"ing"] count] >0) {
                  taskOngoingDataSource  = [OngoingTaskModel  mj_objectArrayWithKeyValuesArray:taskData[@"ing"]];
            }
            NSMutableDictionary *resultDicM = [[NSMutableDictionary alloc]initWithCapacity:3];
         
            if (taskOverDataSource.count>0) {
                [resultDicM setObject:taskOverDataSource forKey:@"over"];
            }
            if (taskUnstartDataSource.count>0) {
                [resultDicM setObject:taskUnstartDataSource forKey:@"unstart"];
            }
            if (taskOngoingDataSource.count>0) {
                [resultDicM setObject:taskOngoingDataSource forKey:@"ongoing"];
            }
//            NSDictionary *resultDic = @{@"over":taskOverDataSource,
//                                        @"unstart":taskUnstartDataSource,
//                                        @"ongoing":taskOngoingDataSource
//                                        };
            successBlock(YES,resultDicM);

        }else
        {
            NSDictionary *errInfo = @{@"errorMessage":responseObject[@"message"],
                                      @"errorCode":@"01"};
            failureBlcok(NO,errInfo);
        }

    } failure:^(NSError *error) {
        NSDictionary *errInfo = @{@"errorMessage":error.userInfo[@"NSLocalizedDescription"],
                                  @"errorCode":@"404"};
        failureBlcok(NO,errInfo);
    }];
    
}



+ (void)netGetTaskDetaildataSources:(NSDictionary *)requestparamater andSuccessResponse:(NetSuccessBlock)successBlock andFailureResponse:(NetFailureBlock)failureBlcok
{
    [QDHttpTool getWithURL:kNewUrl_taskDetail params:requestparamater success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"response %@",responseObject);
        if ([responseObject[@"code" ] isEqualToString:@"00"]) {
            
            NewTaskDetailModel *newTaskDetailmodel = [NewTaskDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            
            NSDictionary *resultDic = @{@"taskDetail":newTaskDetailmodel
                                        };
            
            successBlock(YES,resultDic);
            
        }else
        {
            NSDictionary *errInfo = @{@"errorMessage":responseObject[@"message"],
                                      @"errorCode":responseObject[@"code"]};
            failureBlcok(NO,errInfo);
        }
        
        
    } failure:^(NSError *error) {
        
        NSDictionary *errInfo = @{@"errorMessage":error.userInfo[@"NSLocalizedDescription"],
                                  @"errorCode":@"404"};
        failureBlcok(NO,errInfo);
    }];
    

}

+ (void)netGetBillStatus:(NSString *)userId andSuccessResponse:(NetSuccessBlock)successBlock andFailureResponse:(NetFailureBlock)failureBlcok
{
     //8a237a345787ea230157ad717481 DEBUG
     NSDictionary *requestParamater = @{@"userInfoId":userId};
    
    [QDHttpTool getWithURL:kNewUrl_taskState params:requestParamater success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"response %@",responseObject);
        if ([responseObject[@"code" ] isEqualToString:@"00"]) {
            
            
            successBlock(YES,responseObject);
            
        }else
        {
            NSDictionary *errInfo = @{@"errorMessage":responseObject[@"message"],
                                      @"errorCode":responseObject[@"code"]};
            failureBlcok(NO,errInfo);
        }
        
        
    } failure:^(NSError *error) {
        NSDictionary *errInfo = @{@"errorMessage":error.userInfo[@"NSLocalizedDescription"],
                                  @"errorCode":@"404"};
        failureBlcok(NO,errInfo);
    }];
    

    
    
}


@end
