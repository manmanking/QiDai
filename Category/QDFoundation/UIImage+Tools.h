//
//  UIImage+Tools.h
//  Leqi
//
//  Created by Tianyu on 15/1/29.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**截图 */
+ (UIImage *)imageFromView: (UIView *)theView;

/**2张图合并 */
+ (UIImage *)addSameImage:(UIImage *)image1 toImage:(UIImage *)image2;

/**2张图拼接 */
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

/**纠正图片位置 */
- (UIImage *)fixOrientation;
@end
