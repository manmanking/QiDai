//
//  TaskShareView.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  分享的视图  --放在用户看不懂的位置   --分享时，直接截图和其他的图片拼接

#import <UIKit/UIKit.h>
@class TaskShareModel;
@interface TaskShareView : UIView

@property (nonatomic,strong) TaskShareModel *shareModel;

@end
