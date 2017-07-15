//
//  TaskTotalRidingView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/23.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskTotalRidingView.h"
#import "TaskDetailModel.h"
@interface TaskTotalRidingView ()
/** 奖金*/
@property (nonatomic,strong) UILabel *bonusLabel;

@property (nonatomic,strong) UILabel *distanceLabel;
/** 挑战第%@天*/ 
@property (nonatomic,strong) UILabel *dateLabel;
@end
@implementation TaskTotalRidingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
    }
    return self;
}
- (void)setupCustomView {

    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 580)];
    bgImageView.image = [UIImage imageNamed:@"task_riding_bg_image"];
    [self addSubview:bgImageView];
    
    [self addSubview:self.bonusLabel];
    
    UILabel *bounsLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 388, 720, 24) title:@"累计奖金" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:24];
    [self addSubview:bounsLabel];
    
    UIView *blackBgView = [[UIView alloc]initWithFrame:CGRectMake720(0, 472, 720, 120)];
    blackBgView.backgroundColor = [UIColor blackColor];
    [self addSubview:blackBgView];
    
    UILabel *ridingLabel = [UILabel qd_labelWithFrame:CGRectMake720(28, 48, 110, 28) title:@"总骑行:" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:28];
    [blackBgView addSubview:ridingLabel];
    
    [blackBgView addSubview:self.distanceLabel];
    
    [blackBgView addSubview:self.dateLabel];
}
#pragma mark --- set
- (void)setModel:(TaskDetailModel *)model {
    _model = model;
    NSString *refundStr = [NSString stringWithFormat:@"￥%.0f",[model.totalDayMoney floatValue] ];
    self.bonusLabel.attributedText = [NSString changFontWithString:refundStr defaultFont:(180*SizeScale) specifyFont:(88*SizeScale) specifyRang:NSMakeRange(0, 1) ];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.1fkm",[model.totalDistance floatValue]/1000];
    self.dateLabel.text = [NSString stringWithFormat:@"挑战第%@天",model.challengesDay];
    
}
//- (void)setCompleteDay:(NSString *)completeDay {
//    _completeDay = completeDay;
//    self.dateLabel.text = [NSString stringWithFormat:@"挑战第%@天",completeDay];
//}
#pragma mark --- lazy load
- (UILabel *)bonusLabel {
    if (!_bonusLabel) {
        _bonusLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 194, 720, 142) title:@"￥0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:180];
        _bonusLabel.attributedText = [NSString changFontWithString:@"￥140" defaultFont:180*SizeScaleSubjectTo720 specifyFont:60*SizeScaleSubjectTo720 specifyRang:NSMakeRange(0, 1)];
    }
    return _bonusLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(148, 36, 250, 40) title:@"0km" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:48];
    }
    return _distanceLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel qd_labelWithFrame:CGRectMake720(428, 48, 200, 28) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:28];
    }
    return _dateLabel;
}
@end
