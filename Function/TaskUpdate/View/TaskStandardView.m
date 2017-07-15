//
//  TaskStandard.m
//  QiDai
//
//  Created by manman'swork on 16/11/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "TaskStandardView.h"

@interface TaskStandardView()

@property (nonatomic,strong)UIImageView *taskDetailBackgroundImageView;


@property (nonatomic,strong)UILabel *taskStandardRewardTitleLabel;

@property (nonatomic,strong)UILabel *taskStandardRewardLineLabel;

@property (nonatomic,strong)UILabel *taskStandardRewardLabel;


@property (nonatomic,strong)UILabel *taskStandardMileageTitleLabel;

@property (nonatomic,strong)UILabel *taskStandardMileageLabel;

@property (nonatomic,strong)UILabel *taskStandardFirstLine;


@property (nonatomic,strong)UILabel *taskStandardManyDaysTitleLabel;

@property (nonatomic,strong)UILabel *taskStandardManyDaysLabel;

@property (nonatomic,strong) UIButton *activityDetailButton;


@end



@implementation TaskStandardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype )initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self customUIView];
    }
    
    
    return self;
    
}


- (void)customUIView
{
    
    [self addSubview:self.taskDetailBackgroundImageView];
    [self addSubview:self.activityDetailButton];
    [self addSubview:self.taskStandardRewardLabel];
    [self addSubview:self.taskStandardMileageTitleLabel];
    [self addSubview:self.taskStandardMileageLabel];
    [self addSubview:self.taskStandardFirstLine];
    [self addSubview:self.taskStandardManyDaysTitleLabel];
    [self addSubview:self.taskStandardManyDaysLabel];

}


- (void)setTaskStandarTaskDetailModel:(NewTaskDetailModel *)taskStandarTaskDetailModel
{
    
    
    if ([taskStandarTaskDetailModel.taskMainId isEqualToString:@"A"]) {
        if ([taskStandarTaskDetailModel.complete isEqualToString:@"0"] && [_overFlagStr isEqualToString:@"1"]) {
            [self addSubview:self.taskStandardRewardLineLabel];
            self.taskStandardRewardLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
            
        }
    }
    
    
    NSString *customMoneyFormat =  [NSString stringWithFormat:@"¥%@",taskStandarTaskDetailModel.addBonus];
   // NSString *customMoneyFormat =  [NSString stringWithFormat:@"¥%@",@"888"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:customMoneyFormat];
    [attributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:66.0 *SizeScale750]
     
                          range:NSMakeRange(0,1)];
    _taskStandardRewardLabel.attributedText = attributedStr;
    _taskStandardMileageLabel.text = [NSString stringWithFormat:@"%.2f",taskStandarTaskDetailModel.sumDistance.floatValue/1000];
    _taskStandardManyDaysLabel.text = taskStandarTaskDetailModel.sumStandardDays;
    if ([_overFlagStr isEqualToString:@"1"]) {
        if ([_taskStandarTaskDetailModel.complete isEqualToString:@"0"]) {
            [self addSubview:self.taskStandardRewardLineLabel];
            self.taskStandardRewardLabel.textColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
        }
    }

    
}


- (void)activityDetailButtonClick:(UIButton *)sender
{
    QDLog(@"activityDetailButtonClick ...");
    self.clickHelpButtonAction();
      
    
}



#pragma lazyload





- (UIImageView *)taskDetailBackgroundImageView
{
    if (!_taskDetailBackgroundImageView) {
        _taskDetailBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0,0, 710, 450)];
        _taskDetailBackgroundImageView.image = [UIImage imageNamed:@"TaskDetailBackgroundImage"];
        
    }
    
    
    return _taskDetailBackgroundImageView;
    
}

- (UIButton *)activityDetailButton
{
    if (!_activityDetailButton) {
        _activityDetailButton = [[UIButton alloc]initWithFrame:CGRectMake750(656, 10, 44, 44)];
        [_activityDetailButton  setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
        [_activityDetailButton addTarget:self action:@selector(activityDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return _activityDetailButton;
    
}


- (UILabel *)taskStandardRewardLabel
{
    if (!_taskStandardRewardLabel) {
        _taskStandardRewardLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,60,684,102)];
        _taskStandardRewardLabel.textAlignment = NSTextAlignmentCenter;
        _taskStandardRewardLabel.text = @"";
        _taskStandardRewardLabel.textColor = [UIColor redColor];
        _taskStandardRewardLabel.font = [UIFont systemFontOfSize:136*SizeScaleSubjectTo750];
    }
    return _taskStandardRewardLabel;
}


- (UILabel *)taskStandardRewardLineLabel
{
    if (!_taskStandardRewardLineLabel) {
        _taskStandardRewardLineLabel = [[UILabel alloc]initWithFrame:CGRectMake750(185,110,340,4)];
        _taskStandardRewardLineLabel.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }
    return _taskStandardRewardLineLabel;

}

- (UILabel *)taskStandardMileageTitleLabel
{
    if (!_taskStandardMileageTitleLabel) {
        _taskStandardMileageTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,330,355,33)];
        _taskStandardMileageTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskStandardMileageTitleLabel.text = @"总里程(km)";
        _taskStandardMileageTitleLabel.textColor = [UIColor whiteColor];
        _taskStandardMileageTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];

    }
    return _taskStandardMileageTitleLabel;
}

- (UILabel *)taskStandardMileageLabel
{
    if (!_taskStandardMileageLabel) {
        _taskStandardMileageLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,370,353,80)];
        _taskStandardMileageLabel.textAlignment = NSTextAlignmentCenter;
        _taskStandardMileageLabel.text = @"100";
        _taskStandardMileageLabel.textColor = [UIColor whiteColor];
        _taskStandardMileageLabel.font = [UIFont systemFontOfSize:50*SizeScaleSubjectTo750];
        
        
    }
    return _taskStandardMileageLabel;
}

- (UILabel *)taskStandardFirstLine
{
    if (!_taskStandardFirstLine) {
        _taskStandardFirstLine = [[UILabel alloc]initWithFrame:CGRectMake750(354,370,2,60)];
        _taskStandardFirstLine.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _taskStandardFirstLine;
}





- (UILabel *)taskStandardManyDaysTitleLabel
{
    if (!_taskStandardManyDaysTitleLabel) {
        _taskStandardManyDaysTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(354,330,355,33)];
        _taskStandardManyDaysTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskStandardManyDaysTitleLabel.text = @"总达标天数";
        _taskStandardManyDaysTitleLabel.textColor = [UIColor whiteColor];
        _taskStandardManyDaysTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
       
    }
    return _taskStandardManyDaysTitleLabel;
}
- (UILabel *)taskStandardManyDaysLabel
{
    if (!_taskStandardManyDaysLabel) {
        _taskStandardManyDaysLabel = [[UILabel alloc]initWithFrame:CGRectMake750(357,370,353,80)];
        _taskStandardManyDaysLabel.textAlignment = NSTextAlignmentCenter;
        _taskStandardManyDaysLabel.text = @"500";
        _taskStandardManyDaysLabel.textColor = [UIColor whiteColor];
         _taskStandardManyDaysLabel.font = [UIFont systemFontOfSize:50*SizeScaleSubjectTo750];
    }
    return _taskStandardManyDaysLabel;
}




@end
