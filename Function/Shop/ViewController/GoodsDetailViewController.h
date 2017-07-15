//
//  GoodsDetailViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  商品详情

#import "QDRootViewController.h"

@interface GoodsDetailViewController : QDRootViewController
/** 商品id,上个页面传进来*/
@property (nonatomic,copy) NSString *goodsId;
/** 城市的编码,上个页面传进来*/
@property (nonatomic,copy) NSString *cityCode;
/** 是不是present进来的,点击品牌-->*/
@property (nonatomic,assign) BOOL isPresent;
/** 是否是"任性购"*/
@property (nonatomic,assign) BOOL isActivityOver;
@end
