//
//  QDCustomAlertView.h
//  QiDai
//
//  Created by manman'swork on 16/9/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//


/**
 *  现在 这个视图只做一个按钮的提示框 
    以后将两个定制的提示视图  统一为一个
    现在先这样做吧 保佑我吧
 *
 *  @param nonatomic
 *  @param copy
 *
 *  @return
 */

#import <UIKit/UIKit.h>

@interface QDCustomAlertView : UIView

@property (nonatomic,copy) ClickView clickSureBlock;

@property (nonatomic,copy) ClickView clickCancleBlock;

@property (nonatomic,copy) NSString *title;


@property (nonatomic,assign) BOOL rewriteCancleMethod;

@property (nonatomic,copy) NSString *sureBtnTitle;

@property (nonatomic,copy) NSString *cancleBtnTitle;

@property (nonatomic,assign) BOOL isAutolayout;


@end
