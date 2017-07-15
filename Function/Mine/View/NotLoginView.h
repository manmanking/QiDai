//
//  NotLoginView.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//
//  没有登录
#import <UIKit/UIKit.h>

@protocol NotLoginViewDelegate <NSObject>

- (void)clickLoginBtn;

- (void)clickRegisterBtn;

@end

@interface NotLoginView : UIView

@property (nonatomic,weak) id<NotLoginViewDelegate>delegate;

@end
