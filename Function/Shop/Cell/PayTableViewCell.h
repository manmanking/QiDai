//
//  PayTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic,copy) ClickViewWithPage clickSelectBtnBlock;

@end
