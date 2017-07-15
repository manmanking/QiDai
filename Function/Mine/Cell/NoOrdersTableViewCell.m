//
//  NoOrdersTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NoOrdersTableViewCell.h"

@implementation NoOrdersTableViewCell

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
        self.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    }
    return self;
    
}
- (void)loadCellView {
    UIImageView *defaultImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(262, 180, 210, 186)];
    defaultImageView.image = [UIImage imageNamed:@"orders_default_image"];
    [self addSubview:defaultImageView];
    
    UILabel *topLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 427, 720, 36) title:@"暂无相关订单" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self addSubview:topLabel];
    
    UILabel *bottomLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 525, 720, 34) title:@"不能让大奖溜走,赶快扫购吧" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:30];
    [self addSubview:bottomLabel];
}

@end
