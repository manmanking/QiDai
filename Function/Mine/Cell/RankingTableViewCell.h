//
//  RankingTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankingModel;
@interface RankingTableViewCell : UITableViewCell

@property (nonatomic,strong) RankingModel *model;
/** 排名*/
@property (nonatomic,assign) NSInteger ranking;

@end
