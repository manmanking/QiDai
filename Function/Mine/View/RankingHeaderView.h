//
//  RankingHeaderView.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  rankingVC的tableView的headerView

#import <UIKit/UIKit.h>
@class IndividualRankingModel;
@interface RankingHeaderView : UIView

@property (nonatomic,strong) IndividualRankingModel *model;

/** 显示周排名，月排名的*/
@property (nonatomic,strong) UILabel *rankingTextLabel;
@end
