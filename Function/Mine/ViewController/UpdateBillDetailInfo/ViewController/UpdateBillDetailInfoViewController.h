//
//  UpdateBillDetailInfoViewController.h
//  QiDai
//
//  Created by manman'swork on 16/12/4.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "QDRootViewController.h"
#import "MyOrderModel.h"

@interface UpdateBillDetailInfoViewController : QDRootViewController


@property (nonatomic,strong) MyOrderModel *updateBillDetailModel;


@property (nonatomic,copy) void(^refreshDataSourceBlock)();


@end
