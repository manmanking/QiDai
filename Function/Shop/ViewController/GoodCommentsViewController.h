//
//  GoodCommentsViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  商品评价的vc

#import "QDRootViewController.h"

@interface GoodCommentsViewController : QDRootViewController

/** 商品id,用于获取评论*/
@property (nonatomic,copy) NSString *modelId;

/** 商品评价，由上个页面传进来*/
@property (nonatomic,strong) NSArray *commentArray;

/** 总评论数*/
@property (nonatomic,copy) NSString *totalComment;

/** 好评率*/
@property (nonatomic,copy) NSString *goodRate;

/** 车的小图的url*/
@property (nonatomic,copy) NSString *bikeUrl;
@end
