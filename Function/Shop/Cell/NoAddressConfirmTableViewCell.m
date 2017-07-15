//
//  NoAddressConfirmTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/8.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "NoAddressConfirmTableViewCell.h"

@implementation NoAddressConfirmTableViewCell

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
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
    
}
- (void)loadCellView {
    UIImageView *loactionImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(36, 50, 30, 43)];
    loactionImageView.image = [UIImage imageNamed:@"address_location_image_p"];
    [self addSubview:loactionImageView];
    
    UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(116, 50, 120, 43) title:@"收货地址" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
    [self addSubview:textLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(676, 68, 10, 20)];
    arrowImageView.image = [UIImage imageNamed:@"mine_right_arrow_image"];
    [self addSubview:arrowImageView];
}
@end
