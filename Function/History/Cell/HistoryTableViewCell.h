//
//  HistoryTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SportModel;
@class HistoryTableViewCell;
typedef void(^ClickUploadBtnBlock)(SportModel *,HistoryTableViewCell *);

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic,strong) SportModel *sportModel;

@property (nonatomic,copy) ClickUploadBtnBlock clickUploadBtnBlock;

@end
