//
//  ArcView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ArcView.h"

@implementation ArcView

//画圆
- (void)drawRect:(CGRect)rect {
#pragma -mark -画圆
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x371525).CGColor);
    CGContextSetLineWidth(context, 3.0);//(1 - kProgress)
    
    CGFloat centerX = self.x * SizeScaleSubjectTo720;
    CGFloat centerY = self.y * SizeScaleSubjectTo720;
    CGFloat radius = self.radius * SizeScaleSubjectTo720;
    
    CGContextAddArc(context, centerX, centerY, radius, -M_PI/2 , M_PI/2*3 , 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充
    
    //画笔线的颜色:下面2种方法选其一
    //CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextSetStrokeColorWithColor(context, self.brushColor.CGColor);
    
    //画圆并填充颜
    //CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
    
    CGContextSetLineWidth(context, 3.0);//线的宽度
    CGContextSetLineCap(context, kCGLineCapRound);
    //x,y为圆点坐标，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针
    //startAngle为0默认是正90°方向的
    CGContextAddArc(context, centerX, centerY, radius, -M_PI/2 , -M_PI/2 + 2* M_PI * self.percent , 0); //添加一个圆
    
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充kCGPathFillStroke
    
    //CGContextRelease(context);
}

@end
