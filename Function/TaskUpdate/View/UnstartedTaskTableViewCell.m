//
//  UnstartedTaskTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/11/1.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "UnstartedTaskTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface UnstartedTaskTableViewCell()


@property (nonatomic,strong)UIImageView *unstartedTaskBackgroundImageView;

@property (nonatomic,strong)UIImageView *taskTitleBackgroundImageView;

@property (nonatomic,strong)UIImageView *unstartedTaskBikeImageView;

@property (nonatomic,strong)UILabel *unstartTaskTitleLabel;

@property (nonatomic,strong)UILabel *unstartTaskBikeNameLabel;

@property (nonatomic,strong)UIImageView *unstartedTaskTimeImageView;

@property (nonatomic,strong)UILabel *unstartTaskDateLabel;

@property (nonatomic,strong)UILabel *unstartTaskStandardRewardTitleLabel;

@property (nonatomic,strong)UILabel *unstartTaskStandardRewardLabel;

@property (nonatomic,strong)UILabel *unstartTaskStandardManyTodaysTitleLabel;

@property (nonatomic,strong)UILabel *unstartTaskStandardManyTodaysLabel;

@property (nonatomic,strong)UILabel *unstartTaskStandardDaysRemainTitlelabel;

@property (nonatomic,strong)UILabel *unstartTaskStandardDaysRemainlabel;


@property (nonatomic,strong)UILabel *firstLinelabel;

@property (nonatomic,strong)UILabel *secondLinelabel;



@end





@implementation UnstartedTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self customUIView];
        self.alpha = 0;
        self.backgroundColor = [UIColor blackColor];
    }

    return self;
}



- (void)customUIView
{
    [self.contentView addSubview:self.unstartedTaskBackgroundImageView];
    [self.contentView addSubview:self.taskTitleBackgroundImageView];
    [self.contentView addSubview:self.unstartedTaskBikeImageView];
    [self.contentView addSubview:self.unstartTaskTitleLabel];
    [self.contentView addSubview:self.unstartTaskBikeNameLabel];
    
    [self.contentView addSubview:self.unstartedTaskTimeImageView];
    [self.contentView addSubview:self.unstartTaskDateLabel];
    [self.contentView addSubview:self.unstartTaskStandardRewardTitleLabel];
    [self.contentView addSubview:self.unstartTaskStandardRewardLabel];
    
    [self.contentView addSubview:self.unstartTaskStandardManyTodaysTitleLabel];
    [self.contentView addSubview:self.unstartTaskStandardManyTodaysLabel];
    [self.contentView addSubview:self.unstartTaskStandardDaysRemainTitlelabel];
    [self.contentView addSubview:self.unstartTaskStandardDaysRemainlabel];
    
    [self.contentView addSubview:self.firstLinelabel];
    [self.contentView addSubview:self.secondLinelabel];

    
}


- (void)setUnstartTaskModel:(UnstartTaskModel *)unstartTaskModel
{
    // 设置 未开始的任务 数据
    _unstartTaskTitleLabel.text = unstartTaskModel.taskName;
    [self setLabelForViewCenterFrame:_unstartTaskTitleLabel];
    [_unstartedTaskBikeImageView sd_setImageWithURL:[NSURL URLWithString:unstartTaskModel.image] placeholderImage:[UIImage imageNamed:@"bikePlacehodler"]];
    NSString *bikeName = [NSString stringWithFormat:@"%@ %@ %@",unstartTaskModel.brand,unstartTaskModel.series,unstartTaskModel.model];
    _unstartTaskBikeNameLabel.text = bikeName;
    
    //NSString *taskDurationStr = [NSString stringWithFormat:@"%@-%@",unstartTaskModel.userTaskStartTime,unstartTaskModel.userTaskFinishTime];
    NSString *startTimeStr = [unstartTaskModel.userTaskStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTimeStr = [unstartTaskModel.userTaskFinishTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    //    NSString *taskDatePeriodStr = [NSString stringWithFormat:@"(%@-%@)",startTimeStr,endTimeStr];
    NSString *taskDurationStr = [NSString stringWithFormat:@"%@-%@",startTimeStr,endTimeStr];
    //NSString *userTaskDurationStr = [NSString stringWithFormat:@"%@-%@",startTimeStr,endTimeStr];
    
    _unstartTaskDateLabel.text = taskDurationStr;
    
    _unstartTaskStandardRewardLabel.text = unstartTaskModel.totalPrizeMoney;
    
    _unstartTaskStandardManyTodaysLabel.text = unstartTaskModel.requiredStandardsDays;
    
    _unstartTaskStandardDaysRemainlabel.text = unstartTaskModel.startNumberDays;
    
    
    
}

- (void)setLabelForViewCenterFrame:(UILabel *)tmpLabel
{
    
    CGSize size = tmpLabel.size ;
    CGSize labelsize = [tmpLabel.text sizeWithFont:tmpLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    CGRect updateFrame = tmpLabel.frame;
    int x = 710 *SizeScale750 - labelsize.width - 20;
    updateFrame.origin.x = x/2;
    updateFrame.size.width = labelsize.width + 20 ;
    tmpLabel.frame = updateFrame;
    tmpLabel.layer.cornerRadius = 16.f *SizeScale750;
    tmpLabel.layer.borderColor = [[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1]CGColor];
    tmpLabel.layer.borderWidth = 1.f;
    
}



#pragma ------lazyload


- (UIImageView *)unstartedTaskBackgroundImageView
{
    if (!_unstartedTaskBackgroundImageView) {
     
        _unstartedTaskBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TaskUnstartCellBackgroundBlackBarImageViewSuper"]];
        _unstartedTaskBackgroundImageView.frame = CGRectMake750(0,0, 710, 508);
        _unstartedTaskBackgroundImageView.contentMode = UIViewContentModeScaleToFill;
        
        
    }
    return _unstartedTaskBackgroundImageView;
    
}

//- (UIImageView *)taskTitleBackgroundImageView
//{
//    if (!_taskTitleBackgroundImageView) {
//        _taskTitleBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taskNameBackgroundView"]];
//        _taskTitleBackgroundImageView.frame = CGRectMake750(100,40,506,60);
//        
//        
//    }
//    return _taskTitleBackgroundImageView;
//    
//}


- (UIImageView *)unstartedTaskBikeImageView
{
    if (!_unstartedTaskBikeImageView) {
        
        _unstartedTaskBikeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bikePlacehodler"]];
        _unstartedTaskBikeImageView.frame = CGRectMake750(0,129,140,140);
        [_unstartedTaskBikeImageView setRoundedCorners:UIRectCornerAllCorners radius:(140/2*SizeScaleSubjectTo750)];
        
        
        
    }
    return _unstartedTaskBikeImageView;
    
    
    
    
}

- (UIImageView *)unstartedTaskTimeImageView
{
    if (!_unstartedTaskTimeImageView) {
        
        _unstartedTaskTimeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Clock"]];
        _unstartedTaskTimeImageView.frame = CGRectMake750(180,213, 24,24);
        
        
    }
    return _unstartedTaskTimeImageView;
    
    
    
    
}



- (UILabel *)unstartTaskTitleLabel
{
    if (!_unstartTaskTitleLabel) {
        _unstartTaskTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,74,710,60)];
        _unstartTaskTitleLabel.text = @"秋季爱骑行运动耐力挑战赛";
        _unstartTaskTitleLabel.font = [UIFont systemFontOfSize:33*SizeScaleSubjectTo750];
        _unstartTaskTitleLabel.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1];
        //_taskTitleLabel.backgroundColor = [UIColor redColor];
        _unstartTaskTitleLabel.textColor = [UIColor whiteColor];
        _unstartTaskTitleLabel.layer.masksToBounds = YES;
        _unstartTaskTitleLabel.textAlignment = NSTextAlignmentCenter;
        
   
        
    }
    
    return _unstartTaskTitleLabel;
    
}


- (UILabel *)unstartTaskBikeNameLabel
{
    if (!_unstartTaskBikeNameLabel) {
        _unstartTaskBikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake750(180, 171, 430,38)];
        
        _unstartTaskBikeNameLabel.textAlignment = NSTextAlignmentLeft;
        _unstartTaskBikeNameLabel.text = @"tern-bike";
        _unstartTaskBikeNameLabel.font = [UIFont systemFontOfSize:34*SizeScaleSubjectTo750];
        _unstartTaskBikeNameLabel.textColor = [UIColor whiteColor];
        
    }
    
    return _unstartTaskBikeNameLabel;
    
}

- (UILabel *)unstartTaskDateLabel
{
    if (!_unstartTaskDateLabel) {
        _unstartTaskDateLabel = [[UILabel alloc]initWithFrame:CGRectMake750(210, 216, 300, 24)];
        _unstartTaskDateLabel.textAlignment = NSTextAlignmentLeft;
        _unstartTaskDateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _unstartTaskDateLabel.text = @"2016.10.31-2017.10.31";
        _unstartTaskDateLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
        //_unstartTaskDateLabel.backgroundColor = [UIColor blackColor];
        
    }
    
    return _unstartTaskDateLabel;
    
}






- (UILabel *)unstartTaskStandardRewardTitleLabel
{
    if (!_unstartTaskStandardRewardTitleLabel) {
        
        _unstartTaskStandardRewardTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,368,232,25)];
        _unstartTaskStandardRewardTitleLabel.text = @"总奖金(元)";
        _unstartTaskStandardRewardTitleLabel.textColor = [UIColor blackColor];
        _unstartTaskStandardRewardTitleLabel.textAlignment = NSTextAlignmentCenter;
        _unstartTaskStandardRewardTitleLabel.font = [UIFont systemFontOfSize:24*SizeScaleSubjectTo750];
    }
    
    return _unstartTaskStandardRewardTitleLabel;
    
    
}

- (UILabel *)unstartTaskStandardRewardLabel
{
    if (!_unstartTaskStandardRewardLabel) {
        
        _unstartTaskStandardRewardLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,432,232,38)];
        _unstartTaskStandardRewardLabel.text = @"9000";
        _unstartTaskStandardRewardLabel.textColor = [UIColor blackColor];
        _unstartTaskStandardRewardLabel.textAlignment = NSTextAlignmentCenter;
        _unstartTaskStandardRewardLabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    
    return _unstartTaskStandardRewardLabel;
    
    
}


- (UILabel *)firstLinelabel
{
    if (!_firstLinelabel) {
        _firstLinelabel = [[UILabel alloc]initWithFrame:CGRectMake750(232,405,2,60)];
        _firstLinelabel.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _firstLinelabel;
    
}


- (UILabel *)unstartTaskStandardManyTodaysTitleLabel
{
    if (!_unstartTaskStandardManyTodaysTitleLabel) {
        
        _unstartTaskStandardManyTodaysTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(234,368,232,33)];
        _unstartTaskStandardManyTodaysTitleLabel.text = @"需达标天数";
        _unstartTaskStandardManyTodaysTitleLabel.textColor = [UIColor blackColor];
        _unstartTaskStandardManyTodaysTitleLabel.textAlignment = NSTextAlignmentCenter;
        _unstartTaskStandardManyTodaysTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    
    return _unstartTaskStandardManyTodaysTitleLabel;
    
    
}

- (UILabel *)unstartTaskStandardManyTodaysLabel
{
    if (!_unstartTaskStandardManyTodaysLabel) {
        
        _unstartTaskStandardManyTodaysLabel = [[UILabel alloc]initWithFrame:CGRectMake750(234,432,232,38)];
        _unstartTaskStandardManyTodaysLabel.text = @"20";
        _unstartTaskStandardManyTodaysLabel.textColor = [UIColor blackColor];
        _unstartTaskStandardManyTodaysLabel.textAlignment = NSTextAlignmentCenter;
        _unstartTaskStandardManyTodaysLabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    
    return _unstartTaskStandardManyTodaysLabel;
    
    
}
- (UILabel *)secondLinelabel
{
    if (!_secondLinelabel) {
        _secondLinelabel = [[UILabel alloc]initWithFrame:CGRectMake750(474,405,2,60)];
        _secondLinelabel.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _secondLinelabel;
    
}


- (UILabel *)unstartTaskStandardDaysRemainTitlelabel
{
    if (!_unstartTaskStandardDaysRemainTitlelabel) {
        
        _unstartTaskStandardDaysRemainTitlelabel = [[UILabel alloc]initWithFrame:CGRectMake750(234 *2,368,232,33)];
        _unstartTaskStandardDaysRemainTitlelabel.text = @"距挑战开始天数";
        _unstartTaskStandardDaysRemainTitlelabel.textColor = [UIColor blackColor];
        _unstartTaskStandardDaysRemainTitlelabel.textAlignment = NSTextAlignmentCenter;
        _unstartTaskStandardDaysRemainTitlelabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    
    return _unstartTaskStandardDaysRemainTitlelabel;
    
    
}

- (UILabel *)unstartTaskStandardDaysRemainlabel
{
    if (!_unstartTaskStandardDaysRemainlabel) {
        
        _unstartTaskStandardDaysRemainlabel = [[UILabel alloc]initWithFrame:CGRectMake750(234 *2,432,232,38)];
        _unstartTaskStandardDaysRemainlabel.text = @"2";
        _unstartTaskStandardDaysRemainlabel.textColor = [UIColor blackColor];
        _unstartTaskStandardDaysRemainlabel.textAlignment = NSTextAlignmentCenter;
        _unstartTaskStandardDaysRemainlabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    
    return _unstartTaskStandardDaysRemainlabel;
    
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
