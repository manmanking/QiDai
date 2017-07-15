//
//  HistoryStatisticsViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/20.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HistoryStatisticsViewController.h"
#import "HistoryStatisticsView.h"

@interface HistoryStatisticsViewController ()
{
    /** 年统计的年份*/
    NSInteger _rightYear;
    
    /** 月统计的年份*/
    NSInteger _year;
    /** 月统计的月份*/
    NSInteger _month;
    
    //当前的年份
    NSInteger _nowYear;
    //当前的月份
    NSInteger _nowMonth;
}
/** 周统计的view*/
@property (nonatomic,strong) HistoryStatisticsView *weekView;
/** 月统计的view*/
@property (nonatomic,strong) HistoryStatisticsView *monthView;
/** 年统计的view*/
@property (nonatomic,strong) HistoryStatisticsView *yearView;


@end

@implementation HistoryStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationTitleView];
    
//    self.historyStatisticsView = [[HistoryStatisticsView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:self.historyStatisticsView];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.weekView];
    
}
- (void)setupNavigationTitleView {
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 360, 60)];
    
    NSArray *array=@[@"周",@"月",@"年"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:array];
    segmentControl.frame=CGRectMake720(0,0,330,60);
    segmentControl.selectedSegmentIndex=0;
    segmentControl.tintColor=[UIColor whiteColor];
    [segmentControl addTarget:self action:@selector(switchingMode:) forControlEvents:UIControlEventValueChanged];
    [titleView addSubview:segmentControl];
    self.navigationItem.titleView = titleView;
}
/* 切换类型*/
- (void)switchingMode:(UISegmentedControl *)segmentControl {
    NSInteger position = segmentControl.selectedSegmentIndex;
    
    switch (position) {
        case 0:
            self.weekView.hidden = NO;
            if (_monthView) {
                self.monthView.hidden = YES;
            }
            if (_yearView) {
                self.yearView.hidden = YES;
            }
            break;
        case 1:
            if (!_monthView) {
                [self.view addSubview:self.monthView];
            }
            self.weekView.hidden = YES;
            if (_yearView) {
                self.yearView.hidden = YES;
            }
            self.monthView.hidden = NO;
            break;
        case 2:
            if (!_yearView) {
                [self.view addSubview:self.yearView];
            }
            self.weekView.hidden = YES;
            if (_monthView) {
                self.monthView.hidden = YES;
            }
            self.yearView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark --- lazy load
- (HistoryStatisticsView *)weekView {
    if (!_weekView) {
        _weekView = [[HistoryStatisticsView alloc]initWithFrame:self.view.bounds];
        _weekView.backgroundColor = [UIColor redColor];
    }
    return _weekView;
}

- (HistoryStatisticsView *)monthView {
    if (!_monthView) {
        _monthView = [[HistoryStatisticsView alloc]initWithFrame:self.view.bounds];
    }
    return _monthView;
}

- (HistoryStatisticsView *)yearView {
    if (!_yearView) {
        _yearView = [[HistoryStatisticsView alloc]initWithFrame:self.view.bounds];
        _yearView.backgroundColor = [UIColor whiteColor];
    }
    return _yearView;
}


#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
