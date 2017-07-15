//
//  DataPickViewManager.h
//  PickView
//
//  Created by wenyang.wu on 14-8-19.
//  Copyright (c) 2014年 autonavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PickViewDefine.h"
#import <UIKit/UIKit.h>
@interface PickViewManager : NSObject



//DataPickView
+(void)datePickViewWithFrame:(CGRect)frame
                     current:(NSDate *)date
                   superView:(UIView *)superView
           okCompletionBlock:(DatePickViewcompletionBlock)okCompletionBlock
                 cancelBlock:(DatePickViewcompletionBlock)cancelCompletionBlock;




//CommonPick
+(void)commonPickViewWithFrame:(CGRect)frame
                     superView:(UIView *)superView
                  pickViewType:(PickViewType)pickViewType
                   currentData:(NSString *)currentData
             okCompletionBlock:(CommonPickViewcompletionBlock)okCompletionBlock
                   cancelBlock:(CommonPickViewcompletionBlock)cancelCompletionBlock;

@end
