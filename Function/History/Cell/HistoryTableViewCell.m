//
//  HistoryTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "SportModel.h"
#import "NSDate+Tools.h"
#import "UIButton+EnlargeEdge.h"
@interface HistoryTableViewCell ()

@property (nonatomic,strong) UILabel *distanceLabel;

/** 活动名称 比如:5月5日8:00的骑行*/
@property (nonatomic,strong) UILabel *activityLabel;

@property (nonatomic,strong) UILabel *durationLabel;

@property (nonatomic,strong) UIButton *uploadBtn;

@end
@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadCellView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
    
}
- (void)loadCellView {
    
    [self addSubview:self.distanceLabel];
    
    [self addSubview:self.activityLabel];
    
    
    UIImageView *durationImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(370, 103, 24, 24)];
    durationImageView.image = [UIImage imageNamed:@"history_duration"];
    [self addSubview:durationImageView];
    
    [self addSubview:self.durationLabel];
    
    [self addSubview:self.uploadBtn];
    self.uploadBtn.hidden = YES;
}
#pragma mark --- set
- (void)setSportModel:(SportModel *)sportModel {
    _sportModel = sportModel;
    
//    NSString *sportTime = [sportModel.startTime dataConvertString:@"MM月dd日HH:mm骑行"];
//    self.activityLabel.text = sportTime;
    
    if ([sportModel.ridingName isExist] && ![sportModel.ridingName isEqualToString:@"0"] && ![sportModel.ridingName isEqualToString:@"无"]) {
        self.activityLabel.text = sportModel.ridingName;
    } else {
        self.activityLabel.text = [sportModel.startTime dataConvertString:@"MM月dd日HH:mm骑行"];
    }
    
    
    self.durationLabel.text = [NSString stringWithFormat:@"用时:%@",[PublicTool getFormatTimeWithValue:sportModel.sumTime]];;
    
    NSString *distanceText = [NSString stringWithFormat:@"%.1f  km",sportModel.totalDistance/1000.0f];
    self.distanceLabel.attributedText = [NSString changFontWithString:distanceText defaultFont:64*SizeScaleSubjectTo720 specifyFont:24*SizeScaleSubjectTo720 defaultColor:kColorForfff specifyColor:kColorFor999 specifyRang:NSMakeRange(distanceText.length - 4, 4)];
    
    if (sportModel.upload == 1 && sportModel.uploadDetail == 1) {
        self.uploadBtn.hidden = YES;
        NSLog(@"sporttime %@  %@",sportModel.startTime,self.activityLabel.text);
    }else{
        self.uploadBtn.hidden = NO;
    }
}
#pragma mark --- lazy load
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 0, 370, 174) title:@"0.00  km" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:64];
    }
    return _distanceLabel;
}
- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(370, 0, 350, 103) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:32];
    }
    return _activityLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(408, 103, 300, 24) title:@"01:20:20" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:24];
    }
    return _durationLabel;
}
- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(650, 68, 42, 34) NormalImageString:@"history_upload_button" tapAction:^(UIButton *button) {
            self.clickUploadBtnBlock(self.sportModel,self);
        }];
        [_uploadBtn setEnlargeEdge:10*SizeScale];
    }
    return _uploadBtn;
}
@end
