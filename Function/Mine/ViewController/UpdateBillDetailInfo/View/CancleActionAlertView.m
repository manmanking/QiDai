//
//  CancleActionAlertView.m
//  QiDai
//
//  Created by manman'swork on 16/12/15.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "CancleActionAlertView.h"

@interface CancleActionAlertView()

@property (nonatomic,strong) UIButton *confirmButton;

@property (nonatomic,strong) UIButton *cancleButton;

@property (nonatomic,strong) UIButton *closeButton;


@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) UIImageView *alertBackgroundImageView;



@end



@implementation CancleActionAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self customUIViewAutolayout];
        
    }
    return self;
}


- (void)customUIViewAutolayout
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.alertBackgroundImageView];
    [self addSubview:self.confirmButton];
    [self addSubview:self.cancleButton];
    [self addSubview:self.closeButton];
     
}


- (void)handleSingleTapGesture:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"点击 背景  消失");
     [self removeFromSuperview];
    
}

- (void)confirmButtonClick:(UIButton *) sender
{
    NSLog(@"确定按钮  ...");
    
    self.confirmAction(nil);
    
    
    
}


- (void)cancleButtonClick:(UIButton *) sender
{
    NSLog(@"取消按钮  ...");
    [self removeFromSuperview];
    //self.cancleAction(nil);
    
    
    
}


- (void)closeButtonClick:(UIButton *) sender
{
    NSLog(@"关闭按钮  ...");
    [self removeFromSuperview];
    
    
    
}



#pragma ------lazyload

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton  = [[UIButton alloc]initWithFrame:CGRectMake750(153,704,180,60)];
        [_confirmButton setImage:[UIImage imageNamed:@"CancleActionAlertViewConfirmButtonImageView"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _confirmButton;
}


- (UIButton *)cancleButton
{
    if (!_cancleButton) {
        _cancleButton  = [[UIButton alloc]initWithFrame:CGRectMake750(417,704,180,60)];
        [_cancleButton setImage:[UIImage imageNamed:@"CancleActionAlertViewCancleButtonImageView"] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancleButton;
}



- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton  = [[UIButton alloc]initWithFrame:CGRectMake750(615,510,60,60)];
        [_closeButton setImage:[UIImage imageNamed:@"CancleActionAlertViewCloseButtonImageView"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}



- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:kGetKeyWindow.frame];
        _backgroundView.backgroundColor = [UIColor grayColor];
        _backgroundView.alpha = 0.5f;
        
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_backgroundView addGestureRecognizer:singleRecognizer];
        
        
    }
    return _backgroundView;
    
    
    
}


- (UIImageView *)alertBackgroundImageView
{
    if (!_alertBackgroundImageView) {
        _alertBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(65, 500, 620, 300)];
        _alertBackgroundImageView.image = [UIImage imageNamed:@"CancleActionAlertViewBackgroundImageView"];
        
    }
    return _alertBackgroundImageView;
    
}

@end
