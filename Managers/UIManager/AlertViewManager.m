//
//  AlertViewManager.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AlertViewManager.h"
#import <UIKit/UIKit.h>
#import "NSString+Tools.h"

@interface AlertViewManager ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (copy, nonatomic) AlertActionBlock alertActionBlock;
@property (copy, nonatomic) FirstBtnActionBlock firstBtnActionBlock;
@property (copy, nonatomic) SecondBtnActionBlock secondBtnActionBlock;

@property (strong, nonatomic) UITextField *textField;

@end

@implementation AlertViewManager

+ (instancetype)instance
{
    static id pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc] init];
    });
    return pRet;
}

- (void)showAlertView:(NSString *)title
          withMessage:(NSString *)message
          withCompate:(void(^)())compate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
    if (compate) {
        self.alertActionBlock = compate;
    }
    
    
    self.firstBtnActionBlock = nil;
    self.secondBtnActionBlock = nil;
    
}

- (void)showAlertView:(NSString *)title
          withMessage:(NSString *)message
   withFirstBtnAction:(void(^)())firstBtnAction
  withSecondBtnAction:(void(^)())secondBtnAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
    alertView.tintColor = [UIColor whiteColor];
    
    [alertView show];
    
    if (firstBtnAction) {
        self.firstBtnActionBlock = firstBtnAction;
    }else{
        self.firstBtnActionBlock = nil;
    }
    
    if (secondBtnAction) {
        self.secondBtnActionBlock = secondBtnAction;
    }else{
        self.secondBtnActionBlock = nil;
    }
}

- (void)showInputAlertView:(NSString *)title
               withMessage:(NSString *)message
                  withText:(NSString *)text
        withFirstBtnAction:(void(^)())firstBtnAction
       withSecondBtnAction:(void(^)(NSString *text))secondBtnAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    self.textField = nil;
    [alertView textFieldAtIndex:0].delegate = self;
    if ([text isExist]) {
        [alertView textFieldAtIndex:0].text = text;
    }
    self.textField = [alertView textFieldAtIndex:0];
    
    [alertView show];
    
    if (firstBtnAction) {
        self.firstBtnActionBlock = firstBtnAction;
    }else{
        self.firstBtnActionBlock = nil;
    }
    
    if (secondBtnAction) {
        self.secondBtnActionBlock = secondBtnAction;
    }else{
        self.secondBtnActionBlock = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if (self.alertActionBlock) {
            self.firstBtnActionBlock = nil;
            self.alertActionBlock();
        }
        
        if (self.secondBtnActionBlock) {
            self.secondBtnActionBlock(self.textField.text);
        }
        
    } else {
        
        if (self.firstBtnActionBlock) {
            self.alertActionBlock = nil;
            self.firstBtnActionBlock();
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (self.textField.text.length >= 100) {
            return NO;
        }
    }
    return YES;
}



/**
 *  系统提示信息  只有一个确认按钮
 *
 *  @param title
 *  @param message
 *  @param compate
 */
- (void)showCustomAlertView:(NSString *)title
                withMessage:(NSString *)message
                withCompate:(void(^)())compate
{
    
    
    
}

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
        withSecondBtnAction:(void(^)())secondBtnAction
{
    
    
}



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
             withSecondBtnAction:(void(^)(NSString *text))secondBtnAction
{
    
    
    
}




@end
