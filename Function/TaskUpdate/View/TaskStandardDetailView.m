//
//  TaskStandardDetailView.m
//  QiDai
//
//  Created by manman'swork on 16/11/4.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "TaskStandardDetailView.h"

@interface TaskStandardDetailView()

@property (nonatomic,strong)NSString *taskCategory;


@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIImageView *taskCategoryImageView;

@property (nonatomic,strong)UIImageView *timeLogoImageView;

@property (nonatomic,strong)UILabel *taskDateTitleLabel;
@property (nonatomic,strong)UILabel *taskDateLabel;


@property (nonatomic,strong)UIImageView *taskChallengeImageView;
@property (nonatomic,strong)UILabel *taskChallengeTitleLabel;
@property (nonatomic,strong)UILabel *taskChallengeLabel;


@property (nonatomic,strong)UIImageView *taskStandardPeriodImageView;
@property (nonatomic,strong)UILabel *taskStandardPeriodTitleLabel;
@property (nonatomic,strong)UILabel *taskStandardPeriodLabel;


@property (nonatomic,strong)UIImageView *taskPerGoalImageView;
@property (nonatomic,strong)UILabel *taskPerGoalTitleLabel;
@property (nonatomic,strong)UILabel *taskPerGoalLabel;


@property (nonatomic,strong)UIImageView *taskPerRewardImageView;
@property (nonatomic,strong)UILabel *taskPerRewardTitleLabel;
@property (nonatomic,strong)UILabel *taskPerRewardLabel;

@property (nonatomic,strong)UILabel *taskPerRewardFirstTitleLabel;
@property (nonatomic,strong)UILabel *taskPerRewardSecondTitleLabel;
@property (nonatomic,strong)UILabel *taskPerRewardThirdTitleLabel;
@property (nonatomic,strong)UILabel *taskPerRewardFirstLabel;
@property (nonatomic,strong)UILabel *taskPerRewardSecondLabel;
@property (nonatomic,strong)UILabel *taskPerRewardThirdLabel;

@property (nonatomic,strong)UIImageView *taskGrandPrixImageView;
@property (nonatomic,strong)UILabel *taskGrandPrixTitleLabel;
@property (nonatomic,strong)UILabel *taskGrandPrixLabel;

@end

@implementation TaskStandardDetailView

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
        //[self customUIView];
    }
    
    return self;
    
}

- (void)customUIView:(NSString *)taskCategory;
{
    self.taskCategory = taskCategory;
    [self addSubview:self.backgroundImageView];
    
    
    [self addSubview:self.timeLogoImageView];
    [self addSubview:self.taskDateTitleLabel];
    [self addSubview:self.taskDateLabel];
    
    if ([self.taskCategory isEqualToString:@"2"]) {
        [self ascendingCustomUIView:nil];
    }else
    {
        [self regularUIViewLayout:nil];
        
    }
  
    
}



- (void)setTaskDetailDescripModel:(NewTaskDetailModel *)taskDetailDescripModel
{
    self.taskCategory = taskDetailDescripModel.taskMainId;
    [self addSubview:self.backgroundImageView];
    
    
    [self addSubview:self.timeLogoImageView];
    [self addSubview:self.taskDateTitleLabel];
    [self addSubview:self.taskDateLabel];
    
    if ([self.taskCategory isEqualToString:@"C"]) {
        [self ascendingCustomUIView:taskDetailDescripModel];
    }else
    {
        [self regularUIViewLayout:taskDetailDescripModel];
        
    }
    
}


- (void)fillDataSource:(NewTaskDetailModel *)taskDescrip
{
    
    
    
}


- (void)regularUIViewLayout:(NewTaskDetailModel *)regularTaskDetailModel
{
    [self addSubview:self.taskCategoryImageView];
    [self addSubview:self.taskChallengeImageView];
    [self addSubview:self.taskChallengeTitleLabel];
    [self addSubview:self.taskChallengeLabel];
    
    [self addSubview:self.taskStandardPeriodImageView];
    [self addSubview:self.taskStandardPeriodTitleLabel];
    [self addSubview:self.taskStandardPeriodLabel];
    
    [self addSubview:self.taskPerGoalImageView];
    [self addSubview:self.taskPerGoalTitleLabel];
    [self addSubview:self.taskPerGoalLabel];
    
    [self addSubview:self.taskPerRewardImageView];
    [self addSubview:self.taskPerRewardTitleLabel];
    [self addSubview:self.taskPerRewardLabel];
    
    [self addSubview:self.taskGrandPrixImageView];
    [self addSubview:self.taskGrandPrixTitleLabel];
    [self addSubview:self.taskGrandPrixLabel];
  
    
    [self fillRegularView:regularTaskDetailModel];
    
    
}


/**
 *  更换 布局
 */
- (void)ascendingCustomUIView:(NewTaskDetailModel *)customTaskDetailDecrip
{
    [self addSubview:self.taskCategoryImageView];
    self.taskCategoryImageView.image = [UIImage imageNamed:@"TaskCategoryAscendingNew"];
    [self addSubview:self.taskChallengeImageView];
    [self addSubview:self.taskChallengeTitleLabel];
    self.taskChallengeTitleLabel.frame = CGRectMake750(20, 400, 180, 33);
    [self addSubview:self.taskChallengeLabel];
    self.taskChallengeLabel.frame = CGRectMake750(130,360,230,33);
    
    [self addSubview:self.taskStandardPeriodImageView];
    [self addSubview:self.taskStandardPeriodTitleLabel];
    self.taskStandardPeriodTitleLabel.frame = CGRectMake750(360, 400, 180, 33);
    [self addSubview:self.taskStandardPeriodLabel];
    self.taskStandardPeriodLabel.frame = CGRectMake750(480,360,230,33);
    
    [self addSubview:self.taskPerGoalImageView];
    [self addSubview:self.taskPerGoalTitleLabel];
    self.taskPerGoalTitleLabel.frame = CGRectMake750(20, 533, 180, 33);
    [self addSubview:self.taskPerGoalLabel];
    self.taskPerGoalLabel.frame = CGRectMake750(130,480,230,33);
    
    [self addSubview:self.taskPerRewardImageView];
    [self addSubview:self.taskPerRewardTitleLabel];
    //480,500,230,33
    self.taskPerRewardTitleLabel.frame = CGRectMake750(360, 533, 180, 33);
    //[self addSubview:self.taskPerRewardLabel];
    //480,460,180,33
    //self.taskPerRewardLabel.frame = CGRectMake750(480,480,180,33);
    
    [self addSubview:self.taskPerRewardFirstTitleLabel];
    [self addSubview:self.taskPerRewardFirstLabel];
    [self addSubview:self.taskPerRewardSecondTitleLabel];
    [self addSubview:self.taskPerRewardSecondLabel];
    [self addSubview:self.taskPerRewardThirdTitleLabel];
    [self addSubview:self.taskPerRewardThirdLabel];
    
    [self addSubview:self.taskGrandPrixImageView];
    [self addSubview:self.taskGrandPrixTitleLabel];
    self.taskGrandPrixTitleLabel.frame = CGRectMake750(20, 666, 180, 33);
    [self addSubview:self.taskGrandPrixLabel];
    self.taskGrandPrixLabel.frame = CGRectMake750(130,620,230,33);
    
    [self fillCustomView:customTaskDetailDecrip];
    
    
}


- (void)fillCustomView:(NewTaskDetailModel *)resultDataSourceModel
{
    NSString *startTimeStr = [resultDataSourceModel.userTaskStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
     NSString *endTimeStr = [resultDataSourceModel.userTaskFinishTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *taskDatePeriodStr = [NSString stringWithFormat:@"(%@-%@)",startTimeStr,endTimeStr];
    self.taskDateLabel.text = taskDatePeriodStr;
    self.taskChallengeLabel.text = [NSString stringWithFormat:@"%@天",resultDataSourceModel.totalDuration];
    self.taskStandardPeriodLabel.text = [NSString stringWithFormat:@"%@天",resultDataSourceModel.validDuration];
    self.taskPerGoalLabel.text = [NSString stringWithFormat:@"%dkm",(int)resultDataSourceModel.distancePerDay.integerValue/1000];
    
    self.taskPerRewardLabel.text = resultDataSourceModel.bonusIssue;
    
    
    NSArray *dateArr = [resultDataSourceModel.bonusIssue componentsSeparatedByString:@","];
   
    if (dateArr.count>=1) {
        NSString *firstDateStr = dateArr[0];
        if (firstDateStr.length>0)
            self.taskPerRewardFirstTitleLabel.text = firstDateStr;
    }
    if (dateArr.count>=2) {
        NSString *firstDateStr = dateArr[1];
        if (firstDateStr.length>0)
            self.taskPerRewardSecondTitleLabel.text = firstDateStr;
    }
    if (dateArr.count>=3) {
        NSString *firstDateStr = dateArr[2];
        if (firstDateStr.length>0)
            self.taskPerRewardThirdTitleLabel.text = firstDateStr;
    }
    self.taskGrandPrixLabel.text = [NSString stringWithFormat:@"%@元", resultDataSourceModel.refund];
    
    
}


- (void)fillRegularView:(NewTaskDetailModel *)resultDataSourceModel
{
    //A定期赚
    if ([resultDataSourceModel.taskMainId isEqualToString:@"A"]) {
        self.taskCategoryImageView.image = [UIImage imageNamed:@"TaskCategoryPeriodicalNew"];
    }else
    {
        self.taskCategoryImageView.image = [UIImage imageNamed:@"TaskCategoryDailyNew"];
    }
    NSString *startTimeStr = [resultDataSourceModel.userTaskStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTimeStr = [resultDataSourceModel.userTaskFinishTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *taskDatePeriodStr = [NSString stringWithFormat:@"(%@-%@)",startTimeStr,endTimeStr];
    self.taskDateLabel.text = taskDatePeriodStr;
    self.taskChallengeLabel.text = [NSString stringWithFormat:@"%@天",resultDataSourceModel.totalDuration];
    self.taskStandardPeriodLabel.text = [NSString stringWithFormat:@"%@天",resultDataSourceModel.validDuration];
    self.taskPerGoalLabel.text = [NSString stringWithFormat:@"%dkm",resultDataSourceModel.distancePerDay.integerValue/1000];
    
    self.taskPerRewardLabel.text = [NSString stringWithFormat:@"%@",resultDataSourceModel.bonusIssue];
    
    self.taskGrandPrixLabel.text = [NSString stringWithFormat:@"%@元",resultDataSourceModel.refund];
    
    
    
}



- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0,18,710,710)];
        _backgroundImageView.image = [UIImage imageNamed:@"TaskStandardDetailBackgroundImageView"];
        
    }
    
    return _backgroundImageView;
    
    
}

- (UIImageView *)taskCategoryImageView
{
    if (!_taskCategoryImageView) {
        _taskCategoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(230,0,250,75)];
        _taskCategoryImageView.image = [UIImage imageNamed:@"TaskCategoryDaily"];
        
    }
    
    return _taskCategoryImageView;
    
    
}

- (UIImageView *)timeLogoImageView
{
    if (!_timeLogoImageView) {
        _timeLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(307,110,74,61)];
        _timeLogoImageView.image = [UIImage imageNamed:@"timeLogoImageView"];
        
    }
    
    return _timeLogoImageView;
    
    
}




- (UILabel *)taskDateTitleLabel
{
    if (!_taskDateTitleLabel) {
        _taskDateTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,200,710,33)];
        _taskDateTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskDateTitleLabel.text = @"挑战周期";
        _taskDateTitleLabel.textColor = [UIColor grayColor];
        _taskDateTitleLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo750];
    }
    return _taskDateTitleLabel;
}

- (UILabel *)taskDateLabel
{
    if (!_taskDateLabel) {
        _taskDateLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,240,710,40)];
        _taskDateLabel.textAlignment = NSTextAlignmentCenter;
        _taskDateLabel.text = @"(2016.10.01-2016.12.30)";
        _taskDateLabel.font = [UIFont systemFontOfSize:40*SizeScaleSubjectTo750];
        
    }
    return _taskDateLabel;
}


- (UIImageView *)taskChallengeImageView
{
    if (!_taskChallengeImageView) {
        _taskChallengeImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(80,350,42,40)];
        _taskChallengeImageView.image = [UIImage imageNamed:@"taskChallengeDateImageView"];
        
    }
    
    return _taskChallengeImageView;
    
    
}




- (UILabel *)taskChallengeTitleLabel
{
    if (!_taskChallengeTitleLabel) {
        _taskChallengeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(130,377,180,22)];
        _taskChallengeTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskChallengeTitleLabel.text = @"挑战天数";//
         _taskChallengeTitleLabel.textColor = [UIColor lightGrayColor];
        _taskChallengeTitleLabel.font = [UIFont systemFontOfSize:22*SizeScaleSubjectTo750];
    }
    return _taskChallengeTitleLabel;
}

- (UILabel *)taskChallengeLabel
{
    if (!_taskChallengeLabel) {
        _taskChallengeLabel = [[UILabel alloc]initWithFrame:CGRectMake750(130,340,180,27)];
        _taskChallengeLabel.textAlignment = NSTextAlignmentCenter;
        _taskChallengeLabel.text = @"30天";
        _taskChallengeLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo750];
        
    }
    return _taskChallengeLabel;
}


- (UIImageView *)taskStandardPeriodImageView
{
    if (!_taskStandardPeriodImageView) {
        _taskStandardPeriodImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(433,348,40,41)];
        _taskStandardPeriodImageView.image = [UIImage imageNamed:@"taskStandardPeriodImageView"];
        
    }
    
    return _taskStandardPeriodImageView;
    
    
}




- (UILabel *)taskStandardPeriodTitleLabel
{
    if (!_taskStandardPeriodTitleLabel) {
        _taskStandardPeriodTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(480,377,180,22)];
        _taskStandardPeriodTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskStandardPeriodTitleLabel.text = @"达标天数";
        _taskStandardPeriodTitleLabel.textColor = [UIColor lightGrayColor];
        _taskStandardPeriodTitleLabel.font = [UIFont systemFontOfSize:22*SizeScaleSubjectTo750];
    }
    return _taskStandardPeriodTitleLabel;
}

- (UILabel *)taskStandardPeriodLabel
{
    if (!_taskStandardPeriodLabel) {
        _taskStandardPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake750(480,340,180,27)];
        _taskStandardPeriodLabel.textAlignment = NSTextAlignmentCenter;
        _taskStandardPeriodLabel.text = @"30天";
        _taskStandardPeriodLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo750];
        
    }
    return _taskStandardPeriodLabel;
}





- (UIImageView *)taskPerGoalImageView
{
    if (!_taskPerGoalImageView) {
        _taskPerGoalImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(80,481,41,43)];
        _taskPerGoalImageView.image = [UIImage imageNamed:@"taskPerGoalImageView"];
        
    }
    
    return _taskPerGoalImageView;
    
    
}




- (UILabel *)taskPerGoalTitleLabel
{
    if (!_taskPerGoalTitleLabel) {
        _taskPerGoalTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(130,515,180,22)];
        _taskPerGoalTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerGoalTitleLabel.text = @"每日目标";
        _taskPerGoalTitleLabel.textColor = [UIColor lightGrayColor];
        _taskPerGoalTitleLabel.font = [UIFont systemFontOfSize:22*SizeScaleSubjectTo750];
    }
    return _taskPerGoalTitleLabel;
}

- (UILabel *)taskPerGoalLabel
{
    if (!_taskPerGoalLabel) {
        _taskPerGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake750(130,480,180,33)];
        _taskPerGoalLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerGoalLabel.text = @"10km";
        _taskPerGoalLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo750];
        
    }
    return _taskPerGoalLabel;
}


- (UIImageView *)taskPerRewardImageView
{
    if (!_taskPerRewardImageView) {
        _taskPerRewardImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(433,483,35,51)];
        _taskPerRewardImageView.image = [UIImage imageNamed:@"taskPerRewardImageView"];
        
    }
    
    return _taskPerRewardImageView;
    
    
}




- (UILabel *)taskPerRewardTitleLabel
{
    if (!_taskPerRewardTitleLabel) {
        _taskPerRewardTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(480,515,180,22)];
        _taskPerRewardTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardTitleLabel.text = @"每日奖金";
        _taskPerRewardTitleLabel.textColor = [UIColor lightGrayColor];
        _taskPerRewardTitleLabel.font = [UIFont systemFontOfSize:22*SizeScaleSubjectTo750];
    }
    return _taskPerRewardTitleLabel;
}

- (UILabel *)taskPerRewardLabel
{
    if (!_taskPerRewardLabel) {
        _taskPerRewardLabel = [[UILabel alloc]initWithFrame:CGRectMake750(480,479,180,27)];
        _taskPerRewardLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardLabel.text = @"100元";
        _taskPerRewardLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo750];
        
    }
    return _taskPerRewardLabel;
}


- (UILabel *)taskPerRewardFirstTitleLabel
{
    if (!_taskPerRewardFirstTitleLabel) {
        _taskPerRewardFirstTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(500,460,190,22)];
        _taskPerRewardFirstTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardFirstTitleLabel.text = @"(08.01-08.10)";
        _taskPerRewardFirstTitleLabel.font = [UIFont systemFontOfSize:15*SizeScaleSubjectTo750];
    }
    return _taskPerRewardFirstTitleLabel;
}

- (UILabel *)taskPerRewardFirstLabel
{
    if (!_taskPerRewardFirstLabel) {
        _taskPerRewardFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake750(610,460,80,22)];
        _taskPerRewardFirstLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardFirstLabel.text = @"";
        _taskPerRewardFirstLabel.font = [UIFont boldSystemFontOfSize:18*SizeScaleSubjectTo750];
        
    }
    return _taskPerRewardFirstLabel;
}

- (UILabel *)taskPerRewardSecondTitleLabel
{
    if (!_taskPerRewardSecondTitleLabel) {
        _taskPerRewardSecondTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(500,490,190,22)];
        _taskPerRewardSecondTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardSecondTitleLabel.text = @"(08.11-08.20)";
        _taskPerRewardSecondTitleLabel.font = [UIFont systemFontOfSize:15*SizeScaleSubjectTo750];
    }
    return _taskPerRewardSecondTitleLabel;
}

- (UILabel *)taskPerRewardSecondLabel
{
    if (!_taskPerRewardSecondLabel) {
        _taskPerRewardSecondLabel = [[UILabel alloc]initWithFrame:CGRectMake750(610,490,80,22)];
        _taskPerRewardSecondLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardSecondLabel.text = @"";
        _taskPerRewardSecondLabel.font = [UIFont boldSystemFontOfSize:18*SizeScaleSubjectTo750];
        
    }
    return _taskPerRewardSecondLabel;
}


- (UILabel *)taskPerRewardThirdTitleLabel
{
    if (!_taskPerRewardThirdTitleLabel) {
        _taskPerRewardThirdTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(500,520,190,22)];
        _taskPerRewardThirdTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardThirdTitleLabel.text = @"(08.21-08.30)";
        _taskPerRewardThirdTitleLabel.font = [UIFont systemFontOfSize:15*SizeScaleSubjectTo750];
    }
    return _taskPerRewardThirdTitleLabel;
}

- (UILabel *)taskPerRewardThirdLabel
{
    if (!_taskPerRewardThirdLabel) {
        _taskPerRewardThirdLabel = [[UILabel alloc]initWithFrame:CGRectMake750(610,520,80,22)];
        _taskPerRewardThirdLabel.textAlignment = NSTextAlignmentCenter;
        _taskPerRewardThirdLabel.text = @"";
        _taskPerRewardThirdLabel.font = [UIFont boldSystemFontOfSize:18*SizeScaleSubjectTo750];
        
    }
    return _taskPerRewardThirdLabel;
}



- (UIImageView *)taskGrandPrixImageView
{
    if (!_taskGrandPrixImageView) {
        _taskGrandPrixImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(80,628,38,38)];
        _taskGrandPrixImageView.image = [UIImage imageNamed:@"taskGrandPrixImageView"];
        
    }
    
    return _taskGrandPrixImageView;
    
    
}




- (UILabel *)taskGrandPrixTitleLabel
{
    if (!_taskGrandPrixTitleLabel) {
        _taskGrandPrixTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(130,655,180,33)];
        _taskGrandPrixTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskGrandPrixTitleLabel.text = @"总奖金";
        _taskGrandPrixTitleLabel.textColor = [UIColor lightGrayColor];
        _taskGrandPrixTitleLabel.font = [UIFont systemFontOfSize:22*SizeScaleSubjectTo750];
    }
    return _taskGrandPrixTitleLabel;
}

- (UILabel *)taskGrandPrixLabel
{
    if (!_taskGrandPrixLabel) {
        _taskGrandPrixLabel = [[UILabel alloc]initWithFrame:CGRectMake750(130,617,180,27)];
        _taskGrandPrixLabel.textAlignment = NSTextAlignmentCenter;
        _taskGrandPrixLabel.text = @"3000元";
        _taskGrandPrixLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo750];
        
    }
    return _taskGrandPrixLabel;
}


@end
