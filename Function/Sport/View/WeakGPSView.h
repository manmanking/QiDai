//
//  WeakGPSView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  gps信号弱的view

#import <UIKit/UIKit.h>

@interface WeakGPSView : UIView

/** 点击继续*/
@property (nonatomic,copy) ClickView continueBlock;
/** 点击关闭*/
@property (nonatomic,copy) ClickView cancelBlock;

@end
