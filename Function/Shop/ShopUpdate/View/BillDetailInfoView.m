//
//  BillDetailInfoView.m
//  QiDai
//
//  Created by manman'swork on 16/11/30.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "BillDetailInfoView.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"

@interface BillDetailInfoView()

@property (nonatomic,strong) UIImageView *bikeFlagImageView;


@property (nonatomic,strong) UILabel *bikeNameLabel;

@property (nonatomic,strong) UILabel *bikeColorLabel;

@property (nonatomic,strong) UILabel *bikeSizeLabel;

@property (nonatomic,strong) UILabel *bikeRewardTitleLabel;
@property (nonatomic,strong) UILabel *bikeRewardLabel;

@property (nonatomic,strong) UILabel *bikePriceTitleLabel;
@property (nonatomic,strong) UILabel *bikePriceLabel;

@property (nonatomic,strong) UILabel *bikeActivityTitleLabel;
@property (nonatomic,strong) UILabel *bikeActivityLabel;

@property (nonatomic,strong) UILabel *bikeExpressdeliveryTitleLabel;





@end



@implementation BillDetailInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
        [self customUIViewAutolayout];
        
    }
    
    return self;
    
    
    
    
}


- (void)customUIViewAutolayout
{
   
    [self addSubview:self.bikeFlagImageView];
    [self addSubview:self.bikeNameLabel];
    [self addSubview:self.bikeColorLabel];
    //[self addSubview:self.bikeSizeLabel];
    [self addSubview:self.bikeRewardLabel];
    [self addSubview:self.bikeRewardTitleLabel];
    [self addSubview:self.bikePriceTitleLabel];
    [self addSubview:self.bikePriceLabel];
    [self addSubview:self.bikeActivityLabel];
    [self addSubview:self.bikeActivityTitleLabel];
    //[self addSubview:self.bikeExpressdeliveryTitleLabel];
    
}


- (void)setBillDetailGoodsModel:(GoodsModel *)billDetailGoodsModel
{
    
    [self.bikeFlagImageView sd_setImageWithURL:[NSURL URLWithString:self.selectedImageViewUrlStr]];
    self.bikeNameLabel.text = [NSString stringWithString:billDetailGoodsModel.name];
    self.bikeColorLabel.text = [NSString stringWithFormat:@"颜色:%@",billDetailGoodsModel.color];
    self.bikePriceLabel.text = [NSString stringWithFormat:@"¥%.2f",billDetailGoodsModel.price.floatValue];
    self.bikeRewardLabel.text = [NSString stringWithFormat:@"¥%.2f",self.billDetailActivityModel.refund.floatValue];
    if (self.billDetailActivityModel.information != nil)
    {
    self.bikeActivityLabel.text = [NSString stringWithString:self.billDetailActivityModel.information];    
    }
    
}


#pragma ------lazyload


- (UIImageView *)bikeFlagImageView
{
    if (!_bikeFlagImageView) {
        _bikeFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20, 40,160,160)];
        _bikeFlagImageView.image = [UIImage imageNamed:@"bikePlacehodler"];
        
    }
    
    return _bikeFlagImageView;
    
}

- (UILabel *)bikeNameLabel
{
    if (!_bikeNameLabel) {
        _bikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake750(220, 40, 530, 28)];
        _bikeNameLabel.text = @"Tern 燕鸥折叠自行车 Link N8";
        _bikeNameLabel.font = [UIFont systemFontOfSize:28 *SizeScale750];
        _bikeNameLabel.textColor = [UIColor whiteColor];
    }
    
    return _bikeNameLabel;
    
    
}


- (UILabel *)bikeColorLabel
{
    if (!_bikeColorLabel) {
        _bikeColorLabel = [[UILabel alloc]initWithFrame:CGRectMake750(220,86,300, 23)];
        _bikeColorLabel.textColor = [UIColor grayColor];
        _bikeColorLabel.font = [UIFont systemFontOfSize:23 *SizeScale750];
        _bikeColorLabel.text = @"颜色:土豪金";
        
    }
    return _bikeColorLabel;
    
    
}

- (UILabel *)bikeSizeLabel
{
    if (!_bikeSizeLabel) {
        _bikeSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake750(400,90, 150, 28)];
        _bikeSizeLabel.textColor = [UIColor grayColor];
        _bikeSizeLabel.text = @"尺寸:M";
    }
    return _bikeSizeLabel;

}
- (UILabel *)bikeRewardTitleLabel
{
    if (!_bikeRewardTitleLabel) {
        _bikeRewardTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(220,176 ,100, 24)];
        _bikeRewardTitleLabel.text = @"奖金:";
        _bikeRewardTitleLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _bikeRewardTitleLabel.textColor = [UIColor grayColor];
    }
    return _bikeRewardTitleLabel;

}

- (UILabel *)bikeRewardLabel
{
    if (!_bikeRewardLabel) {
        _bikeRewardLabel = [[UILabel alloc]initWithFrame:CGRectMake750(290, 180, 100, 24)];
        _bikeRewardLabel.text = @"¥888";
        _bikeRewardLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _bikeRewardLabel.textColor = [UIColor whiteColor];
        
    }
    return _bikeRewardLabel;
    
}

- (UILabel *)bikePriceTitleLabel
{
    if (!_bikePriceTitleLabel) {
        _bikePriceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(400, 180,150, 24)];
        _bikePriceTitleLabel.text = @"商品金额:";
        _bikePriceTitleLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _bikePriceTitleLabel.textColor = [UIColor grayColor];
    }
    return _bikePriceTitleLabel;

}

- (UILabel *)bikePriceLabel
{
    if (!_bikePriceLabel) {
        _bikePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake750(550, 180, 100, 24)];
        _bikePriceLabel.text = @"¥8888";
        _bikePriceLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _bikePriceLabel.textColor = [UIColor whiteColor];
    }
    return _bikePriceLabel;

}

- (UILabel *)bikeActivityTitleLabel
{
    if (!_bikeActivityTitleLabel) {
        _bikeActivityTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20,300 , 150, 24)];
        _bikeActivityTitleLabel.text = @"已选活动:";
        _bikeActivityTitleLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        
        _bikeActivityTitleLabel.textColor = [UIColor whiteColor];
    }
    return _bikeActivityTitleLabel;
    
    
}

- (UILabel *)bikeActivityLabel
{
    if (!_bikeActivityLabel) {
        _bikeActivityLabel = [[UILabel alloc]initWithFrame:CGRectMake750(150, 300, 400, 24)];
        _bikeActivityLabel.text = @"每天10公里,每天奖金10元";
        _bikeActivityLabel.font = [UIFont systemFontOfSize:24*SizeScale750];
        _bikeActivityLabel.textColor = [UIColor whiteColor];
        
    }
    return _bikeActivityLabel;
    
    
    
}

//- (UILabel *)bikeExpressdeliveryTitleLabel
//{
//    if (!_bikeExpressdeliveryTitleLabel) {
//        _bikeExpressdeliveryTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,390, 100, 28)];
//        _bikeExpressdeliveryTitleLabel.text = @"快递";
//        _bikeExpressdeliveryTitleLabel.textColor = [UIColor grayColor];
//    }
//    return _bikeExpressdeliveryTitleLabel;
// 
//}

@end
