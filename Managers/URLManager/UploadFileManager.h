//
//  UploadManager.h
//  MapLocation
//
//  Created by wenyang.wu on 1/28/15.
//  Copyright (c) 2015 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;
@class ItemModel;
@class SportModel;
@interface UploadFileManager : NSObject

+ (NSString *)currentUserHomeFolder;

+ (BOOL)createUserFolder:(NSString *)userId;

+ (void)writeToTxtWithFileName:(NSString *)fileName
                          item:(ItemModel *)itemModel;
/**
 *  上传zip点
 *
 *  @param fileName
 *  @param success  
 *  @param failure
 */
+ (void)zipAndUploadItemFileWithFileName:(NSString *)fileName
                                 success:(void (^)())success
                                 failure:(void (^)())failure;

+ (void)downLoadDetailRecordWithUserId:(NSString *)userId
                              fileName:(NSString *)fileName
                               success:(void (^)())success
                               failure:(void (^)())failure;

+ (void)unzipFileWithFileName:(NSString *)fileName;

+ (NSString *)txtFilePathWithFileName:(NSString *)fileName;


@end
