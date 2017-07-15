//
//  CommentUtil.h
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  用于计算CommentCell的高度

#import <Foundation/Foundation.h>
@class CommentModel;
@interface CommentUtil : NSObject

@property (nonatomic,strong) CommentModel *model;

@property (nonatomic,assign) NSInteger cellHeight;
@end
