//
//  PublishCommentViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDRootViewController.h"
#import "LQPhotoPickerViewController.h"

@class MyOrderModel;
@class GoodsModel;
@interface PublishCommentViewController : LQPhotoPickerViewController

@property (nonatomic,assign) BOOL isActivity;

@property (nonatomic,copy) NSString *bikeImageUrl;

@property (nonatomic,copy) NSString *bikeInfo;

@property (nonatomic,strong) GoodsModel *model;

@property (nonatomic,strong) MyOrderModel *myOrderModel;

@property (nonatomic,copy) void(^refreshDataSourceBlock)();

@end
