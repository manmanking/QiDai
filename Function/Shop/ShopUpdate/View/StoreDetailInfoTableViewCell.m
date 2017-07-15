//
//  StoreDetailInfoTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/12/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "StoreDetailInfoTableViewCell.h"

@interface StoreDetailInfoTableViewCell()


@property (nonatomic,strong) UIImageView *positionFlagImageView;

@property (nonatomic,strong) UIImageView *distanceFlagImageView;

@property (nonatomic,strong) UILabel *storeDistanceLabel;

@property (nonatomic,strong) UILabel *storeTitleLabel;

@property (nonatomic,strong) UILabel *storeSubtitleLabel;

@property (nonatomic,strong) UIButton *selectedButton;

@end

@implementation StoreDetailInfoTableViewCell


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
    [self.contentView addSubview:self.storeTitleLabel];
    [self.contentView addSubview:self.storeSubtitleLabel];
    [self.contentView addSubview:self.positionFlagImageView];
    [self.contentView addSubview:self.distanceFlagImageView];
    [self.contentView addSubview:self.storeDistanceLabel];
    [self.contentView addSubview:self.selectedButton];
    
}





- (void)setStoreDetailInfoShopAddressModel:(ShopAddressModel *)storeDetailInfoShopAddressModel
{
    self.storeTitleLabel.text = [NSString stringWithFormat:@"%@",storeDetailInfoShopAddressModel.name];
    self.storeSubtitleLabel.text = [NSString stringWithFormat:@"%@",storeDetailInfoShopAddressModel.address];
    self.storeDistanceLabel.text = [NSString stringWithFormat:@"%.2fkm",storeDetailInfoShopAddressModel.distance.floatValue /1000];
    self.selectedButton.hidden = !_isEnable;
    
    
    
    
}



#pragma  -------lazyload

- (void)selectedButtonClick:(UIButton *)sender
{
    NSLog(@"点击 选中 更多店铺");
    self.choiceMoreStoreAction(@"选中");
    
    
    
    
    
}








- (UIImageView *)positionFlagImageView
{
    if (!_positionFlagImageView) {
        _positionFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20, 87,18,15)];
        _positionFlagImageView.image = [UIImage imageNamed:@"ShopUpdateStoreDetailPositionImageView"];
        
    }
    
    return _positionFlagImageView;
    
    
    
}


- (UIImageView *)distanceFlagImageView
{
    if (!_distanceFlagImageView) {
        _distanceFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(590, 100,18,15)];
        _distanceFlagImageView.image = [UIImage imageNamed:@"ShopUpdateStoreDetailPositionImageView"];
        
    }
    
    return _distanceFlagImageView;
    
    
    
}

- (UILabel *)storeTitleLabel
{
    if (!_storeTitleLabel) {
        _storeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(56, 40, 390, 28)];
        _storeTitleLabel.text = @"Tern 折叠自行车学院路店";
        _storeTitleLabel.textColor = [UIColor whiteColor];
    }
    
    return _storeTitleLabel;
}

- (UILabel *)storeSubtitleLabel
{
    if (!_storeSubtitleLabel) {
        _storeSubtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(56, 90, 500, 28)];
        _storeSubtitleLabel.text = @"北京市海淀区学清路8号科技财富中心";
        _storeSubtitleLabel.textColor = [UIColor grayColor];
    }
    
    return _storeSubtitleLabel;
    
}
- (UILabel *)storeDistanceLabel
{
    if (!_storeDistanceLabel) {
        _storeDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake750(610, 100, 120,30)];
        _storeDistanceLabel.text = @"6.9km";
        _storeDistanceLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _storeDistanceLabel.textColor = [UIColor whiteColor];
    }
    
    return _storeDistanceLabel;
}

- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc]initWithFrame:CGRectMake750(600, 10, 200,30)];
        [_selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedButton setTitle:@"更多店铺>>" forState:UIControlStateNormal];
        _selectedButton.titleLabel.font = [UIFont systemFontOfSize:25*SizeScale750];
        [_selectedButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        
//        [_selectedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
//        [_selectedButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    return _selectedButton;
    
}


@end
