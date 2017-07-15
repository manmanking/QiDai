//
//  NSString+Tools.h
//  Leqi
//
//  Created by Tianyu on 15/1/7.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

/**
 *  手机号正则判断
 *
 *  @return YES_是手机号 NO_非手机号
 */
- (BOOL)isMobileNumberClassification;


/** 判断密码逻辑*/
- (BOOL)judgePassWordLegal;

/**
 *  判断字符串是否为空
 *
 *  @return YES非空 NO空
 */
- (BOOL)isExist;

/**
 *  根据字符串创建字体不同的str    --需要*比例系数
 *
 *  @param string      传入的str
 *  @param defaultFont 默认字体
 *  @param specifyFont 特殊字体
 *  @param rang        特殊字体的rang
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)changFontWithString:(NSString *)string defaultFont:(NSInteger)defaultFont specifyFont:(NSInteger)specifyFont specifyRang:(NSRange)rang;


/**
 *  根据字符串创建字体颜色不同和字体大小不同的str  --需要*比例系数
 *
 *  @param string      传入的str
 *  @param defaultFont 默认字体
 *  @param specifyFont 特殊字体
 *  @param defaultFont 默认字体颜色
 *  @param specifyFont 特殊字体颜色
 *  @param rang        特殊字体的rang
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)changFontWithString:(NSString *)string defaultFont:(NSInteger)defaultFont specifyFont:(NSInteger)specifyFont defaultColor:(UIColor *)defaultColor specifyColor:(UIColor *)specifyColor specifyRang:(NSRange)rang;

/**
 *  根据字符串创建颜色不同的str --需要*比例系数
 *
 *  @param string       传入的str
 *  @param defaultFont  默认字体颜色
 *  @param specifyFont  特殊字体颜色
 *  @param rang          *  @param defaultFont 默认字体颜色
 *  @param specifyFont 特殊字体颜色
 *
 *  @return  *  @param defaultFont 默认字体颜色
 *  @param specifyFont 特殊字体颜色
 */
+ (NSMutableAttributedString *)changTitleColorWithString:(NSString *)string defaultColor:(UIColor *)defaultColor specifyColor:(UIColor *)specifyColor specifyRang:(NSRange)rang;

/**
 *  调整字间距  --不需要*比例系数
 *
 *  @param string      label的text
 *  @param spacingSize 间距
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)addLineSpacingWithString:(NSString *)string spacingSize:(CGFloat)spacingSize;


/**
 *  邮箱正则判断
 *
 *  @return YES_是 NO_非
 */
- (BOOL)isValidateEmail;
/**  添加一个横线
 @param str 需要修改的str
 */
/**
 *  添加一个横线
 *
 *  @param str   需要修改的str
 *  @param color 颜色
 *
 *  @return 加横线的富文本
 */
+ (NSMutableAttributedString *)addHorizontalLineWithString:(NSString *)str
                                                     color:(UIColor *)color;

- (BOOL)containsString:(NSString *)other;


@end
