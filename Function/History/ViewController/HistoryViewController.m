//
//  HistoryViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/29.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryManager.h"
#import "HistoryManager.h"
#import "SportModel.h"
#import "MJRefresh.h"
#import "HistoryStatisticsViewController.h"
#import "HistoryDetailViewController.h"
#import "SynchronizeRidingRecordManager.h"
#import "SportDataBaseManager.h"
#import "UploadFileManager.h"
#import "HistoryNetworkingManager.h"
@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL _upload;
    BOOL _uploadDetail;
}
/** 呈现列表*/
@property (nonatomic,strong) UITableView *tableView;
/** 历史数据的管理者*/
@property (nonatomic,strong) HistoryManager *dataManager;
/** 当前的page*/
@property (nonatomic,assign) NSInteger pageIndex;
/** 数据的个数，用途是决定tableView的cell的个数*/
@property (nonatomic,assign) NSInteger dataSourceCount;
/** 存放月份的数组*/
@property (nonatomic,copy) NSMutableArray *monthArrayM;
/** section距离的数组*/
@property (nonatomic,strong) NSMutableArray *sectionDistanceArrayM;
/** section日期的数组*/
@property (nonatomic,strong) NSMutableArray *sectionDateArrayM;
/** scetion的数据*/
@property (strong,nonatomic) NSMutableDictionary *headersData;

@end
static NSString *const kHistoryTableViewCell = @"HistoryTableViewCell";

@implementation HistoryViewController
#pragma mark --- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadMoreDataSource];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTitleViewWithString:@"历史骑行"];
    //[self creatRightBtnWithImage:@"history_statistical"];
    
    _dataManager = [[HistoryManager alloc]init];
    _pageIndex = 0;
    _dataSourceCount = 0;
    _upload = NO;
    _uploadDetail = NO;
    _monthArrayM = @[].mutableCopy;
    
    _headersData = @{}.mutableCopy;
    
    _sectionDateArrayM = @[].mutableCopy;
    _sectionDistanceArrayM = @[].mutableCopy;
    
    //self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //[self loadMoreDataSource];
    // Do any additional setup after loading the view.
    [self getRidingRecordFromNetworing];
    
    
}

- (void)getRidingRecordFromNetworing
{
   [HistoryNetworkingManager networkingGetRidingRecordDataSource:kUserId andSuccessBlock:^(BOOL isSuccess, NSDictionary *response) {
       NSLog(@"success getRidingRecordFromNetworing %@",response);
   } andFailureBlock:^(BOOL isSuccess, NSDictionary *response) {
       NSLog(@"failure getRidingRecordFromNetworing %@",response);
   }];
    
    
    
}



- (void)clickBackBtn {
    //[self creatRippleEffectTransitionAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBtn {
    HistoryStatisticsViewController *vc = [[HistoryStatisticsViewController alloc]init];
    vc.isBackBtnShow = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- private method
/** 下拉刷新更多*/
- (void)loadMoreData {
    [self loadMoreDataSource];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_footer endRefreshing];
    });
    
}
/** 下拉刷新更多的具体实现方法*/
- (void)loadMoreDataSource {
    
    static BOOL isEmpty = NO;
    
    if (_monthArrayM.count) {
        [_monthArrayM removeAllObjects];
    }
    
    [_monthArrayM addObjectsFromArray:[_dataManager loadMonthSportDataWithPageIndex:_pageIndex] ];
    //[_monthArrayM addObjectsFromArray: array];
    
    
    if (_monthArrayM.count == 0) {
        isEmpty = YES;
    }else {
        
        [_headersData setValue:_monthArrayM.copy forKey:[NSString stringWithFormat: @"%ld", (long)_dataSourceCount]];
        //NSLog(@"%@",_headersData);
        [_sectionDateArrayM addObject:[_dataManager getcurrentMonthWithSection:_pageIndex] ];
        [_sectionDistanceArrayM addObject:[_dataManager getTotalDistanceWithSection:_pageIndex] ];
        _dataSourceCount++;
        //_dataSourceCount
        [_tableView reloadData];
    }
    _pageIndex++;
    
    if ([_dataManager hadLoadAllData]||_pageIndex >= 50) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        //_tableView.tableFooterView = nil;
    }else {
        if (isEmpty) {
            isEmpty = NO;
            [self loadMoreDataSource];
        }
    }
    
}
- (void)uploadSportModel:(SportModel *)sportModel cell:(HistoryTableViewCell *)cell{
    
    //[[LoadingViewManager instance] showLoadingView];
    
    NSString *sid = sportModel.sId;
    
    
    //@weakify_self
    
    //上传骑行数据
//    [SynchronizeRidingRecordManager uploadRidingRecord:sportModel success:^{
//        @strongify_self
//        [SportDataBaseManager updateUpLoadStatusWithUserId:[[LoginManager instance] getUserId] sportId:sid];
//        //weakself->_upload = @"YES";
//        //[weakself uploadDoneWithSportModel:sportModel cell:cell];
//    } failure:^{
//        //weakself->_upload = @"NO";
//        //[weakself uploadDoneWithSportModel:sportModel cell:cell];
//    }];
    
    [SynchronizeRidingRecordManager uploadRidingRecord:sportModel pictureArray:nil success:^(NSDictionary *result) {
        [SportDataBaseManager updateUpLoadStatusWithUserId:[[LoginManager instance] getUserId] sportId:sid];
        _upload = YES;
        [self uploadDoneWithSportModel:sportModel cell:cell];
    } failure:^{
        
    }];
    
    
    //把每个定位点的数据压缩到zip 文件中 并上传到服务器
    [UploadFileManager zipAndUploadItemFileWithFileName:sid success:^{
        [SportDataBaseManager updateUpLoadDetailStatusWithUserId:[[LoginManager instance] getUserId] sportId:sid];
        _uploadDetail = YES;
        [self uploadDoneWithSportModel:sportModel cell:cell];
       [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATAHISTORY_NOTIFICATION object:nil];
    } failure:^{

    }];
}
- (void)uploadDoneWithSportModel:(SportModel *)sportModel cell:(HistoryTableViewCell *)cell{
    if (_upload && _uploadDetail) {

        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        //[cell loadCellWithSportModel:sportModel];
        sportModel.upload = 1;
        sportModel.uploadDetail = 1;
        cell.sportModel = sportModel;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        _upload = NO;
        _uploadDetail = NO;
    }
    
}
#pragma mark --- tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [_headersData valueForKey:[NSString stringWithFormat:@"%ld", (long)section] ];
    return array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSourceCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryTableViewCell];
    if (cell == nil) {
        cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHistoryTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = [_headersData valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section] ];
    SportModel *model = array[indexPath.row];
    cell.sportModel = model;
    @weakify_self
    cell.clickUploadBtnBlock = ^(SportModel *sportModel,HistoryTableViewCell *historyTableViewCell) {
        @strongify_self
        [self uploadSportModel:sportModel cell:historyTableViewCell];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 92)];
    sectionView.backgroundColor = UIColorFromRGB_16(0x171717);
    UIImageView *leftIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake720(20, 0, 30, 32)];
    leftIamgeView.centerY = sectionView.centerY;
    leftIamgeView.image = [UIImage imageNamed:@"history_section_icon"];
    [sectionView addSubview:leftIamgeView];
    UILabel *monthLabel = [UILabel qd_labelWithFrame:CGRectMake720(50, 0 , 150, 92) title:_sectionDateArrayM[section] titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:40];
    [sectionView addSubview:monthLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(550, 34, 24, 24)];
    rightImageView.image = [UIImage imageNamed:@"history_section_distance"];
    [sectionView addSubview:rightImageView];
    UILabel *distanceLabel = [UILabel qd_labelWithFrame:CGRectMake720(600, 0 , 120, 92) title:_sectionDistanceArrayM[section] titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:20];
    [sectionView addSubview:distanceLabel];
    
    return sectionView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryDetailViewController *vc = [[HistoryDetailViewController alloc]init];
    vc.isBackBtnShow = YES;
    NSArray *array = [_headersData valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section] ];
    vc.sportModel = array[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.rowHeight = 174*SizeScaleSubjectTo720;
        _tableView.sectionHeaderHeight = 92*SizeScaleSubjectTo720;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            _tableView.height -= 64;
        }
    }
    return _tableView;
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
