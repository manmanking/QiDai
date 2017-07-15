//
//  PromptUpdateView.m
//  QiDai
//
//  Created by 张汇丰 on 16/8/5.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "PromptUpdateView.h"
#import "UIButton+EnlargeEdge.h"

@interface PromptUpdateView ()

@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *detailLabel;

@end
@implementation PromptUpdateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(74, 336, 572, 682)];
    bgView.centerX = self.centerX;
    bgView.centerY = self.centerY;
    bgView.backgroundColor = UIColorFromRGB_16(0xececec);
    [bgView setRoundedCorners:UIRectCornerAllCorners radius:8*SizeScale];
    [self addSubview:bgView];
    
    UIImageView *downloadImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(177.5, 56, 217, 152)];
    downloadImageView.image = [UIImage imageNamed:@"upload_app_image"];
    [bgView addSubview:downloadImageView];
    
    [bgView addSubview:self.titleLabel];
    [bgView addSubview:self.detailLabel];
    
    self.closeButton = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(513, 30, 25, 25) NormalImageString:@"address_dismiss_image" tapAction:^(UIButton *button) {
        [self removeFromSuperview];
    }];
    [self.closeButton setEnlargeEdge:10*SizeScale];
    [bgView addSubview:self.closeButton];
    
    UIButton *uploadBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(66, 570, 440, 70) title:@"立即更新" titleColor:kColorForfff titleFont:30 backgroundColor:kColorForE60012 tapAction:^(UIButton *button) {
        self.clickUploadBlock();
    }];
    [uploadBtn setRoundedCorners:UIRectCornerAllCorners radius:4*SizeScale];
    [bgView addSubview:uploadBtn];
    
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}
- (void)setDetailStr:(NSString *)detailStr {
    _detailStr = detailStr;
    
    NSArray *array = [detailStr componentsSeparatedByString:@"||"];
    
    if (array.count == 0) {
        return;
    }
    NSString *detailString = @"";
    for (int i = 0; i < array.count; i++) {
        NSString *tempStr = array[i];
        if (i == 0) {
            detailString = tempStr;
        } else {
            detailString = [NSString stringWithFormat:@"%@\n%@",detailString,tempStr];
        }
    }
    self.detailLabel.text = detailString;
    if ([_updateTypeStr isEqual:@2]) {
        _closeButton.hidden = YES;
        
    }
    
}
#pragma mark --- lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 255, 572, 110) title:@"骑待1.3.0新版发布!" titleColor:kColorForE60012 textAlignment:NSTextAlignmentCenter font:36];
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel qd_labelWithFrame:CGRectMake720(47, 330, 572 - 47*2, 190) title:@"" titleColor:kColorFor666 textAlignment:NSTextAlignmentLeft font:28];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}
@end
