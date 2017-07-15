//
//  SelectColorTableViewCell.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/6.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "SelectColorTableViewCell.h"

@implementation SelectColorTableViewCell
{
    /** 颜色btn的数组*/
    NSMutableArray *_btnArrayM;
    
    /** 是否能点击，0不能，1能*/
    NSMutableArray *_enabledArrayM;
}
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
        _enabledArrayM = @[].mutableCopy;
        _btnArrayM = @[].mutableCopy;
        [self loadCellView];
        self.backgroundColor = UIColorFromRGB_16(0x0f0f0f);
    }
    return self;
}

- (void)loadCellView {
    
}
- (void)setupSelectColorViewWithArray:(NSArray *)colorArray {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (_btnArrayM.count) {
        [_btnArrayM removeAllObjects];
    }
    for (int i = 0; i < colorArray.count; i++) {
        UIButton *selectColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectColorButton.frame = CGRectMake720(34+i%3*(242),56+i/3*(166-56), 210, 68);
        [selectColorButton setTitle:colorArray[i] forState:UIControlStateNormal];
        [selectColorButton setTitleColor:UIColorFromRGB_16(0xffffff) forState:UIControlStateNormal];
        [selectColorButton setTitleColor:UIColorFromRGB_16(0x555555) forState:UIControlStateDisabled];
        [selectColorButton setBackgroundImage:[UIImage imageNamed:@"good_selece_color_red"] forState:UIControlStateSelected];
        selectColorButton.titleLabel.font = UIFontOfSize720(24);
        [selectColorButton addTarget:self action:@selector(clickSelectColor:) forControlEvents:UIControlEventTouchUpInside];
        selectColorButton.tag = 10000 + i;
        if (_colorButton) {
            if (selectColorButton.tag == _colorButton.tag) {
                selectColorButton.selected = YES;
                _colorButton = selectColorButton;
            }
        } else {
            
//            if (i == 0) {
//                selectColorButton.selected = YES;
//                _colorButton = selectColorButton;
//            }
        }
        [_btnArrayM addObject:selectColorButton];
        
        [self addSubview:selectColorButton];
        
    }
    
}

- (void)compareColorArray:(NSArray *)array totalArray:(NSArray *)totalArray {
 
    if (_enabledArrayM.count) {
        [_enabledArrayM removeAllObjects];
    }
    
    for (int i = 0; i < totalArray.count; i++) {
        BOOL isContain = [array containsObject:totalArray[i]];
        if (isContain) {
            [_enabledArrayM addObject:@"1"];
        } else {
            [_enabledArrayM addObject:@"0"];
        }
    }
    
    //刷新
    for (int i= 0; i < _btnArrayM.count; i++) {
        UIButton *btn = _btnArrayM[i];
        if ([_enabledArrayM[i] isEqualToString:@"1"]) {
            btn.enabled = YES;
        } else {
            btn.enabled = NO;
        }
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
    }
    
    if (_selectedColour.length>0) {
        for (int i = 0; i<_btnArrayM.count; i++) {
            UIButton *tmp = _btnArrayM[i];
            if ([tmp.currentTitle isEqualToString:_selectedColour]) {
                tmp.selected = YES;
            }
        }
    }
    
}

- (void)clickSelectColor:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    _colorButton.tag = tag;
    _colorButton.selected = NO;
    _colorButton = sender;
    //_colorButton.tag = tag;
    _colorButton.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickColorCellWithColor: page:)]) {
        [self.delegate clickColorCellWithColor:_colorButton.titleLabel.text page:_colorButton.tag - 10000];
    }
    //_colorButton = nil;
    
}

@end
