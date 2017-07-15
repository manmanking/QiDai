//
//  PaymentHandler.m
//  QiDai
//
//  Created by manman'swork on 16/10/28.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "PaymentHandler.h"
#import "QDHttpTool.h"
#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import "PaymentManager.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation PaymentHandler




// 微信APP 支付
+ (void)paymentWeChat:(NSDictionary *)paymentParamaterDic andSuccessBlock:(SuccessPaymentHandlerBlock ) successBlock andFailureBlock:(FailurePaymentHandlerBlock )failureBlock
{

    [QDHttpTool getWithURL:kUrl_payWechat params:paymentParamaterDic success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //调起微信支付
        NSLog(@"WeChat pay response %@",responseObject);
        if (![responseObject[@"code"] isEqualToString:@"00"]) {
            failureBlock(NO,responseObject);
        }
        
        
        NSDictionary *requestParamater = [[NSDictionary alloc]initWithObjectsAndKeys:
                                          [responseObject[@"data"] objectForKey:@"partnerid"],@"partnerId",
                                          [responseObject[@"data"] objectForKey:@"prepayid"],@"prepayId",
                                          [responseObject[@"data"] objectForKey:@"noncestr"],@"nonceStr",
                                          [responseObject[@"data"] objectForKey:@"sign"],@"sign",nil];
        
        NSMutableString *timeStamp = [responseObject[@"data"] objectForKey:@"timestamp"];
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = kWeChatAPPID;
        req.partnerId           = [requestParamater objectForKey:@"partnerId"];//@"1344449701";//1344449701
        req.prepayId            = [requestParamater objectForKey:@"prepayId"];
        req.nonceStr            = [requestParamater objectForKey:@"nonceStr"];
        req.timeStamp           = timeStamp.intValue;
        req.package             = @"Sign=WXPay";
        req.sign                = [requestParamater objectForKey:@"sign"];
        
        [WXApi sendReq:req];
        NSLog(@"appid=%@\npartnerId=%@\nprepayId=%@\nnonceStr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[responseObject [@"data"] objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        successBlock(YES,nil);
    } failure:^(NSError *error) {
        NSLog(@"kUrl_payWechat%@",error);
        NSDictionary *errorDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"404",@"code",nil];
        failureBlock(NO,errorDic);
        
    }];
    
    
}

+ (void)paymentAlipay:(NSDictionary *)paymentParamaterDic andSuccessBlock:(SuccessPaymentHandlerBlock ) successBlock andFailureBlock:(FailurePaymentHandlerBlock )failureBlock
{

    
    [QDHttpTool getWithURL:kUrl_payWechat params:paymentParamaterDic success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //调起微信支付
        NSLog(@"WeChat pay response %@",responseObject);
        if (![responseObject[@"code"] isEqualToString:@"00"]) {
            failureBlock(NO,responseObject);
        }
            /*
             *商户的唯一的parnter和seller。
             *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
             */
            /*============================================================================*/
            /*=======================需要填写商户app申请的===================================*/
            /*============================================================================*/
            NSString *partner = kPayAliPayPartner;
            NSString *seller = kPayAliPaySeller;
            NSString *privateKey = kPayAliPayPrivateKey;

            
            /*
             *生成订单信息及签名
             */
            //将商品信息赋予AlixPayOrder的成员变量
            Order *order = [[Order alloc] init];
            order.partner = partner;
            order.sellerID = seller;
            order.outTradeNO = [paymentParamaterDic objectForKey:@"payOrderNo"]; //订单ID（由商家自行制定）
            order.subject = [paymentParamaterDic objectForKey:@"title"];//[NSString stringWithFormat:@"应支付%@",self.needPayMoney]; //商品标题
            order.body = [paymentParamaterDic objectForKey:@"detail"];//[NSString stringWithFormat:@"应支付%@",self.needPayMoney]; //商品描述
            //order.totalFee = [NSString stringWithFormat:@"0.01"]; //商品价格
            //#warning ---商品价格
            order.totalFee = [paymentParamaterDic objectForKey:@"totalAmount"];//self.needPayMoney; //商品价格
            //
            order.notifyURL = kUrl_payCallBack; //回调URL
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showURL = @"m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"QiDai";// 支付宝 回调APP
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            //NSLog(@"orderSpec = %@",orderSpec);
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                //NSLog(@"%@",orderString);
                // 启动支付宝  支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    // iOS 10 以上  支付完成 之后  回调 这里
                    // 支付宝 app 未安装  则从这 回调
                    NSLog(@"reslut aipay response  = %@",resultDic);
                    NSLog(@"do what you want with result --\n resullt %@", resultDic);
                    if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
                        if ([[PaymentManager sharedManager].delegate respondsToSelector:@selector(managerDidRecvSuccessInfo:)]) {
                            [[PaymentManager sharedManager].delegate managerDidRecvSuccessInfo:@"Success"];
                            
                        }
                        
                    }else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"6001"]){
                        
                        if ([[PaymentManager sharedManager].delegate respondsToSelector:@selector(managerDidRecvSuccessInfo:)]) {
                            [[PaymentManager sharedManager].delegate managerDidRecvFailureInfo:@"Failure2"];// 去掉操作
                            
                        }
                    }else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"4000"]){
                        if ([[PaymentManager sharedManager].delegate respondsToSelector:@selector(managerDidRecvSuccessInfo:)]) {
                            [[PaymentManager sharedManager].delegate managerDidRecvFailureInfo:@"Failure1"];
                            
                        }
                        
                    }

                    
                    
                }];
            }
        
    } failure:^(NSError *error) {
        NSLog(@"kUrl_payWechat%@",error);
        NSDictionary *errorDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"404",@"code",nil];
        failureBlock(NO,errorDic);
        
    }];
    
    
}



@end
