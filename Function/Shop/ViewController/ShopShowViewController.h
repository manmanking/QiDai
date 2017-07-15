//
//  ShopShowViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  二宫格展示

typedef NS_ENUM(NSInteger,ShopShowStatus) {
    ShopShowSearch,     //搜索
    ShopShowActivity,   //活动
    ShopShowType,       //类型
    ShopShowHot,       //热门
};

#import "QDRootViewController.h"

@interface ShopShowViewController : QDRootViewController

/** title*/
@property (nonatomic,copy) NSString *titleStr;

/** index,如果是搜索页面进来的则不需要*/
@property (nonatomic,copy) NSString *index;

/** 如果是搜索，传过来搜索的内容*/
@property (nonatomic,copy) NSString *searchTitle;

/** 标记是活动、类型、搜索*/
@property (nonatomic,assign) ShopShowStatus status;

@end
