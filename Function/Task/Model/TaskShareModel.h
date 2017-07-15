//
//  TaskShareModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskShareModel : NSObject
// tern link p9

/** 车辆图片*/
@property (nonatomic,copy) NSString *bikeImg;

/** logo 的url*/
@property (nonatomic,copy) NSString *logo;
/** 品牌 tern*/
@property (nonatomic,copy) NSString *brand;
/** 系列 link*/
@property (nonatomic,copy) NSString *series;
/** p9*/
@property (nonatomic,copy) NSString *model;
/** 购买地 --北京市远行美店*/
@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *price;

/** 可能没用到*/
@property (nonatomic,copy) NSString *title;

@end
