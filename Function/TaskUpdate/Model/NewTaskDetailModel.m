//
//  NewTaskDetailModel.m
//  QiDai
//
//  Created by manman'swork on 16/11/8.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "NewTaskDetailModel.h"
#import <objc/runtime.h>

@implementation NewTaskDetailModel




- (id)copyWithZone:(nullable NSZone *)zone
{
    NewTaskDetailModel *copyModel = [[self class] allocWithZone:zone];
    
//    unsigned int outCount = 0;
//    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
//    for (int i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        NSLog(@"property's name: %s", property_getName(property));
//    }
//    
//    free(properties);
    
    copyModel.cRefund = self.cRefund;
    copyModel.taskDetailId = self.taskDetailId;
    copyModel.complete = self.complete;
    copyModel.userInfoId = self.userInfoId;
    copyModel.information = self.information;
    
    copyModel.itemId = self.itemId;
    copyModel.foreImg = self.foreImg;
    copyModel.record = self.record;
    copyModel.userTaskStartTime = self.userTaskStartTime;
    copyModel.completeDay = self.completeDay;
    
    copyModel.refund = self.refund;
    copyModel.bonusIssue = self.bonusIssue;
    copyModel.taskMainId = self.taskMainId;
    copyModel.sumDistance = self.sumDistance;
    copyModel.totalPrizeMoney = self.totalPrizeMoney;
    
    
    copyModel.addBonus = self.addBonus;
    copyModel.sumStandardDays = self.sumStandardDays;
    copyModel.distance = self.distance;
    copyModel.validDuration = self.validDuration;
    copyModel.cTime = self.cTime;
    copyModel.nickName = self.nickName;
    copyModel.userTaskFinishTime = self.userTaskFinishTime;
    copyModel.detail = self.detail;
    copyModel.totalDuration = self.totalDuration;
    copyModel.helpPageImage = self.helpPageImage;
    
    copyModel.taskShareImage = self.taskShareImage;
    copyModel.distancePerDay = self.distancePerDay;
    copyModel.taskId = self.taskId;
 

    
    
    return self;
    
    
    
    
}

@end
