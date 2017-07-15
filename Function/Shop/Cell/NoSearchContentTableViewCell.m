//
//  NoSearchContentTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/25.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NoSearchContentTableViewCell.h"

@implementation NoSearchContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadCellView];
    }
    return self;
    
}
- (void)loadCellView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake720(211, 248, 268, 238)];
    imageView.image = [UIImage imageNamed:@"search_no_content_image"];
    [self addSubview:imageView];
    
    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 552, 720, 36) title:@"暂无相关商品" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self addSubview:textLabel];
}

@end
