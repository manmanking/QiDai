//
//  MMKCalendarView.m
//  QiDai
//
//  Created by manman'swork on 16/11/7.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "MMKCalendarView.h"
#import "NewTaskDetailModel.h"
#import "MMKCalendarCollectionViewCell.h"
#import "RedingRecordDateInfoModel.h"
#import "MMKCalendarFooterCollectionReusableView.h"


#define TaskDateColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

#define NoTaskDateColor [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1]

#define TodayDateColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]

#define TaskFutureDateColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

@interface MMKCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong)RedingRecordDateInfoModel *defaultRedingRecordDateInfoModel;

@property (nonatomic,strong) NSDate *userTaskFinishTimeDate;

@property (nonatomic,strong) NSDate *userTaskStartTimeDate;

@property (nonatomic,strong)UICollectionView *calendarCollectionView;

@property (nonatomic,strong) UIView *dateTitleBackgroundView;

@property (nonatomic,strong) UIView *bottomBackgroundView;

@property (nonatomic,strong)NSDate *realDate;

@property (nonatomic,strong) UILabel *currentDateTitleLabel;

@property (nonatomic,strong) NSDate *currentShowDate;//当前显示日期

@property (nonatomic,strong)NSArray *weekDataSourceArr;

@property (nonatomic,strong)UIButton *preButton;


@property (nonatomic,strong)UIButton *nextButton;




@end



static NSString *collectionViewCellIdentify = @"collectionViewCellIdentify";
static NSString *collectionFooterViewSecondIdentify = @"collectionFooterViewSecondIdentify";
static NSString *collectionFooterFirstViewIdentify = @"collectionFooterFirstViewIdentify";

@implementation MMKCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/






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
    }
    
    return self;
}


- (void)customUIView
{
    self.backgroundColor = [UIColor blackColor];
    _currentShowDate = [NSDate date];
    _realDate = _currentShowDate;
    //记录 设置 默认
    _defaultRedingRecordDateInfoModel.daySumDistance = @"0";
    _defaultRedingRecordDateInfoModel.money = @"0";
    _defaultRedingRecordDateInfoModel.complete = @"0";
    _defaultRedingRecordDateInfoModel.date = @"0";
    
    
    _weekDataSourceArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    [self addSubview:self.dateTitleBackgroundView];
    [self.dateTitleBackgroundView addSubview:self.preButton];
    [self.dateTitleBackgroundView addSubview:self.nextButton];
    [self.dateTitleBackgroundView addSubview:self.currentDateTitleLabel];
    
    [self addSubview:self.calendarCollectionView];
    [self.calendarCollectionView registerClass:[MMKCalendarCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentify];
    //[self.calendarCollectionView registerClass:[MMKCalendarFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooterFirstViewIdentify];
   // [self.calendarCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooterViewSecondIdentify];
    
    
    [self addSubview:self.bottomBackgroundView];
    
    
}


- (void)setDateInfoArr:(NSArray *)dateInfoArr
{
    NSLog(@"date info :%ld",dateInfoArr.count);
    
    // 进入之后 设置 是否 可以点击
    [self verifyDateButtonInteractionEnabled];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *taskfinishDateMonthStr = [NSString stringWithFormat:@"%@ 00:00:00",_taskDetailViewModel.userTaskFinishTime];
    NSDate *finishDate = [dateFormatter dateFromString:taskfinishDateMonthStr];
    
    self.userTaskFinishTimeDate = finishDate;
    
    NSString *taskStartDateMonthStr = [NSString stringWithFormat:@"%@ 00:00:00",_taskDetailViewModel.userTaskStartTime];
    
    NSDate *startDate = [dateFormatter dateFromString:taskStartDateMonthStr];
    
    self.userTaskStartTimeDate = startDate;
    

    if (dateInfoArr.count >0) {
        _dateInfoArr = [dateInfoArr copy];
    }
    [self.calendarCollectionView reloadData];
    
 
}


- (void)setDefaultDataSource
{
    
    
}





- (void)preButtonClick:(UIButton *)sender
{
    NSLog(@"pre button click...");
    self.currentShowDate = [self lastMonth:self.currentShowDate];
    [self setDateTitle];
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
    } completion:nil];
    [self verifyPreButtonInteractionEnabled];
    [self verifyNextButtonInteractionEnabled];
    
 
}


- (void)nextButtonClick:(UIButton *)sender
{
    NSLog(@"next button click...");
    self.currentShowDate = [self nextMonth:self.currentShowDate];
    [self setDateTitle];
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
    } completion:nil];
    //[self verifyDateButtonInteractionEnabled];
    [self verifyNextButtonInteractionEnabled];
    [self verifyPreButtonInteractionEnabled];
    
    
}

- (void)verifyDateButtonInteractionEnabled
{
//    NSDate *nextDate = [self nextMonth:self.currentShowDate];
//    NSDate *preDate = [self lastMonth:self.currentShowDate];
    
    [self verifyPreButtonInteractionEnabled];
    [self verifyNextButtonInteractionEnabled];
    
    
    
}


- (void)verifyNextButtonInteractionEnabled
{
    NSLog(@"校验 next button  ...");
    NSDate *nextDateMonth = [self nextMonth:self.currentShowDate];
    NSString *taskOverDateMonthStr = [NSString stringWithFormat:@"%@ 00:00:00",_taskDetailViewModel.userTaskFinishTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *overDate = [dateFormatter dateFromString:taskOverDateMonthStr];
    NSLog(@"next Date %@",overDate);
    //现在显示的时间 与任务的时间做比较 范围内 可以点击
    
    if ([self year:nextDateMonth]<= [self year:overDate] &&[self month:nextDateMonth] <= [self month:overDate]) {
        NSLog(@"into here 1 ...");
        _nextButton.enabled = YES;
        
    }
    else
    {
        _nextButton.enabled = NO;
        [_nextButton setImage:[UIImage imageNamed:@"nextGreyButton"] forState:UIControlStateDisabled];
    }
    
//    if ([nextDateMonth compare:overDate] == NSOrderedAscending) {
//        NSLog(@"into here 1 ...");
//        _nextButton.userInteractionEnabled = YES;
//    }else
//    {
//        _nextButton.enabled = NO;
//        [_nextButton setImage:[UIImage imageNamed:@"nextGreyButton"] forState:UIControlStateDisabled];
//        
//    }
    
    
    
}

- (void)verifyPreButtonInteractionEnabled
{
    NSLog(@"校验 pre button  ...");
    NSDate *preDateMonth = [self lastMonth:self.currentShowDate];
    NSLog(@" over%@",_taskDetailViewModel.userTaskFinishTime);
    NSLog(@"start%@",_taskDetailViewModel.userTaskStartTime);
    NSString *taskStartDateMonthStr = [NSString stringWithFormat:@"%@ 00:00:00",_taskDetailViewModel.userTaskStartTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:taskStartDateMonthStr];
    NSLog(@"startDate %@",startDate);
    
    if ([self year:preDateMonth] >= [self year:startDate])
    {
        if ([self year:preDateMonth] == [self year:startDate])
        {
            if ([self month:preDateMonth] >= [self month:startDate])
            {
                NSLog(@"into here 1 ...");
                _preButton.enabled = YES;
            }
            else
            {
                _preButton.enabled = NO;
                [_preButton setImage:[UIImage imageNamed:@"preGreyButton"] forState:UIControlStateDisabled];
            }
        }else
        {
            
            //跨年的比较
            NSLog(@" 跨年 into here 2 ...");
            _preButton.enabled = YES;
            
            
        }
        
        
    }
    else
    {
        //跨年的比较
        _preButton.enabled = NO;
        [_preButton setImage:[UIImage imageNamed:@"nextGreyButton"] forState:UIControlStateDisabled];
    }

    
    
    
    //[self verifyNextButtonInteractionEnabled];
    
    
//    //现在显示的时间 与任务的时间做比较 范围内 可以点击
//    if ([startDate compare:preDateMonth] != NSOrderedDescending) {
//        NSLog(@"into here 1 ...");
//        _preButton.userInteractionEnabled = YES;
//    }else
//    {
//        _preButton.enabled = NO;
//        [_preButton setImage:[UIImage imageNamed:@"preGreyButton"] forState:UIControlStateDisabled];
//        
//    }
    
}


- (void)setDateTitle
{
    _currentDateTitleLabel.text = [NSString stringWithFormat:@"%ld-%02ld",[self year:_currentShowDate],(long)[self month:_currentShowDate]];
    [self.calendarCollectionView reloadData];
    
}

#pragma ---- UICollectionViewDataSource ---start

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"numberOfSectionsInCollectionView ...");
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"numberOfItemsInSection ...");
    
    if (section == 0) {
        return _weekDataSourceArr.count;
    }else
    {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath ");
    MMKCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentify forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.isShowTodayIndicator = NO;
        [cell updateUIView:CGRectMake750(10, 15, 50, 50) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%@",_weekDataSourceArr[indexPath.row]] andTextColor:[UIColor whiteColor] andborderColor:nil andCornerRadius:0];
        
        return cell;
    }
    else
    {
        //NSDate *date = [NSDate date];
        NSInteger daysInThisMonth = [self totaldaysInMonth:_currentShowDate];// 计算 今天是当月 第几天
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_currentShowDate]; //第一周  在这个月 有几天
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;

        // 第一周 空白区域
        if (i < firstWeekday)
        {
            //            [cell.contentView setText:@""];
            cell.isShowTodayIndicator = NO;
            [cell updateUIView:CGRectMake750(10, 10, 52, 52) andBackgroundColor:[UIColor blackColor] andText:@"" andTextColor:[UIColor whiteColor] andborderColor:[UIColor blackColor] andCornerRadius:0];
            return cell;
            
        } // 最后一周 空白
        else if (i > firstWeekday + daysInThisMonth - 1)
        {
            //            [cell.dateLabel setText:@""];
            cell.isShowTodayIndicator = NO;
            [cell updateUIView:CGRectMake750(10, 10, 52, 52) andBackgroundColor:[UIColor blackColor] andText:@"" andTextColor:[UIColor whiteColor] andborderColor:nil andCornerRadius:0];
            return cell;
        }else{
            
            day = i - firstWeekday + 1;
            cell.isShowTodayIndicator = YES;
            [cell updateUIView:CGRectMake750(10, 10, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:NoTaskDateColor andborderColor:[UIColor blackColor] andCornerRadius:0];
            
            /**
             *  isSuccess 1完成  2未完成  3任务范围内的将来日期  4默认数据
             */
            
            NSString * isSuccess = @"4";
            NSString *currentShowDateStr =[NSString stringWithFormat:@"%@-%02ld",_currentDateTitleLabel.text,day];
            //start of line
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *taskfinishDateMonthStr = [NSString stringWithFormat:@"%@ 00:00:00",currentShowDateStr];
            NSDate *currentShowDate = [dateFormatter dateFromString:taskfinishDateMonthStr];
            // 添加 默认数据
            
            //NSOrderedDescending  NSOrderedAscending
            if (([currentShowDate compare:self.userTaskStartTimeDate] == NSOrderedDescending ||
                 [currentShowDate compare:self.userTaskStartTimeDate] == NSOrderedSame) &&
                ([self.userTaskFinishTimeDate compare:currentShowDate] == NSOrderedDescending ||
                 [self.userTaskFinishTimeDate compare:currentShowDate] == NSOrderedSame) ) {
                NSLog(@"into here ...");
                isSuccess = @"2";
                    
                // 检测任务结束日期 是否超过当前时间 超过则 清除 默认设置
                if ([currentShowDate compare:_realDate] == NSOrderedDescending) {
                    isSuccess = @"3";
                }
                    
            }
            
            
            
            
            
            // end of line
            
            
            
            
            
            
            
            for (RedingRecordDateInfoModel *tmpModel in _dateInfoArr ) {
                if ([tmpModel.complete isEqualToString:@"1"] && [tmpModel.date isEqualToString:currentShowDateStr]) {
                    isSuccess = @"1";
                    break;
                }else if([tmpModel.complete isEqualToString:@"0"] && [tmpModel.date isEqualToString:currentShowDateStr])
                {
                    isSuccess = @"2";
                    break;
                    
                }
            }
            
            
            //现在  加紧现在 本月
            if ([_realDate isEqualToDate:self.currentShowDate])
            {
                
                if (day == [self day:_currentShowDate])
                {
                    cell.isShowTodayIndicator = YES;
                    [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TodayDateColor andborderColor:[UIColor blackColor] andCornerRadius:0];
                    
                    
                    if ([isSuccess isEqualToString:@"1"])
                    {
                        [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TodayDateColor andborderColor:[UIColor redColor] andCornerRadius:26.f*SizeScale750];
                    }
                   
//                    if ([isSuccess isEqualToString:@"2"])
//                    {
//                       
//                        [cell updateUIView:CGRectMake750(16, 10, 44, 44) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor grayColor] andCornerRadius:22.f*SizeScale750];
//                    }
                    
                }
                else if (day > [self day:_currentShowDate])
                {
                    cell.isShowTodayIndicator = NO;
//                    if ([isSuccess isEqualToString:@"1"])
//                    {
//                        [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor redColor] andCornerRadius:25.f*SizeScale750];
//                    }
                    
//                    if ([isSuccess isEqualToString:@"2"])
//                    {
//                        [cell updateUIView:CGRectMake750(16, 10,44, 44) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor grayColor] andCornerRadius:22.f*SizeScale750];
//                    }
                    //任务范围内的 日期
                    if ([isSuccess isEqualToString:@"3"]) {
                        [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskFutureDateColor andborderColor:[UIColor blackColor] andCornerRadius:0];
                    }
                   
                    
                }
                else if (day < [self day:_currentShowDate])
                {
                    cell.isShowTodayIndicator = NO;
                    if ([isSuccess isEqualToString:@"1"])
                    {
                        [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor redColor] andCornerRadius:25.f*SizeScale750];
                    }
                    
                    if ([isSuccess isEqualToString:@"2"])
                    {
                        [cell updateUIView:CGRectMake750(16, 10, 44, 44) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor grayColor] andCornerRadius:22.f*SizeScale750];
                    }
                   
                    
                }
            }//将来  为将来准备
            else if ([_realDate compare:_currentShowDate] == NSOrderedAscending)
            {
                cell.isShowTodayIndicator = NO;
                if ([isSuccess isEqualToString:@"1"])
                {
                    [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor redColor] andCornerRadius:25.f*SizeScale750];
                }else if ([isSuccess isEqualToString:@"2"])
                {
                    [cell updateUIView:CGRectMake750(16, 10, 44, 44) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor grayColor] andCornerRadius:22.f*SizeScale750];
                }
                //任务范围内的 日期
                if ([isSuccess isEqualToString:@"3"]) {
                    [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskFutureDateColor andborderColor:[UIColor blackColor] andCornerRadius:0];
                }
            }// 曾经  反省 过程
            else if ([_realDate compare:_currentShowDate] == NSOrderedDescending)
            {
                cell.isShowTodayIndicator = NO;
                if ([isSuccess isEqualToString:@"1"])
                {
                    [cell updateUIView:CGRectMake750(12, 9, 52, 52) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor redColor] andCornerRadius:25.f*SizeScale750];
                }else if ([isSuccess isEqualToString:@"2"])
                {
                    [cell updateUIView:CGRectMake750(16, 10, 44, 44) andBackgroundColor:[UIColor blackColor] andText:[NSString stringWithFormat:@"%ld",(long)day] andTextColor:TaskDateColor andborderColor:[UIColor grayColor] andCornerRadius:22.f*SizeScale750];
                }

            }
            isSuccess = @"4";
            
        }
        
        return cell;
    }
    
    
    
    
    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"预选则 ...");
    return YES;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_currentShowDate];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_currentShowDate];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    NSLog(@"day %ld,month%ld year%ld",day, [comp month], [comp year]);
    NSString *isSuccess = @"3";
    RedingRecordDateInfoModel *selectRedingRecordDateInfoModel = nil;
    NSString *dateStr = [NSString stringWithFormat:@"%@-%02ld",_currentDateTitleLabel.text,day];
    for (RedingRecordDateInfoModel *tmpModel in _dateInfoArr) {
        if ([tmpModel.complete isEqualToString:@"1"] && [tmpModel.date isEqualToString:dateStr]) {
            isSuccess = @"1";
            selectRedingRecordDateInfoModel = [tmpModel copy];
            
            break;
        }
        else if ([tmpModel.complete isEqualToString:@"0"] &&[tmpModel.date isEqualToString:dateStr])
        {
            isSuccess = @"2";
            selectRedingRecordDateInfoModel = [tmpModel copy];
            break;
        }
    }
    self.selectedDate(isSuccess,selectRedingRecordDateInfoModel);

}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *resuableview = nil;
//    
//    if (kind == UICollectionElementKindSectionFooter) {
//        if (indexPath.section == 1) {
//            
//            MMKCalendarFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooterFirstViewIdentify forIndexPath:indexPath];
//            
//            resuableview = footerView;
//        }
//        else
//        {
//            UICollectionReusableView *footerSecondView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionFooterViewSecondIdentify forIndexPath:indexPath];
//            resuableview = footerSecondView;
//            
//        }
//    
//        
//    }
//    return resuableview;
//    
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return CGSizeMake(710 *SizeScale750,1);
//    }else{
//        
//        
//        return CGSizeMake(710 * SizeScale750 , 90 *SizeScale750);
//    }
//}




#pragma ---- UICollectionViewDelegate ---end



#pragma 计算日期


- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (BOOL) verifyDateEqualDay:(NSString *)oneDateStr andTwoDate:(NSString *)twoDateStr
{
    NSString *test = @"2014-07-16";
   NSDate *oneDate = [self stringConvertToDate:test andFormate:@"yyyy-MM-dd"];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unitFlags fromDate:oneDateStr toDate:twoDateStr options:0];

    return YES;
    
}


- (NSDate *)stringConvertToDate:(NSString *)dateStr andFormate:(NSString *)formatrStr
{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    
    [df setDateFormat:formatrStr];
    
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    
    NSDate*date =[[NSDate alloc]init];
    
    date =[df dateFromString:dateStr];
    return date;
    
    
//   NSString *str = [NSString stringWithFormat:@"%@",date];
//    
//    NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
//    
//    [df2 setDateFormat:formatrStr];
//    
//    NSString* str1 = [df2 stringFromDate:date];
    

}



#pragma lazyload

- (UILabel *)currentDateTitleLabel
{
    if (!_currentDateTitleLabel) {
        _currentDateTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake750(80,10,560, 38)];
        _currentDateTitleLabel.textColor = [UIColor blackColor];
        _currentDateTitleLabel.font = [UIFont systemFontOfSize:38*SizeScale750];
        _currentDateTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self setDateTitle];
    }
    
    return _currentDateTitleLabel;
}



- (UIButton *)preButton
{
    if (!_preButton) {
        _preButton = [[UIButton alloc]initWithFrame:CGRectMake750(40,8, 44, 44)];
        [_preButton setImage:[UIImage imageNamed:@"preBlackButton"] forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(preButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preButton;
}




- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]initWithFrame:CGRectMake750(640,8, 44, 44)];
        [_nextButton setImage:[UIImage imageNamed:@"nextBlackButton"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _nextButton;
    
}


- (UICollectionView *)calendarCollectionView
{
    if (!_calendarCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake((710*SizeScale750)/7,(580*SizeScale750)/7);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        //flowLayout.footerReferenceSize = CGSizeMake(710*SizeScale750,90*SizeScale750);
        
        _calendarCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake750(0,60,710,580)  collectionViewLayout:flowLayout];
        _calendarCollectionView.backgroundColor = [UIColor blackColor];
        _calendarCollectionView.delegate = self;
        _calendarCollectionView.dataSource = self;
        
        
    }
    return _calendarCollectionView;
    
    
    
    
}

- (UIView *)dateTitleBackgroundView
{
    if (!_dateTitleBackgroundView) {
        _dateTitleBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 0, 710, 60)];
        _dateTitleBackgroundView.backgroundColor = [UIColor whiteColor];
        _dateTitleBackgroundView.layer.cornerRadius = 5.f;
        
        
        
    }
    return _dateTitleBackgroundView;
    
}

- (UIView *)bottomBackgroundView
{
    if (!_bottomBackgroundView) {
        _bottomBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 645, 710, 90)];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake750(0,0, 710, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [_bottomBackgroundView addSubview:lineLabel];
        UILabel *redCircle = [[UILabel alloc]initWithFrame:CGRectMake750(0,35, 16, 16)];
        redCircle.layer.borderColor = [[UIColor redColor]CGColor];
        redCircle.layer.borderWidth = 1.f;
        redCircle.layer.cornerRadius = 8.f *SizeScale750;
        [_bottomBackgroundView addSubview:redCircle];
        UILabel *beUpToStandardCircle = [[UILabel alloc]initWithFrame:CGRectMake750(36,28 ,50, 30)];
        beUpToStandardCircle.text = @"达标";
        beUpToStandardCircle.font = [UIFont systemFontOfSize:22*SizeScale750];
        beUpToStandardCircle.textColor = [UIColor whiteColor];
        [_bottomBackgroundView addSubview:beUpToStandardCircle];

        UILabel *grayCircle = [[UILabel alloc]initWithFrame:CGRectMake750(130,35, 16, 16)];
        grayCircle.layer.borderColor = [[UIColor grayColor]CGColor];
        grayCircle.layer.borderWidth = 1.f;
        grayCircle.layer.cornerRadius = 8.f *SizeScale750;
        [_bottomBackgroundView addSubview:grayCircle];
        UILabel *notUpToThetandardCircle = [[UILabel alloc]initWithFrame:CGRectMake750(166,28,80, 30)];
        notUpToThetandardCircle.text = @"未达标";
        notUpToThetandardCircle.font = [UIFont systemFontOfSize:22*SizeScale750];
        notUpToThetandardCircle.textColor = [UIColor whiteColor];
        [_bottomBackgroundView addSubview:notUpToThetandardCircle];
    
        
    }
    
    return _bottomBackgroundView;
    
}


@end
