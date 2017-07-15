//
//  UILabel+QDExtension.m
//  Leqi
//
//  Created by 张汇丰 on 15/12/21.
//  Copyright © 2015年 com.hoolai. All rights reserved.
//

#import "UILabel+QDExtension.h"

@implementation UILabel (QDExtension)

+ (instancetype)qd_labelWithFrame:(CGRect )frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                    textAlignment:(NSTextAlignment)textAlignment
                             font:(CGFloat )font {
    UILabel *label  = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = titleColor;
    label.textAlignment = textAlignment;
    label.font = UIFontOfSize720(font);
    return label;
}


- (void)setupLabelAutolayoutHeight
{
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
    
}

@end
