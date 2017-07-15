//
//  BrandListViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/8.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  品牌展示列表

#import "QDRootViewController.h"
@class BrandModel;
@interface BrandListViewController : QDRootViewController

@property (nonatomic,strong) BrandModel *brandModel;


@property (nonatomic,strong) NSMutableArray *brandDataSourcesMarr;

@end









