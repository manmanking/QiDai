//
//  ExpressAssembleTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "ExpressAssembleTableViewCell.h"

@interface ExpressAssembleTableViewCell()


@property (nonatomic,strong) UIButton *selectedButton;




@end



@implementation ExpressAssembleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self customUIViewAutolayout];
        
        
    }
    
    
    return self;
    
}

- (void)customUIViewAutolayout

{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.selectedButton];
    
}


#pragma  -------lazyload

- (void)selectedButtonClick:(UIButton *)sender
{
    sender.selected = YES;
    NSLog(@"点击 选中 组装 发货");
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.indexRowStr,@"indexRow",self.titleLabel.text,@"key",nil];
    
    self.selectedExpressAssembleAction(dic);
    
    
    
}


- (void)setIsSelectedSuccess:(BOOL)isSelectedSuccess
{
    if (isSelectedSuccess) {
        self.selectedButton.selected = isSelectedSuccess;
    }else
    {
        self.selectedButton.selected = isSelectedSuccess;
    }
    
    
    
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(70, 40,200,27)];
        _titleLabel.text = @"组装后发货";
        _titleLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(270, 43,300,23)];
        _subtitleLabel.text = @"需支付100元组装费";
        _subtitleLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _subtitleLabel.textColor = [UIColor grayColor];
    }
    
    return _subtitleLabel;
 
}


- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc]initWithFrame:CGRectMake750(20, 40, 30, 30)];
        [_selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedButton setImage:[UIImage imageNamed:@"ExpressAssembleCellSelected"] forState:UIControlStateSelected];
        [_selectedButton setImage:[UIImage imageNamed:@"ExpressAssembleCellUnSelected"] forState:UIControlStateNormal];
    }
    
    return _selectedButton;
    
}





@end
