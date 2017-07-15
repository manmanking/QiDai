//
//  UIButton+HorizontalLayout.m
//  Leqi
//
//  Created by 张汇丰 on 15/12/18.
//  Copyright © 2015年 com.hoolai. All rights reserved.
//

#import "UIButton+HorizontalLayout.h"

@implementation UIButton (HorizontalLayout)

- (void)setHorizontalLayoutWithSpace:(CGFloat)itemSpace {
    
    
    //CGFloat spacing = itemSpace;
    
    CGSize imageSize = self.imageView.image.size;
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, self.width -titleSize.width, 0.0, 0);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0, 0, imageSize.width);
}

- (void)test:(CGFloat)itemSpace {
    
    CGFloat spacing = itemSpace;
    
    CGSize imageSize = self.imageView.image.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
}

@end
