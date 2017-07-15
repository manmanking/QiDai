//
//  AddressConfirmTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  地址确认

#import <UIKit/UIKit.h>
@class PersonalAddressModel;
@interface AddressConfirmTableViewCell : UITableViewCell

@property (nonatomic,strong) PersonalAddressModel *model;

@property (nonatomic,assign) BOOL isArrowShow;

@end
