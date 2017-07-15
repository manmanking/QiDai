//
//  QDAlertView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDAlertView : UIView

@property (nonatomic,copy) ClickView clickSureBlock;

@property (nonatomic,copy) ClickView clickCancleBlock;

@property (nonatomic,copy) NSString *title;

/** 按钮取反*/
@property (nonatomic,assign) BOOL isContrary;

@property (nonatomic,assign) BOOL rewriteCancleMethod;

@property (nonatomic,copy) NSString *sureBtnTitle;

@property (nonatomic,copy) NSString *cancleBtnTitle;

@property (nonatomic,assign) BOOL isAutolayout;


/**
*  更新视图  title 和按钮都确定好之后在 更新视图 
 */
- (void)updateUIAutolayout;


@end
