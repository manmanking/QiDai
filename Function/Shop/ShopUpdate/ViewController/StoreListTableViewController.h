//
//  StoreListTableViewController.h
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "QDRootViewController.h"
#import "ShopAddressModel.h"

typedef void(^ShopListSelectedAction)(NSInteger parameterSelectFlagStr);

@interface StoreListTableViewController : QDRootViewController


@property (nonatomic,copy) ShopListSelectedAction shopListSelectedAction;

@property (nonatomic,strong) NSArray *datasourcesArr;

@end
