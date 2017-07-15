//
//  NSString+Tools.m
//  Leqi
//
//  Created by Tianyu on 15/1/7.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "NSString+Tools.h"
#import <CoreText/CoreText.h>
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@implementation NSString (Tools)

- (BOOL)isMobileNumberClassification {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((77|33|53|8[019])\\d|349|700)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSString * taiwan = @"^0(9)\\d{8}$";
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    NSPredicate *regextestTaiwan = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",taiwan];
    
    
    if (([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)
        || ([regextestphs evaluateWithObject:self] == YES)
        || ([regextestTaiwan evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)judgePassWordLegal{
    BOOL result = false;
    if ([self length] >= 6){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [self isEqualToString:filtered];
    
    return result&&basic;
}
/**
 *  判断字符串是否为空
 *
 *  @return YES非空 NO空
 */
- (BOOL)isExist {
    if (self == nil) {
        return NO;
    }
    
    if (self == NULL) {
        return NO;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    return YES;
}
+ (NSMutableAttributedString *)changFontWithString:(NSString *)string defaultFont:(NSInteger)defaultFont specifyFont:(NSInteger)specifyFont specifyRang:(NSRange)rang {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger newLoaction = rang.location+rang.length;
    NSInteger count = string.length;
    if (newLoaction > count) {
        return attributedString;
    }
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:defaultFont] range:NSMakeRange(0, rang.location)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:specifyFont] range:rang];
    
    if ( newLoaction < count) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:defaultFont] range:NSMakeRange(newLoaction, count - newLoaction)];
    }
    return attributedString;
}

+ (NSMutableAttributedString *)changFontWithString:(NSString *)string defaultFont:(NSInteger)defaultFont specifyFont:(NSInteger)specifyFont defaultColor:(UIColor *)defaultColor specifyColor:(UIColor *)specifyColor specifyRang:(NSRange)rang {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger newLoaction = rang.location+rang.length;
    NSInteger count = string.length;
    if (newLoaction > count) {
        return attributedString;
    }
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:defaultFont] range:NSMakeRange(0, rang.location)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:specifyFont] range:rang];
    
    if ( newLoaction < count) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:defaultFont] range:NSMakeRange(newLoaction, count - newLoaction)];
    }
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:defaultColor range:NSMakeRange(0,rang.location)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:specifyColor range:rang];
    if ( newLoaction < count) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:defaultColor range:NSMakeRange(newLoaction, count - newLoaction)];
    }
    return attributedString;
}

+ (NSMutableAttributedString *)changTitleColorWithString:(NSString *)string defaultColor:(UIColor *)defaultColor specifyColor:(UIColor *)specifyColor specifyRang:(NSRange)rang {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger newLoaction = rang.location + rang.length;
    NSInteger count = string.length;
    if (newLoaction > count) {
        return attributedString;
    }
    [attributedString addAttribute:NSForegroundColorAttributeName value:specifyColor range:rang];
    if ( newLoaction < count) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:defaultColor range:NSMakeRange(newLoaction, count - newLoaction)];
    }
    return attributedString;
}

// 调整字间距
+ (NSMutableAttributedString *)addLineSpacingWithString:(NSString *)string spacingSize:(CGFloat)spacingSize {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSDictionary * attris = @{NSKernAttributeName:@(spacingSize * SizeScale)
                              };
    
    [attributedString setAttributes:attris range:NSMakeRange(0,attributedString.length - 1)];
    return attributedString;
}

- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


+ (NSMutableAttributedString *)addHorizontalLineWithString:(NSString *)str
                                                     color:(UIColor *)color {
    NSUInteger length = [str length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    return attri;
}

- (BOOL)containsString:(NSString *)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

@end
