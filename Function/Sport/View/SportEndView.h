//
//  SportEndView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  运动结束页面或者是历史的骑行报告页面

#import <UIKit/UIKit.h>
@class SportModel;
@interface SportEndView : UIView
/** 活动名称*/
@property (nonatomic,strong) UITextField *nameTF;

@property (nonatomic,strong) SportModel *sportModel;

/** 是否是历史的骑行报告*/
@property (nonatomic,assign) BOOL isHistory;

/** 是否显示 可修改骑行记录 名称图片logo */
@property (nonatomic,assign) BOOL whetherShowWriteImageView;

/** 赋值完，手动创建*/
- (void)setupSportEndView;
@end
