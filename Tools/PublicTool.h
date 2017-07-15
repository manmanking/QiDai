//
//  PublicTool.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicTool : NSObject

/**
 *  获取一个随机整数，范围在[from,to），包括from，包括to
 *
 *  @param from 最小范围值
 *  @param to   最大范围值
 *
 *  @return 随机数结果
 */
+ (double)getRandomNumber:(int)from to:(int)to;

/**
 *  两个浮点数比大小返回较大的数
 *
 *  @param value1
 *  @param value2
 *
 *  @return 较大的数
 */
+ (double)geFastestWithValue1:(double)value1 withValue2:(double)value2;

/**
 *  获取两个数的差值
 *
 *  @param firstValue  减数
 *  @param secondValue 被减数
 *
 *  @return 差值（可正可负）
 */
+ (double)getDValueWithFirstValue:(double)firstValue withSecondValue:(double)secondValue;

/**
 *  int型转换成时间格式
 *
 *  @param value
 *
 *  @return 00:00:00
 */
+ (NSString *)getFormatTimeWithValue:(int)value;

/**
 *  判断是否是3.5寸设备
 *
 */
+ (BOOL)isIphone4;

/**
 *  截屏功能
 *
 *  @param view 要截屏的View
 *
 *  ios7以后可以用系统提供的api
 *  - (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates *是否立即生成快照*
 */
+ (UIImage *)captureImageFromeView:(UIView *)view;

/**
 *  获得当前的时间字符串
 *
 *  @param formalStr 时间的格式
 *
 *  @return 
 */
+ (NSString *)getCurrentTimeStrFormat:(NSString *)formalStr;


/**
 *  比较两个时间的间隔
 *
 *  @param lastDate
 *  @param expiredDate
 *
 *  @return 返回的集合  包含年间隔 月间隔 日间隔 等时间单位的间隔
 */
+ (NSDateComponents *)intervalFromLastDate:(NSDate *)lastDate AndExpiredDate:(NSDate *)expiredDate;


/**
 *  时间戳转字符串
 *
 */
+ (NSString *)dataConvertTime:(double)time withConcertStr:(NSString *)str;

/**
 *  根据NSData返回字符串
 *
 *  @param date   日期时间
 *  @param format 格式
 *
 *  @return 字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

/**
 *  根据字符串返回NSData
 *
 *  @param dateString 日期的字符串
 *  @param format     格式
 *
 *  @return NSData
 */
+ (NSDate *)dateFromString:(NSString*)dateString  format:(NSString *)format;


+ (NSString *)timeStringFromTimeSecond:(NSInteger)timeSecond;

+ (CGSize)sizeWithFont:(UIFont*)tFont constrainedToSize:(CGSize)consize text:(NSString *)text;

/**
 *  拼接长图
 *
 *  @param imgAry 拼接底层图片的数组
 *  @param text   水印文字
 *
 *  @return 拼接后的图片
 */
+ (UIImage *)combineWithSubstrateImgAry:(NSArray *)imgAry withText:(NSString *)text;


/**
 *  10进制转16进制
 */

+ (NSString *) turn10to16:(NSString *)str;


/**
 *  16进制转10进制
 */
+ (NSString *) turn16to10:(NSString *)str;

/**
 *  int转换成2字节byte
 */
+ (NSData *)turnIntTo2Bytes:(int)intValue;


/**
 *  16进制data转字符串
 */
+ (NSString*)hexStringForData:(NSData*)data;


/**
 *  16进制字符串转data
 */
+ (NSData*)dataForHexString:(NSString*)hexString;

/**
 *  计算文本高度
 */
//+ (CGSize)getTextHeightWithText:(NSString *)text
//                           font:(UIFont *)font
//                           size:(CGSize)size;

/**
 *  模糊
 */
+(UIImage *)fuzzyImage:(UIImage *)image;

@end
