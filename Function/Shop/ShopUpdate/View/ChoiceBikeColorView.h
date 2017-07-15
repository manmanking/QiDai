//
//  ChoiceBikeColorView.h
//  QiDai
//
//  Created by manman'swork on 16/12/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "QDRootView.h"


typedef void(^SelectColorAction)(NSString *selectColorStr);

typedef void(^OkayAction)(NSDictionary *parameter);

@interface ChoiceBikeColorView : QDRootView


/**
 *  活动颜色  ，分割
 */
@property (nonatomic,strong) NSString *activityColorSetStr;

/**
 *  商品颜色 数组 ，分割
 */

@property (nonatomic,strong) NSString *colorSetStr;


/**
 *  价格
 */

@property (nonatomic,strong) NSString *bikePriceStr;

/**
 *   图片数组 ，分割
 */
@property (nonatomic,strong) NSString *bikeImageViewStr;


@property (nonatomic,copy) SelectColorAction selectColorAction;

@property (nonatomic,copy)  OkayAction okayAction;

@end
