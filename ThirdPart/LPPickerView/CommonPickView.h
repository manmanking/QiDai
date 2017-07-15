//
//  CommonPickView.h
//  PickView
//
//  Created by wenyang.wu on 14-8-19.
//  Copyright (c) 2014年 autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickViewDefine.h"
@interface CommonPickView : UIView
@property (copy,nonatomic) CommonPickViewcompletionBlock okCompletionBlock;
@property (copy,nonatomic) CommonPickViewcompletionBlock cancelCompletionBlock;

-(id)initWithFrame:(CGRect)frame
      pickViewType:(PickViewType)pickViewType
       currentData:(NSString *)dataString
 okCompletionBlock:(CommonPickViewcompletionBlock)okCompletionBlock
       cancelBlock:(CommonPickViewcompletionBlock)cancelCompletionBlock;

- (void)show;
@end
