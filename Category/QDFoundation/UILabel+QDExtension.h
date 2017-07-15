//
//  UILabel+QDExtension.h
//  Leqi
//
//  Created by 张汇丰 on 15/12/21.
//  Copyright © 2015年 com.hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (QDExtension)

/**
 *  快捷创建label
 *
 *  @param frame
 *  @param title
 *  @param titleColor
 *  @param textAlignment
 *  @param font
 *
 *  @return
 */
+ (instancetype)qd_labelWithFrame:(CGRect )frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                    textAlignment:(NSTextAlignment)textAlignment
                             font:(CGFloat )font;


/**
 *  设置label的高度自适应
 *
 *  @param titleStr 
 */
- (void)setupLabelAutolayoutHeight;


@end
