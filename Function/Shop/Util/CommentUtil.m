//
//  CommentUtil.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CommentUtil.h"
#import "CommentModel.h"
@implementation CommentUtil

- (void)setModel:(CommentModel *)model {
    UILabel *commentLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 110, 650, 34) title:model.common titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];;
    //布局
    CGSize titleSize = [commentLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(commentLabel.bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:(26*SizeScale)]} context:nil].size;
    commentLabel.height = titleSize.height;
    self.cellHeight = commentLabel.bottom;
    //310为大于3张图片的高度 155为1到3张图片的高度
    
    NSInteger imageViewHeight = 0;
    NSArray *array = [model.image componentsSeparatedByString:@","];
    if (![model.image isExist]) {
        array = nil;
    }
    if (array.count == 0) {
        imageViewHeight = 0;
    } else if (array.count <= 3) {
        imageViewHeight = 155;
    } else {
        imageViewHeight = 310;
    }
    self.cellHeight = self.cellHeight + imageViewHeight*SizeScale + 90*SizeScale;

}

@end
