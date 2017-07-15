//
//  UploadManager.m
//  MapLocation
//
//  Created by wenyang.wu on 1/28/15.
//  Copyright (c) 2015 com.hoolai. All rights reserved.
//

#import "UploadFileManager.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "LoginManager.h"
#import "ItemModel.h"
#import "SportModel.h"
#import "zip.h"
#import "ZipArchive.h"


#define boundary  @"----------V2ymHFg03ehbqgZCaKO6jy"

#define ITEM      @"item"
#define ITEM_ZIP  @"itemZip"
#define ITEM_TXT  @"itemTxt"
@implementation UploadFileManager






+(NSString *)documentsFolder {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


+(BOOL)createUserFolder:(NSString *)userId{
    NSString *filePath = [[UploadFileManager documentsFolder] stringByAppendingPathComponent:userId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        return YES;
    }
}



+(NSString *)currentUserHomeFolder{
    NSString *filePath = [[UploadFileManager documentsFolder] stringByAppendingPathComponent:[[LoginManager instance] getUserId]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}


+(void)writeToTxtWithFileName:(NSString *)fileName item:(ItemModel *)itemModel{
    NSString *path = [[UploadFileManager currentUserHomeFolder] stringByAppendingPathComponent:ITEM];
    BOOL isDirectory = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:[fileName stringByAppendingString:@".txt"]];
    FILE * f = fopen([path UTF8String], "at");
    NSString *string = [NSString stringWithFormat:@"%@,%f,%f,%f,%f",itemModel.sid,itemModel.latitude,itemModel.longitude,itemModel.altitude,itemModel.speed];
    fprintf(f, "%s", [[string stringByAppendingString:@"\n"] UTF8String]);
    fclose (f);
}


+ (void)zipItemFileWithFileName:(NSString *)fileName
{
    NSString *directory = [[UploadFileManager currentUserHomeFolder] stringByAppendingPathComponent:ITEM];
    NSString *filePath = [directory stringByAppendingPathComponent:[fileName stringByAppendingString:@".txt"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL isDirectory = YES;
        NSString *zipPath = [directory stringByAppendingPathComponent:ITEM_ZIP];
        if (![[NSFileManager defaultManager] fileExistsAtPath:zipPath isDirectory:&isDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:zipPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *zipFilePath = [zipPath stringByAppendingPathComponent:[fileName stringByAppendingString:@".zip"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:nil];
        }
        ZipArchive *zip = [[ZipArchive alloc] init];
        [zip CreateZipFile2:zipFilePath];
        [zip addFileToZip:filePath newname:[fileName stringByAppendingString:@".txt"]];
        [zip CloseZipFile2];
    }
}

//success:(void (^)(NSURLSessionDataTask *task, id responseObject))success

+(void)unzipFileWithFileName:(NSString *)fileName{
    NSString *itemdirectory = [[UploadFileManager currentUserHomeFolder] stringByAppendingPathComponent:ITEM];
    NSString *zipPath = [itemdirectory stringByAppendingPathComponent:ITEM_ZIP];
    NSString *zipFilePath = [zipPath stringByAppendingPathComponent:[fileName stringByAppendingString:@".zip"]];
    
    ZipArchive *unZip = [[ZipArchive alloc] init];
    [unZip UnzipOpenFile:zipFilePath];
    [unZip UnzipFileTo:itemdirectory overWrite:YES];
    [unZip UnzipCloseFile];
}


+(NSString *)txtFilePathWithFileName:(NSString *)fileName{
    NSString *itemdirectory = [[UploadFileManager currentUserHomeFolder] stringByAppendingPathComponent:ITEM];
    return [itemdirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
}


+(void)zipAndUploadItemFileWithFileName:(NSString *)fileName
                                success:(void (^)())success
                                failure:(void (^)())failure{
    
    [UploadFileManager zipItemFileWithFileName:fileName];
    NSString *filePath = [[[[UploadFileManager currentUserHomeFolder] stringByAppendingPathComponent:ITEM] stringByAppendingPathComponent:ITEM_ZIP] stringByAppendingPathComponent:[fileName stringByAppendingString:@".zip"]];
    [UploadFileManager afpostFileWithFileFullPath:filePath userId:[[LoginManager instance] getUserId] success:success failure:failure];
}


#pragma mark AFNetWorking  上传文件
+(void)afpostFileWithFileFullPath:(NSString *)filePath
                           userId:(NSString *)userId
                          success:(void (^)())success
                          failure:(void (^)())failure{
    
    if (filePath.length >0 && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",nil];
        NSString *uploadUrl = [NSString stringWithFormat:@"%@/%@",kUrl_forRidingRecord,userId];
//        [manager POST:uploadUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            NSData *data = [NSData dataWithContentsOfFile:filePath];
//            NSArray *nameAry=[filePath componentsSeparatedByString:@"/"];
//            NSString *picFileName = [nameAry objectAtIndex:[nameAry count]-1];
//            [formData appendPartWithFileData:data name:@"file" fileName:picFileName mimeType:@"file"];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"post Big success returnedDic=%@", result);
//            
//            if (success) {
//                success();
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"post big file fail error=%@", error);
//            if (failure) {
//                failure();
//            }
//        }];

     // start of line
//         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//         
//         NSDictionary *dict = @{@"username":@"Saup"};
        
         //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
//         [manager POST:@"http://192.168.1.111:12345/upload.php" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//         
//         UIImage *image =[UIImage imageNamed:@"moon"];
//         NSData *data = UIImagePNGRepresentation(image);
        
         // end of line
        
        
        [manager POST:uploadUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSArray *nameAry=[filePath componentsSeparatedByString:@"/"];
            NSString *picFileName = [nameAry objectAtIndex:[nameAry count]-1];
            [formData appendPartWithFileData:data name:@"file" fileName:picFileName mimeType:@"file"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"post Big success returnedDic=%@", result);
            
            if (success) {
                success();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"post big file fail error=%@", error);
            if (failure) {
                failure();
            }
            NSLog(@"kUrl_forRidingRecord file upload  :%@",error);

        }];
    }else{
    
//        if (failure) {
//            //NSLog(@"post big file fail error");
//            failure();
//        }
        success();
    }
}


//kUrl_downloadDetailRecord
#pragma mark --- 下载
+ (void)downLoadDetailRecordWithUserId:(NSString *)userId
                             fileName:(NSString *)fileName
                              success:(void (^)())success
                              failure:(void (^)())failure{
    
    NSString *downloadURL = [NSString stringWithFormat:@"%@?userId=%@&filename=%@.zip",kUrl_downloadDetailRecord,userId,fileName];
    
    NSString *filePath = [self currentUserHomeFolder];
    
    NSString *itemdirectory = [[UploadFileManager currentUserHomeFolder] stringByAppendingPathComponent:ITEM];
    BOOL isDirectory = YES;
    NSString *zipPath = [itemdirectory stringByAppendingPathComponent:ITEM_ZIP];
    if (![[NSFileManager defaultManager] fileExistsAtPath:zipPath isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:zipPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    filePath = [zipPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",fileName]];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html/zip/txt"];
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        //NSLog(@"默认下载地址:%@",targetPath);
        NSLog(@"filePath:%@",filePath);
        //NSString *path = [zipPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
//        return [NSURL URLWithString:path];
        return [NSURL URLWithString:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成调用的方法
//        NSLog(@"下载完成：");
        NSLog(@"%@",response);
        if (error) {
            failure();
        } else {
            NSLog(@"下载成功 ---%@",filePath);
            success();
        }
    }];
    
    //开始启动任务
    [task resume];
    
}


#pragma mark AFNetWorking 上传图片



#pragma mark -  NSURLSession  实现的上传图片
- (void)uploadImageWithImagePath:(NSString *)imagePath
{
    NSURL *uploadURL = [NSURL URLWithString:@"http://120.27.36.179:8080/q7bike/app/forUpload"];
    //文件路径处理(随意)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSData *body = [self prepareDataForUploadWithImagePath:imagePath];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:uploadURL];
        [request setHTTPMethod:@"POST"];
        
        // 以下2行是关键，NSURLSessionUploadTask不会自动添加Content-Type头
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message: %@", message);
            [session invalidateAndCancel];
        }];
        [uploadTask resume];
    });
}

-(NSData*) prepareDataForUploadWithImagePath:(NSString *)imagePath
{
    NSString *fileName = [imagePath lastPathComponent];
    NSMutableData *body = [NSMutableData data];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (data) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"file",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}
@end
