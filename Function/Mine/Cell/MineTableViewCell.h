//
//  MineTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/5/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *leftImageView;

@property (nonatomic,strong) UILabel *titleLabel;

/** 指数*/
@property (nonatomic,assign) NSInteger index;

@end
