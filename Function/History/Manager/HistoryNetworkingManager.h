//
//  HistoryNetworkingManager.h
//  QiDai
//
//  Created by manman'swork on 16/11/15.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^NetSuccessBlock)(BOOL isSuccess,NSDictionary *response);

typedef void(^NetFailureBlock)(BOOL isSuccess,NSDictionary *response);

@interface HistoryNetworkingManager : NSObject


+ (void)networkingGetRidingRecordDataSource:(NSString *) userId andSuccessBlock:(NetSuccessBlock) successBlock andFailureBlock:(NetFailureBlock) failureBlock;

@end
