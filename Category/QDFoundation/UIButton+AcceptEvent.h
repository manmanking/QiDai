//
//  UIButton+AcceptEvent.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/14.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AcceptEvent)

/** 防止btn重复点击*/
@property (nonatomic, assign) NSTimeInterval qd_acceptEventInterval;   // 可以用这个给重复点击加间隔

/** 计时用的，无视*/
//@property (nonatomic, assign) NSTimeInterval qd_acceptEventTime;
@end
