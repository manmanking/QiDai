//
//  QDAlphaWarnView.m
//  QiDai
//
//  Created by 张汇丰 on 16/8/8.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDAlphaWarnView.h"


@interface QDAlphaWarnView()


@property (nonatomic,strong)UIImageView *imageView;

@end



@implementation QDAlphaWarnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromAlphaRGB(0x000000, 0.2);
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake720(54, 0, 612, 132)];
    self.imageView.top = self.bottom - 320*SizeScale;
    self.imageView.image = [UIImage imageNamed:@"OrderTemporaryImageView"];//shop_alert_Image
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBlankView)];
    [self addGestureRecognizer:tapGR];
    
    UIButton *closeBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(567, 26, 25, 25) NormalImageString:@"address_dismiss_image" tapAction:^(UIButton *button) {
        [self clickBlankView];
    }];
    [self.imageView addSubview:closeBtn];
}

- (void)setWhereFromStr:(NSString *)whereFromStr
{
    if ([whereFromStr isEqualToString:@"OrderTemporary"]) {
        self.imageView.image = [UIImage imageNamed:@"OrderTemporaryImageView"];
    }
    
}


- (void)clickBlankView {
    [self removeFromSuperview];
}
@end
