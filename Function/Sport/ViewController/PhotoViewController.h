//
//  PhotoViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/15.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDRootViewController.h"

@interface PhotoViewController : QDRootViewController

/** 拍照的image*/
@property (nonatomic,strong) UIImage *photo;

/** 图片的数量，最多4张*/
@property (assign, nonatomic) int photoCount;

/** 开始时间,用于命名图片*/
@property (copy, nonatomic) NSString *sportTimeStr;


@end
