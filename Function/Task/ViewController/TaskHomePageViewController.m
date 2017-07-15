//
//  TaskHomePageViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/25.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TaskHomePageViewController.h"
#import "TaskNotBeginTableViewCell.h"
#import "TaskStatusTableViewCell.h"
#import "TaskFinishTableViewCell.h"
#import "TaskHomePageHeaderView.h"
#import "MJExtension.h"
#import "TaskModel.h"
#import "OngoingModel.h"
#import "TaskCalendarViewController.h"
#import "MJRefresh.h"
@interface TaskHomePageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    /** 正在进行*/
    OngoingModel *_ingModel;
    /** 已结束*/
    NSMutableArray *_overArrayM;
    /** 即将开始*/
    NSMutableArray *_beginArrayM;
    
}
@property (nonatomic,strong) UITableView *tableView;
/** tableHeaderView*/
@property (nonatomic,strong) TaskHomePageHeaderView *headerView;
/** 没有数据的时候展示*/
@property (nonatomic,strong) UIImageView *defaultImageView;

//是否更新
@property (nonatomic,assign) BOOL isUpdate;

@end

static NSString *const kTaskNotBeginTableViewCell = @"TaskNotBeginTableViewCell";
static NSString *const kTaskStatusTableViewCell = @"TaskStatusTableViewCell";
static NSString *const kTaskFinishTableViewCell = @"TaskFinishTableViewCell";

@implementation TaskHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUpdate = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    [self creatTitleViewWithString:@"任务"];
    self.view.backgroundColor = [UIColor blackColor];
    
    _overArrayM = @[].mutableCopy;
    _beginArrayM = @[].mutableCopy;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.defaultImageView;
    @weakify_self
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify_self
        [self getTaskNetworkData];
    }];
 
    [self getTaskNetworkData];
    //运动结束 刷新
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTaskNetworkData) name:kRefreshTaskNotification object:nil];
    //历史骑行  上传  成功 刷新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTaskNetworkData) name:kUPDATAHISTORY_NOTIFICATION object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if ( [[[NSUserDefaults standardUserDefaults]objectForKey:kAddTaskSuccessUpdateTaskHome]isEqualToString: @"1"]||
        [[[NSUserDefaults standardUserDefaults]objectForKey:kLoginSuccessUpdateTaskHome]isEqualToString: @"1"])
    {
       
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:kAddTaskSuccessUpdateTaskHome]isEqualToString: @"1"])
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kAddTaskSuccessUpdateTaskHome];
        else
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kLoginSuccessUpdateTaskHome];
        //不可以每次进入页面 都更新数据 可以手动更新数据
        [self getTaskNetworkData];
    }
    
}
#pragma mark --- interface
- (void)getTaskNetworkData {
    
    //NSDictionary *parameter = @{@"userInfoId":[[LoginManager instance] getUserId]};
    [self.tableView.mj_header endRefreshing];
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    
    NSDictionary *parameter = @{@"userInfoId":kUserId};
    [QDHttpTool getWithURL:kUrl_getTask_index params:parameter success:^(BOOL isSuccess, NSDictionary *responseObject) {
        if (!isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"] ];
            return ;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        NSLog(@"%@",responseObject);
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"00"]) {
            
            _ingModel = nil;
            
            if (![[responseObject[@"data"] valueForKey:@"ing"] isKindOfClass:[NSNull class]]) {
                _ingModel = [OngoingModel mj_objectWithKeyValues:[responseObject[@"data"] valueForKey:@"ing"] ] ;
                _ingModel.refund = [[responseObject[@"data"] valueForKey:@"money"] integerValue];
                
                if (_ingModel) {
                    self.tableView.tableHeaderView = self.headerView;
                    self.headerView.model = _ingModel;
                } else {
                    //self.headerView.height = 532*SizeScale;
                }
            }
            
            if (_beginArrayM.count) {
                [_beginArrayM removeAllObjects];
            }
            [_beginArrayM addObjectsFromArray:[TaskModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] valueForKey:@"begin"]] ];
            
            if (_overArrayM.count) {
                [_overArrayM removeAllObjects];
            }
            [_overArrayM addObjectsFromArray:[TaskModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] valueForKey:@"over"]] ];
            
            //!_ingModel && !_beginArrayM.count && !_overArrayM.count
            if (!_ingModel) {
                self.tableView.tableHeaderView = self.defaultImageView;
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
- (void)clearDataSources
{
    
    
    
    
}

#pragma mark --- private method
/** 点击henaderview 进入下个页面*/
- (void)clickCalendarView {
    
    if (_ingModel) {
        TaskCalendarViewController *vc = [[TaskCalendarViewController alloc]init];
        vc.taskModel = _ingModel;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}
#pragma mark --- tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _beginArrayM.count;
    }
    
    if (section == 0 && _beginArrayM.count == 0) {
        return 0;
    }
    if (section == 2 && _overArrayM.count == 0) {
        return 0;
    }
    /** 状态栏*/
    if (section == 0 || section == 2) {
        return 1;
    }
    return _overArrayM.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //状态栏
    if (indexPath.section == 0 || indexPath.section == 2) {
        TaskStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskStatusTableViewCell];
        if (cell == nil) {
            cell = [[TaskStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTaskStatusTableViewCell];
        }
        if (indexPath.section == 0) {
            cell.finish = NO;
        } else {
            cell.finish = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        TaskNotBeginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskNotBeginTableViewCell];
        if (cell == nil) {
            cell = [[TaskNotBeginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTaskNotBeginTableViewCell];
        }
        cell.model = _beginArrayM[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    TaskFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskFinishTableViewCell];
    if (cell == nil) {
        cell = [[TaskFinishTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTaskFinishTableViewCell];
    }
    cell.model = _overArrayM[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 178*SizeScale;
    }
    /** 状态栏*/
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 80*SizeScale;
    }
    return 166*SizeScale;
}

#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.height -= (44+64+10);
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (TaskHomePageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TaskHomePageHeaderView alloc]initWithFrame:CGRectMake720(0, 0, 720, 532)];
        @weakify_self
        _headerView.clickBlock = ^ {
            
            @strongify_self
            [self clickCalendarView];
            
        };
    }
    return _headerView;
}
- (UIImageView *)defaultImageView {
    if (!_defaultImageView) {
        _defaultImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 720, 1052)];
        _defaultImageView.image = [UIImage imageNamed:@"task_default_bg_image"];
    }
    return _defaultImageView;
}
- (void)dealloc {
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
