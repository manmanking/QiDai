//
//  UploadImageManager.h
//  Leqi
//
//  Created by Tianyu on 15/1/30.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UploadImageManager : NSObject
//我的上传头像
+ (void)uploadImageWithImagePath:(NSString *)imgPath compate:(void(^)(BOOL isSuccess, NSString *errStr, NSString *newUrl))compate;

#pragma -mark 以下都是运动结束上传
//上传数据的图片
+ (void)uploadImageWithImage:(UIImage *)image ridingId:(NSString *)rid userId:(NSString *)uid WithSuccess:(void(^)(double progress))success
                  completion:(void(^)())complete;
//判断是否需要上传照片
+ (void)checkPhotoWithDic:(NSDictionary *)dic compate:(void (^)(NSArray *result))compate;
//多图上传照片
+ (void)uploadImageWithArray:(NSArray *)imageArr dataImage:(UIImage *)dataImage ridingId:(NSString *)rid userId:(NSString *)uid
                 WithSuccess:(void(^)(double progress))success
                  completion:(void(^)(NSDictionary *))complete;

/**
 *  评论图片的多图上传
 *
 *  @param imageArray 图片数组
 *  @param compate    nil
 */
+ (void)uploadCommentImageWithArray:(NSArray *)imageArray compate:(void(^)(BOOL isSuccess, NSString *errStr, NSString *newUrl))compate;

@end
