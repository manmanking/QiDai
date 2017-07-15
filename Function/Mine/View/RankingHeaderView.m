//
//  RankingHeaderView.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "RankingHeaderView.h"
#import "IndividualRankingModel.h"
@interface RankingHeaderView ()


/** 第几名*/
@property (nonatomic,strong) UILabel *rankingLabel;
/** 总距离*/
@property (nonatomic,strong) UILabel *distanceLabel;
/** 总时长*/
@property (nonatomic,strong) UILabel *durationLabel;

@end
@implementation RankingHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setupCustomView {
    [self addSubview:self.rankingLabel];
    
    //周排名左边的icon
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(87, 156, 40, 40)];
    iconImageView.image = [UIImage imageNamed:@"ranking_icon"];
    [self addSubview:iconImageView];
    
    [self addSubview:self.rankingTextLabel];
    
    NSArray *tempArray = @[@"总里程",@"总时长"];
    for (int i = 0; i < tempArray.count; i++) {
        UILabel *tempLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 94, 92, 26) title:tempArray[i] titleColor:kColorFor666 textAlignment:NSTextAlignmentCenter font:25];
        if (i == 1) {
            tempLabel.top = 165*SizeScaleSubjectTo720;
        }
        [self addSubview:tempLabel];
    }
    [self addSubview:self.distanceLabel];
    
    [self addSubview:self.durationLabel];
}
#pragma mark --- set
- (void)setModel:(IndividualRankingModel *)model {
    _model = model;
    self.rankingLabel.text = model.rank;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.1fkm",[model.distance floatValue]/1000];
    self.durationLabel.text = [PublicTool getFormatTimeWithValue:[model.time intValue] ];
}

#pragma mark --- lazy load
- (UILabel *)rankingTextLabel {
    if (!_rankingTextLabel) {
        _rankingTextLabel = [UILabel qd_labelWithFrame:CGRectMake720(141, 156, 140, 40) title:@"周排名" titleColor:kColorFor666 textAlignment:NSTextAlignmentLeft font:32];
    }
    return _rankingTextLabel;
}
- (UILabel *)rankingLabel {
    if (!_rankingLabel) {
        _rankingLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 62, 360, 60) title:@"1" titleColor:UIColorFromRGB_16(0xd91c17) textAlignment:NSTextAlignmentCenter font:60];
    }
    return _rankingLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(460, 92, 160, 30) title:@"45km" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:34];
    }
    return _distanceLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel qd_labelWithFrame:CGRectMake720(460, 160, 160, 30) title:@"00:00:00" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:34];
    }
    return _durationLabel;
}

@end
