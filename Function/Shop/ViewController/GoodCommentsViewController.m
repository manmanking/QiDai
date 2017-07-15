//
//  GoodCommentsViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/7/9.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  商品评价

#import "GoodCommentsViewController.h"
#import "CommentUtil.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "GoodCommentHeaderView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface GoodCommentsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //好中差图 的数组
    NSMutableArray *_goodArrayM;
    /** 中评的数组*/
    NSMutableArray *_commonArrayM;
    /** 坏评的数组*/
    NSMutableArray *_badArrayM;
    /** 图片评的数组*/
    NSMutableArray *_imageArrayM;
    /** 临时，用于tableView的数据*/
    NSMutableArray *_tempArrayM;
    
}
/** 列表*/
@property (nonatomic,strong) UITableView *tableView;
/** headerView*/
@property (nonatomic,strong) GoodCommentHeaderView *headerView;
@end

@implementation GoodCommentsViewController

static NSString *const kTableViewCell = @"kCommentTableViewCell";



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kGoodsEvaluation];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kGoodsEvaluation];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTitleViewWithString:@"商品评价"];
    
    _tempArrayM = @[].mutableCopy;
    [_tempArrayM addObjectsFromArray:self.commentArray];
    
    [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:kTableViewCell];
    [self.view addSubview:self.tableView];
    self.headerView.goodRate = self.goodRate;
    [self.headerView.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.bikeUrl]];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //self.tableView.mj_footer = [mj]
    [self getCommentMessage];
    // Do any additional setup after loading the view.
}
#pragma mark --- interface
/**
 *  请求评价的数据
 *
 *  @param page 1好评，2中评，3差评，4图，0也可为空
 */
- (void)getCommentDataSourceWithPage:(NSInteger)page {
    if (![self.modelId isExist]) {
        self.modelId = @"";
    }
    if (_tempArrayM.count) {
        [_tempArrayM removeAllObjects];
    }
    
    switch (page) {
        case 0:
            [_tempArrayM addObjectsFromArray:self.commentArray];
            [self.tableView reloadData];
            return;
            break;
        case 1:
            if (_goodArrayM) {
                [_tempArrayM addObjectsFromArray:_goodArrayM];
                [self.tableView reloadData];
                return;
            }
            _goodArrayM = @[].mutableCopy;
            break;
        case 2:
            if (_commonArrayM) {
                [_tempArrayM addObjectsFromArray:_commonArrayM];
                [self.tableView reloadData];
                return;
            }
            _commonArrayM = @[].mutableCopy;
            break;
        case 3:
            if (_badArrayM) {
                [_tempArrayM addObjectsFromArray:_badArrayM];
                [self.tableView reloadData];
                return;
            }
            _badArrayM = @[].mutableCopy;
            break;
        case 4:
            if (_imageArrayM) {
                [_tempArrayM addObjectsFromArray:_imageArrayM];
                [self.tableView reloadData];
                return;
            }
            _imageArrayM = @[].mutableCopy;
            break;
        default:
            break;
    }
    
    //查询评价    status：1好评，2中评，3差评，4图，0也可为空    type:2为商品评价，1为活动评价
    NSDictionary *brandParam = @{@"type":@"2",
                                 @"modelId":self.modelId,
                                 @"start":@"0",
                                 @"status":@(page)};
    [QDHttpTool getWithURL:kUrl_getComment params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        NSArray *commentArray = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        switch (page) {
            case 1:
                [_goodArrayM addObjectsFromArray:commentArray];
                [_tempArrayM addObjectsFromArray:_goodArrayM];
                break;
            case 2:
                [_commonArrayM addObjectsFromArray:commentArray];
                [_tempArrayM addObjectsFromArray:_commonArrayM];
                break;
            case 3:
                [_badArrayM addObjectsFromArray:commentArray];
                [_tempArrayM addObjectsFromArray:_badArrayM];
                break;
            case 4:
                [_imageArrayM addObjectsFromArray:commentArray];
                [_tempArrayM addObjectsFromArray:_imageArrayM];
                break;
            default:
                break;
        }

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
/** 获取好中差的评论数*/
- (void)getCommentMessage {
    //查询评价的好中差的数量    type:2为商品评价，1为活动评价
    NSDictionary *brandParam = @{@"type":@"2",
                                 @"modelId":self.modelId};
    [QDHttpTool getWithURL:kUrl_getCommonMessage params:brandParam success:^(BOOL isSuccess, NSDictionary *responseObject) {
        NSLog(@"---%@",responseObject);
        
        NSArray *titleArray = @[self.totalComment,responseObject[@"good"],responseObject[@"common"],responseObject[@"bad"],responseObject[@"image"]];
        self.headerView.titleArray = titleArray;
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark --- private mehtod
#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---
#pragma mark --- UITableVIew Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tempArrayM.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell];
    cell.model = _commentArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentUtil *util = [[CommentUtil alloc]init];
    util.model = _commentArray[indexPath.row];
    return util.cellHeight;
}

#pragma mark --- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.height = self.view.height - 64 ;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (GoodCommentHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[GoodCommentHeaderView alloc]initWithFrame:CGRectMake720(0, 0, 720, 290)];
        @weakify_self
        _headerView.clickBtnBlock = ^(NSInteger page){
            @strongify_self
            [self getCommentDataSourceWithPage:page];
        };
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
