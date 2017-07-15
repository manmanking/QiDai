//
//  ActivityRulesViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  活动详情的vc

#import "QDRootViewController.h"

@interface ActivityRulesViewController : QDRootViewController

/** 活动id,用于获取活动数据*/
@property (nonatomic,copy) NSString *activityId;

/** 活动评价的id*/
@property (nonatomic,copy) NSString *activityCommentId;
///** 评论数量*/
//@property (nonatomic,copy) NSString *commentCount;

/** 是否是Present进来的*/
@property (nonatomic,assign) BOOL isPresent;


@end
