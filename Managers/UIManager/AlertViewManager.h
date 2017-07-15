//
//  AlertViewManager.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlertActionBlock)(void);
typedef void(^FirstBtnActionBlock)(void);
typedef void(^SecondBtnActionBlock)(NSString *text);

@interface AlertViewManager : NSObject

+ (instancetype)instance;

/**
 *  系统提示信息  只有一个确认按钮
 *
 *  @param title
 *  @param message
 *  @param compate
 */
- (void)showAlertView:(NSString *)title
          withMessage:(NSString *)message
          withCompate:(void(^)())compate;

/**
 *  系统提示信息  有两个按钮 一个取消 一个确定 按钮
 *
 *  @param title
 *  @param message
 *  @param firstBtnAction
 *  @param secondBtnAction
 */
- (void)showAlertView:(NSString *)title
          withMessage:(NSString *)message
   withFirstBtnAction:(void(^)())firstBtnAction
  withSecondBtnAction:(void(^)())secondBtnAction;



/**
 *  系统的提示信息   有一个可以输入框  两个按钮
 *
 *  @param title
 *  @param message
 *  @param text
 *  @param firstBtnAction
 *  @param secondBtnAction
 */
- (void)showInputAlertView:(NSString *)title
               withMessage:(NSString *)message
                  withText:(NSString *)text
        withFirstBtnAction:(void(^)())firstBtnAction
       withSecondBtnAction:(void(^)(NSString *text))secondBtnAction;

#warning 下面的提示信息 都是自定义的视图

/**
 *  系统提示信息  只有一个确认按钮
 *
 *  @param title
 *  @param message
 *  @param compate
 */
- (void)showCustomAlertView:(NSString *)title
          withMessage:(NSString *)message
          withCompate:(void(^)())compate;

/**
 *  系统提示信息  有两个按钮 一个取消 一个确定 按钮
 *
 *  @param title
 *  @param message
 *  @param firstBtnAction
 *  @param secondBtnAction
 */
- (void)showCustomAlertView:(NSString *)title
          withMessage:(NSString *)message
   withFirstBtnAction:(void(^)())firstBtnAction
  withSecondBtnAction:(void(^)())secondBtnAction;



/**
 *  系统的提示信息   有一个可以输入框  两个按钮
 *
 *  @param title
 *  @param message
 *  @param text
 *  @param firstBtnAction
 *  @param secondBtnAction
 */
- (void)showCustomInputAlertView:(NSString *)title
               withMessage:(NSString *)message
                  withText:(NSString *)text
        withFirstBtnAction:(void(^)())firstBtnAction
       withSecondBtnAction:(void(^)(NSString *text))secondBtnAction;



@end
