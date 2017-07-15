//
//  StoreAssembleTableViewCell.h
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StoreAssembleSelctedAcction)(NSDictionary *parameter);

@interface StoreAssembleTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subtitleLabel;

@property (nonatomic,assign) BOOL isSelectedSuccess;

@property (nonatomic,copy) StoreAssembleSelctedAcction storeAssembleSelctedAcction;

@end
