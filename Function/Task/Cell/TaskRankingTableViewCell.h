//
//  TaskRankingTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  今日--排名的cell

#import <UIKit/UIKit.h>
@class TaskInfoModel;
@interface TaskRankingTableViewCell : UITableViewCell
/** 排名*/
@property (nonatomic,assign) NSInteger ranking;

@property (nonatomic,strong) TaskInfoModel *model;
@end
