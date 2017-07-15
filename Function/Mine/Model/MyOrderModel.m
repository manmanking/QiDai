//
//  MyOrderModel.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderModel


- (id)copyWithZone:(NSZone *)zone
{
    MyOrderModel *model = [[[self class] allocWithZone:zone] init];
    model.bonus = self.bonus;
    model.series = self.series;
    model.brand = self.brand;
    model.model = self.model;
    model.title = self.title;
    model.color = self.color;
    model.address = self.address;
    model.brandImg = self.brandImg;
    model.needPayMoney = self.needPayMoney;
    model.itemImg = self.itemImg;
    model.orderId = self.orderId;
    model.status = self.status;
    model.shopName = self.shopName;
    model.information = self.information;
    model.actiC = self.actiC;
    model.actiCItem = self.actiCItem;
    model.activity_id = self.activity_id;
    model.modelId = self.modelId;
    model.pay_type = self.pay_type;
    model.image = self.image;
    model.c_time = self.c_time;



  
    return model;
    
    
    
    
}

@end
