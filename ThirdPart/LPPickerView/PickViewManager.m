//
//  DataPickViewManager.m
//  PickView
//
//  Created by wenyang.wu on 14-8-19.
//  Copyright (c) 2014年 autonavi. All rights reserved.
//

#import "PickViewManager.h"
#import "DatePickView.h"
#import "CommonPickView.h"
@implementation PickViewManager

+(void)datePickViewWithFrame:(CGRect)frame
                 current:(NSDate *)date
               superView:(UIView *)superView
       okCompletionBlock:(DatePickViewcompletionBlock)okCompletionBlock
                 cancelBlock:(DatePickViewcompletionBlock)cancelCompletionBlock{
    
    DatePickView *datePick = [[DatePickView alloc] initWithFrame:frame
                                                            date:date
                                               okCompletionBlock:okCompletionBlock
                                                     cancelBlock:cancelCompletionBlock];
    [superView addSubview:datePick];
    [datePick show];
}


+(void)commonPickViewWithFrame:(CGRect)frame
                     superView:(UIView *)superView
                  pickViewType:(PickViewType)pickViewType
                   currentData:(NSString *)currentData
             okCompletionBlock:(CommonPickViewcompletionBlock)okCompletionBlock
                   cancelBlock:(CommonPickViewcompletionBlock)cancelCompletionBlock{
    
    CommonPickView *commomPick = [[CommonPickView alloc] initWithFrame:frame
                                                          pickViewType:pickViewType
                                                           currentData:currentData
                                                     okCompletionBlock:okCompletionBlock
                                                           cancelBlock:cancelCompletionBlock];
    [superView addSubview:commomPick];
    [commomPick show];
}

@end
