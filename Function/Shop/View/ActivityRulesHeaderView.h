//
//  ActivityRulesHeaderView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityModel;
@interface ActivityRulesHeaderView : UIView

/** 动态高度*/
@property (nonatomic,assign) NSInteger dynamicHeight;


@property (nonatomic,strong) ActivityModel *activityModel;


//@property (nonatomic,strong) NSMutableArray *numberArrayM;
- (void)setPersonImageViewWithArray:(NSArray *)array;
@end
