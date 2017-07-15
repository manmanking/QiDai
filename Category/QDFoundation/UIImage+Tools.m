//
//  UIImage+Tools.m
//  Leqi
//
//  Created by Tianyu on 15/1/29.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)

+ (UIImage *)imageWithScrollView:(UIScrollView *)scrollView
{
    UITableView *tableView = (UITableView *)scrollView;
    [tableView.tableFooterView removeFromSuperview];
    UIImage *img;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect rect = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, NO, 0.0);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    img = UIGraphicsGetImageFromCurrentImageContext();
    scrollView.contentOffset = contentOffset;
    scrollView.frame = rect;
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


//截图
+ (UIImage *)imageFromView: (UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//2张图合并
+ (UIImage *)addSameImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image1.size.width, image1.size.height), NO, 0);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
//拼接
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image1.size.width, image1.size.height+image2.size.height), NO, 0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0, image1.size.height, image2.size.width, image2.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
 
    // add by manman start of line
//    [[UIColor blackColor] setFill];
//  CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetRGBFillColor(context, 0,0,0,0);
//    
    // end of line
    UIGraphicsEndImageContext();
    return resultingImage;
}
//修改方向
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
