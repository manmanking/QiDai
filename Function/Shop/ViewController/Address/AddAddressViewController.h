//
//  AddAddressViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  添加地址与编辑地址

#import "QDRootViewController.h"
@class PersonalAddressModel;
typedef void(^RefreshAddress)();

@interface AddAddressViewController : QDRootViewController

@property (nonatomic,copy) RefreshAddress refreshAddressBlock;

/** 个人地址的model*/
@property (nonatomic,strong) PersonalAddressModel *model;

/** 是否是编辑模式*/
@property (nonatomic,assign) BOOL isEdit;

@end
