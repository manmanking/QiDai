//
//  StoreListStoreInfoTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "StoreListStoreInfoTableViewCell.h"

@interface  StoreListStoreInfoTableViewCell()


@property (nonatomic,strong) UIImageView *distanceFlagImageView;

@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,strong) UIButton *telephoneButton;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *subtitleLable;


@end



@implementation StoreListStoreInfoTableViewCell

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
        
        [self customUIViewAutolayout];

    }
    return self;

}


- (void)customUIViewAutolayout
{
  
    
    
    
    
}


- (void)selectButtonClick:(UIButton *)sender
{
    
    NSLog(@"选中...");
    
    
    
}

- (void)telephoneButtonClick:(UIButton *)sender
{
    
    NSLog(@"电话");
    
}



#pragma --------lazyload



- (UIImageView *)distanceFlagImageView
{
    if (!_distanceFlagImageView) {
        _distanceFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(620,100, 20, 20)];
        _distanceFlagImageView.image = [UIImage imageNamed:@"ShopUpdateStoreDetailPositionImageView"];
    }
    return _distanceFlagImageView;
 
}

- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 50, 100, 80)];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setImage:[UIImage imageNamed:@"ShopUpdateGoodsDetailActivitySelectedImageView"] forState:UIControlStateNormal];
        
        
        
    }
    
    return _selectButton;
    
}


- (UIButton *)telephoneButton
{
    if (!_telephoneButton) {
        _telephoneButton = [[UIButton alloc]initWithFrame:CGRectMake(620, 20, 80, 80)];
        [_telephoneButton addTarget:self action:@selector(telephoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_telephoneButton setImage:[UIImage imageNamed:@"StoreListCellTelephoneImageView"] forState:UIControlStateNormal];
    }
    return _telephoneButton;
}



@end
