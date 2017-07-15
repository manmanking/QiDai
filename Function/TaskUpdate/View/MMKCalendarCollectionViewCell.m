//
//  MMKCalendarCollectionViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/11/7.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "MMKCalendarCollectionViewCell.h"


@interface MMKCalendarCollectionViewCell()

@property (nonatomic,strong) UILabel *titleLabel;


@property (nonatomic,strong) UIImageView *todayIndicatorImage;



@end


@implementation MMKCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self customUIView];
    }
    
    
    return self;
    
    
}

- (void)customUIView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.todayIndicatorImage];
    
    
}

- (void)setIsShowTodayIndicator:(BOOL)isShowTodayIndicator
{
    
    self.todayIndicatorImage.hidden = !isShowTodayIndicator;
    
}



- (void)updateUIView:(CGRect )updateFrame andBackgroundColor:(UIColor *) backgroundColor andText:(NSString *) titleStr  andTextColor:(UIColor *)textColor andborderColor:(UIColor *) updateborderColor
     andCornerRadius:(float) cornerRadius
{
//    if (self.isShowTodayIndicator) {
//       
//    }
    //self.todayIndicatorImage.hidden = NO;
    self.titleLabel.text = titleStr;
    self.titleLabel.frame = updateFrame;
    self.titleLabel.backgroundColor = backgroundColor;
    self.titleLabel.layer.borderColor = updateborderColor.CGColor;
    self.titleLabel.textColor = textColor;
    self.titleLabel.layer.cornerRadius = cornerRadius;
    
    
    
}

#pragma lazyload -----------mark



- (UIImageView *)todayIndicatorImage
{
    if (!_todayIndicatorImage) {
        _todayIndicatorImage = [[UIImageView alloc]initWithFrame:CGRectMake750(30,63,17, 8)];
        _todayIndicatorImage.image = [UIImage imageNamed:@"todayIndicator"];
       // _todayIndicatorImage.backgroundColor = [UIColor redColor];
    }
    return _todayIndicatorImage;
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(16, 15, 50, 50)];
        _titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.borderWidth = 1.f;
        _titleLabel.font = [UIFont systemFontOfSize:27*SizeScale750];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _titleLabel;
    
}





@end
