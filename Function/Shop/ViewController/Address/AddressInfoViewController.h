//
//  AddressInfoViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/1.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  店铺信息

#import "QDRootViewController.h"

@class ShopAddressModel;
typedef NS_ENUM(NSInteger, AMapRoutePlanningType)
{
    AMapRoutePlanningTypeDrive = 0,
    AMapRoutePlanningTypeWalk,
    AMapRoutePlanningTypeBus
};

@interface AddressInfoViewController : QDRootViewController

@property (nonatomic,strong) ShopAddressModel *model;

@end
