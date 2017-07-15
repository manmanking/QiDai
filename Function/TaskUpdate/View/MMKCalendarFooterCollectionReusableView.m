//
//  MMKCalendarFooterCollectionReusableView.m
//  QiDai
//
//  Created by manman'swork on 16/11/13.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "MMKCalendarFooterCollectionReusableView.h"

@interface MMKCalendarFooterCollectionReusableView()

@property (nonatomic,strong) UIView *backgroundView;


@end


@implementation MMKCalendarFooterCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self customUiView];
        
    }
    return self;
    
    
    
}


- (void)customUiView
{
    [self addSubview:self.backgroundView];
    
    
    
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0,0, 710, 90)];
        UILabel *redCircle = [[UILabel alloc]initWithFrame:CGRectMake750(0, 40, 10, 10)];
        redCircle.layer.borderColor = [[UIColor redColor]CGColor];
        redCircle.layer.borderWidth = 1.f;
        redCircle.layer.cornerRadius = 5.f *SizeScale750;
        [_backgroundView addSubview:redCircle];
        UILabel *beUpToStandardCircle = [[UILabel alloc]initWithFrame:CGRectMake750(30, 30,50, 30)];
        beUpToStandardCircle.text = @"达标";
        beUpToStandardCircle.font = [UIFont systemFontOfSize:22*SizeScale750];
        beUpToStandardCircle.textColor = [UIColor whiteColor];
        [_backgroundView addSubview:beUpToStandardCircle];
        
        UILabel *grayCircle = [[UILabel alloc]initWithFrame:CGRectMake750(130,40, 10, 10)];
        grayCircle.layer.borderColor = [[UIColor grayColor]CGColor];
        grayCircle.layer.borderWidth = 1.f;
        grayCircle.layer.cornerRadius = 5.f *SizeScale750;
        [_backgroundView addSubview:grayCircle];
        UILabel *notUpToThetandardCircle = [[UILabel alloc]initWithFrame:CGRectMake750(150, 30,80, 30)];
        notUpToThetandardCircle.text = @"未达标";
        notUpToThetandardCircle.font = [UIFont systemFontOfSize:22*SizeScale750];
        notUpToThetandardCircle.textColor = [UIColor whiteColor];
        [_backgroundView addSubview:notUpToThetandardCircle];
        
        
    }
    
    return _backgroundView;
    
}




@end
