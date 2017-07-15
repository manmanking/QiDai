//
//  AccountTableViewCell.h
//  Leqi
//
//  Created by 张汇丰 on 16/1/11.
//  Copyright © 2016年 com.hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell

//第一是头像
//@property (nonatomic,assign) BOOL isFirst;

- (void)showDataWithTitle:(NSString *)title detail:(NSString *)detail;
@end
