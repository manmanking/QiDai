//
//  BillConfirmViewController.h
//  QiDai
//
//  Created by manman'swork on 16/11/30.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "QDRootViewController.h"
#import "GoodsModel.h"
#import "ActivityModel.h"
#import "ShopAddressModel.h"
@interface BillConfirmViewController : QDRootViewController



@property (nonatomic,strong) NSString *selectedBikeImageViewUrlStr;

@property (nonatomic,strong) GoodsModel *billConfirmGoodsModel;

@property (nonatomic,strong) ActivityModel *billConfirmActivityModel;


@property (nonatomic,strong) NSMutableArray *shopAddressMArr;

@property (nonatomic,strong) NSString *colorStr;

@end
