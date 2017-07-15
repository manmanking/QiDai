//
//  DatePickView.m
//  PickView
//
//  Created by wenyang.wu on 14-8-19.
//  Copyright (c) 2014年 autonavi. All rights reserved.
//

#import "DatePickView.h"


@interface DatePickView()

@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIView *modelView;

@end

@implementation DatePickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame
              date:(NSDate *)date
 okCompletionBlock:(DatePickViewcompletionBlock)okCompletionBlock
       cancelBlock:(DatePickViewcompletionBlock)cancelCompletionBlock
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.modelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.modelView.backgroundColor = [UIColor whiteColor];
        self.modelView.alpha = 0.5f;
        [self addSubview:self.modelView];
        
        
        self.alpha = 0;
        
        _okCompletionBlock = okCompletionBlock;
        _cancelCompletionBlock = cancelCompletionBlock;
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, frame.size.height - 216 , frame.size.width, 216)];
        
        _datePicker.backgroundColor = UIColorFromRGB_10(229, 232, 240);
        // 设置当前显示时间
        if (date) {
            [_datePicker setDate:date animated:YES];
        }
        // 设置显示最大时间（此处为当前时间）
        [_datePicker setMaximumDate:[NSDate date]];
        
        // 设置UIDatePicker的显示模式
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        
        
        _datePicker.minimumDate = [self stringToDate:@"1900-01-01"];
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* str = [formatter stringFromDate:date];
        _datePicker.maximumDate = [self stringToDate:str];
        
        // 当值发生改变的时候调用的方法
        // [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePicker];
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216 - 30 , frame.size.width, 1)];
        topLineView.backgroundColor = [UIColor colorWithRed:107/255.0 green:108/255.0 blue:120/255.0 alpha:1];
        [self addSubview:topLineView];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 216 - 30 , frame.size.width, 60)];
        topView.backgroundColor = UIColorFromRGB_10(229, 232, 240);
        [self addSubview:topView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HCDW/2-40, 10, 80, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"选择生日";
        [topView addSubview:label];
        UIImageView *downArrow = [[UIImageView alloc]initWithFrame:CGRectMake(HCDW/2-5, 40, 10, 8)];
        downArrow.image = [UIImage imageNamed:@"downArrow"];
        [topView addSubview:downArrow];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216 - 10 - 4 + 40, frame.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:107/255.0 green:108/255.0 blue:120/255.0 alpha:1];
        [self addSubview:lineView];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
            _datePicker.frame = CGRectMake(0, frame.size.height - 216 - 30 - 20, frame.size.width, 216);
            topLineView.frame = CGRectMake(0, frame.size.height - 216 - 30 - 39 - 4 - 1 - 20, frame.size.width, 1);
            label.frame = CGRectMake(0, frame.size.height - 216 - 30 - 39 - 4 - 20, frame.size.width, 39);
            lineView.frame = CGRectMake(0, frame.size.height - 216 - 30 - 4 - 20, frame.size.width, 4);
        }
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
//        okButton.showsTouchWhenHighlighted = YES;
//        [okButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:okButton];
    }
    

    
    return self;
}

-(NSDate*)stringToDate:(NSString *)str
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [inputFormatter dateFromString:str];
}

-(void)clickCancelButton{
    [UIView animateWithDuration:0.15 animations:^{
        self.modelView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.frame;
                rect.origin.y = 600;
                self.frame = rect;
                _cancelCompletionBlock(nil);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }];
        }
    }];
}

- (void)show
{
    CGRect defaultRect = self.frame;
    CGRect rect = self.frame;
    rect.origin.y = 600;
    self.frame = rect;
    self.alpha = 1;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.modelView.alpha = 0;
        self.frame = defaultRect;
    } completion:nil];

}

-(void)clickOkButton{
    _okCompletionBlock(_datePicker.date);
    [self clickCancelButton];
}




@end
