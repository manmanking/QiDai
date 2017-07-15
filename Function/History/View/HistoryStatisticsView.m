//
//  HistoryStatisticsView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/21.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HistoryStatisticsView.h"
#import "HistoryGraphView.h"
@interface HistoryStatisticsView ()<UIScrollViewDelegate>
/** 月统计*/
@property (nonatomic,strong) UIScrollView *monthScrollView;
/** 距离*/
@property (nonatomic,strong) UILabel *distanceLabel;
/** 总时长*/
@property (nonatomic,strong) UILabel *durationLabel;
/** 卡路里*/
@property (nonatomic,strong) UILabel *calorieLabel;
/** 日期*/
@property (nonatomic,strong) UILabel *dataLabel;
/** 向左的手势*/
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
/** 向右的手势*/
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
/** 绘制线条的view*/
@property (nonatomic,strong) HistoryGraphView *graphView;
@end
@implementation HistoryStatisticsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {
    
    [self addSubview:self.distanceLabel];
    
    self.graphView.pointsArray = @[@"1000",@"0",@"7000",@"0",@"10",@"0",@"0",@"4000",@"0",@"0",@"800",@"1000"];
    //self.graphView.pointsArray = @[@"0",@"0",@"4000",@"0",@"0",@"800",@"1000"];
    //self.graphView.pointsArray = @[@"1000",@"0",@"7000",@"0",@"10",@"0",@"0",@"4000",@"0",@"0",@"800",@"1000",@"1000",@"0",@"7000",@"0",@"10",@"0",@"0",@"4000",@"0",@"0",@"800",@"1000",@"0",@"0",@"4000",@"0",@"0",@"800",@"1000"];
    [self.graphView setupCustomView];
    [self addSubview:self.graphView];
    
    
    [self setupBottomView];
}
- (void)setupBottomView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 710, 720, 442)];
    bgView.backgroundColor = UIColorFromRGB_16(0x1d1d1d);//
    [self addSubview:bgView];
    
    [bgView addSubview:self.dataLabel];
    [bgView addSubview:self.durationLabel];
    [bgView addSubview:self.calorieLabel];
    NSArray *tempArr = @[@"时长(h)",@"卡路里"];
    
    for (int i = 0; i < tempArr.count; i++) {
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake720(92, 156, 44, 4)];
        barView.backgroundColor = UIColorFromRGB_16(0x35a4da);
        [bgView addSubview:barView];
        
        UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(92, 188, 120, 30) title:tempArr[i] titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:30];
        [bgView addSubview:textLabel];
        if (i == 1) {
            barView.left = 492*SizeScaleSubjectTo720;
            barView.backgroundColor = UIColorFromRGB_16(0xe97b1a);
            textLabel.left = 492*SizeScaleSubjectTo720;
        }
    }
}
#pragma mark --- lazy load
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 68, 660, 72) title:@"520km" titleColor:kColorForfff textAlignment:NSTextAlignmentRight font:90];
    }
    return _distanceLabel;
}
- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 46, 720, 34) title:@"20116年" titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:36];
    }
    return _dataLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(92, 262, 234, 80) title:@"1" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:80];
    }
    return _durationLabel;
}
- (UILabel *)calorieLabel {
    if (!_calorieLabel) {
        _calorieLabel = [UILabel qd_labelWithFrame:CGRectMake720(492, 262, 228, 80) title:@"1" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:80];
    }
    return _calorieLabel;
}
- (HistoryGraphView *)graphView {
    if (!_graphView) {
        _graphView = [[HistoryGraphView alloc]initWithFrame:CGRectMake720(0, 210, 720, 490)];
        
//        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        //[_graphView addGestureRecognizer:self.leftSwipeGestureRecognizer];
        //[_graphView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    }
    return _graphView;
}
@end
