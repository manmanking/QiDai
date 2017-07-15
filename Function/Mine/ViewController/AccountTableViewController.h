//
//  AccountTableViewController.h
//  Leqi
//  展示用户资料的VC
//  Created by 张汇丰 on 16/1/11.
//  Copyright © 2016年 com.hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountTableViewControllerDelegate <NSObject>

/** 刷新“我的“数据*/
- (void)refreshPersonalInformation;

@end

@interface AccountTableViewController : UITableViewController

@property (nonatomic,weak) id<AccountTableViewControllerDelegate>delegate;

@end
