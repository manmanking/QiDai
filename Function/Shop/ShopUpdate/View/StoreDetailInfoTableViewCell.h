//
//  StoreDetailInfoTableViewCell.h
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopAddressModel.h"



typedef void(^ChoiceMoreStoreAction)(NSString *parameter);

@interface StoreDetailInfoTableViewCell : UITableViewCell


@property (nonatomic,assign) BOOL isEnable;


@property (nonatomic,strong) ShopAddressModel *storeDetailInfoShopAddressModel;

@property (nonatomic,copy) ChoiceMoreStoreAction choiceMoreStoreAction;

@end
