//
//  PaymentManager.m
//  QiDai
//
//  Created by manman'swork on 16/10/27.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "PaymentManager.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation PaymentManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PaymentManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PaymentManager alloc] init];
    });
    return instance;
}






#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
  if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
      
        switch (resp.errCode) {
            case WXSuccess:
                //strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                //self.successPayBlock(@"Success",nil);
                if ([self.delegate respondsToSelector:@selector(managerDidRecvSuccessInfo:)]) {
                    [self.delegate managerDidRecvSuccessInfo:@"Success"];
                }
                break;

                
          case  WXErrCodeUserCancel:
                // 去掉操作
                //strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                //NSDictionary *dic = @{[NSNumber numberWithInt:resp.errCode]:@"errCode"};//[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:,nil];
                if ([self.delegate respondsToSelector:@selector(managerDidRecvFailureInfo:)]) {
                    [self.delegate managerDidRecvFailureInfo:@"Failure2"];
                }
                break;
                
                
                
            default:
                //strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                //NSDictionary *dic = @{[NSNumber numberWithInt:resp.errCode]:@"errCode"};//[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:,nil];
                if ([self.delegate respondsToSelector:@selector(managerDidRecvFailureInfo:)]) {
                    [self.delegate managerDidRecvFailureInfo:@"Failure1"];
                }
                break;
                
                
                
                
                
                //                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"支付失败" otherButtonTitles:nil, nil];
                //                [alert show];
              
        }
        // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //[alert show];
    }
    
}



- (void)payAliPay:(NSURL *) url;
{
    
    if ([url.host isEqualToString:@"safepay"]) {

        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"do what you want with result --\n resullt %@", resultDic);
             if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
                 if ([self.delegate respondsToSelector:@selector(managerDidRecvSuccessInfo:)]) {
                     [self.delegate managerDidRecvSuccessInfo:@"Success"];
                     
                 }
                 
             }else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"6001"]){

                 if ([self.delegate respondsToSelector:@selector(managerDidRecvSuccessInfo:)]) {
                     [self.delegate managerDidRecvFailureInfo:@"Failure2"];// 去掉操作
                     
                 }
             }else if([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"4000"]){
                 if ([self.delegate respondsToSelector:@selector(managerDidRecvSuccessInfo:)]) {
                     [self.delegate managerDidRecvFailureInfo:@"Failure1"];
                     
                 }
                 
             }
             
         }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]) {
        [[AlipaySDK defaultService]
         processAuthResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"do what you want with result --\n result %@", resultDic);
         }];
    }
    
    
}



@end
