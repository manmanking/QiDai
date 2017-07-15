//
//  PaymentManager.h
//  QiDai
//
//  Created by manman'swork on 16/10/27.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"


@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvFailureInfo:(NSString *)isFailure;

- (void)managerDidRecvSuccessInfo:(NSString *)isSuccess;


@end

// 支付成功  block 回调
typedef void(^SuccessPayBlock)(NSString *isSuccess , NSDictionary *successDic);

//支付失败 block 回调
typedef void(^FailurePayBlock)(NSString *failureStr);



@interface PaymentManager : NSObject<WXApiDelegate>

//
//@property (nonatomic,strong)SuccessPayBlock *successPayBlock;
//
//@property (nonatomic,strong)FailurePayBlock *failurePayBlock;


@property (nonatomic,strong)id <WXApiManagerDelegate> delegate;


+(instancetype)sharedManager;

/**
 *  支付宝支付
 *
 *  @param aliResponse 回调
 */
- (void)payAliPay:(NSURL *) url;

@end
