//
//  UIButton+EnlargeEdge.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//
//  扩大btn的作用域
#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)

/**
 *  扩大btn作用域
 *
 *  @param size 大小
 */
- (void)setEnlargeEdge:(CGFloat) size;


/**
 *  扩大btn作用域
 *
 *  @param top    top
 *  @param right  right
 *  @param bottom bottom
 *  @param left   left
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
