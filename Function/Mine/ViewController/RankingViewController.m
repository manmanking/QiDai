//
//  RankingViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/24.
//  Copyright © 2016年 张汇丰. All rights reserved.
//
typedef NS_ENUM(NSInteger, RankStatus) {
    RankTotal = 0,
    RankMonth = 1,
    RankWeek = 2
};
#import "RankingViewController.h"
#import "RankingTableViewCell.h"
#import "RankingHeaderView.h"
#import "RankingModel.h"
#import "IndividualRankingModel.h"
#import "MBProgressHUDManager.h"
#import "MJExtension.h"
@interface RankingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //总，月，周的数据
    NSMutableArray *_totalArrayM;
    NSMutableArray *_monthArrayM;
    NSMutableArray *_weekArrayM;
    
    //总，月，周的model
    IndividualRankingModel *_totalModel;
    IndividualRankingModel *_monthModel;
    IndividualRankingModel *_weekModel;
    
    //标记
    RankStatus _tag;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) RankingHeaderView *headerView;
@end
static NSString *const kRankingTableViewCell = @"RankingTableViewCell";
@implementation RankingViewController
#pragma mark --- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    _totalArrayM = @[].mutableCopy;
    _monthArrayM = @[].mutableCopy;
    _weekArrayM = @[].mutableCopy;
    _tag = RankWeek;
    
    NSArray *array=@[@"周",@"月",@"总"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:array];
    segmentControl.frame = CGRectMake720(0, 0, 390, 44);
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor=[UIColor whiteColor];
    [segmentControl addTarget:self action:@selector(changeDateStatus:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getNetworkData];
}
#pragma mark --- private method

- (void)getNetworkData {
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    
    NSDictionary *parameter = @{@"userId":[[LoginManager instance]getUserId]};
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [QDHttpTool getWithURL:kUrl_TaskGetTotalRank params:parameter success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (isSuccess) {
            _totalModel = [IndividualRankingModel mj_objectWithKeyValues:responseObject[@"myRecord"] ];
            [_totalArrayM addObjectsFromArray:[RankingModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"ranks"]] ];
        }
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [QDHttpTool getWithURL:kUrl_TaskGetMonthRank params:parameter success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (isSuccess) {
            _monthModel = [IndividualRankingModel mj_objectWithKeyValues:responseObject[@"myRecord"] ];
            [_monthArrayM addObjectsFromArray:[RankingModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"ranks"]] ];
        }
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [QDHttpTool getWithURL:kUrl_TaskGetWeekRank params:parameter success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (isSuccess) {
            _weekModel = [IndividualRankingModel mj_objectWithKeyValues:responseObject[@"myRecord"] ];
            [_weekArrayM addObjectsFromArray:[RankingModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"ranks"]] ];
        }
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
        self.headerView.model = _weekModel;
        [self.tableView reloadData];
    });

}
- (void)changeDateStatus:(UISegmentedControl *)segmentControl {
    
    NSInteger position = segmentControl.selectedSegmentIndex;
    
    switch (position) {
        case 0:
            self.headerView.rankingTextLabel.text = @"周排名";
            [self clickWeekView];
            break;
        case 1:
            self.headerView.rankingTextLabel.text = @"月排名";
            [self clickMonthView];
            break;
        case 2:
            self.headerView.rankingTextLabel.text = @"总排名";
            [self clickTotalView];
            break;
        default:
            break;
    }
}
- (void)refreshHeaderView {
    switch (_tag) {
        case RankWeek:
            self.headerView.model = _weekModel;
            break;
        case RankMonth:
            self.headerView.model = _monthModel;
            break;
        case RankTotal:
            self.headerView.model = _totalModel;
            break;
        default:
            break;
    }
}
- (void)clickWeekView {
    _tag = RankWeek;
    [self refreshHeaderView];
    [self.tableView reloadData];
}
- (void)clickMonthView {
    _tag = RankMonth;
    [self refreshHeaderView];
    [self.tableView reloadData];
    
}
- (void)clickTotalView {
    _tag = RankTotal;
    [self refreshHeaderView];
    [self.tableView reloadData];
}
- (void)clickBackBtn {
    //[self creatOglFlipTransitionAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (_tag) {
        case RankWeek:
            number = _weekArrayM.count;
            break;
        case RankMonth:
            number = _monthArrayM.count;
            break;
        case RankTotal:
            number = _totalArrayM.count;
            break;
        default:
            break;
    }
    return number;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRankingTableViewCell];
    if (cell == nil) {
        cell = [[RankingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRankingTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (_tag) {
        case RankWeek:
            cell.model = _weekArrayM[indexPath.row];
            break;
        case RankMonth:
            //NSLog(@"%@",_monthArrayM[indexPath.row]);
            cell.model = _monthArrayM[indexPath.row];
            break;
        case RankTotal:
            cell.model = _totalArrayM[indexPath.row];
            break;
        default:
            break;
    }
    cell.ranking = indexPath.row + 1;
    return cell;
}


#pragma mark --- lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        if (![PublicTool isIphone4]) {
            _tableView.height = _tableView.height - 64;
        }
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.rowHeight = 110*SizeScaleSubjectTo720;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (RankingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[RankingHeaderView alloc]initWithFrame:CGRectMake720(0, 0, 720, 250)];
    }
    return _headerView;
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
