//
//  TaskStandardVerifyResultView.m
//  QiDai
//
//  Created by manman'swork on 16/11/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "TaskStandardVerifyResultView.h"

@interface TaskStandardVerifyResultView()

@property (nonatomic,strong)UIImageView *backgroundImageView;


@property (nonatomic,strong)UIImageView *resultSymbol;

@property (nonatomic,strong)UIImageView *todayRewardImageView;


@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,strong)UILabel *rewardLabel;

@property (nonatomic,strong)UILabel *rewardLineLabel;

@property (nonatomic,strong)UILabel *todayRedingTitleLabel;

@property (nonatomic,strong)UILabel *todayRedingLabel;

//lineLabel
//@property (nonatomic,strong)UILabel *rewardLineLabel;

@property (nonatomic,strong)UILabel *firstLineLabel;

@property (nonatomic,strong)UILabel *todayGoalTitleLabel;

@property (nonatomic,strong)UILabel *todayGoalLabel;

@property (nonatomic,strong)UILabel *botomLabel;



@end



@implementation TaskStandardVerifyResultView

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
       
        [self customUIView];
        //self.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    return self;
}




- (void)customUIView
{
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.resultSymbol];
    [self addSubview:self.closeButton];
    [self addSubview:self.rewardLabel];
    [self addSubview:self.todayRewardImageView];
    [self addSubview:self.todayRedingTitleLabel];
    //[self addSubview:self.firstLineLabel];
    [self addSubview:self.todayRedingLabel];
    [self addSubview:self.todayGoalTitleLabel];
    [self addSubview:self.todayGoalLabel];
    [self addSubview:self.botomLabel];
    
    
    
}

//- (void)setIsSuccess:(NSString *)isSuccess
//{
//    if ([isSuccess isEqualToString:@"1"])
//    {
//        
//    }else if ([isSuccess isEqualToString:@"2"])
//    {
//        
//    }
//    
//    
//    
//    
//}


#pragma  本页面的数据  还没填充  


- (void)setResultRedingRecordDateInfoModel:(RedingRecordDateInfoModel *)resultRedingRecordDateInfoModel
{
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeCurrentDate = [date  dateByAddingTimeInterval: interval];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *taskfinishDateMonthStr = [NSString stringWithFormat:@"%@ 00:00:00",resultRedingRecordDateInfoModel.date];
    NSDate *currentTaskDate = [dateFormatter dateFromString:taskfinishDateMonthStr];
    NSInteger taskLocalInterval = [zone secondsFromGMTForDate: currentTaskDate];
    NSDate *currentTaskTodayStartLocalDate = [currentTaskDate  dateByAddingTimeInterval: taskLocalInterval];
    NSDate *currentTaskTodayEndLocalDate = [currentTaskDate  dateByAddingTimeInterval: taskLocalInterval + 24*60*60];
    
    
    
    NSString *customMoneyFormat =  [NSString stringWithFormat:@"¥%@",resultRedingRecordDateInfoModel.money];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:customMoneyFormat];
    [attributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:66.0 *SizeScale750]
     
                          range:NSMakeRange(0,1)];
    // 完成
    if ([_isSuccess isEqualToString:@"1"]) {
        _resultSymbol.image = [UIImage imageNamed:@"TaskStandardVerifyResultSuccessNew"];
         self.rewardLabel.attributedText = attributedStr;
        if ([currentTaskTodayStartLocalDate compare:localeCurrentDate] == NSOrderedAscending &&
            [currentTaskTodayEndLocalDate compare:localeCurrentDate] == NSOrderedDescending)
            _todayRewardImageView.image = [UIImage imageNamed:@"TaskStandardVerifyResultTodayMoneyRedButton"];
        else  {
            _todayRewardImageView.image = [UIImage imageNamed:@"TaskStandardVerifyResultYesterdayMoneyRedButton"];
            _todayRedingTitleLabel.text = @"当日骑行(km)";
        }
    } // 未完成
    else if ([_isSuccess isEqualToString:@"2"])
    {
        _resultSymbol.image = [UIImage imageNamed:@"TaskStandardVerifyResultFailureNew"];
        if ([currentTaskTodayStartLocalDate compare:localeCurrentDate] == NSOrderedAscending &&
            [currentTaskTodayEndLocalDate compare:localeCurrentDate] == NSOrderedDescending)
            _todayRewardImageView.image = [UIImage imageNamed:@"TaskStandardVerifyResultTodayMoneyGreyButton"];
        else {
            _todayRewardImageView.image = [UIImage imageNamed:@"TaskStandardVerifyResultYesterdayMoneyGreyButton"];
            _todayRedingTitleLabel.text = @"当日骑行(km)";
            
        }
            
        self.rewardLabel.text = [NSString stringWithFormat:@"¥%@",resultRedingRecordDateInfoModel.money];
        self.rewardLabel.attributedText = attributedStr;
        self.rewardLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
        
    }
    if ([_overFlagStr isEqualToString:@"1"]) {
        if ([_taskCategoryStr isEqualToString:@"A"] && [_completeStr isEqualToString:@"0"]) {
                _rewardLabel.textColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
                [self addSubview:self.rewardLineLabel];
                //self.rewardLineLabel.backgroundColor = [UIColor redColor];
                
        }
    }
   
    self.todayRedingLabel.text = [NSString stringWithFormat:@"%.2f",resultRedingRecordDateInfoModel.daySumDistance.floatValue /1000];
    self.todayGoalLabel.text = [NSString stringWithFormat:@"%ld",self.distancePerDay.integerValue/1000];
    
    
    
    
   
    
    
    
    
    
    
    
}



- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0, 0,750, 1334)];
        _backgroundImageView.image = [UIImage imageNamed:@"TaskStandardVerifyResultBackgroundImageViewSuperStar"];
        
    }
    return _backgroundImageView;
}


- (UIImageView *)resultSymbol
{
    if (!_resultSymbol) {
        _resultSymbol = [[UIImageView alloc]initWithFrame:CGRectMake750(10, 454, 730, 150)];//0, 485, 750, 160)
        _resultSymbol.image = [UIImage imageNamed:@"TaskStandardVerifyResultSuccessNew"];
        
    }
    return _resultSymbol;
    
}




- (void)closeButtonClick:(UIButton *) sender
{
    NSLog(@"closeButtonClick ...");
    [self removeFromSuperview];
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake750(613,315,60,60)];//609,370,60,60
        [_closeButton setImage:[UIImage imageNamed:@"CloseBlack"] forState:UIControlStateNormal];
        //_closeButton.backgroundColor = [UIColor lightGrayColor];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)rewardLabel
{
    if (!_rewardLabel) {
        _rewardLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20, 625, 700, 75)];
        _rewardLabel.text = @"¥20";
        _rewardLabel.textColor = [UIColor redColor];
        _rewardLabel.textAlignment = NSTextAlignmentCenter;
        _rewardLabel.font = [UIFont boldSystemFontOfSize:100*SizeScaleSubjectTo750];
    }
    return _rewardLabel;
    
}


- (UILabel *)rewardLineLabel
{
    if (!_rewardLineLabel) {
        _rewardLineLabel = [[UILabel alloc]initWithFrame:CGRectMake750(115+20 +120, 625 +38,240,4)];
//        _rewardLineLabel.text = @"¥20";
        _rewardLineLabel.backgroundColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
        //_rewardLineLabel.textAlignment = NSTextAlignmentCenter;
        //_rewardLineLabel.font = [UIFont boldSystemFontOfSize:100*SizeScaleSubjectTo750];
    }
    return _rewardLineLabel;
    
}



- (UIImageView *)todayRewardImageView
{
    if (!_todayRewardImageView) {
        _todayRewardImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(245,759 , 260, 46)];
        _todayRewardImageView.image = [UIImage imageNamed:@"TaskStandardVerifyResultTodayMoneyButton"];
    }
    return _todayRewardImageView;
    
    
}


- (UILabel *)todayRedingTitleLabel
{
    
    if (!_todayRedingTitleLabel) {
        _todayRedingTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(165, 890, 168, 28)];
        _todayRedingTitleLabel.text = @"今日骑行(km)";
        _todayRedingTitleLabel.textColor = [UIColor whiteColor];
        _todayRedingTitleLabel.textAlignment = NSTextAlignmentCenter;
        _todayRedingTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
        
    }
    return _todayRedingTitleLabel;
    
}

- (UILabel *)todayRedingLabel
{
    
    if (!_todayRedingLabel) {
        _todayRedingLabel = [[UILabel alloc]initWithFrame:CGRectMake750(174,953,161,38)];
        _todayRedingLabel.text = @"12";
        _todayRedingLabel.textColor = [UIColor whiteColor];
        _todayRedingLabel.textAlignment = NSTextAlignmentCenter;
        _todayRedingLabel.font = [UIFont systemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    return _todayRedingLabel;
    
}


- (UILabel *)firstLineLabel
{
    if (!_firstLineLabel) {
        _firstLineLabel = [[UILabel alloc]initWithFrame:CGRectMake750(378, 925,1, 60)];
        _firstLineLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _firstLineLabel;
}

- (UILabel *)todayGoalTitleLabel
{
    
    if (!_todayGoalTitleLabel) {
        _todayGoalTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(443, 890, 109, 28)];
        _todayGoalTitleLabel.text = @"目标(km)";
        _todayGoalTitleLabel.textColor = [UIColor whiteColor];
        _todayGoalTitleLabel.textAlignment = NSTextAlignmentCenter;
        _todayGoalTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
        
    }
    return _todayGoalTitleLabel;
    
}
- (UILabel *)todayGoalLabel
{
    
    if (!_todayGoalLabel) {
        _todayGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake750(451,953, 87,38)];
        _todayGoalLabel.text = @"10";
        _todayGoalLabel.textColor = [UIColor whiteColor];
        _todayGoalLabel.textAlignment = NSTextAlignmentCenter;
        _todayGoalLabel.font = [UIFont systemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    return _todayGoalLabel;
    
}



- (UILabel *)botomLabel
{
    if (!_botomLabel) {
        _botomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.bottom-50, 750, 50)];
        _botomLabel.backgroundColor = [UIColor blackColor];
                       
    }
    return _botomLabel;
    
    
    
    
}

@end
