//
//  OngoingTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/10/31.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "OngoingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Tools.h"
@interface OngoingTableViewCell()

// 背景图片
@property (nonatomic,strong)UIImageView *taskBackgroundImageView;

@property (nonatomic,strong)UIImageView *taskTitleBackgroundImageView;

@property (nonatomic,strong)UILabel *taskTitleLabel;

@property (nonatomic,strong)UIImageView *bikeImageView;

@property (nonatomic,strong)UILabel *bikeNameLabel;

@property (nonatomic,strong)UIImageView *timeImageView;

@property (nonatomic,strong)UILabel *taskDateLabel;

@property (nonatomic,strong)UIView *taskDetailBackgroundView;

@property (nonatomic,strong)UILabel *taskMoneylabel;

@property (nonatomic,strong)UILabel *taskTodayRedingTitleLabel;

@property (nonatomic,strong)UILabel *taskTodayRedingLabel;

@property (nonatomic,strong)UILabel *taskTodayRedingGoalTitleLabel;

@property (nonatomic,strong)UILabel *taskTodayRedingGoalLabel;

@property (nonatomic,strong)UILabel *taskDaysRemainTitlelabel;

@property (nonatomic,strong)UILabel *taskDaysRemainlabel;

@property (nonatomic,strong)UILabel *taskProgressGraylabel;

@property (nonatomic,strong)UILabel *taskProgressRedlabel;

@property (nonatomic,strong)UIImageView *taskProgressFloatPointImageView;

@property (nonatomic,strong)UILabel *taskProgressFloatLabel;

@property (nonatomic,strong)UILabel *firstLinelabel;

@property (nonatomic,strong)UILabel *secondLinelabel;

@property (nonatomic,strong)UILabel *taskMoneyTitlelabel;










@end

@implementation OngoingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"OngoingTableViewCell  into here ...");
    // Initialization code
    
    
    
    
    
    
    
}
//
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self customUIView];
        self.alpha = 0;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
    
}

- (void)customUIView
{
    
    [self.contentView addSubview:self.taskBackgroundImageView];
    [self.contentView addSubview:self.taskTitleBackgroundImageView];
    [self.contentView addSubview:self.taskTitleLabel];
    [self.contentView addSubview:self.bikeImageView];
    [self.contentView addSubview:self.bikeNameLabel];
    [self.contentView addSubview:self.timeImageView];
    [self.contentView addSubview:self.taskDateLabel];
    [self.contentView addSubview:self.taskMoneylabel];
    [self.contentView addSubview:self.taskMoneyTitlelabel];
    [self.contentView addSubview:self.taskTodayRedingTitleLabel];
    [self.contentView addSubview:self.taskTodayRedingLabel];
    [self.contentView addSubview:self.firstLinelabel];
    [self.contentView addSubview:self.taskTodayRedingGoalTitleLabel];
    [self.contentView addSubview:self.taskTodayRedingGoalLabel];
    [self.contentView addSubview:self.secondLinelabel];
    
    [self.contentView addSubview:self.taskDaysRemainTitlelabel];
    [self.contentView addSubview:self.taskDaysRemainlabel];
    [self.contentView addSubview:self.taskProgressGraylabel];
    [self.contentView addSubview:self.taskProgressRedlabel];
    [self.contentView addSubview:self.taskProgressFloatPointImageView];
    [self.contentView addSubview:self.taskProgressFloatLabel];
    
}

-(void)setOngoingTaskModel:(OngoingTaskModel *)ongoingTaskModel
{
    // 设置 正在进行时的任务页面  数据
    if (ongoingTaskModel.distancePerDay.integerValue <=  ongoingTaskModel.daySumDistance.integerValue) {
        _taskBackgroundImageView.image = [UIImage imageNamed:@"TaskOngoingCellRedBackgroundSuper"];
    }else
    {
         _taskBackgroundImageView.image = [UIImage imageNamed:@"TaskOngoingCellGrayBackgroundSuper"];
    }
    // 标题
    _taskTitleLabel.text = ongoingTaskModel.taskName;
    //标题 剧中 设置
    [self setLabelForViewCenterFrame:_taskTitleLabel];
    
    [_bikeImageView sd_setImageWithURL:[NSURL URLWithString:ongoingTaskModel.image] placeholderImage:[UIImage imageNamed:@"bikePlacehodler"]];
    NSString *bikeNameStr = [NSString stringWithFormat:@"%@ %@ %@",ongoingTaskModel.brand,ongoingTaskModel.series,ongoingTaskModel.model];
    _bikeNameLabel.text = bikeNameStr;
    
    
    NSString *startTimeStr = [ongoingTaskModel.userTaskStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTimeStr = [ongoingTaskModel.userTaskFinishTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//    NSString *taskDatePeriodStr = [NSString stringWithFormat:@"(%@-%@)",startTimeStr,endTimeStr];
    NSString *taskDurationStr = [NSString stringWithFormat:@"%@-%@",startTimeStr,endTimeStr];
    _taskDateLabel.text = taskDurationStr;
    
    
    NSString *customMoneyFormat =  [NSString stringWithFormat:@"¥%@",ongoingTaskModel.nowDayMoney];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:customMoneyFormat];
    
    [attributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:66.0 *SizeScale750]
     
                          range:NSMakeRange(0,1)];
    
//    NSDictionary * attris = @{NSKernAttributeName:@(4.0 * SizeScale)
//                              };
//    
//    [attributedStr setAttributes:attris range:NSMakeRange(0,attributedStr.length - 1)];
   
    _taskMoneylabel.attributedText = attributedStr;
    
    NSString *todayRedingStr = [NSString stringWithFormat:@"%.2f",(float)ongoingTaskModel.daySumDistance.integerValue /1000];
    if ([todayRedingStr isEqualToString:@"0.00"]) {
        todayRedingStr = @"0";
    }
    _taskTodayRedingLabel.text = todayRedingStr;
    _taskTodayRedingGoalLabel.text = [NSString stringWithFormat:@"%ld",(long)ongoingTaskModel.distancePerDay.integerValue/1000];
    
    
    _taskDaysRemainlabel.text = ongoingTaskModel.endNumberDays;
    
    _taskProgressGraylabel.backgroundColor = [UIColor grayColor];
    
    float progressData = 0.0;
    if (ongoingTaskModel.daySumDistance.floatValue >= ongoingTaskModel.distancePerDay.floatValue){
        progressData = 1.0;
    }else
    {
       progressData = ongoingTaskModel.daySumDistance.floatValue /ongoingTaskModel.distancePerDay.floatValue;
    }
    
   // NSLog(@"progressData %f",progressData);
    [self setTaskProgross:progressData];
    
    
}



- (void)setTaskProgross:(float)progress
{
    NSString *floatStr = nil ;//[NSString stringWithFormat:@"%.2f％",progress*100];
    if (progress == 0) {
        floatStr = @"0％";
    }else
    {
        floatStr = [NSString stringWithFormat:@"%d％",(int)(progress*100)];
    }
    
    if(isnan(progress)){
        progress = 0;
        floatStr = @"0％";
    }
    if (isinf(progress)) {
        progress = 0;
        floatStr = @"0％";
    }
    
   // NSLog(@"progressData  floatStr %@",floatStr);
    CGFloat customWidth = progress *670 *SizeScale750;
    
    //NSLog(@"progressData  floatStr customWidth %f",customWidth);
    
    CGRect updateFrameRed = _taskProgressRedlabel.frame;
    updateFrameRed.size.width = customWidth;
    _taskProgressRedlabel.frame = updateFrameRed;
    
   
    
    CGRect updateFrameFloatPointImage = _taskProgressFloatPointImageView.frame;
    
    //NSLog(@"progressData  floatStr _taskProgressFloatLabel.origin.x %f",_taskProgressFloatLabel.origin.x);
    updateFrameFloatPointImage.origin.x = customWidth +_taskProgressRedlabel.origin.x;
    //NSLog(@"progressData  floatStr  updateFrameFloatPointImage.origin.x %f",updateFrameFloatPointImage.origin.x);
    
  
    CGRect updateFrameFloat = _taskProgressFloatLabel.frame;
    updateFrameFloat.origin.x = customWidth +_taskProgressRedlabel.origin.x;
    _taskProgressFloatLabel.text = floatStr;
    
    if (updateFrameFloat.origin.x > 650 *SizeScale750) {
        updateFrameFloat.origin.x = 630*SizeScale750;
    }
    _taskProgressFloatLabel.frame = updateFrameFloat;
    
    _taskProgressFloatPointImageView.frame = updateFrameFloatPointImage;
      
}




- (void)setLabelForViewCenterFrame:(UILabel *)tmpLabel
{
    
    CGSize size = tmpLabel.size ;
    CGSize labelsize = [tmpLabel.text sizeWithFont:tmpLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    CGRect updateFrame = tmpLabel.frame;
    int x = 710 *SizeScale750 - labelsize.width -20;
    updateFrame.origin.x = x/2;
    updateFrame.size.width = labelsize.width + 20 ;
    tmpLabel.frame = updateFrame;
    tmpLabel.layer.cornerRadius = 16.f *SizeScale750;
    tmpLabel.layer.borderColor = [[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1]CGColor];
    tmpLabel.layer.borderWidth = 1.f;
    
}


#pragma lazyload



- (UIImageView *)taskBackgroundImageView
{
    if (!_taskBackgroundImageView) {
        _taskBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TaskOngoingCellRedBackgroundSuper"]];
        _taskBackgroundImageView.frame = CGRectMake750(0, 0, 710, 807);
        
        
    }
    return _taskBackgroundImageView;
    
}


//- (UIImageView *)taskTitleBackgroundImageView
//{
//    if (!_taskTitleBackgroundImageView) {
//        _taskTitleBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taskNameBackgroundView"]];
//        _taskTitleBackgroundImageView.frame = CGRectMake750(150,20,406,60);
//        
//        
//    }
//    return _taskTitleBackgroundImageView;
//    
//}

- (UILabel *)taskTitleLabel
{
    if (!_taskTitleLabel) {
        _taskTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,74,710,60)];
        _taskTitleLabel.text = @"秋季爱骑行运动耐力挑战赛";
        _taskTitleLabel.font = [UIFont systemFontOfSize:33*SizeScaleSubjectTo750];
        //_taskTitleLabel.backgroundColor = [UIColor redColor];
         _taskTitleLabel.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1];
        _taskTitleLabel.textColor = [UIColor whiteColor];
        _taskTitleLabel.layer.masksToBounds = YES;
        _taskTitleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _taskTitleLabel;

}




- (UIImageView *)bikeImageView
{
    
    if (!_bikeImageView) {
        _bikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0, 129,140, 140)];
        [_bikeImageView setRoundedCorners:UIRectCornerAllCorners radius:(140/2*SizeScaleSubjectTo750)];
        _bikeImageView.image = [UIImage imageNamed:@"bikePlacehodler"];
        }
    return _bikeImageView;

}

- (UILabel *)bikeNameLabel
{
    if (!_bikeNameLabel) {
        _bikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake750(180, 171, 430,38)];
        _bikeNameLabel.textAlignment = NSTextAlignmentLeft;
        _bikeNameLabel.text = @"tern-bike";
        _bikeNameLabel.font = [UIFont systemFontOfSize:34*SizeScaleSubjectTo750];
        _bikeNameLabel.textColor = [UIColor whiteColor];
        
        
    }
    
    return _bikeNameLabel;
    
}


- (UIImageView *)timeImageView
{
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(180, 213, 24, 24)];
        _timeImageView.image = [UIImage imageNamed:@"Clock"];
        
    }
    
    return _timeImageView;
}


- (UILabel *)taskDateLabel
{
    if (!_taskDateLabel) {
        _taskDateLabel = [[UILabel alloc]initWithFrame:CGRectMake750(210,216,300, 24)];
        _taskDateLabel.textAlignment = NSTextAlignmentLeft;
        _taskDateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _taskDateLabel.text = @"2016.10.31-2017.10.31";
        _taskDateLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
        
    }
    
    return _taskDateLabel;
}


- (UILabel *)taskMoneyTitlelabel
{
    if (!_taskMoneyTitlelabel) {
        _taskMoneyTitlelabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,347, 710, 30)];
        _taskMoneyTitlelabel.text = @"今日奖金(元)";
        _taskMoneyTitlelabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
        _taskMoneyTitlelabel.textAlignment = NSTextAlignmentCenter;
        _taskMoneyTitlelabel.textColor = [UIColor blackColor];
        
        
        //_taskMoneylabel.alpha = ;
        //_taskMoneylabel.attributedText = attributedStr;
        
    }
    return _taskMoneyTitlelabel;
    
    
    
}

- (UILabel *)taskMoneylabel
{
    if (!_taskMoneylabel) {
        _taskMoneylabel = [[UILabel alloc]initWithFrame:CGRectMake750(0, 416, 670, 102)];
        _taskMoneylabel.text = @"¥100";
        _taskMoneylabel.font = [UIFont systemFontOfSize:136*SizeScaleSubjectTo750];
        _taskMoneylabel.textAlignment = NSTextAlignmentCenter;
        _taskMoneylabel.textColor = [UIColor redColor];
        
       
        //_taskMoneylabel.alpha = ;
        //_taskMoneylabel.attributedText = attributedStr;
        
    }
    return _taskMoneylabel;

}


- (void)testMethod
{
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 30)];
    
    testLabel.backgroundColor = [UIColor lightGrayColor];
    
    testLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"今天天气不错呀"];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16.0]
     
                          range:NSMakeRange(2, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(2, 2)];
    
    testLabel.attributedText = AttributedStr;
    
}

//今日骑行  标题
- (UILabel *)taskTodayRedingTitleLabel
{
    if (!_taskTodayRedingTitleLabel) {
        _taskTodayRedingTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0, 576, 234, 33)];
        _taskTodayRedingTitleLabel.text = @"今日骑行(km)";
        _taskTodayRedingTitleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _taskTodayRedingTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskTodayRedingTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    return _taskTodayRedingTitleLabel;
    
    
}

//今日骑行  数据
- (UILabel *)taskTodayRedingLabel
{
    if (!_taskTodayRedingLabel) {
        _taskTodayRedingLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,616,230, 90)];
        _taskTodayRedingLabel.text = @"90";
        _taskTodayRedingLabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        _taskTodayRedingLabel.textColor = [UIColor blackColor];
        _taskTodayRedingLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _taskTodayRedingLabel;
    
    
    
    
}

- (UILabel *)firstLinelabel
{
    if (!_firstLinelabel) {
        _firstLinelabel  = [[UILabel alloc]initWithFrame:CGRectMake750(232,620, 2, 60)];
        _firstLinelabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _firstLinelabel;
 
}


//每日目标  标题
- (UILabel *)taskTodayRedingGoalTitleLabel
{
    if (!_taskTodayRedingGoalTitleLabel) {
        _taskTodayRedingGoalTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(236,576,234, 33)];
        _taskTodayRedingGoalTitleLabel.text = @"每日目标(km)";
        _taskTodayRedingGoalTitleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _taskTodayRedingGoalTitleLabel.textAlignment = NSTextAlignmentCenter;
        _taskTodayRedingGoalTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    return _taskTodayRedingGoalTitleLabel;
    
    
}

//每日目标  数据
- (UILabel *)taskTodayRedingGoalLabel
{
    if (!_taskTodayRedingGoalLabel) {
        _taskTodayRedingGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake750(233+2, 616, 232, 90)];
        _taskTodayRedingGoalLabel.text = @"100";
         _taskTodayRedingGoalLabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        _taskTodayRedingGoalLabel.textColor = [UIColor blackColor];
        _taskTodayRedingGoalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _taskTodayRedingGoalLabel;
    
    
    
    
}

- (UILabel *)secondLinelabel
{
    if (!_secondLinelabel) {
        _secondLinelabel  = [[UILabel alloc]initWithFrame:CGRectMake750(234 *2,620 , 2, 60)];
        _secondLinelabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _secondLinelabel;
    
}



//具挑战结束天数  标题
- (UILabel *)taskDaysRemainTitlelabel
{
    if (!_taskDaysRemainTitlelabel) {
        _taskDaysRemainTitlelabel = [[UILabel alloc]initWithFrame:CGRectMake750(234*2, 576,234, 33)];
        _taskDaysRemainTitlelabel.text = @"距挑战结束天数";
        _taskDaysRemainTitlelabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _taskDaysRemainTitlelabel.textAlignment = NSTextAlignmentCenter;
        _taskDaysRemainTitlelabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    return _taskDaysRemainTitlelabel;
    
    
}

//具挑战结束天数  数据
- (UILabel *)taskDaysRemainlabel
{
    if (!_taskDaysRemainlabel) {
        _taskDaysRemainlabel = [[UILabel alloc]initWithFrame:CGRectMake750(234*2 + 4,606, 244, 90)];
        _taskDaysRemainlabel.text = @"30";
         _taskDaysRemainlabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        _taskDaysRemainlabel.textColor = [UIColor blackColor];
        _taskDaysRemainlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _taskDaysRemainlabel;
    
    
    
    
}

- (UILabel *)taskProgressGraylabel
{
    if (!_taskProgressGraylabel) {
        _taskProgressGraylabel = [[UILabel alloc]initWithFrame:CGRectMake750(20,566+130 +40 , 670, 6)];
        _taskProgressGraylabel.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:0.5];
    }
    return _taskProgressGraylabel;
    
    
    
    
}

- (UILabel *)taskProgressRedlabel
{
    if (!_taskProgressRedlabel) {
        _taskProgressRedlabel = [[UILabel alloc]initWithFrame:CGRectMake750(20,566+130 +40 ,380, 6)];
        _taskProgressRedlabel.backgroundColor = [UIColor redColor];
    }
    return _taskProgressRedlabel;
    
    
    
    
}


- (UIImageView *)taskProgressFloatPointImageView
{
    if (!_taskProgressFloatPointImageView) {
        _taskProgressFloatPointImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TaskHomeOngoingRedPoint"]];
        _taskProgressFloatPointImageView.frame = CGRectMake750(20,566+125 +40 ,16,16);

    }
    return _taskProgressFloatPointImageView;
    
    
    
}

- (UILabel *)taskProgressFloatLabel
{
    
    if (!_taskProgressFloatLabel) {
        _taskProgressFloatLabel = [[UILabel alloc]initWithFrame:CGRectMake750(20, 566 +130 +15 +40,90, 23)];
        _taskProgressFloatLabel.text = @"100%";
        _taskProgressFloatLabel.font = [UIFont systemFontOfSize:30*SizeScale750];
        
    }
    
    return _taskProgressFloatLabel;
}


//[self addSubview:self.taskProgrossGraylabel];
//[self addSubview:self.taskProgrossRedlabel];





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
