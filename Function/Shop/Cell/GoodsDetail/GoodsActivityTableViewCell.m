//
//  GoodsActivityTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "GoodsActivityTableViewCell.h"
#import "ActivityModel.h"
@interface GoodsActivityTableViewCell ()
{
    /** 标记作用*/
    UIButton *_selectButton;
}
/** 活动名称*/
@property (nonatomic,strong) UILabel *activityLabel;
/** 报名人数*/
@property (nonatomic,strong) UILabel *numberLabel;
/** 开始时间---弃用，合并到numberLabel*/
@property (nonatomic,strong) UILabel *startTimeLabel;
/** 奖金*/
@property (nonatomic,strong) UILabel *bonusLabel;
@end
@implementation GoodsActivityTableViewCell

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
        self.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    }
    return self;
    
}
- (void)loadCellView {
    _selectButton = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(34, 53, 44, 44) NormalBackgroundImageString:@"good_select_activity" tapAction:^(UIButton *button) {
        [self clickSelectButton];
    }];
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"good_select_activity_p"] forState:UIControlStateSelected];
    [self addSubview:_selectButton];
    
    [self addSubview:self.activityLabel];
    [self addSubview:self.numberLabel];
    //[self addSubview:self.startTimeLabel];
    
    UIImageView *bonusImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(518, 36, 168, 78)];
    bonusImageView.image = [UIImage imageNamed:@"good_bonus_frame"];
    [self addSubview:bonusImageView];
    [bonusImageView addSubview:self.bonusLabel];
    
    UIButton *clickDetailBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(302, 145, 116, 21) NormalBackgroundImageString:@"good_click_detail_image" tapAction:^(UIButton *button) {
        self.clickDetailBlock(self.page);
    }];
    [self addSubview:clickDetailBtn];
}
- (void)clickSelectButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickActivityCellWithPage:)]) {
        [self.delegate clickActivityCellWithPage:self.page];
    }
}
#pragma mark --- set
- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _selectButton.selected = isSelect;
}
- (void)setActivityModel:(ActivityModel *)activityModel {
    _activityModel = activityModel;
    self.activityLabel.text = [NSString stringWithFormat:@"%@",activityModel.information];
    self.numberLabel.text = activityModel.desc;

    NSString *refund = [NSString stringWithFormat:@"￥%@",activityModel.refund];
    self.bonusLabel.attributedText = [NSString changFontWithString:refund defaultFont:36*SizeScale specifyFont:22*SizeScale specifyRang:NSMakeRange(0, 1)];
}
#pragma mark --- lazy load
- (UILabel *)activityLabel {
    if (!_activityLabel) {
        _activityLabel = [UILabel qd_labelWithFrame:CGRectMake720(104, 43, 415, 25) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    }
    return _activityLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [UILabel qd_labelWithFrame:CGRectMake720(104, 92, 640, 21) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:22];
    }
    return _numberLabel;
}
- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [UILabel qd_labelWithFrame:CGRectMake720(240, 92, 250, 21) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:22];
    }
    return _startTimeLabel;
}
- (UILabel *)bonusLabel {
    if (!_bonusLabel) {
        _bonusLabel = [UILabel qd_labelWithFrame:CGRectMake720(4, 10, 160, 29) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:36];
    }
    return _bonusLabel;
}

@end
