//
//  ActivityModel.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)copyWithZone:(NSZone *)zone
{
    ActivityModel *copyModel = [[[self class] allocWithZone:zone]init];
    copyModel.id = _id;
    copyModel.refund = _refund;
    copyModel.information = _information;
    copyModel.detail = _detail;
    copyModel.countdown = _countdown;
    copyModel.CRefund = _CRefund;
    copyModel.type = _type;
    copyModel.quantity = _quantity;
    copyModel.beginTime = _beginTime;
    copyModel.endTime = _endTime;
    copyModel.distancePerDay = _distancePerDay;
    copyModel.taskDetailId = _taskDetailId;
    copyModel.desc = _desc;
    copyModel.color = _color;
    copyModel.shop_id = _shop_id;

    return copyModel;

    
}

@end
