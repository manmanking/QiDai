//
//  PromptUpdateView.h
//  QiDai
//
//  Created by 张汇丰 on 16/8/5.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptUpdateView : UIView


@property (nonatomic,copy) NSString *updateTypeStr;

@property (nonatomic,copy) NSString *titleStr;

@property (nonatomic,copy) NSString *detailStr;

@property (nonatomic,copy) ClickView clickUploadBlock;

@end
