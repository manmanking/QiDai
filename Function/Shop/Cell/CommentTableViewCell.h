//
//  CommentTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@interface CommentTableViewCell : UITableViewCell
/** 动态高度*/
@property (nonatomic,assign) CGFloat dynamicHeight;

@property (nonatomic,strong) CommentModel *model;

/** 是否是活动，活动没有颜色*/
@property (nonatomic,assign) BOOL isActivity;
@end
