//
//  CommentModel.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  评论

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/** 用户id*/
@property (nonatomic,copy) NSString *id;
/** 用户名字*/
@property (nonatomic,copy) NSString *username;
/** 星级*/
@property (nonatomic,copy) NSString *level;
/** 时间*/
@property (nonatomic,copy) NSString *c_time;
/** 颜色*/
@property (nonatomic,copy) NSString *color;
/** 评论*/
@property (nonatomic,copy) NSString *common;
/** id*/
@property (nonatomic,copy) NSString *modelid;
/** 图片*/ 
@property (nonatomic,copy) NSString *image;

/** 1 活动评价 2 商品评价*/
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *userinfo_id;

/** 父类id,保留此功能*/
@property (nonatomic,copy) NSString *parent_id;

@end
