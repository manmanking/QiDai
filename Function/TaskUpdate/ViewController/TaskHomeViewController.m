//
//  TaskHomeViewController.m
//  QiDai
//
//  Created by manman'swork on 16/10/31.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "TaskHomeViewController.h"
#import "OngoingTableViewCell.h"
#import "TaskDetailViewController.h"
#import "UnstartedTaskTableViewCell.h"
#import "OverTaskTableViewCell.h"
#import "HttpTaskHomeManager.h"
#import "OverTaskModel.h"
#import "OngoingModel.h"
#import "UnstartTaskModel.h"
#import "MJRefresh.h"
#import "MBProgressHUDManager.h"




@interface TaskHomeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)NSMutableArray *overTaskMArr;

@property (nonatomic,strong)NSMutableArray *ongoingTaskMArr;

@property (nonatomic,strong)NSMutableArray *unstartMTaskArr;

@property (nonatomic,strong)UIImageView *taskBuyBikeImageView;

@property (nonatomic,strong)UISegmentedControl *segmentedControl;

@property (nonatomic,strong)NSArray *segmentDataSourceArr;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong) UIView *baseBackgroundView;

@property (nonatomic,strong) UIImageView *offlineImageView;

@property (nonatomic,strong) UIImageView *onTheRoadImageView;

@property (nonatomic,strong) UIImageView *baseImageView;

@property (nonatomic,strong) UIImageView *noTaskImageView;

/**
 *  1 没有订单 2 在路上 3 有任务
 */
@property (nonatomic,strong) NSString *taskState;


@end


static NSString *ongoingTableViewCellIdentifyStr = @"ongoingTableViewCellIdentifyStr";
static NSString *unstartedTaskTableViewCellIdentifyStr = @"unstartedTaskTableViewCellIdentifyStr";
static NSString *overTaskTableViewCellIdentifyStr = @"overTaskTableViewCellIdentifyStr";

@implementation TaskHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationView];
    self.taskState = @"3";
    
    self.view.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1];
    self.title  = @"任务";

    self.segmentDataSourceArr = @[@"进行中",@"未开始",@"已结束"];
    [self.view addSubview:self.segmentedControl];
//    NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSBackgroundColorAttributeName,
//                         [UIFont fontWithName:@"AppleGothic"size:18],NSFontAttributeName,
//                         [UIColor whiteColor],NSForegroundColorAttributeName,nil];
   // [self.segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
//    NSDictionary *selectedDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                            [UIColor grayColor],NSBackgroundColorAttributeName,
//                               [UIFont fontWithName:@"AppleGothic"size:18],NSFontAttributeName,
//                               [UIColor whiteColor],NSForegroundColorAttributeName,nil];
//    [self.segmentedControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:32*SizeScale750],NSFontAttributeName,nil];
    
    [self.segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    self.segmentedControl.tintColor = [UIColor grayColor];
    self.segmentedControl.selectedSegmentIndex = 0;// 默认选择第一个
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self getBillStatusAndTaskDataSOurce];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:refreshTaskUpdateHomeAndRedingHome];
    }];
    
    self.taskBuyBikeImageView.hidden = YES;
    
    
    [self.tableView registerClass:[OngoingTableViewCell class] forCellReuseIdentifier:ongoingTableViewCellIdentifyStr];
    [self.tableView registerClass:[UnstartedTaskTableViewCell class] forCellReuseIdentifier:unstartedTaskTableViewCellIdentifyStr];
    [self.tableView registerClass:[OverTaskTableViewCell class] forCellReuseIdentifier:overTaskTableViewCellIdentifyStr];
   
    
    //    //历史骑行  上传  成功 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBillStatusAndTaskDataSOurce) name:kUPDATAHISTORY_NOTIFICATION object:nil];
//    [self getBillStatus];
//    [self getTaskDataSources];

    [self getBillStatusAndTaskDataSOurce];
    
    NSLog(@"the day is nice day :%@",NEWHostAndPort);
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    QDLog(@"sport home animated :%@",[[NSUserDefaults standardUserDefaults] valueForKey:kAddTaskSuccessUpdateTaskHome]);
    
    if ( [[[NSUserDefaults standardUserDefaults]valueForKey:kAddTaskSuccessUpdateTaskHome]isEqualToString: @"1"]||
        [[[NSUserDefaults standardUserDefaults]valueForKey:kLoginSuccessUpdateTaskHome]isEqualToString: @"1"])
    {
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:kAddTaskSuccessUpdateTaskHome]isEqualToString: @"1"])
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kAddTaskSuccessUpdateTaskHome];
        else
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kLoginSuccessUpdateTaskHome];
        //不可以每次进入页面 都更新数据 可以手动更新数据
//        
//        [self getBillStatus];
//        [self getTaskDataSources];
        [self getBillStatusAndTaskDataSOurce];
    }
  
    
}


- (void)setupNavigationView {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blackBarbackgroundImageView"] forBarMetrics:UIBarMetricsDefault];
    [self creatTitleViewWithString:@"任务"];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setFrame:CGRectMake720(0, 0, 40,50)];
//    [rightBtn setContentMode:UIViewContentModeLeft];
//    [rightBtn setImage:[UIImage imageNamed:@"shop_seach_btn"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(clickSeachBtn) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setFrame:CGRectMake720(0, 0, 40,32)];
//    [leftBtn setImage:[UIImage imageNamed:@"shop_scan_btn"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(clickScanAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    
}


- (void)segmentedControlSelectIndex:(UISegmentedControl *) segmentedControl
{
    NSInteger selectedIndex = segmentedControl.selectedSegmentIndex;
    switch (selectedIndex) {
        case SegmentedControlTaskSelectedOngoing:
            NSLog(@"selectedIndex 0 ...");
            if ([self.taskState isEqualToString:@"1"]) {
                self.tableView.backgroundView = self.noTaskImageView;
                if ([self.taskState isEqualToString:@"1"] &&self.unstartMTaskArr.count>0)
                {
                    self.tableView.backgroundView = self.baseImageView;
                }
            }else if ([self.taskState isEqualToString:@"2"])
            {
                //买了车 在路上
                self.tableView.backgroundView = self.onTheRoadImageView;
            }
            if (self.ongoingTaskMArr.count) {
                self.tableView.backgroundView = self.baseBackgroundView;
                
            }
            break;
            
        case SegmentedControlTaskSelectedUnstart:
            NSLog(@"selectedIndex 1 ...");
            if ([self.taskState isEqualToString:@"1"]) {
                self.tableView.backgroundView = self.noTaskImageView;
                if ([self.taskState isEqualToString:@"1"] && self.ongoingTaskMArr.count >0 ) {
                    self.tableView.backgroundView = self.baseImageView;
                }
            }else if ([self.taskState isEqualToString:@"2"])
            {
                self.tableView.backgroundView = self.onTheRoadImageView;
            }
            if (self.unstartMTaskArr.count) {
                self.tableView.backgroundView = self.baseBackgroundView;
                
            }
            break;
            
        case SegmentedControlTaskSelectedOver:
            NSLog(@"selectedIndex 2 ...");
            if ([self.taskState isEqualToString:@"1"]) {
                self.tableView.backgroundView = self.noTaskImageView;
                if ([self.taskState isEqualToString:@"1"]&& (self.ongoingTaskMArr.count>0 ||self.unstartMTaskArr.count>0)) {
                    self.tableView.backgroundView = self.baseImageView;
                    
                }
                
            }else if ([self.taskState isEqualToString:@"2"])
            {
                self.tableView.backgroundView = self.onTheRoadImageView;
            }
            if (self.overTaskMArr.count) {
                self.tableView.backgroundView = self.baseBackgroundView;
                
            }
            
            break;
            
        default:
            break;
    }
    
    
    [self.tableView reloadData];
    
    
    
}


- (void)getBillStatusAndTaskDataSOurce
{
    self.taskState = @"3";
    [[MBProgressHUDManager instance] sendRequestShowHUD:kGetKeyWindow];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    [HttpTaskHomeManager netGetBillStatus:kUserId andSuccessResponse:^(BOOL isSuccess, NSDictionary *response) {
       NSNumber *isHave = response[@"data"];
        
        if ([isHave  isEqual: @1]) {
            //self.tableView.backgroundView = self.onTheRoadImageView;
            self.taskState = @"2";
        }else
        {
            self.taskState = @"1";
            //self.tableView.backgroundView = self.noTaskImageView;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
         dispatch_group_leave(group);
    } andFailureResponse:^(BOOL isSuccess, NSDictionary *response) {
        if ([response[@"errorCode"] isEqualToString:@"01"]) {
            
        }else
        {
            self.tableView.backgroundView = self.offlineImageView;
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
         dispatch_group_leave(group);
    }];
    
     dispatch_group_enter(group);
    [HttpTaskHomeManager netGetTaskdataSources:kUserId andSuccessResponse:^(BOOL isSuccess, NSDictionary *response) {
        NSLog(@"task home Success response %@",response);
        [self clearTheDataSources];
        if (isSuccess) {
            if (response[@"over"]) {
                self.overTaskMArr = response[@"over"];
            }
            if (response[@"unstart"]) {
                self.unstartMTaskArr = response[@"unstart"];
            }
            if (response[@"ongoing"]) {
                self.ongoingTaskMArr = response[@"ongoing"];
            }
            
            if (self.overTaskMArr.count >0 || self.unstartMTaskArr.count>0 ||self.ongoingTaskMArr.count) {
                self.tableView.backgroundView = self.baseBackgroundView;
                
            }
            
            [self.tableView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
        }

        
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        dispatch_group_leave(group);
        
    } andFailureResponse:^(BOOL isSuccess, NSDictionary *response) {
        NSLog(@"task home Failure response %@",response);
        [self clearTheDataSources];
        if ([response[@"errorCode"] isEqualToString:@"01"]) {
            self.tableView.backgroundView = self.noTaskImageView;
            
            [[MBProgressHUDManager instance] requestSuccessWithMessage:response[@"errorMessage"]];
        }else
        {
            self.tableView.backgroundView = self.offlineImageView;
            [[MBProgressHUDManager instance] requestFailAndHideHUD];
        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        [self.tableView reloadData];
         dispatch_group_leave(group);
    }];
  
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        [self segmentedControlSelectIndex:self.segmentedControl];
        
//        if ([self.taskState isEqualToString:@"1"]) {
//            self.tableView.backgroundView = self.noTaskImageView;
//            
//        }
//        if ([self.taskState isEqualToString:@"2"]) {
//            self.tableView.backgroundView = self.onTheRoadImageView;
//            
//        }
//        if (self.ongoingTaskMArr.count) {
//            self.tableView.backgroundView = self.baseBackgroundView;
//            
//        }
        
        
    });
    
    
    
    
}

- (void)getBillStatus
{
    [HttpTaskHomeManager netGetBillStatus:kUserId andSuccessResponse:^(BOOL isSuccess, NSDictionary *response) {
        BOOL isHave = response[@"data"];
        
        if (isHave) {
        
            self.tableView.backgroundView = self.onTheRoadImageView;
            self.taskState = @"2";
        }else
        {
            self.taskState = @"1";
            self.tableView.backgroundView = self.noTaskImageView;
        }
        
    } andFailureResponse:^(BOOL isSuccess, NSDictionary *response) {
        if ([response[@"errorCode"] isEqualToString:@"01"]) {
            
        }else
        {
            self.tableView.backgroundView = self.offlineImageView;
        }

    }];
    
    
    
    
}

- (void)reloadButtonClick:(UIButton *)sender
{
    
    NSLog(@"reloadButtonClick ...");
    [self getTaskDataSources];
    
}



- (void)getTaskDataSources
{
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.view];
    [HttpTaskHomeManager netGetTaskdataSources:kUserId andSuccessResponse:^(BOOL isSuccess, NSDictionary *response) {
        NSLog(@"task home Success response %@",response);
        [self clearTheDataSources];
        if (isSuccess) {
            if (response[@"over"]) {
               self.overTaskMArr = response[@"over"];
            }
            if (response[@"unstart"]) {
                self.unstartMTaskArr = response[@"unstart"];
            }
            if (response[@"ongoing"]) {
               self.ongoingTaskMArr = response[@"ongoing"];
            }

            if (self.overTaskMArr.count >0 || self.unstartMTaskArr.count>0 ||self.ongoingTaskMArr.count) {
                self.tableView.backgroundView = self.baseBackgroundView;
                
            }
            
            [self.tableView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
        }
//        }else
//        {
//            [[MBProgressHUDManager instance] requestSuccessWithMessage:response[@"errorMessage"]];
//        }
        [[MBProgressHUDManager instance] requestSuccessWithMessage:@""];
        
    } andFailureResponse:^(BOOL isSuccess, NSDictionary *response) {
        NSLog(@"task home Failure response %@",response);
        [self clearTheDataSources];
        if ([response[@"errorCode"] isEqualToString:@"01"]) {
            self.tableView.backgroundView = self.noTaskImageView;
           
            [[MBProgressHUDManager instance] requestSuccessWithMessage:response[@"errorMessage"]];
        }else
        {
            self.tableView.backgroundView = self.offlineImageView;
            [[MBProgressHUDManager instance] requestFailAndHideHUD];
        }
       
         [self.tableView reloadData];
        
    }];
    
    
}



- (void)clearTheDataSources
{
    if (self.overTaskMArr.count)
        [self.overTaskMArr removeAllObjects];
    if (self.ongoingTaskMArr.count)
        [self.ongoingTaskMArr removeAllObjects];
    if (self.unstartMTaskArr.count)
        [self.unstartMTaskArr removeAllObjects];
    
    
    
}


#pragma UITableViewDataSource ----Start of line 

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == SegmentedControlTaskSelectedOngoing) {
        
        return  self.ongoingTaskMArr.count;
    }
    if (self.segmentedControl.selectedSegmentIndex == SegmentedControlTaskSelectedUnstart) {
        return self.unstartMTaskArr.count;
    }
    if (self.segmentedControl.selectedSegmentIndex ==
        SegmentedControlTaskSelectedOver) {
        return self.overTaskMArr.count;
        
    }
    return 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    //上、左、下、右的边距
//    return UIEdgeInsetsMake(10,0,0,0 );
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectIndexSegmentController = self.segmentedControl.selectedSegmentIndex;
    
    
    if (selectIndexSegmentController == SegmentedControlTaskSelectedOngoing) {
        OngoingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ongoingTableViewCellIdentifyStr];
//        if (cell == nil) {
//            cell = [[OngoingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ongoingTableViewCellIdentifyStr];
//        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
        if (indexPath.row<_ongoingTaskMArr.count) {
            cell.ongoingTaskModel = _ongoingTaskMArr[indexPath.row];
        }
      
        return cell;
        
    }
    if (selectIndexSegmentController == SegmentedControlTaskSelectedUnstart) {
        
        UnstartedTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:unstartedTaskTableViewCellIdentifyStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
        if (indexPath.row<_unstartMTaskArr.count) {
            cell.unstartTaskModel = _unstartMTaskArr[indexPath.row];
        }
        
        return cell;
        
        
        
    }
    if (selectIndexSegmentController == SegmentedControlTaskSelectedOver) {
        
        OverTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:overTaskTableViewCellIdentifyStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
        if (indexPath.row<_overTaskMArr.count) {
            cell.overTaskModel = _overTaskMArr[indexPath.row];
        }
        return cell;
        
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selected = self.segmentedControl.selectedSegmentIndex;
    
    switch (selected) {
        case SegmentedControlTaskSelectedOngoing:
            
            return (767*SizeScaleSubjectTo750);
            break;
        case SegmentedControlTaskSelectedUnstart:
            
            return (508*SizeScaleSubjectTo750);
            break;
        case SegmentedControlTaskSelectedOver:
            
            return (508*SizeScaleSubjectTo750);
            break;
    }
    return 0;
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"预选");
     NSInteger selected = self.segmentedControl.selectedSegmentIndex;
    switch (selected) {
        case SegmentedControlTaskSelectedOngoing:
            return indexPath;
            break;
        case SegmentedControlTaskSelectedUnstart:
            return nil;
            break;
        case SegmentedControlTaskSelectedOver:
           return indexPath;
            break;
    }

    
    
    return indexPath;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc]init];
    NSInteger selected = self.segmentedControl.selectedSegmentIndex;
    NSString *taskDetailId = nil;
    NSString *taskOverStr = @"0";
    
    OngoingTaskModel *ongoingTaskModel = nil;
    UnstartTaskModel *unstartTaskModel  = nil;
    OverTaskModel *overTaskModel = nil;
    
    NSLog(@"did selected %ld",(long)indexPath.row);
    NSLog(@"did selected ongoingTaskMArr %ld",self.ongoingTaskMArr.count);
    NSLog(@"did selected unstartMTaskArr %ld",self.unstartMTaskArr.count);
    NSLog(@"did selected overTaskMArr %ld",self.overTaskMArr.count);

    switch (selected) {
        case SegmentedControlTaskSelectedOngoing:
            ongoingTaskModel  = _ongoingTaskMArr[indexPath.row];
            taskDetailId = ongoingTaskModel.taskDetailId;
            //taskDetailViewController.taskType = SegmentedControlTaskSelectedOngoing;
            taskOverStr = @"0";
            break;
        case SegmentedControlTaskSelectedUnstart:
            unstartTaskModel  = _unstartMTaskArr[indexPath.row];
            taskDetailId = unstartTaskModel.taskDetailId;
            //taskDetailViewController.taskType = SegmentedControlTaskSelectedUnstart;
            taskOverStr = @"0";
            break;
        case SegmentedControlTaskSelectedOver:
            overTaskModel  = _overTaskMArr[indexPath.row];
            taskDetailId = overTaskModel.taskDetailId;
            taskOverStr = @"1";
            //taskDetailViewController.taskType = SegmentedControlTaskSelectedUnstart;
            break;
    }
    
    
    taskDetailViewController.taskDetailId = taskDetailId;
    taskDetailViewController.isBackBtnShow = YES;
    taskDetailViewController.overFlagStr = taskOverStr;
    taskDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskDetailViewController animated:YES];
    
    
    
    
}




#pragma UITableViewDataSource ----end of line







#pragma lazyload -----start of line


- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:self.segmentDataSourceArr];
        _segmentedControl.frame = CGRectMake750(20,10,710,66);
        [_segmentedControl addTarget:self action:@selector(segmentedControlSelectIndex:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    
    return _segmentedControl;
    
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake750(20,76, 710,990) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TaskThereIsNotActivityBackgroundIamgeView"]];
        [_tableView.backgroundView addSubview:self.taskBuyBikeImageView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;

    }
    return _tableView;
    
}

- (UIImageView *)taskBuyBikeImageView
{
    if (!_taskBuyBikeImageView) {
        _taskBuyBikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(111, 710, 488, 91)];
        _taskBuyBikeImageView.image = [UIImage imageNamed:@"TaskBuyBike"];
    }
    return _taskBuyBikeImageView;
    
    
    
}


- (UIImageView *)offlineImageView
{
    if (!_offlineImageView) {
        _offlineImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0,0, 710,950)];
        _offlineImageView.image = [UIImage imageNamed:@"networkOfflineBaseBackgroundView"];
        [_offlineImageView setUserInteractionEnabled:YES];
        UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake750(221,469, 268, 76)];
        [reloadButton setImage:[UIImage imageNamed:@"networkReloadButtonImage"] forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_offlineImageView addSubview:reloadButton];
    }
    return _offlineImageView;
}


- (UIImageView *)noTaskImageView
{
    if (!_noTaskImageView) {
        _noTaskImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0,0, 710,950)];
        _noTaskImageView.image = [UIImage imageNamed:@"TaskThereIsNotActivityBackgroundShopImageView"];
       
    }
    return _noTaskImageView;
}


//TaskThereIsNotActivityBackgroundBaseImageView
- (UIImageView *)baseImageView
{
    if (!_baseImageView) {
        _baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0,0, 710,950)];
        _baseImageView.image = [UIImage imageNamed:@"TaskThereIsNotActivityBackgroundBaseImageView"];
        
    }
    return _baseImageView;
}



- (UIImageView *)onTheRoadImageView
{
    if (!_onTheRoadImageView) {
        _onTheRoadImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(0,0, 710,950)];
        _onTheRoadImageView.image = [UIImage imageNamed:@"TaskThereIsNotActivityBackgroundOnTheRoadImageView"];
        
    }
    return _onTheRoadImageView;
}


- (UIView *)baseBackgroundView
{
    if (!_baseBackgroundView) {
        _baseBackgroundView = [[UIView alloc]initWithFrame:CGRectMake750(0, 0, 710, 990)];
        _baseBackgroundView.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:1.0];
        
    }
    return _baseBackgroundView;
 
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
