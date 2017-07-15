//
//  PullupSportView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  开始骑行的bottom的隐藏界面

#import <UIKit/UIKit.h>

@protocol PullupSportViewDelegate <NSObject>
/** 点击向上的按钮*/
- (void)clickPullupBtn;

@end

@interface PullupSportView : UIView

@property (nonatomic,weak) id<PullupSportViewDelegate> delegate;

/** 更新数据*/
- (void)updateSportDataWithParame:(NSDictionary *)parame;

@end
