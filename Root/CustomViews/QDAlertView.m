//
//  QDAlertView.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "QDAlertView.h"

@interface QDAlertView ()

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIButton *sureBtn;
@end
@implementation QDAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromAlphaRGB(0x000000, 0.2);
        [self setupCustomView];
    }
    return self;
}

- (void)setupCustomView {
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake720(74, 336, 572, 362)];
    self.backgroundView.backgroundColor = UIColorFromRGB_16(0xececec);
    //[self.backgroundView setRoundedCorners:UIRectCornerAllCorners radius:8*SizeScale];
    [self addSubview:self.backgroundView];
    
    self.titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(90, 90, 572 - 90*2, 110) title:@"确定删除地址吗?" titleColor:kColorFor000 textAlignment:NSTextAlignmentCenter font:36];
    //self.titleLabel.backgroundColor = [UIColor redColor];
    [self.backgroundView addSubview:self.titleLabel];

    //QDLog(@"title frame :%@  sizescale %f",NSStringFromCGRect(self.titleLabel.frame),SizeScale);
    
    UIButton *closeBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(513, 30, 25, 25) NormalImageString:@"address_dismiss_image" tapAction:^(UIButton *button) {
        [self removeFromSuperview];
    }];
    [self.backgroundView addSubview:closeBtn];
    
    
    // modify by manman on 2016-09-28 start of line
    // 这样可以动态的设置 视图的样式
    //由于按钮的个数是不确定的 所以这个按钮的设置可以放在更新视图中  所以下面对按钮的设置将被注视掉

//    self.cancelBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(31, self.titleLabel.bottom/(SizeScale) +20, 244, 70) title:@"取消" titleColor:kColorForfff titleFont:30 backgroundColor:UIColorFromRGB_10(124, 124, 124) tapAction:^(UIButton *button) {
//        
//        if (self.rewriteCancleMethod) {
//            self.clickCancleBlock();
//            //add by manman  on 2016-09-14  BUG  start of line
//            [self removeFromSuperview];
//            // end of line
//            return ;
//        }
//        
//        if (self.isContrary) {
//            self.clickSureBlock();
//        } else {
//            [self clickCancelBtn];
//        }
//    }];
//    //QDLog(@"cancle frame :%@",NSStringFromCGRect(_cancelBtn.frame));
//    [self.backgroundView addSubview:self.cancelBtn];
//   
//    
//    self.sureBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(297, self.titleLabel.bottom/(SizeScale) +20, 244, 70) title:@"确定" titleColor:kColorForfff titleFont:30 backgroundColor:UIColorFromRGB_10(199, 0, 16) tapAction:^(UIButton *button) {
//        
//        if (self.isContrary) {
//            [self clickCancelBtn];
//        } else {
//            self.clickSureBlock();
//        }
//        //add by manman  on 2016-09-14  BUG  start of line
//        [self removeFromSuperview];
//        // end of line
//        
//        
//    }];
//    [self.backgroundView addSubview:self.sureBtn];
    
    // end of line

    
}

/**
 *  更新视图  title 和按钮都确定好之后在 更新视图 
 */
- (void)updateUIAutolayout
{
    
    CGRect okayButtonFrame = CGRectZero;
    if (self.cancleBtnTitle.length >0 && self.sureBtnTitle.length >0) {
        
            //两个按钮都存在
            //31, 220, 244, 70
            CGRect cancleButtonFrame = CGRectMake(31,220, 244, 70);
            okayButtonFrame = CGRectMake(297, 220, 244, 70);
            [self createCancleButtonFrame:cancleButtonFrame];
            //[self createOKayButtonFrame:okayButtonFrame];
    }

     QDLog(@"backgroundView frame  :%@",NSStringFromCGRect(self.backgroundView.frame));
    //一个按钮
    if (self.sureBtnTitle.length >0 && self.cancleBtnTitle.length <= 0)
        okayButtonFrame = CGRectMake((self.backgroundView.width/(SizeScale) - 244 )/2, 220, 244, 70);
    
    [self createOKayButtonFrame:okayButtonFrame];

    self.titleLabel.text = self.title;
    [self.titleLabel setupLabelAutolayoutHeight];

    CGRect surButtonFrameUpdate =   CGRectMake(self.sureBtn.frame.origin.x,30 + self.titleLabel.bottom, self.sureBtn.frame.size.width, self.sureBtn.frame.size.height) ;
    self.sureBtn.frame = surButtonFrameUpdate;
    if (self.cancleBtnTitle.length >0) {
        CGRect cancleButtonFrameUpdate =   CGRectMake(self.cancelBtn.frame.origin.x, 30 + self.titleLabel.bottom, self.cancelBtn.frame.size.width, self.cancelBtn.frame.size.height);
        self.cancelBtn.frame = cancleButtonFrameUpdate;
    }
    
    CGRect bgViewFrameUpdate = CGRectMake(self.backgroundView.frame.origin.x/(SizeScale), self.backgroundView.frame.origin.y/(SizeScale), self.backgroundView.frame.size.width/(SizeScale), self.backgroundView.frame.size.height/(SizeScale));
    self.backgroundView.frame = CGRectMake720(bgViewFrameUpdate.origin.x, bgViewFrameUpdate.origin.y, bgViewFrameUpdate.size.width,self.sureBtn.bottom/(SizeScale)+70 );// self.sureBtn.bottom/(SizeScale)+70;
    //self.backgroundView.backgroundColor = [UIColor redColor];//UIColorFromRGB_16(0xececec);
    QDLog(@"backgroundView update frame  :%@",NSStringFromCGRect(self.backgroundView.frame));
    [self.backgroundView setRoundedCorners:UIRectCornerAllCorners radius:8*SizeScale];
    
    //self.frame = self.backgroundView.frame;
    
}


- (void)createCancleButtonFrame:(CGRect)cancleFrame
{
    
    self.cancelBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(cancleFrame.origin.x ,cancleFrame.origin.y , 244, 70) title:self.cancleBtnTitle titleColor:kColorForfff titleFont:30 backgroundColor:UIColorFromRGB_10(124, 124, 124) tapAction:^(UIButton *button) {
        
        if (self.rewriteCancleMethod) {
            self.clickCancleBlock();
            //add by manman  on 2016-09-14  BUG  start of line
            [self removeFromSuperview];
            // end of line
            return ;
        }
        
        if (self.isContrary) {
            self.clickSureBlock();
        } else {
            [self clickCancelBtn];
        }
    }];
    //QDLog(@"cancle frame :%@",NSStringFromCGRect(_cancelBtn.frame));
    [self.backgroundView addSubview:self.cancelBtn];
    
    
}


- (void)createOKayButtonFrame:(CGRect)okayFrame
{
    self.sureBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(okayFrame.origin.x, okayFrame.origin.y, 244, 70) title:self.sureBtnTitle titleColor:kColorForfff titleFont:30 backgroundColor:UIColorFromRGB_10(199, 0, 16) tapAction:^(UIButton *button) {
        
        if (self.isContrary) {
            [self clickCancelBtn];
        } else {
            self.clickSureBlock();
        }
        //add by manman  on 2016-09-14  BUG  start of line
        [self removeFromSuperview];
        // end of line
        
        
    }];
    
      [self.backgroundView addSubview:self.sureBtn];
    
    
    
}

#pragma mark --- private method
- (void)clickCancelBtn {
    [self removeFromSuperview];
}
//- (void)setTitle:(NSString *)title {
//    _title = title;
//    self.titleLabel.text = title;
//}
//- (void)setSureBtnTitle:(NSString *)sureBtnTitle {
//    _sureBtnTitle = sureBtnTitle;
//    [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
//}
//- (void)setCancleBtnTitle:(NSString *)cancleBtnTitle {
//    _cancleBtnTitle = cancleBtnTitle;
//    [self.cancelBtn setTitle:cancleBtnTitle forState:UIControlStateNormal];
//}
//- (void)setIsContrary:(BOOL)isContrary {
//    _isContrary = isContrary;
//    if (isContrary) {
//
//    }
//}
#pragma mark --- lazy load
//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        
//        //_titleLabel.numberOfLines = 0;
//    }
//    return _titleLabel;
//}

@end
