//
//  PulldownSportView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/2.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  开始骑行的下拉 界面

#import <UIKit/UIKit.h>

@protocol PulldownSportViewDelegate <NSObject>

/** 点击运动结束按钮*/
- (void)clickSportEndBtn;
/** 点击运动暂停*/
- (void)clickSportPauseBtn:(UIButton *)button;
/** 点击显示地图*/
- (void)clickShowMapBtn;
/** 点击向下的按钮*/
- (void)clickPulldownBtn;

@end
@interface PulldownSportView : UIView

@property (nonatomic,weak) id<PulldownSportViewDelegate> delegate;

@property (nonatomic,strong) UIButton *sportPauseBtn;

/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param isHaveTask 是否有任务
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame isHaveTask:(BOOL)isHaveTask;

@end
