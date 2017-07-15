//
//  MMKCalendarCollectionViewCell.h
//  QiDai
//
//  Created by manman'swork on 16/11/7.
//  Copyright © 2016年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMKCalendarCollectionViewCell : UICollectionViewCell


@property (nonatomic,assign) BOOL isShowTodayIndicator;

- (void)updateUIView:(CGRect )updateFrame andBackgroundColor:(UIColor *) backgroundColor andText:(NSString *) titleStr  andTextColor:(UIColor *)textColor andborderColor:(UIColor *) updateborderColor
     andCornerRadius:(float) cornerRadius;

@end
