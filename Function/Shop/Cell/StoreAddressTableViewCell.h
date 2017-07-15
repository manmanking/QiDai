//
//  StoreAddressTableViewCell.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/10.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailModel;
@class ShopAddressModel;
@interface StoreAddressTableViewCell : UITableViewCell

/** 点击订单进来的*/
@property (nonatomic,strong) OrderDetailModel *model;

/** 商品详情进来的*/
@property (nonatomic,strong) ShopAddressModel *shopModel;
@end
