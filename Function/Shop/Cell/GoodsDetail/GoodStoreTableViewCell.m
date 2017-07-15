//
//  GoodStoreTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/28.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "GoodStoreTableViewCell.h"
#import "ShopAddressModel.h"
#import "QDLineView.h"
#import "UIButton+AcceptEvent.h"
@interface GoodStoreTableViewCell ()
{
   
}
/** 店铺名*/
@property (nonatomic,strong) UILabel *storeLabel;
/** 店铺地址*/
@property (nonatomic,strong) UILabel *addressLabel;
/** 距离*/
@property (nonatomic,strong) UILabel *distanceLabel;


@end
@implementation GoodStoreTableViewCell

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
    
    QDLineView *lineView = [[QDLineView alloc]initWithFrame:CGRectMake720(104, 96, 720 - 104, 1)];
    [self addSubview:lineView];
    
    UIButton *phoneBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(627, 28, 39, 41) NormalBackgroundImageString:@"good_click_phone" tapAction:^(UIButton *button) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickPhoneBtnWithPage:)]) {
            [self.delegate clickPhoneBtnWithPage:self.page];
        }
    }];
    phoneBtn.qd_acceptEventInterval = 2.0f;
    [self addSubview:phoneBtn];
    
    UIImageView *locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(558, 132, 14, 20)];
    locationImageView.image = [UIImage imageNamed:@"good_location_image"];
    [self addSubview:locationImageView];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(676, 132, 10, 20)];
    arrowImageView.image = [UIImage imageNamed:@"mine_right_arrow_image"];
    [self addSubview:arrowImageView];
    
    [self addSubview:self.storeLabel];
    //self.storeLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.addressLabel];
    [self addSubview:self.distanceLabel];

    _selectButton = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(34, 53, 44, 44) NormalBackgroundImageString:@"good_select_activity" tapAction:^(UIButton *button) {
        [self clickSelectButton];
    }];
  
    [_selectButton setBackgroundImage:[UIImage imageNamed:@"good_select_activity_p"] forState:UIControlStateSelected];
    [self addSubview:_selectButton];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake720(520, 96, 200, 96);
    clearBtn.backgroundColor = [UIColor clearColor];
    [clearBtn addTarget:self action:@selector(clickAddressButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
    
}
#pragma mark --- set
- (void)setModel:(ShopAddressModel *)model {
    _model = model;
    
    
    if ([model.name isExist]) {
        self.storeLabel.text = model.name;
    }
    if (model.address) {
        self.addressLabel.text = model.address;
    }
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.1dkm",[model.distance intValue]/1000];
    
    if (_activityId.integerValue == _model.taskId.integerValue) {
          [_selectButton setBackgroundImage:[UIImage imageNamed:@"good_select_activity"] forState:UIControlStateNormal];
        _selectButton.userInteractionEnabled = YES;
    }else
    {
          [_selectButton setBackgroundImage:[UIImage imageNamed:@"good_select_activity_gray"] forState:UIControlStateNormal];
        _selectButton.userInteractionEnabled = NO;
        
    }
    //[_selectButton setTitle:@"test" forState:UIControlStateNormal];
    
    
    
}

- (void)setIsSelect:(BOOL)isSelect {
    NSLog(@"select %@",isSelect== NO ? @"no":@"yes");
    
    
    _isSelect = isSelect;
    _selectButton.selected = isSelect;
//    if (isSelect == YES) {
//       
//        //[_selectButton setImage:[UIImage imageNamed:@"good_select_activity"] forState:UIControlStateNormal];
//    }
//    if (isSelect == NO) {
//          //[_selectButton setImage:[UIImage imageNamed:@"good_select_activity_gray"] forState:UIControlStateNormal];
//        _selectButton.selected = NO;
//        
//    }
}
#pragma mark --- private method
- (void)clickAddressButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAddressBtnWithPage:)]) {
        [self.delegate clickAddressBtnWithPage:self.page];
    }
}
- (void)clickSelectButton {
    NSLog(@"select store button click ...%ld ",self.page);
    self.selectButton.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickStoreCellWithPage:)]) {
        [self.delegate clickStoreCellWithPage:self.page];
    }
}
#pragma mark --- lazy load
- (UILabel *)storeLabel {
    if (!_storeLabel) {
        _storeLabel = [UILabel qd_labelWithFrame:CGRectMake720(104, 36, 410, 33) title:@"Tern" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    }
    return _storeLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel qd_labelWithFrame:CGRectMake720(104, 132, 410, 22) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    }
    return _addressLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(584, 132, 85, 20) title:@"0km" titleColor:kColorForfff textAlignment:NSTextAlignmentLeft font:26];
    }
    return _distanceLabel;
}
@end
