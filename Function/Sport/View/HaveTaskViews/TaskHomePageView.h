//
//  TaskHomePageView.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/26.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SportTaskModel;
@interface TaskHomePageView : UIView

@property (nonatomic,copy) ClickView clickStartBtnBlock;

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,strong) SportTaskModel *model;


@property (nonatomic,assign) BOOL existUploadData;
@end
