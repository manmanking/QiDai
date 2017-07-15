//
//  UIView+QDFoundation.h
//  Leqi
//
//  Created by 张汇丰 on 15/10/21.
//  Copyright © 2015年 com.hoolai. All rights reserved.
//
//  扩展UIView

#import <UIKit/UIKit.h>

typedef void(^ClickView)();

typedef void (^ClickViewWithParameter)(NSString *);

typedef void (^ClickViewWithPage)(NSInteger);

@interface UIView (QDFoundation)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

/** 移除所有的view*/
- (void)removeAllSubviews;
- (UIViewController *)viewController;
/** 设置圆角*/
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
