//
//  BrandListSectionCollectionReusableView.m
//  QiDai
//
//  Created by manman'swork on 16/9/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "BrandListSectionCollectionReusableView.h"

@interface BrandListSectionCollectionReusableView()


@property (nonatomic,strong)UIButton *synthesizeBtn;


@property (nonatomic,strong)UIButton *priceBtn;


@property (nonatomic,strong) NSString *upAndDown;


@end



@implementation BrandListSectionCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
       
        [self setupUIViewAutolayout];
    }
    return self;
    
}


- (void)setupUIViewAutolayout
{
    
    [self addSubview:self.synthesizeBtn];
    self.synthesizeBtn.selected = YES;
    self.upAndDown = @"UP";
    [self addSubview:self.priceBtn];
}




/**
 *  综合按钮
 *
 *  @return
 */
- (UIButton *)synthesizeBtn {
    if (!_synthesizeBtn) {
        _synthesizeBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(0,0, 360, 90) title:@"综合" titleColor:kColorForccc titleFont:30 backgroundColor:UIColorFromRGB_16(0x252525) tapAction:^(UIButton *button) {
            NSLog(@"点击 综合  按钮");
            self.synthesizeBtn.selected = YES;
            self.priceBtn.selected = NO;
            [_priceBtn setImage:[UIImage imageNamed:@"shop_arrow_common"] forState:UIControlStateNormal];
            [_synthesizeBtn setTitleColor:UIColorFromRGB_16(0xe60012) forState:UIControlStateSelected];
            [self synthesizeBtnClick];
            
            
        }];
        
    }
    
    return _synthesizeBtn;
}


/**
 *  价格按钮
 */
- (void)priceButtonClick
{
     self.synthesizeBtn.selected = NO;
    
    if (self.priceBtn.selected)
    {
        
        if ([self.upAndDown isEqualToString:@"DOWN"])
        {
            [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_desc"] forState:UIControlStateSelected];
            self.priceBtnClick(self.upAndDown);
            self.upAndDown = @"UP";
        }
        else if([self.upAndDown isEqualToString:@"UP"])
        {
            [self.priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
            self.priceBtnClick(self.upAndDown);
            self.upAndDown = @"DOWN";
        }
        
    }
    else
    {
        self.priceBtn.selected = YES;
        self.priceBtnClick(self.upAndDown);
    }
    
    
}



- (UIButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(360,0, 360, 90) title:@"价格" titleColor:kColorForccc titleFont:30 backgroundColor:UIColorFromRGB_16(0x252525) tapAction:^(UIButton *button) {
            
            // 添加点击 价格按钮的视图变化
            // 数据的操作是由外部控制器操作
            NSLog(@"点击 价格  按钮");
            
            [self priceButtonClick];
            
            
        }];
        _priceBtn.imageView.contentMode = UIViewContentModeRight;
        _priceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_priceBtn setTitleColor:UIColorFromRGB_16(0xe60012) forState:UIControlStateSelected];
        [_priceBtn setImage:[UIImage imageNamed:@"shop_arrow_common"] forState:UIControlStateNormal];
        [_priceBtn setImage:[UIImage imageNamed:@"shop_arrow_asc"] forState:UIControlStateSelected];
    }
    return _priceBtn;
}
@end
