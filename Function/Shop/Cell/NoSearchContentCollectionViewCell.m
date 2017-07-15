//
//  NoSearchContentCollectionViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/25.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NoSearchContentCollectionViewCell.h"

@implementation NoSearchContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupCustomView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake720(211, 248, 268, 238)];
    imageView.image = [UIImage imageNamed:@"search_no_content_image"];
    [self addSubview:imageView];
    
    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 552, 720, 36) title:@"暂无相关商品" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self addSubview:textLabel];
}

@end
