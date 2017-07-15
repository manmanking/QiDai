//
//  AccountTableViewCell.m
//  Leqi
//
//  Created by 张汇丰 on 16/1/11.
//  Copyright © 2016年 com.hoolai. All rights reserved.
//

#import "AccountTableViewCell.h"

@interface AccountTableViewCell ()

@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) UIImageView *portraitImageView;

@property (nonatomic,strong) UIImageView *arrowImageView;

@end

@implementation AccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupCustomView];
    }
    return self;
}

- (void)setupCustomView {
    
    [self addSubview:self.leftLabel];
    
    [self addSubview:self.rightLabel];
    
    self.leftLabel.centerY = 65*SizeScaleSubjectTo720;
    self.rightLabel.centerY = 65*SizeScaleSubjectTo720;
    
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(684, 0, 10, 20)];
    _arrowImageView.centerY = 65*SizeScaleSubjectTo720;
    _arrowImageView.image = [UIImage imageNamed:@"userinfo_right_arrow"];
    [self addSubview:_arrowImageView];
}

- (void)showDataWithTitle:(NSString *)title detail:(NSString *)detail {
    _leftLabel.text = title;
    //_rightLabel.text = detail;
    
    if ([detail isEqualToString:@""]) {
        self.rightLabel.text = @"未知";
    }
    else
    {
        //手机号
        if([[LoginManager instance] LoginTypeStatus] == telephoneType){
            if([title isEqualToString:@"手机"]){
                _arrowImageView.hidden = YES;
            }
        }
        if ([title isEqualToString:@"性别"]) {
            
            if ([[NSString stringWithFormat:@"%@",detail] isEqualToString:@"0"]) {
                self.rightLabel.text = @"帅哥";
                return;
            } else if([[NSString stringWithFormat:@"%@",detail] isEqualToString:@"1"]) {
                self.rightLabel.text = @"美女";
                return;
            }
        }
        if ([title isEqualToString:@"身高"]) {
            self.rightLabel.text = [NSString stringWithFormat:@"%@cm",detail];
            return;
        }
        if ([title isEqualToString:@"体重"]) {
            self.rightLabel.text = [NSString stringWithFormat:@"%@kg",detail];
            return;
        }
        if ([title isEqualToString:@"生日"]) {
            self.rightLabel.text = [NSString stringWithFormat:@"%@",[PublicTool dataConvertTime:[detail doubleValue] withConcertStr:@"yyyy年MM月dd日"]];
            return;
        }
        if ([title isEqualToString:@"修改密码"]) {
            self.rightLabel.text = @"";
            return;
        }
        if ([title isEqualToString:@"邮箱"]) {
            if ([detail isEqualToString:@"(null)"]) {
               self.rightLabel.text = @"";
                return;
                
            }
        }
        self.rightLabel.text = [NSString stringWithFormat:@"%@",detail];
    }

}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB_16(0x232323).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}
#pragma mark --- set
//- (void)setIsFirst:(BOOL)isFirst {
//    _isFirst = isFirst;
//    self.rightLabel.hidden = YES;
//    self.leftLabel.centerY = 71*SizeScaleSubjectTo720;
//    [self addSubview:self.portraitImageView];
//}
#pragma mark --- get
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel qd_labelWithFrame:CGRectMake720(20, 0, 300, 30) title:@"头像" titleColor:UIColorFromRGB_16(0x999999) textAlignment:NSTextAlignmentLeft font:28];
        _leftLabel.centerY = 65*SizeScaleSubjectTo720;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel qd_labelWithFrame:CGRectMake720(360, 0, 300, 30) title:@"asfhkgk" titleColor:UIColorFromRGB_16(0xffffff) textAlignment:NSTextAlignmentRight font:24];
        _rightLabel.centerY = 65*SizeScaleSubjectTo720;
    }
    return _rightLabel;
}
//- (UIImageView *)portraitImageView {
//    if (!_portraitImageView) {
//        _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMakeSubjectTo720(562, 0, 90, 90)];
//        _portraitImageView.image = [UIImage imageNamed:@"head_portrait_btn"];
//        _portraitImageView.centerY = 71*SizeScaleSubjectTo720;
//    }
//    return _portraitImageView;
//}
@end
