//
//  CommonPickView.m
//  PickView
//
//  Created by wenyang.wu on 14-8-19.
//  Copyright (c) 2014年 autonavi. All rights reserved.
//

#import "CommonPickView.h"

@interface CommonPickView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,strong)  UIPickerView *pickerView;

@property (nonatomic,assign) PickViewType pickViewType;

@property (nonatomic,strong) UIView *modelView;
@property (nonatomic,strong) UILabel *label;

@end

@implementation CommonPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame
      pickViewType:(PickViewType)pickViewType
       currentData:(NSString *)dataString
 okCompletionBlock:(CommonPickViewcompletionBlock)okCompletionBlock
       cancelBlock:(CommonPickViewcompletionBlock)cancelCompletionBlock
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.modelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.modelView.backgroundColor = [UIColor whiteColor];
        self.modelView.alpha = 0.5;
        [self addSubview:self.modelView];
        
        self.alpha = 1;
        
        _okCompletionBlock = okCompletionBlock;
        _cancelCompletionBlock = cancelCompletionBlock;
        
        _pickViewType = pickViewType;
        
        if (_pickViewType == PerimeterPicker || _pickViewType == ClockWeightPicker) {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216 , frame.size.width, 216)];
        }else{
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216 , frame.size.width, 216)];
        }
        _pickerView.backgroundColor = UIColorFromRGB_10(229, 232, 240);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        if (_pickViewType == WeightPicker || _pickViewType == ClockWeightPicker) {
            [_pickerView selectRow:[dataString intValue]-30 inComponent:0 animated:YES];
        } else if (_pickViewType == HeightPicker) {
            [_pickerView selectRow:[dataString intValue]-100 inComponent:0 animated:YES];
        }
        [self addSubview:_pickerView];
        //39
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 216 - 30 , frame.size.width, 60)];
        topView.backgroundColor = UIColorFromRGB_10(229, 232, 240);
        [self addSubview:topView];
        // || _pickViewType == ClockWeightPicker
        if (_pickViewType == PerimeterPicker ) {
            [topView setFrame:CGRectMake(0, frame.size.height - 216 -60, frame.size.width, 60)];
        }
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(HCDW/2-60, 10, 120, 30)];
        //self.label.backgroundColor = [UIColor redColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        
        if (_pickViewType == WeightPicker) {
            self.label.text = @"选择体重";
        } else if (_pickViewType == ClockWeightPicker){
            self.label.text = @"选择体重";
        } else if (_pickViewType == HeightPicker){
            self.label.text = @"选择身高";
        } else if(_pickViewType == PerimeterPicker) {
            self.label.text = @"选择码表周长";
        }else{
            self.label.text = @"选择性别";
        }
        self.label.textColor = UIColorFromRGB_10(40, 40, 40);
        [topView addSubview:self.label];
        UIImageView *downArrow = [[UIImageView alloc]initWithFrame:CGRectMake(HCDW/2-5, 40, 10, 8)];
        downArrow.image = [UIImage imageNamed:@"downArrow"];
        [topView addSubview:downArrow];
        
        
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        topLineView.backgroundColor = UIColorFromRGB_10(107, 108, 120);
        [topView addSubview:topLineView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bounds.size.height - 1, frame.size.width, 1)];
        lineView.backgroundColor = UIColorFromRGB_10(107, 108, 120);
        [topView addSubview:lineView];
        
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(HCDW-60, 10, 60, 40)];
        //[cancelButton setBackgroundColor:[UIColor colorWithRed:251/255.0 green:65/255.0 blue:73/255.0 alpha:1]];
        [cancelButton setTitle:@"确定" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cancelButton.showsTouchWhenHighlighted = YES;
        [cancelButton addTarget:self action:@selector(clickOkButton) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancelButton];

        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(10,10,60,40)];
        [okButton setTitle:@"取消" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:okButton];
//        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height -50, frame.size.width/2, 50)];
//        [cancelButton setBackgroundColor:[UIColor colorWithRed:251/255.0 green:65/255.0 blue:73/255.0 alpha:1]];
//        [cancelButton setTitle:@"确定" forState:UIControlStateNormal];
//        cancelButton.showsTouchWhenHighlighted = YES;
//        [cancelButton addTarget:self action:@selector(clickOkButton) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cancelButton];
        
       
//        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height -50, frame.size.width/2, 50)];
//        [okButton setBackgroundColor:[UIColor colorWithRed:91/255.0 green:157/255.0 blue:218/255.0 alpha:1]];
//        [okButton setTitle:@"取消" forState:UIControlStateNormal];
//        [okButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:okButton];
    }
    return self;
}

- (void)show
{
    CGRect defaultRect = self.frame;
    CGRect rect = self.frame;
    rect.origin.y = 600;
    self.frame = rect;
    self.alpha = 1;
    
#pragma -mark alpha
    [UIView animateWithDuration:0.3 animations:^{
        self.modelView.alpha = 0;
        self.frame = defaultRect;
    } completion:nil];
    
}

-(void)clickCancelButton
{
    [UIView animateWithDuration:0.15 animations:^{
        self.modelView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.frame;
                rect.origin.y = 600;
                self.frame = rect;
                _cancelCompletionBlock(0);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }];
        }
    }];

}

-(void)clickOkButton{

    /*
     NSString *dataString = @"";
    
    if (_pickViewType == WeightPicker) {
        
        dataString = [NSString stringWithFormat:@"%d.%ldKG",WeightMinValue+[_pickerView selectedRowInComponent:0],(long)[_pickerView selectedRowInComponent:1]];
        
    }else if (_pickViewType == HeightPicker){
        dataString = [NSString stringWithFormat:@"%d.%ldCM",HeightMinValue+[_pickerView selectedRowInComponent:0],(long)[_pickerView selectedRowInComponent:1]];
    }
     */

    NSInteger data;
    if (_pickViewType == WeightPicker) {
        data = WeightMinValue+[_pickerView selectedRowInComponent:0];
    } else if (_pickViewType == HeightPicker){
        data = HeightMinValue+[_pickerView selectedRowInComponent:0];
    }else if (_pickViewType == ClockWeightPicker){
        data = WeightMinValue+[_pickerView selectedRowInComponent:0];
    }else if (_pickViewType == PerimeterPicker){
        NSString *perimeter = [kPerimeterSizeArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
        data = [[[perimeter componentsSeparatedByString:@"|"] lastObject] intValue];
    } else {
        data = [_pickerView selectedRowInComponent:0];
    }
    
    _okCompletionBlock(data);
    
    [self clickCancelButton];
}


//选项默认值
-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    return;
}
//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    if (_pickViewType == GenderPicker || _pickViewType == PerimeterPicker) {
        return 1;
    }
    return 2;
}

//返回数组总数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            
            if (_pickViewType == WeightPicker) {
                return 221;
            } else if (_pickViewType == HeightPicker) {
                return 141;
            } else if (_pickViewType == PerimeterPicker) {
                return kPerimeterSizeArray.count;
            }else if (_pickViewType == ClockWeightPicker) {
                return 141;
            }else {
                return 2;
            }
            
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (_pickViewType == WeightPicker) {
        
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%ld",(long)WeightMinValue+row];
                break;
            case 1:
                return @"KG";
                break;
            default:
                return @"";
                break;
        }
        
    }
    else if (_pickViewType == ClockWeightPicker) {
        
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%ld",(long)WeightMinValue+row];
                break;
            case 1:
                return @"KG";
                break;
            default:
                return @"";
                break;
        }
        
    }
    else if (_pickViewType == HeightPicker){
    
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%ld",(long)HeightMinValue+row];
                break;
            case 1:
                return @"CM";
                break;
            default:
                return @"";
                break;
        }
    }else if (_pickViewType == PerimeterPicker){
        
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%@ mm",[kPerimeterSizeArray objectAtIndex:row]];
                break;
            case 1:
                return @"";
                break;
            default:
                return @"";
                break;
        }
    } else {
        
        switch (component) {
            case 0:
                if (row == 0) {
                  return @"帅哥";
                }
                return @"美女";
                break;
                
            default:
                return @"";
                break;
        }
    }
}





//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

@end
