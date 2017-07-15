//
//  DatePickView.h
//  PickView
//
//  Created by wenyang.wu on 14-8-19.
//  Copyright (c) 2014年 autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PickViewDefine.h"
@interface DatePickView : UIView

@property (copy,nonatomic) DatePickViewcompletionBlock okCompletionBlock;
@property (copy,nonatomic) DatePickViewcompletionBlock cancelCompletionBlock;

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date okCompletionBlock:(DatePickViewcompletionBlock)okCompletionBlock cancelBlock:(DatePickViewcompletionBlock)cancelCompletionBlock;
- (void)show;
@end
