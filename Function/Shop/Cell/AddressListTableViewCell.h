//
//  AddressListTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  地址列表

#import <UIKit/UIKit.h>
@class PersonalAddressModel;
@protocol AddressListTableViewCellDelegate <NSObject>

- (void)clickEditBtnWithIndex:(NSInteger)index;

- (void)clickSelectBtnWithIndex:(NSInteger)index;

@end

@interface AddressListTableViewCell : UITableViewCell

@property (nonatomic,weak) id<AddressListTableViewCellDelegate>delegate;

@property (nonatomic,strong) PersonalAddressModel *model;
/** 当前的位置*/
@property (nonatomic,assign) NSInteger index;
/** 时候被选中*/
@property (nonatomic,assign) BOOL isSelect;

@end
