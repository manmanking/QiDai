//
//  UploadImageManager.m
//  Leqi
//
//  Created by Tianyu on 15/1/30.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import "UploadImageManager.h"
#import "AFNetworking.h"
#import "UIImage+Tools.h"
@implementation UploadImageManager

+ (void)uploadImageWithImagePath:(NSString *)imgPath compate:(void (^)(BOOL, NSString *, NSString *))compate
{
    if (imgPath.length >0) {
        //1。创建管理者对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:kUrl_forUpload parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData* data;
            if(imgPath) {
                UIImage *image=[UIImage imageWithContentsOfFile:imgPath];
                data = UIImageJPEGRepresentation(image, 0.5);
            }
            NSString *picFileName = [imgPath lastPathComponent];
            [formData appendPartWithFileData:data name:@"file" fileName:picFileName mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject valueForKey:@"code"] isEqualToString:@"00"]) {
                compate(YES,nil,responseObject[@"newUrl"]);
            } else {
                compate(NO, responseObject[@"message"], nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (compate) {
                compate(NO, @"网络连接失败，请稍后再试", nil);
            }
        }];

    }
}
+ (void)uploadCommentImageWithArray:(NSArray *)imageArray compate:(void(^)(BOOL isSuccess, NSString *errStr, NSString *newUrl))compate {
    if (imageArray.count == 0) {
        if (compate) {
            compate(YES,nil,@"");
        }
        return;
    }
    //NSDictionary *dic = @{@"userInfoId":kUserId};
    //        NSData* data;
    
    //        NSString *picFileName = [imgPath lastPathComponent];
    //        [formData appendPartWithFileData:data name:@"file" fileName:picFileName mimeType:@"image/jpeg"];
    //
    //        [formData appendPartWithFileData:UIImageJPEGRepresentation(dataImage, 0.5) name:@"file" fileName:[NSString stringWithFormat:@"%@.png",rid] mimeType:@"image/jpeg"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl_uploadComment,kUserId];
    
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (int i = 0; i<imageArray.count; i++) {
            //NSArray *array1 = [imageArray[i] componentsSeparatedByString:@","];
            UIImage *tempImage = imageArray[i];
            tempImage = [tempImage fixOrientation];
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(tempImage, 0.5) name:@"file" fileName:@"liuguoqiangshuobuyongqimingzi" mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"00"]) {
            compate(YES,nil,responseObject[@"data"]);
        } else {
            compate(NO, responseObject[@"message"], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (compate) {
            compate(NO, @"网络连接失败，请稍后再试", nil);
        }
    }];
}
+ (void)uploadImageWithImage:(UIImage *)image ridingId:(NSString *)rid userId:(NSString *)uid WithSuccess:(void(^)(double progress))success
                  completion:(void(^)())complete
{
    
//    if (image) {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"userId",nil];
//        NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",kUrl_forUpload,uid];
//        
//        AFHTTPRequestOperation *operation = [manager POST:uploadUrl
//                                               parameters:params
//                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                                    NSData* data = UIImageJPEGRepresentation(image, 0.4);
//                                    NSString *picFileName = [NSString stringWithFormat:@"%@.png",rid];
//                                    [formData appendPartWithFileData:data name:@"file" fileName:picFileName mimeType:@"image/jpeg"];
//                                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                    
//                                    NSError *error;
//                                    //NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//                                    
//                                    if (error) {
//                                        if (complete) {
//                                            //complete();
//                                        }
//                                    } else {
//                                        if (complete) {
//                                            //complete();
//                                        }
//                                    }
//                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                    if (complete) {
//                                        complete();
//                                    }
//                                }];
//        
//        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            success( ((double)totalBytesWritten/(double)totalBytesExpectedToWrite) );
//            if (((double)totalBytesWritten/(double)totalBytesExpectedToWrite) == 1) {
//                NSLog(@"保存成功");
//                complete();
//            }
//        }];
//    }
}


+ (void)checkPhotoWithDic:(NSDictionary *)dic compate:(void (^)(NSArray *))compate {
    
    NSString *checkPhotoURL = [NSString stringWithFormat:@"%@?userId=%@&ridingId=%@",kUrl_checkPhoto,[dic valueForKey:@"userId"],[dic valueForKey:@"ridingId"]];
    NSArray *pictureArr = [dic valueForKey:@"fileName"];
    for (NSString *str in pictureArr) {
        NSArray *array = [str componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
        //NSLog(@"array:%@",array[array.count -1]);
        checkPhotoURL = [NSString stringWithFormat:@"%@&fileName=%@",checkPhotoURL,array[array.count -1]];
    }
    //NSLog(@"%@",checkPhotoURL);

    [[AFHTTPSessionManager manager] GET:checkPhotoURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        QDLog(@"checkPhotoWithDic :%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] isEqualToString:@"00"]) {
                if (compate) {
                    compate(responseObject);
                }
            } else {
                if (compate) {
                    
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (compate) {
            
        }
    }];
}

+ (void)uploadImageWithArray:(NSArray *)imageArr dataImage:(UIImage *)dataImage ridingId:(NSString *)rid userId:(NSString *)uid
                 WithSuccess:(void(^)(double progress))success
                  completion:(void(^)(NSDictionary *))complete{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@/%@",kUrl_uploadPhoto,uid,rid];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:uploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
         //[formData appendPartWithFileData:UIImageJPEGRepresentation(dataImage, 0.5) name:@"file" fileName:[NSString stringWithFormat:@"%@.png",rid] mimeType:@"image/jpeg"];
         if (imageArr.count > 0) {
             for (int i = 0; i<imageArr.count; i++) {
                 NSArray *array1 = [imageArr[i] componentsSeparatedByString:@"/"];
                 UIImage *tempImage = [UIImage imageNamed:imageArr[i]];
                 tempImage = [tempImage fixOrientation];

                 [formData appendPartWithFileData:UIImageJPEGRepresentation(tempImage, 0.01) name:@"file" fileName:array1[array1.count -1] mimeType:@"image/jpeg"];

             }
         }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"00"]) {
            complete(responseObject);
        } else {
            complete(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (complete) {
//            compate(NO, @"网络连接失败，请稍后再试", nil);
//        }
        
        
        NSLog(@"kUrl_uploadPhoto :%@",error);
    }];

}
@end
