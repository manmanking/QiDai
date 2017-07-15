//
//  UIButton+QDExtension.h
//  Leqi
//
//  Created by 张汇丰 on 15/12/21.
//  Copyright © 2015年 com.hoolai. All rights reserved.
//
//  快速创建button
#import <UIKit/UIKit.h>

typedef void(^TapButtonActionBlock) (UIButton *button);

@interface UIButton (QDExtension)

/**
 *  快速创建文字Button
 *
 *  @param frame           frame
 *  @param title           title
 *  @param titleColor      titleColor
 *  @param font            titleFont
 *  @param backgroundColor backgroundColor
 *  @param tapAction       点击事件
 *
 *  @return button
 */
+ (instancetype)qd_buttonTextButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                        titleColor:(UIColor *)titleColor
                         titleFont:(CGFloat )font
                   backgroundColor:(UIColor *)backgroundColor
                         tapAction:(TapButtonActionBlock)tapAction;

/**
 *   快速创建背景图片Button
 *
 *  @param frame       frame
 *  @param imageString 按钮的背景图片
 *  @param tapAction   回调
 */
+ (instancetype)qd_buttonImageButtonWithFrame:(CGRect)frame
                   NormalBackgroundImageString:(NSString *)imageString
                                     tapAction:(TapButtonActionBlock)tapAction;

/**
 *   快速创建图片Button
 *
 *  @param frame       frame
 *  @param imageString 按钮的背景图片
 *  @param tapAction   回调
 */
+ (instancetype)qd_buttonImageButtonWithFrame:(CGRect)frame NormalImageString:(NSString *)imageString tapAction:(TapButtonActionBlock)tapAction;

@end
