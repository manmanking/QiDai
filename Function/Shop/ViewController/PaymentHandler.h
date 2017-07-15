//
//  PaymentHandler.h
//  QiDai
//
//  Created by manman'swork on 16/10/28.
//  Copyright © 2016年 manman. All rights reserved.
//
#import "QDHttpTool.h"

#import <Foundation/Foundation.h>


// 失败的回调
typedef void(^FailurePaymentHandlerBlock)(BOOL isSuccess , NSDictionary *paramaterDic);

//成功的回调
typedef void(^SuccessPaymentHandlerBlock)(BOOL isSuccess , NSDictionary *responseObject);

@interface PaymentHandler : NSObject


// 微信APP 支付
+ (void)paymentWeChat:(NSDictionary *)paymentParamaterDic andSuccessBlock:(SuccessPaymentHandlerBlock ) SuccessBlock andFailureBlock:(FailurePaymentHandlerBlock )failureBlock;

//支付宝 支付
+ (void)paymentAlipay:(NSDictionary *)paymentParamaterDic andSuccessBlock:(SuccessPaymentHandlerBlock ) successBlock andFailureBlock:(FailurePaymentHandlerBlock )failureBlock;
@end
