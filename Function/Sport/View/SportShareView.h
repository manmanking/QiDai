//
//  SportShareView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/16.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  运动结束弹出来的分享的视图

#import <UIKit/UIKit.h>

@interface SportShareView : UIView

@property (nonatomic,copy) ClickViewWithPage clickShareBtnBlock;

@property (nonatomic,copy) ClickView clickCloseBlock;

@end
