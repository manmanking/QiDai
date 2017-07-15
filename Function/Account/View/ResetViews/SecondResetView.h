//
//  SecondResetView.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickSureBtnBlock)(NSString *phone,NSString *password,NSString *code);

@interface SecondResetView : UIView

/** 手机号*/
@property (nonatomic,copy) NSString *phone;


@property (nonatomic,copy) ClickViewWithParameter clickGetCodeBtn;

@property (nonatomic,copy) ClickSureBtnBlock clickSureBtnBlock;

/** 定时器开启*/
- (void)timerCountDown;
@end
