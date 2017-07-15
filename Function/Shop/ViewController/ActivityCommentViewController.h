//
//  ActivityCommentViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  活动评价

#import "QDRootViewController.h"

@interface ActivityCommentViewController : QDRootViewController

/** 活动id,用于获取评论*/
@property (nonatomic,copy) NSString *activityId;

/** 商品评价，由上个页面传进来*/
@property (nonatomic,strong) NSArray *commentArray;

/** 总评论数*/
@property (nonatomic,copy) NSString *totalComment;

/** 好评率*/
@property (nonatomic,copy) NSString *goodRate;

@end
