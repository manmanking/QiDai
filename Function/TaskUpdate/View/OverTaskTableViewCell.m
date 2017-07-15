//
//  OverTaskTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/11/2.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "OverTaskTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface OverTaskTableViewCell()


@property (nonatomic,strong)UIImageView *overTaskBackgroundImageView;

@property (nonatomic,strong)UIImageView *taskTitleBackgroundImageView;

@property (nonatomic,strong)UIImageView *overTaskBikeImageView;

@property (nonatomic,strong)UILabel *overTaskTitleLabel;

@property (nonatomic,strong)UILabel *overTaskBikeNameLabel;

@property (nonatomic,strong)UIImageView *overTaskTimeImageView;

@property (nonatomic,strong)UILabel *overTaskDateLabel;

@property (nonatomic,strong)UILabel *overTaskStandardRewardTitleLabel;

@property (nonatomic,strong)UILabel *overTaskStandardRewardLabel;

@property (nonatomic,strong)UILabel *overTaskStandardManyTodaysTitleLabel;

@property (nonatomic,strong)UILabel *overTaskStandardManyTodaysLabel;

@property (nonatomic,strong)UILabel *overTaskStandardDaysRemainTitlelabel;

@property (nonatomic,strong)UILabel *overTaskStandardDaysRemainlabel;


@property (nonatomic,strong)UILabel *firstLinelabel;

@property (nonatomic,strong)UILabel *secondLinelabel;




@end




@implementation OverTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customUIView];
    }
    
    
    return self;
    
}




- (void)customUIView
{
    [self.contentView addSubview:self.overTaskBackgroundImageView];
    [self.contentView addSubview:self.taskTitleBackgroundImageView];
    [self.contentView addSubview:self.overTaskBikeImageView];
    [self.contentView addSubview:self.overTaskTitleLabel];
    [self.contentView addSubview:self.overTaskBikeNameLabel];
    
    [self.contentView addSubview:self.overTaskTimeImageView];
    [self.contentView addSubview:self.overTaskDateLabel];
    [self.contentView addSubview:self.overTaskStandardRewardTitleLabel];
    [self.contentView addSubview:self.overTaskStandardRewardLabel];
    
    [self.contentView addSubview:self.overTaskStandardManyTodaysTitleLabel];
    [self.contentView addSubview:self.overTaskStandardManyTodaysLabel];
    [self.contentView addSubview:self.overTaskStandardDaysRemainTitlelabel];
    [self.contentView addSubview:self.overTaskStandardDaysRemainlabel];
    
    [self.contentView addSubview:self.firstLinelabel];
    [self.contentView addSubview:self.secondLinelabel];
    
    
}




- (void)setOverTaskModel:(OverTaskModel *)overTaskModel
{
    
    // 设置 已经结束的任务的  数据 
    _overTaskTitleLabel.text = overTaskModel.taskName;
    [self setLabelForViewCenterFrame:_overTaskTitleLabel];
    [_overTaskBikeImageView sd_setImageWithURL:[NSURL URLWithString:overTaskModel.image] placeholderImage:[UIImage imageNamed:@"bikePlacehodler"]];
    NSString *bikeNameStr = [NSString stringWithFormat:@"%@ %@ %@",overTaskModel.brand,overTaskModel.series,overTaskModel.model];
    _overTaskBikeNameLabel.text = bikeNameStr;
    
    //2016-10-10   2016.10.10   2016.10.10-2016.11.11
    NSString *startTimeStr = [overTaskModel.userTaskStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTimeStr = [overTaskModel.userTaskFinishTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    //    NSString *taskDatePeriodStr = [NSString stringWithFormat:@"(%@-%@)",startTimeStr,endTimeStr];
    //NSString *taskDurationStr = [NSString stringWithFormat:@"%@-%@",startTimeStr,endTimeStr];
    NSString *userTaskDurationStr = [NSString stringWithFormat:@"%@-%@",startTimeStr,endTimeStr];
    _overTaskDateLabel.text = userTaskDurationStr;
    if ([overTaskModel.complete isEqualToString:@"1"]) {
        _overTaskBackgroundImageView.image = [UIImage imageNamed:@"TaskOverSuccessCellBackgroundBlackBarImageViewSuper"];
    }else
    {
       _overTaskBackgroundImageView.image = [UIImage imageNamed:@"TaskOverFailureCellBackgroundBlackBarImageViewSuper"];
    }
    _overTaskStandardRewardLabel.text = overTaskModel.totalPrizeMoney;
    _overTaskStandardManyTodaysLabel.text = overTaskModel.totalDuration;
    _overTaskStandardDaysRemainlabel.text = overTaskModel.sumStandardDays;
    

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



- (UIImageView *)overTaskBackgroundImageView
{
    if (!_overTaskBackgroundImageView) {
        
        _overTaskBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TaskOverFailureCellBackgroundBlackBarImageViewSuper"]];
        _overTaskBackgroundImageView.frame = CGRectMake750(0,0, 710, 508);
        _overTaskBackgroundImageView.contentMode = UIViewContentModeScaleToFill;
        
        
    }
    return _overTaskBackgroundImageView;
    
}

//- (UIImageView *)taskTitleBackgroundImageView
//{
//    if (!_taskTitleBackgroundImageView) {
//        _taskTitleBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taskNameBackgroundView"]];
//        _taskTitleBackgroundImageView.frame = CGRectMake750(122,40,456,60);
//        
//        
//    }
//    return _taskTitleBackgroundImageView;
//    
//}

- (UIImageView *)overTaskBikeImageView
{
    if (!_overTaskBikeImageView) {
        
        _overTaskBikeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bikePlacehodler"]];
        _overTaskBikeImageView.frame = CGRectMake750(0,129,140,140);
        [_overTaskBikeImageView setRoundedCorners:UIRectCornerAllCorners radius:(140/2*SizeScaleSubjectTo750)];
        
        
        
    }
    return _overTaskBikeImageView;
    
    
    
    
}

- (UIImageView *)overTaskTimeImageView
{
    if (!_overTaskTimeImageView) {
        
        _overTaskTimeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Clock"]];
        _overTaskTimeImageView.frame = CGRectMake750(180,213, 24,24);
        
        
    }
    return _overTaskTimeImageView;
    
}



- (UILabel *)overTaskTitleLabel
{
    if (!_overTaskTitleLabel) {
        _overTaskTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,74,710,60)];
        _overTaskTitleLabel.text = @"秋季爱骑行运动耐力挑战赛";
        _overTaskTitleLabel.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1];
        _overTaskTitleLabel.font = [UIFont systemFontOfSize:34*SizeScaleSubjectTo750];
        //_taskTitleLabel.backgroundColor = [UIColor redColor];
        _overTaskTitleLabel.textColor = [UIColor whiteColor];
        _overTaskTitleLabel.layer.masksToBounds = YES;
        _overTaskTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
    }
    
    return _overTaskTitleLabel;
    
}


- (UILabel *)overTaskBikeNameLabel
{
    if (!_overTaskBikeNameLabel) {
        _overTaskBikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake750(180, 171, 430,38)];
        
        _overTaskBikeNameLabel.textAlignment = NSTextAlignmentLeft;
        _overTaskBikeNameLabel.text = @"tern-bike";
        _overTaskBikeNameLabel.font = [UIFont systemFontOfSize:34*SizeScaleSubjectTo750];
        _overTaskBikeNameLabel.textColor = [UIColor whiteColor];
        
    }
    
    return _overTaskBikeNameLabel;
    
}

- (UILabel *)overTaskDateLabel
{
    if (!_overTaskDateLabel) {
        _overTaskDateLabel = [[UILabel alloc]initWithFrame:CGRectMake750(210,216, 300, 24)];
        _overTaskDateLabel.textAlignment = NSTextAlignmentLeft;
        _overTaskDateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _overTaskDateLabel.text = @"2016.10.31-2017.10.31";
        _overTaskDateLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
        //_unstartTaskDateLabel.backgroundColor = [UIColor blackColor];
        
    }
    
    return _overTaskDateLabel;
    
}






- (UILabel *)overTaskStandardRewardTitleLabel
{
    if (!_overTaskStandardRewardTitleLabel) {
        
        _overTaskStandardRewardTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,368,232,33)];
        _overTaskStandardRewardTitleLabel.text = @"累计奖金(元)";
        _overTaskStandardRewardTitleLabel.textColor = [UIColor blackColor];
        _overTaskStandardRewardTitleLabel.textAlignment = NSTextAlignmentCenter;
        _overTaskStandardRewardTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    
    return _overTaskStandardRewardTitleLabel;
    
    
}

- (UILabel *)overTaskStandardRewardLabel
{
    if (!_overTaskStandardRewardLabel) {
        
        _overTaskStandardRewardLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,432,230,38)];
        _overTaskStandardRewardLabel.text = @"9000";
        _overTaskStandardRewardLabel.textColor = [UIColor blackColor];
        _overTaskStandardRewardLabel.textAlignment = NSTextAlignmentCenter;
        _overTaskStandardRewardLabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    
    return _overTaskStandardRewardLabel;
    
    
}


- (UILabel *)firstLinelabel
{
    if (!_firstLinelabel) {
        _firstLinelabel = [[UILabel alloc]initWithFrame:CGRectMake750(231,405,2,60)];
        _firstLinelabel.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _firstLinelabel;
    
}


- (UILabel *)overTaskStandardManyTodaysTitleLabel
{
    if (!_overTaskStandardManyTodaysTitleLabel) {
        
        _overTaskStandardManyTodaysTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(234,368,232,33)];
        _overTaskStandardManyTodaysTitleLabel.text = @"总里程(km)";
        _overTaskStandardManyTodaysTitleLabel.textColor = [UIColor blackColor];
        _overTaskStandardManyTodaysTitleLabel.textAlignment = NSTextAlignmentCenter;
        _overTaskStandardManyTodaysTitleLabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    
    return _overTaskStandardManyTodaysTitleLabel;
    
    
}

- (UILabel *)overTaskStandardManyTodaysLabel
{
    if (!_overTaskStandardManyTodaysLabel) {
        
        _overTaskStandardManyTodaysLabel = [[UILabel alloc]initWithFrame:CGRectMake750(234,432,232,38)];
        _overTaskStandardManyTodaysLabel.text = @"20";
        _overTaskStandardManyTodaysLabel.textColor = [UIColor blackColor];
        _overTaskStandardManyTodaysLabel.textAlignment = NSTextAlignmentCenter;
        _overTaskStandardManyTodaysLabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    
    return _overTaskStandardManyTodaysLabel;
    
    
}
- (UILabel *)secondLinelabel
{
    if (!_secondLinelabel) {
        _secondLinelabel = [[UILabel alloc]initWithFrame:CGRectMake750(474,405,2,60)];
        _secondLinelabel.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _secondLinelabel;
    
}


- (UILabel *)overTaskStandardDaysRemainTitlelabel
{
    if (!_overTaskStandardDaysRemainTitlelabel) {
        
        _overTaskStandardDaysRemainTitlelabel = [[UILabel alloc]initWithFrame:CGRectMake750(234 *2,368,232,33)];
        _overTaskStandardDaysRemainTitlelabel.text = @"总达标天数";
        _overTaskStandardDaysRemainTitlelabel.textColor = [UIColor blackColor];
        _overTaskStandardDaysRemainTitlelabel.textAlignment = NSTextAlignmentCenter;
        _overTaskStandardDaysRemainTitlelabel.font = [UIFont systemFontOfSize:26*SizeScaleSubjectTo750];
    }
    
    return _overTaskStandardDaysRemainTitlelabel;
    
    
}

- (UILabel *)overTaskStandardDaysRemainlabel
{
    if (!_overTaskStandardDaysRemainlabel) {
        
        _overTaskStandardDaysRemainlabel = [[UILabel alloc]initWithFrame:CGRectMake750(234 *2,432,232,38)];
        _overTaskStandardDaysRemainlabel.text = @"2";
        _overTaskStandardDaysRemainlabel.textColor = [UIColor blackColor];
        _overTaskStandardDaysRemainlabel.textAlignment = NSTextAlignmentCenter;
        _overTaskStandardDaysRemainlabel.font = [UIFont boldSystemFontOfSize:50*SizeScaleSubjectTo750];
        
    }
    
    return _overTaskStandardDaysRemainlabel;
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
