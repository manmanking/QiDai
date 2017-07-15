//
//  BillDetailInfoView.h
//  QiDai
//
//  Created by manman'swork on 16/11/30.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
#import "ActivityModel.h"
@interface BillDetailInfoView : UIView


@property (nonatomic,strong) GoodsModel *billDetailGoodsModel;


@property (nonatomic,strong) ActivityModel *billDetailActivityModel;



@property (nonatomic,strong) NSString *selectedImageViewUrlStr;

@property (nonatomic,strong) NSString *selectedActivityStr;

@property (nonatomic,strong) NSString *selectedColorStr;
@end
