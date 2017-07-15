//
//  HistoryGraphView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HistoryGraphView.h"

@implementation HistoryGraphView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //[self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    CGFloat maxDistance = [[self.pointsArray valueForKeyPath:@"@max.floatValue"] floatValue]/1000;
    if (maxDistance == 0) {
        maxDistance = 1;
    }
    //NSLog(@"%@",self.pointsArray);
    NSArray *weekArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i < self.pointsArray.count ; i++) {
        
        //年
        if (self.pointsArray.count == 12) {
            UILabel *dataLabel = [UILabel qd_labelWithFrame:CGRectMake720(75 + 53*i, 390, 40, 25) title:[NSString stringWithFormat:@"%d",i+1] titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:28];
            [self addSubview:dataLabel];
            UIView *barView = [[UIView alloc]initWithFrame:CGRectMake720(80 + 53*i, 0, 28, 0)];
            CGFloat pointHeight = ([self.pointsArray[i] floatValue]/1000);
            barView.height = pointHeight/maxDistance*342*SizeScaleSubjectTo720 + 8*SizeScaleSubjectTo720;
            barView.top = 350*SizeScaleSubjectTo720- barView.height;
            barView.backgroundColor = UIColorFromRGB_16(0x35a4da);
            [self addSubview:barView];
        }
        //周
        else if (self.pointsArray.count == 7) {
            //日期
            UILabel *dataLabel = [UILabel qd_labelWithFrame:CGRectMake720(80 + 80*i, 390, 36, 25) title:weekArray[i] titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:28];
            [self addSubview:dataLabel];
            UIView *barView = [[UIView alloc]initWithFrame:CGRectMake720(80 + 80*i, 0, 36, 0)];
            CGFloat pointHeight = ([self.pointsArray[i] floatValue]/1000);
            barView.height = pointHeight/maxDistance*342*SizeScaleSubjectTo720 + 8*SizeScaleSubjectTo720;
            barView.top = 350*SizeScaleSubjectTo720- barView.height;
            barView.backgroundColor = UIColorFromRGB_16(0x35a4da);
            [self addSubview:barView];
        }
        //年
        else {
            if ( (i+1)%5 == 0) {
                //日期
                UILabel *dataLabel = [UILabel qd_labelWithFrame:CGRectMake720(80 + 20*i, 390, 40, 25) title:[NSString stringWithFormat:@"%d",i+1] titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
                [self addSubview:dataLabel];
            }
            if (i == 0) {
                UILabel *dataLabel = [UILabel qd_labelWithFrame:CGRectMake720(80 + 20*i, 390, 40, 25) title:[NSString stringWithFormat:@"%d",i+1] titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:28];
                [self addSubview:dataLabel];
            }
            UIView *barView = [[UIView alloc]initWithFrame:CGRectMake720(80 + 20*i, 0, 10, 0)];
            CGFloat pointHeight = ([self.pointsArray[i] floatValue]/1000);
            barView.height = pointHeight/maxDistance*342*SizeScaleSubjectTo720 + 8*SizeScaleSubjectTo720;
            barView.top = 350*SizeScaleSubjectTo720- barView.height;
            barView.backgroundColor = UIColorFromRGB_16(0x35a4da);
            [self addSubview:barView];
        }
        
        
        
        
    }
    float spaceY = (350-8)/5 *SizeScaleSubjectTo720;
    for (int i = 0; i <= 5; i++) {
        
        UILabel *label = [UILabel qd_labelWithFrame:CGRectMake(0, spaceY * (i), 60 *SizeScaleSubjectTo720, 20 *SizeScaleSubjectTo720) title:[NSString stringWithFormat:@"%.1f",(maxDistance-(i* maxDistance/5) )] titleColor:UIColorFromRGB_16(0x4c4c4c) textAlignment:NSTextAlignmentCenter font:22];
        [self addSubview:label];
    }

}
- (void)setupGraphView {
    
}
@end
