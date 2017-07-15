//
//  GoodsModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/6.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

/** 详情页面的地址*/
@property (nonatomic,copy) NSString *detail;
/** id*/ 
@property (nonatomic,copy) NSString *id;
/** 品牌的中文名字*/
@property (nonatomic,copy) NSString *brandCn;
/** 车的系列*/
@property (nonatomic,copy) NSString *series;
/** 车的品牌*/
@property (nonatomic,copy) NSString *brand;
/** 车的介绍*/
@property (nonatomic,copy) NSString *title;
/** 车的小图*/
@property (nonatomic,copy) NSString *image;
/** 价格*/
@property (nonatomic,copy) NSString *price;
/** 支付方式 1快递，2自取*/
@property (nonatomic,copy) NSString *pay_type;
/** 颜色,例子:"白,灰,红"，需要自己再转回为数组*/
@property (nonatomic,copy) NSString *color;
/** 无*/
@property (nonatomic,copy) NSString *model;

/** 区域*/
@property (nonatomic,copy) NSString *area;
/** 轮播图,需要自己再转回为数组*/
@property (nonatomic,copy) NSString *photo;
/** 车的名字*/
@property (nonatomic,copy) NSString *name;

/** 透明图，需要用,分割*/
@property (nonatomic,copy) NSString *share_image;


@end
