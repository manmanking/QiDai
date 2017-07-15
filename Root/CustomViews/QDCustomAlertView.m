//
//  QDCustomAlertView.m
//  QiDai
//
//  Created by manman'swork on 16/9/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDCustomAlertView.h"


@interface QDCustomAlertView()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIButton *sureBtn;

@end

@implementation QDCustomAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromAlphaRGB(0x000000, 0.2);
        [self setupCustomView];
    }
    return self;
}

- (void)setupCustomView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(74, 336, 572, 504)];
    bgView.backgroundColor = UIColorFromRGB_16(0xececec);
    [bgView setRoundedCorners:UIRectCornerAllCorners radius:8*SizeScale];
    [self addSubview:bgView];
    
    [bgView addSubview:self.titleLabel];
  
    QDLog(@"title frame :%@  sizescale %f",NSStringFromCGRect(self.titleLabel.frame),SizeScale);
    
    UIButton *closeBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(513, 30, 25, 25) NormalImageString:@"address_dismiss_image" tapAction:^(UIButton *button) {
        [self removeFromSuperview];
    }];
    [bgView addSubview:closeBtn];
    //31, 220, 244, 70

    QDLog(@"cancle frame :%@",NSStringFromCGRect(_cancelBtn.frame));
    [bgView addSubview:self.cancelBtn];
    
    self.sureBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720((bgView.frame.size.width/(SizeScale) - 244)/2, self.titleLabel.bottom/(SizeScale) +20, 244, 70) title:@"确定" titleColor:kColorForfff titleFont:30 backgroundColor:UIColorFromRGB_10(199, 0, 16) tapAction:^(UIButton *button) {
        
       
        //add by manman  on 2016-09-14  BUG  start of line
        [self removeFromSuperview];
        // end of line
        
        
    }];
    [bgView addSubview:self.sureBtn];
    CGRect bgViewFrameUpdate = CGRectMake(bgView.frame.origin.x/(SizeScale), bgView.frame.origin.y/(SizeScale), bgView.frame.size.width/(SizeScale), bgView.frame.size.height/(SizeScale));
    bgView.frame = CGRectMake720(bgViewFrameUpdate.origin.x, bgViewFrameUpdate.origin.y, bgViewFrameUpdate.size.width,self.sureBtn.bottom/(SizeScale)+70 );//
    
}

#pragma mark --- private method
- (void)clickCancelBtn {
    [self removeFromSuperview];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
- (void)setSureBtnTitle:(NSString *)sureBtnTitle {
    _sureBtnTitle = sureBtnTitle;
    [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
}
- (void)setCancleBtnTitle:(NSString *)cancleBtnTitle {
    _cancleBtnTitle = cancleBtnTitle;
    [self.cancelBtn setTitle:cancleBtnTitle forState:UIControlStateNormal];
}

#pragma mark --- lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(70, 90,572 - 2*70 , 300) title:@"确定删除地址吗?" titleColor:kColorFor000 textAlignment:NSTextAlignmentCenter font:36];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


@end
