//
//  ArcView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcView : UIView

@property (nonatomic,assign) CGFloat x;

@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat radius;

@property (nonatomic,assign) CGFloat percent;
/** 画笔颜色 青色UIColorFromRGB_16(0x4bec89)*/
@property (nonatomic,strong) UIColor *brushColor;
@end
