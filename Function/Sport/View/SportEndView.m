//
//  SportEndView.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/7.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SportEndView.h"
#import "SportModel.h"
#import "NSDate+Tools.h"
@interface SportEndView ()


/** 距离*/
@property (nonatomic,strong) UILabel *distanceLabel;
/** 时长*/
@property (nonatomic,strong) UILabel *durationLabel;
/** 卡路里*/
@property (nonatomic,strong) UILabel *calorieLabel;
/** 积分*/
@property (nonatomic,strong) UILabel *pointLabel;
/** 匀速*/
@property (nonatomic,strong) UILabel *averageSpeedLabel;
/** 海拔*/
@property (nonatomic,strong) UILabel *altitudeLabel;
/** 累计爬升*/
@property (nonatomic,strong) UILabel *upAltitudeLabel;
/**  骑行记录名称  修改图标logo*/
@property (nonatomic,strong) UIImageView *writeImageView;

@end
@implementation SportEndView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //[self setupCustomView];
        //[self setupSportEndView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupSportEndView {
    //iamge拒左82
    self.writeImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(82, 40.5, 37, 40)];
    self.writeImageView.image = [UIImage imageNamed:@"sport_write_image"];
    [self addSubview:self.writeImageView];
    
    [self addSubview:self.nameTF];
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake720(0, 118, 720, 1)];
    topLineView.backgroundColor = kColorFor83;
    topLineView.alpha = 0.4;
    [self addSubview:topLineView];
    
    [self addSubview:self.distanceLabel];
    
    NSArray *array1 = @[@"时长",@"卡路里",@"积分"];
    for (int i = 0; i < array1.count; i++) {
        UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(0 + i*240, 300, 240, 24) title:array1[i] titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:26];
        [self addSubview:textLabel];
    }
    [self addSubview:self.durationLabel];
    [self addSubview:self.calorieLabel];
    [self addSubview:self.pointLabel];
    
    UIView *middleLineView = [[UIView alloc]initWithFrame:CGRectMake720(0, 118, 720, 1)];
    middleLineView.top = topLineView.bottom + 322*SizeScale;
    middleLineView.backgroundColor = kColorFor83;
    middleLineView.alpha = 0.4;
    [self addSubview:middleLineView];

    UILabel *titleLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 486, 720, 28) title:@"记录详情" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:30];
    [self addSubview:titleLabel];
    
    NSArray *detailArray = @[@"均速(km/h)",@"最高海拔(m)",@"累计爬升(m)",@"极速(km/h)",@"平均海拔(m)",@"累计下降(m)"];
    NSArray *detailDataArray = @[
                                 [NSString stringWithFormat:@"%0.2f",self.sportModel.averageSpeed*3.6],
                                 [NSString stringWithFormat:@"%.2f",self.sportModel.maxAltitude],
                                 [NSString stringWithFormat:@"%.2f",self.sportModel.upAltitude],
                                 [NSString stringWithFormat:@"%.2f",self.sportModel.maxSpeed*3.6],
                                 [NSString stringWithFormat:@"%.2f",self.sportModel.averageAltitude],
                                 [NSString stringWithFormat:@"%.2f",self.sportModel.downAltitude]
                                 ];
    for (int i = 0; i < detailArray.count ; i++) {
        UILabel *topLabel = [UILabel qd_labelWithFrame:CGRectMake720(0 + i%3*240, 601 + i/3*190, 240, 38) title:detailDataArray[i] titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:48];
        [self addSubview:topLabel];
        
        UILabel *bottomLabel = [UILabel qd_labelWithFrame:CGRectMake720(0 + i%3*240, 669 + i/3*190, 240, 24) title:detailArray[i] titleColor:kColorFor999 textAlignment:NSTextAlignmentCenter font:22];
        [self addSubview:bottomLabel];
    }
    
    
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake720(0, 940, 720, 1)];
    bottomLineView.alpha = 0.4;
    bottomLineView.backgroundColor = kColorFor83;
    [self addSubview:bottomLineView];
    
}
#pragma mark ---  set methods
- (void)setSportModel:(SportModel *)sportModel {
    _sportModel = sportModel;
    
    NSString *distance = [NSString stringWithFormat:@"%.2f km",sportModel.totalDistance/1000];
    self.distanceLabel.attributedText = [NSString changFontWithString:distance defaultFont:76*SizeScale specifyFont:36*SizeScale defaultColor:kColorForfff specifyColor:kColorFor999 specifyRang:NSMakeRange(distance.length - 3, 3)];
    
    self.durationLabel.text = [PublicTool getFormatTimeWithValue:sportModel.sumTime];
    self.calorieLabel.text = [NSString stringWithFormat:@"%.1f",sportModel.calorie];
    self.pointLabel.text = [NSString stringWithFormat:@"%d",sportModel.totalPoints];
    
    if ([sportModel.ridingName isExist] && ![sportModel.ridingName isEqualToString:@"0"]) {
        self.nameTF.text = sportModel.ridingName;
    } else {
        self.nameTF.text = [sportModel.startTime dataConvertString:@"MM月dd日HH:mm骑行"];
    }
    
    
 
}
- (void)setIsHistory:(BOOL)isHistory {
    _isHistory = isHistory;
    self.nameTF.enabled = NO;

}
- (void)setWhetherShowWriteImageView:(BOOL)isTrue
{
    self.writeImageView.hidden = isTrue;
    
}
#pragma mark --- lazy load
- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc]initWithFrame:CGRectMake720(158, 0, 480, 118)];
        //_nameTF.text = @"04-19 骑行";
        _nameTF.textColor = kColorForfff;
        _nameTF.enabled = YES;
    }
    return _nameTF;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 174, 720, 60) title:@"0.00 km" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:76];
    }
    return _distanceLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 350, 240, 40) title:@"00:00:00" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _durationLabel;
}
- (UILabel *)calorieLabel {
    if (!_calorieLabel) {
        _calorieLabel = [UILabel qd_labelWithFrame:CGRectMake720(240, 350, 240, 40) title:@"0.0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _calorieLabel;
}
- (UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [UILabel qd_labelWithFrame:CGRectMake720(480, 350, 240, 40) title:@"0" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:40];
    }
    return _pointLabel;
}
@end
