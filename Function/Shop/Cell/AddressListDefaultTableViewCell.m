//
//  AddressListDefaultTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AddressListDefaultTableViewCell.h"

@implementation AddressListDefaultTableViewCell

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
        self.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
    }
    return self;
    
}
- (void)loadCellView {
    UIImageView *defaultImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(260, 172, 200, 191)];
    defaultImageView.image = [UIImage imageNamed:@"address_list_default_image"];
    [self addSubview:defaultImageView];
    
    UILabel *topLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 427, 720, 34) title:@"目前还没有添加地址" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    [self addSubview:topLabel];
    
    UILabel *bottomLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 525, 720, 34) title:@"点击下面按钮新增" titleColor:kColorForccc textAlignment:NSTextAlignmentCenter font:30];
    [self addSubview:bottomLabel];
}

@end
