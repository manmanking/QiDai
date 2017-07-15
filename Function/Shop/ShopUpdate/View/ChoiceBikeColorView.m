//
//  ChoiceBikeColorView.m
//  QiDai
//
//  Created by manman'swork on 16/12/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "ChoiceBikeColorView.h"
#import "UIImageView+WebCache.h"

@interface ChoiceBikeColorView()
/**
 *  选择自行车颜色
 */

@property (nonatomic,strong) UIView *grayBackgroundView;

@property (nonatomic,strong) UIView *whiteBackgroundView;

@property (nonatomic,strong) NSMutableArray *bikeColorDatasourcesMArr;

@property (nonatomic,strong) UIImageView *bikeImageView;

@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,strong) UILabel *bikePriceLabel;

@property (nonatomic,strong) UILabel *selectedTitleLabel;

@property (nonatomic,strong) UILabel *selectedBikeColorLabel;

@property (nonatomic,strong) UILabel *bikeColorTitleLabel;

@property (nonatomic,strong) UILabel *firstLineLabel;



@property (nonatomic,strong) UIScrollView *colorBacgroundScrollView;

@property (nonatomic,strong) UIButton *confirmButton;


@property (nonatomic,strong) UIButton *selectedButton;



/**
 *   商品颜色数组
 */
@property (nonatomic,strong) NSArray *baseColorArr;

/**
 *  活动颜色 数组
 */
@property (nonatomic,strong) NSArray *activityColorArr;

/**
 *  商品图片 数组
 */
@property (nonatomic,strong) NSArray *bikeImageColorArr;



@property (nonatomic,strong)NSString *selectedBikeImageViewUrlStr;







@end


@implementation ChoiceBikeColorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor grayColor];
        self.selectedButton = nil;
        [self customUIViewAutolayout];
    }
    
    return self;
    
    
    
}




- (void)customUIViewAutolayout
{
    [self addSubview:self.grayBackgroundView];
    [self addSubview:self.whiteBackgroundView];
    [self addSubview:self.closeButton];
    [self addSubview:self.bikeImageView];
    
    [self addSubview:self.bikePriceLabel];
    [self addSubview:self.selectedTitleLabel];
    [self addSubview:self.selectedBikeColorLabel];
    
    [self addSubview:self.bikeColorTitleLabel];
    [self addSubview:self.firstLineLabel];
    [self addSubview:self.colorBacgroundScrollView];
    
    [self addSubview:self.confirmButton];

}

- (void)setColorSetStr:(NSString *)colorSetStr
{
    
    /**
     *  图片颜色
     */
    self.bikeImageColorArr = [self.bikeImageViewStr componentsSeparatedByString:@","];
    /**
     *  活动颜色
     */
    self.activityColorArr = [_activityColorSetStr componentsSeparatedByString:@","];
    
    self.baseColorArr = [colorSetStr componentsSeparatedByString:@","];
    
     NSString *firstImageStr = @"0";
    if (self.activityColorArr.count>0) {
       firstImageStr = self.activityColorArr[0];
    }
    
    // 默认显示第一个活动颜色
    for (int i = 0; i < self.baseColorArr.count; i++) {
        NSString *tmpBaseColorStr = self.baseColorArr[i];
        if ([tmpBaseColorStr isEqualToString:firstImageStr]) {
            self.selectedBikeImageViewUrlStr = self.bikeImageColorArr[i];
        [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:self.bikeImageColorArr[i]]];
            break;
            
        }
    }
    if (self.bikePriceStr) {
        self.bikePriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.bikePriceStr.floatValue];
    }
    if (colorSetStr.length <1) {
        return;
    }
  
    
    
    [self createColorButtonUIViewAutolayout:self.baseColorArr];
    
    
    
}


- (void)colorButtonClick:(UIButton *) sender
{
    if (self.selectedButton != nil) {
        [self.selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         self.selectedButton.layer.borderColor = [[UIColor blackColor]CGColor];
    }
    
    NSLog(@" titile %@",sender.currentTitle);
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.layer.borderColor = [[UIColor redColor]CGColor];
    self.selectedButton = sender;
    self.selectedBikeColorLabel.text = self.selectedButton.titleLabel.text;
    
    NSString *currentTitleStr = [sender currentTitle];
    int index = 0;
    for (int i= 0; i <self.baseColorArr.count; i++) {
        NSString *tmpColorStr = self.baseColorArr[i];
        if ([tmpColorStr isEqualToString:currentTitleStr]) {
            index = i; break;
        }
    }
    NSString *bikeImageUrlStr = self.bikeImageColorArr[index];
    /**
     *  3.颜色选取页面，选择不同颜色图片随之改变，当某一颜色没有图片时，取上一次颜色的图片；
     */
    if (bikeImageUrlStr.length>3) {
        self.selectedBikeImageViewUrlStr = bikeImageUrlStr;
        [self.bikeImageView sd_setImageWithURL:[NSURL URLWithString:bikeImageUrlStr]];
    }
    
    
    
    
    
}
- (void)createColorButtonUIViewAutolayout:(NSArray *)colorArr
{
//    CGRect startFrame = CGRectMake750(20, 20, 150, 30);
    self.colorBacgroundScrollView.contentSize = CGSizeMake(750 *SizeScale750, (50 + 50 *colorArr.count/3)*SizeScale750);
    long j=0;
 
    if (colorArr.count /3 == 0) {
        j =  colorArr.count/3;
    }else
    {
        j =  colorArr.count/3 +1;
    }
    if (!j)  j =1;
    for (int line = 0; line < j;line ++) {
        

        for (int i = 0 ;i< 3 ; i ++) {


            if (line *3 +i >= colorArr.count) {
                return;
            }
            NSLog(@"i =%d line %d",i ,line);
            CGRect startFrame = CGRectMake750(20 + i * 220, 20 + 60 *line , 150, 50);
            UIButton *tmpButton = [[UIButton alloc]initWithFrame:startFrame];
            [tmpButton setTitle:colorArr[ line *3 +i ] forState:UIControlStateNormal];
            [tmpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // 正常  黑色
            [tmpButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];//不可点  灰色
            [tmpButton addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            tmpButton.layer.cornerRadius = 5.f;
            tmpButton.layer.borderColor = [[UIColor grayColor]CGColor];
            tmpButton.layer.borderWidth = 1.f;
            tmpButton.enabled = NO;
            [self.colorBacgroundScrollView addSubview:tmpButton];
            for (NSString *tmpColor in self.activityColorArr) {
                
                NSString *verifyColorStr = colorArr[line *3 +i];
                NSLog(@"tmpColor  %@",tmpColor);
                NSLog(@"verifyColorStr  %@",verifyColorStr);
                if ([tmpColor isEqualToString:verifyColorStr]) {
                    tmpButton.enabled = YES;
                    tmpButton.layer.borderColor = [[UIColor blackColor]CGColor];
                    break;
                }
            }
            
        }
    
    
    }
    
}



- (void)handleSingleTapGesture:(UITapGestureRecognizer *) tapGestureRecognizer
{
    
    
    
    NSLog(@" 点击背景 关闭 ...");
    [self removeFromSuperview];
    
    
    
}


- (void)closeButtonClick:(UIButton *)sender
{
    
    NSLog(@"关闭 ...");
    [self removeFromSuperview];
    
    
    
    
}


- (void)confirmButtonClick:(UIButton *)sender
{
    
    NSLog(@"确认 ...");
    
    /**
     *  将 颜色 传递 回去
     */
    
    
    if (self.selectedButton!= nil) {
        NSString *colorStr = self.selectedButton.currentTitle;
        NSDictionary *colorDic = [[NSDictionary alloc]initWithObjectsAndKeys:colorStr,@"color",self.selectedBikeImageViewUrlStr,@"bikeImageViewUrl",nil];
        
        self.okayAction(colorDic);
    }else
    {
        [self alertViewTitle:@"提示" andSubmessage:@"请选择颜色"];
    }
    
    
}



#pragma lazyload

- (UIView *)grayBackgroundView
{
    if (!_grayBackgroundView) {
        _grayBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 0, 750, 1334)];
        _grayBackgroundView.backgroundColor = [UIColor blackColor];
        _grayBackgroundView.alpha = .5f;
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_grayBackgroundView addGestureRecognizer:singleRecognizer];
    }
    
    return _grayBackgroundView;
    
    
    
    
    
}




- (UIView *)whiteBackgroundView
{
    if (!_whiteBackgroundView) {
        _whiteBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 812, 750, 520)];
        _whiteBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    return _whiteBackgroundView;
    
    
    
    
    
}



- (NSMutableArray *)bikeColorDatasourcesMArr
{
    if (!_bikeColorDatasourcesMArr) {
        _bikeColorDatasourcesMArr = [[NSMutableArray alloc]initWithCapacity:4];
    }
    return _bikeColorDatasourcesMArr;
    
    
}


- (UIImageView *)bikeImageView
{
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20,747, 180, 180)];
        _bikeImageView.image = [UIImage imageNamed:@"bikePlacehodler"];
        
    }
    return _bikeImageView;
    
    
}


- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake750(670, 832, 60, 60)];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"closeNew"] forState:UIControlStateNormal];
        
    }
    
    return _closeButton;
    
    
    
    
    
}


- (UILabel *)bikePriceLabel
{
    if (!_bikePriceLabel) {
        _bikePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake750(240, 852, 450, 30)];
        _bikePriceLabel.text = @"¥888";
        _bikePriceLabel.font = [UIFont systemFontOfSize:28*SizeScale750];
        _bikePriceLabel.textColor = [UIColor redColor];
        
    }
    
    return _bikePriceLabel;
    
}

- (UILabel *)selectedTitleLabel
{
    
    if (!_selectedTitleLabel) {
        _selectedTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(240, 902,62, 20)];
        _selectedTitleLabel.text = @"已选:";
        _selectedTitleLabel.font = [UIFont systemFontOfSize:20 *SizeScale750];
    }
    return _selectedTitleLabel;
    
    
    
}

- (UILabel *)selectedBikeColorLabel
{
    if (!_selectedBikeColorLabel ) {
        _selectedBikeColorLabel = [[UILabel alloc]initWithFrame:CGRectMake750(320, 902, 200, 20)];
        _selectedBikeColorLabel.text = @"";
        _selectedBikeColorLabel.textAlignment = NSTextAlignmentLeft;
        _selectedBikeColorLabel.font = [UIFont systemFontOfSize:20 *SizeScale750];
        
        
    }
    return _selectedBikeColorLabel;
    
}


- (UILabel *)bikeColorTitleLabel
{
    
    if (!_bikeColorTitleLabel) {
        _bikeColorTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20, 980, 200, 20)];
        _bikeColorTitleLabel.text = @"颜色分类:";
    }
    return _bikeColorTitleLabel;
    
    
    
}

- (UILabel *)firstLineLabel
{
    if (!_firstLineLabel ) {
        _firstLineLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0, 1210,750,1)];
        _firstLineLabel.backgroundColor = [ UIColor grayColor];
        
    }
    return _firstLineLabel;
    
}
- (UIScrollView *)colorBacgroundScrollView
{
    if (!_colorBacgroundScrollView) {
        _colorBacgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake750(0, 1020, 750, 180)];
        _colorBacgroundScrollView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _colorBacgroundScrollView;
    
    
    
}
- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake750(200, 1220, 350, 90)];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 5;
        
        _confirmButton.backgroundColor = [UIColor redColor];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    }
    return _confirmButton;
    
    
}



- (void)alertViewTitle:(NSString *)titleStr andSubmessage:(NSString *)submessageStr
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:titleStr message:submessageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}


//
//
//
//@property (nonatomic,strong) UIScrollView *colorBacgroundScrollView;
//
//@property (nonatomic,strong) UIButton *confirmButton;









@end
