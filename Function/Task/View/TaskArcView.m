//
//  TaskArcView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskArcView.h"
#import "ArcView.h"
@interface TaskArcView ()

@property (nonatomic,strong) UILabel *dataLabel;

@end
@implementation TaskArcView
//画圆
- (void)drawRect:(CGRect)rect {
    //CAShapeLayer   -openGL
    
#pragma -mark -画圆
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x371525).CGColor);
    CGContextSetLineWidth(context, 3.0*SizeScaleSubjectTo720);//(1 - kProgress)
    
    CGFloat centerX = 77 * SizeScaleSubjectTo720;
    CGFloat centerY = 187 * SizeScaleSubjectTo720;
    CGFloat radius = 184 * SizeScaleSubjectTo720;
    CGContextAddArc(context, centerX, centerY, radius, -M_PI/2 , M_PI/2*3 , 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充
    
    //画笔线的颜色:下面2种方法选其一
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x4bec89).CGColor);
    //画圆并填充颜
    //CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
    CGContextSetLineWidth(context, 3.0*SizeScaleSubjectTo720);//线的宽度
    CGContextSetLineCap(context, kCGLineCapRound);
    //x,y为圆点坐标，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针
    //startAngle为0默认是正90°方向的
    CGContextAddArc(context, centerX, centerY, radius, -M_PI/2 , -M_PI/2 + 2* M_PI * 0.5 * self.greenPercent, 0); //添加一个圆
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充kCGPathFillStroke
    
#pragma mark --- 2
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x371525).CGColor);
    CGContextSetLineWidth(context, 3.0*SizeScaleSubjectTo720);//(1 - kProgress)
    
    CGFloat centerX1 = 77 * SizeScaleSubjectTo720;
    CGFloat centerY1 = 187 * SizeScaleSubjectTo720;
    CGFloat radius1 = 148 * SizeScaleSubjectTo720;
    CGContextAddArc(context, centerX1, centerY1, radius1, -M_PI/2 , M_PI/2*3 , 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充
    
    //画笔线的颜色:下面2种方法选其一
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0xe97b1a).CGColor);
    //画圆并填充颜
    //CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
    CGContextSetLineWidth(context, 3.0*SizeScaleSubjectTo720);//线的宽度
    CGContextSetLineCap(context, kCGLineCapRound);
    //x,y为圆点坐标，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针
    //startAngle为0默认是正90°方向的
    CGContextAddArc(context, centerX1, centerY1, radius1, -M_PI/2 , -M_PI/2 + 2* M_PI * 0.5 * self.orangePercent , 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充kCGPathFillStroke
    
#pragma mark --- 3
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x371525).CGColor);
    CGContextSetLineWidth(context, 3.0*SizeScaleSubjectTo720);//(1 - kProgress)
    
    CGFloat centerX2 = 77 * SizeScaleSubjectTo720;
    CGFloat centerY2 = 187 * SizeScaleSubjectTo720;
    CGFloat radius2 = 111 * SizeScaleSubjectTo720;
    CGContextAddArc(context, centerX2, centerY2, radius2, -M_PI/2 , M_PI/2*3 , 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充
    
    //画笔线的颜色:下面2种方法选其一
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x666666).CGColor);
    //画圆并填充颜
    //CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
    CGContextSetLineWidth(context, 3.0*SizeScaleSubjectTo720);//线的宽度
    CGContextSetLineCap(context, kCGLineCapRound);
    //x,y为圆点坐标，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针
    //startAngle为0默认是正90°方向的
    CGContextAddArc(context, centerX2, centerY2, radius2, -M_PI/2 , -M_PI/2 + 2* M_PI * 0.5 * self.grayPercent , 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径加填充kCGPathFillStroke
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}

- (void)setupCustomView {
    
    NSArray *textArr = @[@"达标",@"未达标",@"延期"];
    NSArray *colorArr = @[UIColorFromRGB_16(0x2aa654),UIColorFromRGB_16(0xe97b1a),UIColorFromRGB_16(0x666666)];
    for (int i = 0; i < textArr.count; i++) {
        UILabel *completeLabel = [UILabel qd_labelWithFrame:CGRectMake720(94, 422 + 52*i, 120, 24) title:textArr[i] titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
        [self addSubview:completeLabel];
        
        UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake720(58,368 + 58 + 52*i, 16, 16)];
        [circleView setRoundedCorners:UIRectCornerAllCorners radius:circleView.height/2];
        circleView.backgroundColor = colorArr[i];
        [self addSubview:circleView];
    }
    //142 + 44 + 17
    
    UILabel *completeLabel = [UILabel qd_labelWithFrame:CGRectMake720(28, 203, 96, 22) title:@"达标天数" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:completeLabel];
    [self addSubview:self.dataLabel];
    
}
- (void)setCompleteDate:(NSString *)completeDate {
    _completeDate = completeDate;
    self.dataLabel.text = completeDate;
}
#pragma mark --- lazy load
- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [UILabel qd_labelWithFrame:CGRectMake720(28, 142, 96, 44) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:54];
    }
    return _dataLabel;
}
@end
