//
//  ShopUpdateGoodsDetailActivityTableViewCell.m
//  QiDai
//
//  Created by manman'swork on 16/11/29.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "ShopUpdateGoodsDetailActivityTableViewCell.h"

@interface ShopUpdateGoodsDetailActivityTableViewCell()

@property (nonatomic,strong) UIImageView *backgroundImageView;

@property (nonatomic,strong) UIButton *selectedButton;

@property (nonatomic,strong) UIImageView *selectedFlagImageView;

@property (nonatomic,strong) UIButton *activityDetailButton;

@property (nonatomic,strong) UIImageView *intoFlagImageView;

@property (nonatomic,strong) UILabel *rewardTitleLable;

@property (nonatomic,strong) UILabel *rewardLable;

@property (nonatomic,strong) UILabel *activityTitleLabel;

@property (nonatomic,strong) UIImageView *personFalgImageView;

@property (nonatomic,strong) UILabel *joinActivityNumberLabel;

@property (nonatomic,strong) UIImageView *dateFalgImageView;

@property (nonatomic,strong) UILabel *dateActivityTimeLabel;


@property (nonatomic,strong) NSTimer *timekeeping;


@property (nonatomic,strong) NSString *dateIntervalStr;



@property (nonatomic,strong) UILabel *firstLine;







@end




@implementation ShopUpdateGoodsDetailActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dateIntervalStr = @"0";
        [self customUIViewAutolayout];
        
        [self registerNSNotificationCenter];
        
    }
    self.contentView.backgroundColor = [UIColor blackColor];
    return self;
 
}

- (void)customUIViewAutolayout
{
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView addSubview:self.selectedButton];
    [self.contentView addSubview:self.firstLine];
    [self.contentView addSubview:self.activityDetailButton];
    [self.contentView addSubview:self.activityTitleLabel];
    [self.contentView addSubview:self.rewardLable];
    [self.contentView addSubview:self.rewardTitleLable];
    [self.contentView addSubview:self.personFalgImageView];
    [self.contentView addSubview:self.dateFalgImageView];
    [self.contentView addSubview:self.joinActivityNumberLabel];
    [self.contentView addSubview:self.dateActivityTimeLabel];
     
}




/**
 *  设置  数据
 *
 *  @param activityModel 
 */

- (void)setActivityUpdateModel:(ActivityModel *)activityUpdateModel
{
    
    _activityUpdateModel = activityUpdateModel;
    
    self.rewardLable.text = [NSString stringWithFormat:@"¥%@",activityUpdateModel.refund];
    self.activityTitleLabel.text = activityUpdateModel.information;
    if (activityUpdateModel.count.integerValue >0) {
        self.joinActivityNumberLabel.text = [NSString stringWithFormat:@"%@人已报名",activityUpdateModel.count];
    }
    else
    {
        self.joinActivityNumberLabel.text = @"报名进行中";
    }
    //self.dateActivityTimeLabel.text = activityUpdateModel.endTime;
    [self activityCountdownDate:activityUpdateModel.endTime];
     
}



- (void)updateActivityCountdown
{
    
    self.dateActivityTimeLabel.text = self.dateIntervalStr;
    
    
    
}

- (void)compareTheDate:(NSDate *)endDate
{
    NSDate *currentDate = [NSDate date];
    
    
    
    
    
}





- (void)selectedButtonClick:(UIButton *)sender
{
    
    sender.selected = YES;
    NSLog(@"点击 选中  按钮 ...");
    
    /**
     *  参数 暂时传递 nil 被选中的那一行  传出去
     */
    NSDictionary *indexRow = [[NSDictionary alloc]initWithObjectsAndKeys:self.indexRow,@"indexRow",nil];
    
    self.activitySelectedAction(indexRow);
    
    
    
    
}

- (void)selectedActivityDetailButtonClick:(UIButton *)sender
{
    NSLog(@"查看  详细 信息");
    /**
     *  参数  将 activityId  传出去
     */
    
    NSDictionary *parameter = [[NSDictionary alloc]initWithObjectsAndKeys:self.activityUpdateModel.taskDetailId,@"taskDetailId", nil];
    self.activityDetailSelectedAction(parameter);
    
    
    
    
}



/**
 *
 *  选中的
 */
- (void)setSelectedIsSuccess:(BOOL)selectedIsSuccess
{
    /**
     *
     *  选中的标记操作
     *
     */
    
    if (selectedIsSuccess == YES) {
        _selectedButton.selected = YES;
        self.backgroundImageView.image = [UIImage imageNamed:@"ShopUpdateGoodsDetailActivityRedNewBackgroundImageView"];
    }else
    {
        _selectedButton.selected = NO;
        self.backgroundImageView.image = [UIImage imageNamed:@"ShopUpdateGoodsDetailActivityGreyNewBackgroundImageView"];
    }
   
    
    
    
    
}




#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_GOODSDETAIL_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GOODSDETAIL_TIME_CELL object:nil];
}


- (void)notificationCenterEvent:(id)sender {
    
    
    //NSLog(@" 更改 时间倒计时  ...  ");
    
    
//    if (self.m_isDisplayed) {
//        [self loadData:self.m_data indexPath:self.m_tmpIndexPath];
//    }
    [self activityCountdownDate:_activityUpdateModel.endTime];
    
    
}


- (void)activityCountdownDate:(NSString *)endTime
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *taskfinishDateMonthStr = [NSString stringWithFormat:@"%@ 00:00:00",endTime];
    NSDate *currentShowDate = [dateFormatter dateFromString:taskfinishDateMonthStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:currentShowDate];
    NSDate *localEndDate = [currentShowDate dateByAddingTimeInterval:interval];
    //NSLog(@"localDate :%@",localEndDate);
    
    NSTimeInterval secondsInterval =  [self compareSatrtDate:[NSDate date] andEndTime:localEndDate];
    
    //self.dateIntervalStr = [NSString stringWithFormat:@"%@",dateInterval];
 
    //[self.timekeeping fire];
    
     NSString *remainDateStr = [self lessSecondToDay:secondsInterval];
    self.dateActivityTimeLabel.text = [NSString stringWithFormat:@"距结束%@",remainDateStr];
    
    
    
}

- ( NSTimeInterval )compareSatrtDate:(NSDate *) startDate  andEndTime:(NSDate *) endDate
{
    
    
    
    NSTimeInterval startInterval =[startDate timeIntervalSince1970];
    
    NSTimeInterval endInterval =[endDate timeIntervalSince1970];
    
    NSTimeInterval secondsInterval =endInterval-startInterval;
    
   
    
    
    return secondsInterval;
    
}


- (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@"%02lu日%02lu:%02lu:%02lu",(unsigned long)day,(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
    
}



#pragma lazyload

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20,40,710,150)];
        _backgroundImageView.image = [UIImage imageNamed:@"ShopUpdateGoodsDetailActivityGreyNewBackgroundImageView"];
        
    }
    return _backgroundImageView;
    
}

- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc]initWithFrame:CGRectMake750(45,90,44,44)];
        [_selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedButton setImage:[UIImage imageNamed:@"ShopUpdateGoodsDetailActivityUnselectedImageView"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"ShopUpdateGoodsDetailActivitySelectedImageView"] forState:UIControlStateSelected];
        
        
    }
    return _selectedButton;
 
}

- (UIImageView *)selectedFlagImageView
{
    if (!_selectedFlagImageView) {
        _selectedFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(45,90,44,44)];
        _selectedFlagImageView.image = [UIImage imageNamed:@"ShopUpdateGoodsDetailActivityUnselectedImageView"];
    }
    return _selectedFlagImageView;
    
}



//activityDetailButton

- (UIButton *)activityDetailButton
{
    if (!_activityDetailButton) {
        _activityDetailButton = [[UIButton alloc]initWithFrame:CGRectMake750(680,100,17,34)];
        [_activityDetailButton addTarget:self action:@selector(selectedActivityDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_activityDetailButton setImage:[UIImage imageNamed:@"ShopUpdateGoodsDetailActivityIntoDetailImageView"] forState:UIControlStateNormal];
        
        
        
    }
    return _activityDetailButton;
    
}



- (UIImageView *)_intoFlagImageView
{
    if (!_intoFlagImageView) {
        _intoFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(690,100,17,34)];
        _intoFlagImageView.image = [UIImage imageNamed:@"ShopUpdateGoodsDetailActivityIntoDetailImageView"];
        
    }
    return _intoFlagImageView;
    
}


- (UILabel *)rewardLable
{
    if (!_rewardLable) {
        _rewardLable = [[UILabel alloc]initWithFrame:CGRectMake750(111,72, 107,28)];
        _rewardLable.text = @"¥8888";
        _rewardLable.textAlignment = NSTextAlignmentCenter;
        _rewardLable.font = [UIFont systemFontOfSize:22*SizeScale750];
        _rewardLable.textColor = [UIColor whiteColor];
        
    }
    
    return _rewardLable;
    
}


- (UILabel *)rewardTitleLable
{
    if (!_rewardTitleLable) {
        _rewardTitleLable = [[UILabel alloc]initWithFrame:CGRectMake750(126, 130,70, 22)];
        _rewardTitleLable.text = @"总奖金";
        _rewardTitleLable.textColor = [UIColor redColor];
        _rewardTitleLable.font = [UIFont systemFontOfSize:22 *SizeScale750];
        
    }
    
    return _rewardTitleLable;
    
}


- (UILabel *)activityTitleLabel
{
    if (!_activityTitleLabel) {
        _activityTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(236, 70, 470, 30)];
        _activityTitleLabel.text = @"每天骑行10公里,每天奖10元";
        _activityTitleLabel.textColor = [UIColor whiteColor];
    }
    
    return _activityTitleLabel;
    
}


- (UIImageView *)personFalgImageView
{
    if (!_personFalgImageView) {
        _personFalgImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(236,130,24,24)];
        _personFalgImageView.image = [UIImage imageNamed:@"personFalgImageView"];
        
    }
    return _personFalgImageView;
    
}


- (UILabel *)joinActivityNumberLabel
{
    if (!_joinActivityNumberLabel) {
        _joinActivityNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake750(270,130, 118,26)];
        _joinActivityNumberLabel.text = @"报名进行中";
        _joinActivityNumberLabel.textColor = [UIColor grayColor];
        _joinActivityNumberLabel.font = [UIFont systemFontOfSize:22*SizeScale750];
        
    }
    
    return _joinActivityNumberLabel;
    
}

- (UIImageView *)dateFalgImageView
{
    if (!_dateFalgImageView) {
        _dateFalgImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(418,130,22,22)];
        _dateFalgImageView.image = [UIImage imageNamed:@"dateFalgImageView"];
        
    }
    return _dateFalgImageView;
    
}

- (UILabel *)dateActivityTimeLabel
{
    if (!_dateActivityTimeLabel) {
        _dateActivityTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake750(450, 130, 300,22)];
        _dateActivityTimeLabel.text = @"距开始16天08:08:08";
        _dateActivityTimeLabel.textColor = [UIColor grayColor];
        _dateActivityTimeLabel.font = [UIFont systemFontOfSize:22*SizeScale750];
        
    }
    
    return _dateActivityTimeLabel;
}



- (UILabel *)firstLine
{
    if (!_firstLine) {
        _firstLine = [[UILabel alloc]initWithFrame:CGRectMake750(215,92, 1, 40)];
        _firstLine.backgroundColor = [UIColor grayColor];
    }
    return _firstLine;
    
}

- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

@end
