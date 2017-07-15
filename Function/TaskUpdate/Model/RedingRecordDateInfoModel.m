//
//  RedingRecordDateInfoModel.m
//  QiDai
//
//  Created by manman'swork on 16/11/8.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "RedingRecordDateInfoModel.h"

@implementation RedingRecordDateInfoModel

- (id)copyWithZone:(NSZone *)zone
{
    RedingRecordDateInfoModel *model = [[[self class] allocWithZone:zone] init];
    model.date = self.date;
    model.daySumDistance  = self.daySumDistance;
    model.complete = self.complete;
    model.money = self.money;
    return model;
}


@end
