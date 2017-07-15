//
//  ShopUpdateGoodsDetailActivityTableViewCell.h
//  QiDai
//
//  Created by manman'swork on 16/11/29.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"


typedef void(^ActivityDetailSelectedAction)(NSDictionary * parameter);

typedef void(^ActivitySelectedAction)(NSDictionary * parameter);

@interface ShopUpdateGoodsDetailActivityTableViewCell : UITableViewCell


@property (nonatomic,strong) ActivityModel *activityUpdateModel;

@property (nonatomic,assign)BOOL selectedIsSuccess;

@property (nonatomic,strong) NSString *indexRow;


@property (nonatomic,copy)ActivitySelectedAction activitySelectedAction;

@property (nonatomic,copy)ActivityDetailSelectedAction activityDetailSelectedAction;

@end
