//
//  HistoryNetworkingManager.m
//  QiDai
//
//  Created by manman'swork on 16/11/15.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "HistoryNetworkingManager.h"
#import "QDHttpTool.h"

@implementation HistoryNetworkingManager


+ (void)networkingGetRidingRecordDataSource:(NSString *) userId andSuccessBlock:(NetSuccessBlock) successBlock andFailureBlock:(NetFailureBlock) failureBlock
{
       NSDictionary *requestParamater = @{@"userId":userId};
    [QDHttpTool getWithURL:kUrl_historyGetHistory params:requestParamater success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"response %@",responseObject);
        if ([responseObject[@"code" ] isEqualToString:@"00"]) {
            
            
//            
//            NSDictionary *resultDic = @{@"taskDetail":newTaskDetailmodel
//                                        };
//            
//            successBlock(YES,resultDic);
            
        }else
        {
            NSDictionary *errInfo = @{@"errorMessage":responseObject[@"message"],
                                      @"errorCode":responseObject[@"code"]};
            failureBlock(NO,errInfo);
        }
        
        
    } failure:^(NSError *error) {
        NSDictionary *errInfo = @{@"errorMessage":error.userInfo[@"NSLocalizedDescription"],
                                  @"errorCode":@"404"};
        failureBlock(NO,errInfo);
    }];
    
    
}
@end
