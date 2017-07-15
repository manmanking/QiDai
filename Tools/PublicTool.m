//
//  PublicTool.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PublicTool.h"
#import "sys/utsname.h"

@implementation PublicTool

/**
 *  获取一个随机整数，范围在[from,to），包括from，包括to
 *
 *  @param from 最小范围值
 *  @param to   最大范围值
 *
 *  @return 随机数结果
 */
+ (double)getRandomNumber:(int)from to:(int)to
{
    return (double)(from + (arc4random() % (to - from + 1)));
}


/**
 *  两个浮点数比大小返回较大的数
 *
 *  @param value1
 *  @param value2
 *
 *  @return 较大的数
 */
+ (double)geFastestWithValue1:(double)value1 withValue2:(double)value2
{
    if (value1 > value2) {
        return value1;
    } else if (value2 > value1) {
        return value2;
    } else {
        return value2;
    }
}


/**
 *  获取两个数的差值
 *
 *  @param firstValue  减数
 *  @param secondValue 被减数
 *
 *  @return 差值（可正可负）
 */
+ (double)getDValueWithFirstValue:(double)firstValue withSecondValue:(double)secondValue
{
    return firstValue - secondValue;
}

/**
 *  int型转换成时间格式
 *
 *  @param value
 *
 *  @return 00:00:00
 */
+ (NSString *)getFormatTimeWithValue:(int)value
{
    if (value > 0) {
        NSString *result = @"";
        int hour = 0,minute = 0,second = 0;
        
        hour = value/3600;
        value = value%3600;
        minute = value/60;
        second = value%60;
        
        NSString *hourStr = !(hour < 10) ? [NSString stringWithFormat:@"%d",hour] : [NSString stringWithFormat:@"0%d",hour];
        NSString *minuteStr = !(minute < 10) ? [NSString stringWithFormat:@"%d",minute] : [NSString stringWithFormat:@"0%d",minute];
        NSString *secondStr = !(second < 10) ? [NSString stringWithFormat:@"%d",second] : [NSString stringWithFormat:@"0%d",second];
        
        result = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondStr];
        
        return result;
    }else{
        
        return @"00:00:00";
    }
}

/**
 *  判断是否是3.5寸设备
 *
 */
+ (BOOL)isIphone4
{
    struct utsname u;
    uname(&u);
    NSString *machine = [NSString stringWithCString:u.machine encoding:NSUTF8StringEncoding];
    if ([machine isEqualToString:@"iPhone3,1"] || [machine isEqualToString:@"iPhone4,1"] || [machine isEqualToString:@"iPhone3,3"]) {
        return YES;
    }
    return NO;
    
}

/**
 *  截屏功能
 *
 *  @param view 要截屏的View
 *
 *  ios7以后可以用系统提供的api
 *  - (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates *是否立即生成快照*
 */
+ (UIImage *)captureImageFromeView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  时间戳转字符串
 *
 */
+ (NSString *)dataConvertTime:(double)time withConcertStr:(NSString *)str
{
    NSDateFormatter *formatter;
    NSDate *temp;
    temp = [NSDate dateWithTimeIntervalSince1970:time];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:str];
    return [formatter stringFromDate:temp];
}


+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
    
}

+ (NSDate *)dateFromString:(NSString*)dateString  format:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];//设置时区
    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
    
}


+ (NSString *)timeStringFromTimeSecond:(NSInteger)timeSecond{
    
    NSString *timeString = @"";
    if (timeSecond>3600) {
        NSInteger hour = timeSecond/3600;
        if (hour<10) {
            timeString = [NSString stringWithFormat:@"0%ld:",(long)hour];
        }else{
            timeString = [NSString stringWithFormat:@"%ld:",(long)hour];
        }
    }
    
    NSInteger temptime = timeSecond%3600;
    NSInteger min = temptime/60;
    if (min<10) {
        timeString = [timeString stringByAppendingFormat:@"0%ld:",(long)min];
    }else{
        timeString = [timeString stringByAppendingFormat:@"%ld:",(long)min];
    }
    
    
    temptime = timeSecond%60;
    NSInteger second = temptime/60;
    if (second<10) {
        timeString = [timeString stringByAppendingFormat:@"0%ld",(long)second];
    }else{
        timeString = [timeString stringByAppendingFormat:@"%ld",(long)second];
    }
    return timeString;
}

//+ (CGSize)sizeWithFont:(UIFont*)tFont constrainedToSize:(CGSize)consize text:(NSString *)text
//{
//    if (!(text.length>0)) {
//        text = @"";
//    }
//    CGSize contentTextSize=CGSizeZero;
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: tFont}];
//
//    contentTextSize = [attrStr boundingRectWithSize:consize // 用于计算文本绘制时占据的矩形块
//                                            options:NSStringDrawingUsesLineFragmentOrigin // 文本绘制时的附加选项
//                                            context:nil].size; // context上下文。包括一些
//    contentTextSize = CGSizeMake(contentTextSize.width, contentTextSize.height);
//    return contentTextSize;
//}

/**
 *  拼接长图
 *
 *  @param imgAry 拼接底层图片的数组
 *  @param img    拼接上层图片的数组
 *
 *  @return 拼接后的图片
 */
+ (UIImage *)combineWithSubstrateImgAry:(NSArray *)imgAry withText:(NSString *)text;
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width*2;
    CGFloat height = 0.0f;
    CGFloat firstHeight = 0.0f;
    for (int i = 0; i < imgAry.count; i++) {
        CGFloat proportion = ((UIImage *)imgAry[i]).size.width/width;
        height += ((UIImage *)imgAry[i]).size.height / proportion;
        if (i==0) {
            firstHeight = height;
        }
    }
    CGSize offScreenSize = CGSizeMake(width, height-20);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    float originY = 0.0f;
    for (int i = 0; i < imgAry.count; i++) {
        
        UIImage *tempImg = (UIImage *)imgAry[i];
        CGSize imageSize = tempImg.size;
        
        CGRect rect;
        rect.origin.x = 0;
        rect.origin.y = originY;
        rect.size.width = width;
        rect.size.height = width*imageSize.height/imageSize.width;
        
        originY += rect.size.height;
        
        [tempImg drawInRect:rect];
    }
    
    // 拼接完图片增加水印
    UILabel *lab = [[UILabel alloc] init];
    lab.numberOfLines = 0;
    lab.font = [UIFont boldSystemFontOfSize:40];
    if (text && text.length > 0) {
        lab.text = text;
    }else{
        lab.text = @"未骑行或码表未连接";
    }
    lab.textColor = UIColorFromRGB_10(234, 84, 4);
    lab.shadowColor = [UIColor brownColor];
    lab.shadowOffset = CGSizeMake(0, 4);
    [lab drawTextInRect:CGRectMake(30, firstHeight-200, width, 200)];
    
    // 拼接 图片水印
    UIImage *logoImage = [UIImage imageNamed:@"watermark"];
    
    [logoImage drawInRect:CGRectMake(width-logoImage.size.width*1.6-10, 10, logoImage.size
                                     .width*1.6, logoImage.size.height*1.6) blendMode:kCGBlendModeNormal alpha:.85];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imagez;
    
}

#pragma mark - 10->16
+ (NSString *) turn10to16:(NSString *)str
{
    int num = [str intValue];
    NSMutableString * result = [[NSMutableString alloc]init];
    while (num > 0) {
        int a = num % 16;
        char c;
        if (a > 9) {
            c = 'A' + (a - 10);
        }else{
            c = '0' + a;
        }
        NSString * reminder = [NSString stringWithFormat:@"%c",c];
        [result insertString:reminder atIndex:0];
        num = num / 16;
    }
    return result;
}

#pragma mark - 16->10 字母一定要大写
+ (NSString *) turn16to10:(NSString *)str
{
    int sum = 0;
    for (int i = 0; i < str.length; i++) {
        sum *= 16;
        char c = [str characterAtIndex:i] ;
        if (c >= 'A') {
            sum += c - 'A' + 10;
        }else{
            sum += c - '0';
        }
    }
    return [NSString stringWithFormat:@"%d",sum];
}

#pragma mark - int转为2字节byte存入data中
+ (NSData *)turnIntTo2Bytes:(int)intValue
{
    Byte byte[] = {1,2};
    byte[0] = intValue >> 8&0xff;
    byte[1] = intValue & 0xff;
    return [NSData dataWithBytes:byte length:2];
}

#pragma mark - 16进制data转字符串
+ (NSString*)hexStringForData:(NSData*)data
{
    if (data == nil) {
        return nil;
    }
    
    NSMutableString* hexString = [NSMutableString string];
    
    const unsigned char *p = [data bytes];
    
    for (int i=0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    return hexString;
}

#pragma mark - 16进制字符串转data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        } else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}

#pragma mark - 计算文本高度
//+ (CGSize)getTextHeightWithText:(NSString *)text
//                           font:(UIFont *)font
//                           size:(CGSize)size
//{
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        CGRect rect = [text boundingRectWithSize:size
//                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                      attributes:@{NSFontAttributeName:font}
//                                         context:nil];
//        return rect.size;
//    }
//    else
//    {
//        CGSize textSize = [text sizeWithFont:font
//                           constrainedToSize:size
//                               lineBreakMode:NSLineBreakByWordWrapping];
//        return textSize;
//    }
//}

/**
 *  模糊
 */
+(UIImage *)fuzzyImage:(UIImage *)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *theImage = image;
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:extendedImage forKey:kCIInputImageKey];
    [blurFilter setValue:[NSNumber numberWithFloat:10] forKey:@"inputRadius"];
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return returnImage;
}


+ (NSString *)getCurrentTimeStrFormat:(NSString *)formatStr
{
    
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}


+ (NSDateComponents *)intervalFromLastDate:(NSDate *)lastDate AndExpiredDate:(NSDate *)expiredDate
{
//    // 截止时间字符串格式
//    NSString *expireDateStr = status.expireDatetime;
//    // 当前时间字符串格式
//    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
//    // 截止时间data格式
//    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
//    // 当前时间data格式
//    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:lastDate toDate:expiredDate options:0];
    
    return dateCom;
}



@end
