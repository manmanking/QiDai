//
//  CommentTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
@interface CommentTableViewCell (){
    NSMutableArray *_photoImageViewArrayM;
}
/** 昵称*/
@property (nonatomic,strong) UILabel *nameLabel;
/** 评论*/
@property (nonatomic,strong) UILabel *commentLabel;
/** 颜色*/
@property (nonatomic,strong) UILabel *colorLabel;
/** 日期*/
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UIImageView *starImageView1;
@property (nonatomic,strong) UIImageView *starImageView2;
@property (nonatomic,strong) UIImageView *starImageView3;
@property (nonatomic,strong) UIImageView *starImageView4;
@property (nonatomic,strong) UIImageView *starImageView5;

@property (nonatomic,strong) UIImageView *photoImageView1;
@property (nonatomic,strong) UIImageView *photoImageView2;
@property (nonatomic,strong) UIImageView *photoImageView3;
@property (nonatomic,strong) UIImageView *photoImageView4;
@property (nonatomic,strong) UIImageView *photoImageView5;
@property (nonatomic,strong) UIImageView *photoImageView6;

@end
@implementation CommentTableViewCell

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
        _photoImageViewArrayM = @[].mutableCopy;
        [self loadCellView];
        
        self.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    }
    return self;
    
}
- (void)loadCellView {
    //dynamicHeight
    [self addSubview:self.nameLabel];
    [self addSubview:self.commentLabel];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(34 + 226*(i%3), 0, 200, 130)];
        
        //photoImageView.image = [UIImage imageNamed:@"find_topBg"];
        switch (i) {
            case 0:
                self.photoImageView1 = photoImageView;
                break;
            case 1:
                self.photoImageView2 = photoImageView;
                break;
            case 2:
                self.photoImageView3 = photoImageView;
                break;
            case 3:
                self.photoImageView4 = photoImageView;
                break;
            case 4:
                self.photoImageView5 = photoImageView;
                break;
            default:
                self.photoImageView6 = photoImageView;
                break;
        }
        [_photoImageViewArrayM addObject:photoImageView];
        [self addSubview:photoImageView];
    }
    
    [self addSubview:self.dateLabel];
    
    [self addSubview:self.colorLabel];
    
    

    for (int i = 0; i < 5; i++) {
        UIImageView *starImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(563 + 22*i, 46, 22, 21)];
        starImageView.image = [UIImage imageNamed:@"comment_star_image"];
        [self addSubview:starImageView];
        switch (i) {
            case 0:
                self.starImageView1 = starImageView;
                break;
            case 1:
                self.starImageView2 = starImageView;
                break;
            case 2:
                self.starImageView3 = starImageView;
                break;
            case 3:
                self.starImageView4 = starImageView;
                break;
            case 4:
                self.starImageView5 = starImageView;
                break;
            default:
                break;
        }
    }
    self.dynamicHeight = 0*SizeScaleSubjectTo720;
}
#pragma mark --- set
- (void)setModel:(CommentModel *)model {
    _model = model;

    self.nameLabel.text = model.username;
    self.commentLabel.text = model.common;
    self.dateLabel.text = model.c_time;
    self.colorLabel.text = [NSString stringWithFormat:@"颜色: %@",model.color];
    [self refreshStarView:[model.level integerValue]];
    
    //布局
    CGSize titleSize = [self.commentLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.commentLabel.bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:(26*SizeScaleSubjectTo720)]} context:nil].size;
    self.commentLabel.height = titleSize.height;
    self.dynamicHeight = self.commentLabel.bottom;
    //310为大于3张图片的高度 155为1到3张图片的高度
    
    NSInteger imageViewHeight = 0;
    
    NSArray *array = [model.image componentsSeparatedByString:@","];
    if (![model.image isExist]) {
        array = nil;
    }
    if (array.count == 0) {
        imageViewHeight = 0;
    } else if (array.count <= 3) {
        imageViewHeight = 155;
    } else {
        imageViewHeight = 310;
    }
    
    //图片
    //NSArray *photoArray = [model.image componentsSeparatedByString:@","];
    for (int i = 0; i < _photoImageViewArrayM.count; i++) {
        UIImageView *photoImageView = (UIImageView *)_photoImageViewArrayM[i];
        photoImageView.top = self.dynamicHeight + (150*(i/3)+24)*SizeScaleSubjectTo720;
        

        if (i >= array.count) {
            photoImageView.hidden = YES;
        } else {
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:array[i] ] placeholderImage:[UIImage imageNamed:@"find_topBg"] ];
        }
        
        if (array.count == 0) {
            photoImageView.hidden = YES;
        }
    }
    
    self.dynamicHeight = self.dynamicHeight + imageViewHeight*SizeScaleSubjectTo720;
    self.dateLabel.top = self.dynamicHeight + 30*SizeScaleSubjectTo720;
    self.colorLabel.top = self.dynamicHeight + 30*SizeScaleSubjectTo720;
    //photoImageView.top = self.dynamicHeight + (150*(i/3)+24)*SizeScaleSubjectTo720;
}
- (void)setIsActivity:(BOOL)isActivity {
    _isActivity = isActivity;
    if (!isActivity) {
        return;
    }
    self.colorLabel.hidden = YES;
    self.dateLabel.left = self.colorLabel.left;
}
#pragma mark --- private
- (void)refreshStarView:(NSInteger)star {
    switch (star) {
        case 1:
            self.starImageView1.hidden = YES;
            self.starImageView2.hidden = YES;
            self.starImageView3.hidden = YES;
            self.starImageView4.hidden = YES;
            break;
        case 2:
            self.starImageView1.hidden = YES;
            self.starImageView2.hidden = YES;
            self.starImageView3.hidden = YES;
            self.starImageView4.hidden = NO;
            break;
        case 3:
            self.starImageView1.hidden = YES;
            self.starImageView2.hidden = YES;
            self.starImageView3.hidden = NO;
            self.starImageView4.hidden = NO;
            break;
        case 4:
            self.starImageView1.hidden = YES;
            self.starImageView2.hidden = NO;
            self.starImageView3.hidden = NO;
            self.starImageView4.hidden = NO;
            break;
        case 5:
            self.starImageView1.hidden = NO;
            self.starImageView2.hidden = NO;
            self.starImageView3.hidden = NO;
            self.starImageView4.hidden = NO;
            break;
        default:
            break;
    }
}
#pragma mark --- lazy load
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 46, 250, 22) title:@"" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:24];
    }
    return _nameLabel;
}
- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 110, 650, 34) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel qd_labelWithFrame:CGRectMake720(170, 0, 240, 20) title:@"" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:22];
    }
    return _dateLabel;
}
- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 0, 140, 20) title:@"" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:22];
    }
    return _colorLabel;
}
@end
