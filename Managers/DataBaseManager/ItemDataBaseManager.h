//
//  ItemDataBaseManager.h
//  Leqi
//
//  Created by Tianyu on 15/1/18.
//  Copyright (c) 2015年 com.hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ItemModel;

@interface ItemDataBaseManager : NSObject

+ (void)insertItemData:(ItemModel *)itemModel;


// dataArray --- [LocationModel,LocationModel,......]; 
+ (void)insertItemDataArray:(NSArray *)dataArray;

+ (NSArray *)getItemDataWithSid:(NSString *)sid;

+ (NSArray *)getItemDataFromTxtWithSid:(NSString *)sid;

@end
