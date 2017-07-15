//
//  RankingTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "RankingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "RankingModel.h"
@interface RankingTableViewCell ()
{
    UIView *_greenView;
}
@property (nonatomic,strong) UIImageView *portraitImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) UILabel *rankLabel;

@property (nonatomic,strong) UIImageView *rankImageView;
@end

@implementation RankingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect); //上分割线，
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x232323).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self loadCellView];
    }
    return self;
    
}
- (void)loadCellView {
    
    [self addSubview:self.portraitImageView];
    
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.rankImageView];
    self.rankImageView.hidden = YES;
    
    [self addSubview:self.rankLabel];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake720(372, 49, 328, 4)];
    [grayView setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight radius:2];
    grayView.backgroundColor = kColorFor666;
    [self addSubview:grayView];
    
    _greenView = [[UIView alloc]initWithFrame:CGRectMake720(372, 49, 328, 4)];
    [_greenView setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight radius:2];
    _greenView.backgroundColor = UIColorFromRGB_16(0x45c01a);
    [self addSubview:_greenView];
    
    [self addSubview:self.distanceLabel];
}

#pragma mark --- set
- (void)setModel:(RankingModel *)model {
    
    _model = model;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.foreImg] placeholderImage:[UIImage imageNamed:@"head_portrait_btn"]];
    self.ranking = [model.rank integerValue];

    self.nameLabel.text = model.nickName;
    
    _greenView.width = 328 * SizeScaleSubjectTo720 * ([model.percentBar floatValue]);
    
    if ([model.percentBar floatValue] < 0.5) {
        _greenView.backgroundColor = UIColorFromRGB_16(0xe97b1a);
    } else {
        _greenView.backgroundColor = UIColorFromRGB_16(0x45c01a);
    }
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.1fkm",[model.distance floatValue]/1000 ];
    
    
}

- (void)setRanking:(NSInteger)ranking {
    _ranking = ranking;
    switch (ranking) {
        case 1:
            self.rankImageView.hidden = NO;
            self.rankLabel.hidden = YES;
            self.rankImageView.image = [UIImage imageNamed:@"ranking_first_image"];
            
            break;
        case 2:
            self.rankImageView.hidden = NO;
            self.rankLabel.hidden = YES;
            self.rankImageView.image = [UIImage imageNamed:@"ranking_second_image"];
            
            break;
        case 3:
            self.rankImageView.hidden = NO;
            self.rankLabel.hidden = YES;
            self.rankImageView.image = [UIImage imageNamed:@"ranking_third_image"];
            
            break;
        default:
            self.rankImageView.hidden = YES;
            self.rankLabel.hidden = NO;
            //_greenView.width = 150*SizeScaleSubjectTo720;
            self.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)ranking];
            if (ranking == 100) {
                self.rankLabel.frame = CGRectMake720(15, 35, 50, 40);
            }
            break;
    }
}

#pragma mark --- lazy load
- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(20, 35, 38, 51)];
    }
    return _rankImageView;
}
- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 35, 40, 40) title:@"1" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:26];
    }
    return _rankLabel;
}
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(90, 17, 76, 76)];
        [_portraitImageView setRoundedCorners:UIRectCornerAllCorners radius:76/2*SizeScaleSubjectTo720];
    }
    return _portraitImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel qd_labelWithFrame:CGRectMake720(194, 49, 170, 25) title:@"name" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:22];
        _nameLabel.centerY = 110/2*SizeScaleSubjectTo720;
    }
    return _nameLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(372, 73, 328, 25) title:@"45km" titleColor:UIColorFromRGB_16(0xd4d4d4) textAlignment:NSTextAlignmentRight font:22];
    }
    return _distanceLabel;
}

@end
