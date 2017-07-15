//
//  TaskHomePageHeaderView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OngoingModel;
@interface TaskHomePageHeaderView : UIView

@property (nonatomic,copy) ClickView clickBlock;

@property (nonatomic,strong) OngoingModel *model;

@end
