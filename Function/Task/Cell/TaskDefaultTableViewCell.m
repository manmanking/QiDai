//
//  TaskDefaultTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/8/8.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskDefaultTableViewCell.h"

@implementation TaskDefaultTableViewCell

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
    
}

@end
