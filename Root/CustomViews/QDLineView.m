//
//  QDLineView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/11.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDLineView.h"

@implementation QDLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColorFor83;
        self.alpha = 0.6;
    }
    return self;
}
//- (void)setupCustomView {
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(104, 96, 720 - 104, 96)];
//    lineView.backgroundColor = kColorFor83;
//    lineView.alpha = 0.6;
//    [self addSubview:lineView];
//}
@end
