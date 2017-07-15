//
//  AccountTableViewController.m
//  Leqi
//
//  Created by 张汇丰 on 16/1/11.
//  Copyright © 2016年 com.hoolai. All rights reserved.
//

#import "AccountTableViewController.h"
#import "AccountTableViewCell.h"
#import "UserInfoModel.h"
#import "UserInfoDBManager.h"
#import "MineEditViewController.h"
#import "PickViewManager.h"
#import "UpdateUserManager.h"
#import "UIButton+WebCache.h"
#import "ShowCameraManager.h"
#import "UploadImageManager.h"
#import "MBProgressHUDManager.h"
#import "UserInfoManager.h"
@interface AccountTableViewController ()
{
    /** 头像的button*/
    UIButton *_portraitButton;
    
    //列表的数据，1，2代表的是section
    NSMutableArray *_dataSourceArray1;
    NSMutableArray *_dataSourceArray2;
    NSMutableArray *_dataSourceArray3;
    //列表的头数组  1，2代表的是section
    NSMutableArray *_rowArray1;
    NSMutableArray *_rowArray2;
    NSMutableArray *_rowArray3;
    
    /** 上个界面是否需要刷新*/
    BOOL _isNeedRefresh;
}
/** 中间过渡的model*/
@property (nonatomic,strong) UserInfoModel *userInfo_save;
/** 编辑页面的vc*/
@property (nonatomic,strong) MineEditViewController *editVC;

@end

static NSString *const kAccountTableViewCellIdentifier = @"AccountTableViewCell";
static CGFloat const kAccountTableViewCellHeight = 110;

@implementation AccountTableViewController

#pragma mark --- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUserInfoDataSource];
    [self.tableView reloadData];
    //self.navigationController.hidesBottomBarWhenPushed = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];  
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

- (void)getUserBaseInfoFormNetwork
{
    [UserInfoManager saveUserBaseInfo:[[LoginManager instance] getUserId]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackBtn];
    [self loadTitleView];
    _dataSourceArray1 = @[].mutableCopy;
    self.navigationController.navigationBarHidden = NO;
    _rowArray1 = @[@"昵称",@"性别",@"身高",@"体重",@"生日"].mutableCopy;
    _dataSourceArray2 = @[].mutableCopy;
    _rowArray2 = @[@"手机",@"邮箱"].mutableCopy;
    _dataSourceArray3 = @[].mutableCopy;
    
    [self setupUserInfoDataSource];
    self.view.backgroundColor = UIColorFromRGB_16(0x171717);
    self.tableView.backgroundColor = UIColorFromRGB_16(0x171717);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self setupHeaderView];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark --- UI
- (void)loadTitleView {
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake720(0,0,300,54)];
    textLabel.text = @"账号管理";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:36*SizeScale];
    textLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = textLabel;
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB_10(22, 25, 33);
}
- (void)loadBackBtn {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    UIButton *backBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(0, 0, 60, 60) NormalBackgroundImageString:@"" tapAction:^(UIButton *button) {
        [self clickBackBtn:nil];
    }];
    [backBtn setEnlargeEdge:20*SizeScale];
    [backBtn setImage:[UIImage imageNamed:@"reset_back_image"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
- (UIView *)setupHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 230)];
    headerView.backgroundColor = [UIColor blackColor];
    #pragma mark --- 更换头像
    _portraitButton = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(280, 40, 160, 160) NormalBackgroundImageString:@"head_portrait_btn" tapAction:^(UIButton *button) {
        [self clickChangePortrait];
    }];
    //[_portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:portraitUrl] forState:UIControlStateNormal];
    [_portraitButton setRoundedCorners:UIRectCornerAllCorners radius:160/2*SizeScaleSubjectTo720 ];
    [headerView addSubview:_portraitButton];
    return headerView;
    
}
#pragma mark --- dataSource
- (void)setupUserInfoDataSource {
    UserInfoModel *userInfo = [UserInfoDBManager getUserInfoWithUserId:kUserId];

    self.userInfo_save = userInfo;
    
    //NSLog(@"%@",kUserId);
    if (_dataSourceArray1.count) {
        [_dataSourceArray1 removeAllObjects];
    }
    if (_dataSourceArray2.count) {
        [_dataSourceArray2 removeAllObjects];
    }
    if (_dataSourceArray3.count) {
        [_dataSourceArray3 removeAllObjects];
    }
    [_dataSourceArray1 addObjectsFromArray:@[userInfo.nickName, userInfo.gender, userInfo.height, userInfo.weight, userInfo.birthday]];
    
    if ([[LoginManager instance] LoginTypeStatus] == telephoneType) {
        //[_dataSourceArray2 addObjectsFromArray:@[userInfo.phoneNo, userInfo.email]];
        
        _rowArray3 = @[@"修改密码"].mutableCopy;
        [_dataSourceArray3 addObjectsFromArray:@[userInfo.password]];
        
    } else {

        [_dataSourceArray2 addObjectsFromArray:@[userInfo.phoneNo, userInfo.email]];
    }

    [_portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.foreImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_portrait_btn"]];
}
- (void)clickBackBtn:(id)sender {
    if (_isNeedRefresh) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshPersonalInformation)]) {
            [self.delegate refreshPersonalInformation];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[LoginManager instance] LoginTypeStatus] == telephoneType) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataSourceArray1.count;
    } else if (section == 1) {
        return _dataSourceArray2.count;
    } else {
        return _dataSourceArray3.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAccountTableViewCellIdentifier];
    if (!cell) {
        cell = [[AccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAccountTableViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleStr = [self getRowAryWith:indexPath][indexPath.row];
    NSString *detailStr = [self getValueAryWith:indexPath][indexPath.row];
    
    NSLog(@"titleStr %@  detailStr%@",titleStr,detailStr);
    
    [cell showDataWithTitle:[NSString stringWithFormat:@"%@",titleStr] detail:[NSString stringWithFormat:@"%@",detailStr]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kAccountTableViewCellHeight * SizeScaleSubjectTo720;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self clickRow:indexPath.row];
    
    _isNeedRefresh = YES;
    
    if (indexPath.section == 0) {
        [self clickSection0_Row:indexPath.row];
    } else if (indexPath.section == 1) {
        [self clickSection1_Row:indexPath.row];
    } else {
        MineEditViewController *editVC = [[MineEditViewController alloc]init];
        //_editVC.leftKey = [self getRowAryWith:indexPath][indexPath.row];
        //_editVC.rightValue = [NSString stringWithFormat:@"%@",[self getValueAryWith:indexPath][indexPath.row]];
        editVC.isBackBtnShow = YES;
        editVC.editType = EditPassword;
        [self.navigationController pushViewController:editVC animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 720, 20)];
    view.backgroundColor = UIColorFromRGB_16(0x171717);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20*SizeScaleSubjectTo720;
}
#pragma mark --- private methods
- (void)clickSection0_Row:(NSInteger)row {
    CGRect rect = [UIScreen mainScreen].bounds;
    switch (row) {
        case 0:
        {
            self.editVC.editType = EditName;
            self.editVC.userInfoModel = self.userInfo_save;
            self.editVC.leftKey = _rowArray1[row];
            self.editVC.rightValue = [NSString stringWithFormat:@"%@",_dataSourceArray1[row] ];
            [self.navigationController pushViewController:self.editVC animated:YES];
            break;
        }
        case 1:
        {
            NSInteger count = [self.userInfo_save.gender integerValue];
            
            if (count == 0) {
                [_dataSourceArray1 replaceObjectAtIndex:row withObject:@"美女"];
                count ++;
            }else{
                [_dataSourceArray1 replaceObjectAtIndex:row withObject:@"帅哥"];
                count --;
            }
            self.userInfo_save.gender = @(count);
            [self.tableView reloadData];
            [self saveUserData];
            //[[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"保存成功"];
            break;
        }
        case 2:
        {
            [PickViewManager commonPickViewWithFrame:rect
                                           superView:MAIN_WINDOW
                                        pickViewType:HeightPicker
                                         currentData:@"165"
                                   okCompletionBlock:^(NSInteger data) {
                                       self.userInfo_save.height = @(data);
                                       [_dataSourceArray1 replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%ld",(long)data]];
                                       [self.tableView reloadData];
                                       self.tabBarController.tabBar.hidden = NO;
                                       [self saveUserData];
                                       //[[MBProgressHUDManager instance] showTextOnlyWithView:self.navigationController.view withText:@"保存成功"];
                                       
                                   } cancelBlock:^(NSInteger data) {
                                       self.tabBarController.tabBar.hidden = YES;
                                   }];
            self.tabBarController.tabBar.hidden = NO;
            break;
        }
        case 3:
        {
            [PickViewManager commonPickViewWithFrame:rect
                                           superView:MAIN_WINDOW
                                        pickViewType:WeightPicker
                                         currentData:@"60"
                                   okCompletionBlock:^(NSInteger data) {
                                       self.userInfo_save.weight = @(data);
                                       [_dataSourceArray1 replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%ld",(long)data]];
                                       [self.tableView reloadData];
                                       self.tabBarController.tabBar.hidden = NO;
                                       [kNSUSERDEFAULE setValue:self.userInfo_save.weight forKey:kCLOCKWEIGHT];
                                       [self saveUserData];
                                       
                                   } cancelBlock:^(NSInteger data) {
                                       self.tabBarController.tabBar.hidden = YES;
                                   }];
            self.tabBarController.tabBar.hidden = NO;
            break;
        }
        case 4:
        {
            [PickViewManager datePickViewWithFrame:rect
                                           current:nil
                                         superView:MAIN_WINDOW
                                 okCompletionBlock:^(NSDate *date) {
                                     self.userInfo_save.birthday = @([date timeIntervalSince1970]);
                                     [_dataSourceArray1 replaceObjectAtIndex:row withObject:@([date timeIntervalSince1970])];
                                     [self.tableView reloadData];
                                     self.tabBarController.tabBar.hidden = YES;
                                     [self saveUserData];
                                     
                                 } cancelBlock:^(NSDate *date) {
                                     self.tabBarController.tabBar.hidden = YES;
                                 }];
            self.tabBarController.tabBar.hidden = NO;
            break;
        }
        default:
            break;
    }

}

- (void)clickSection1_Row:(NSInteger)row {
    switch (row) {
        case 0:
            if ([[LoginManager instance] LoginTypeStatus] == telephoneType) {
                
            }else {
                self.editVC.editType = EditName;
                self.editVC.userInfoModel = self.userInfo_save;
                self.editVC.leftKey = _rowArray2[row];
                self.editVC.rightValue = [NSString stringWithFormat:@"%@",_dataSourceArray2[row] ];
                [self.navigationController pushViewController:self.editVC animated:YES];
            }
            break;
        case 1:
            self.editVC.editType = EditName;
            self.editVC.userInfoModel = self.userInfo_save;
            self.editVC.leftKey = _rowArray2[row];
            self.editVC.rightValue = [NSString stringWithFormat:@"%@",_dataSourceArray2[row] ];
            [self.navigationController pushViewController:self.editVC animated:YES];
            break;
        default:
            break;
    }
}
- (NSArray *)getValueAryWith:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return _dataSourceArray1;
            break;
        case 1:
            return _dataSourceArray2;
            break;
        case 2:
            return _dataSourceArray3;
            break;
        default:
            return nil;
            break;
    }
}
- (NSArray *)getRowAryWith:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return _rowArray1;
            break;
        case 1:
            return _rowArray2;
            break;
        case 2:
            return _rowArray3;
            break;
        default:
            return nil;
            break;
    }
}

- (void)clickChangePortrait {
    
    [[ShowCameraManager instance] showActionForForeSheetInTabbar:self.tabBarController.tabBar inViewController:self compate:^(NSString *imgStr) {
        
        [_portraitButton setBackgroundImage:[UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:imgStr]] forState:UIControlStateNormal];
        
         //上传头像到服务器
        [UploadImageManager uploadImageWithImagePath:[NSHomeDirectory() stringByAppendingPathComponent:imgStr] compate:^(BOOL isSuccess, NSString *errStr, NSString *newUrl) {
            if (isSuccess) {
                if ([newUrl isExist]) {
                    self.userInfo_save.foreImg = newUrl;
                    [self saveUserData];
                }
               [_portraitButton sd_setBackgroundImageWithURL:[NSURL URLWithString:newUrl] forState:UIControlStateNormal];
            } else {
                
            }
        }];
    }];
    
}

- (void)saveUserData
{
    if (![[LoginManager instance] isLogin]) {
        return;
    }
    self.userInfo_save.userId = [[LoginManager instance] getUserId];
    [UserInfoDBManager updateUserInfo:self.userInfo_save];

    [[MBProgressHUDManager instance] showHUDLoadingView:self.navigationController.view];
    
    
    [UpdateUserManager updateUser:self.userInfo_save
                          compate:^(BOOL isSuccess, NSString *errStr, NSDictionary *result) {
                              if (isSuccess) {
                                
                                  [MBProgressHUDManager instance].hud.labelText = @"保存成功";
                                  [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
                              } else {
                                  
                                  [MBProgressHUDManager instance].hud.labelText = @"保存失败";
                                  [[MBProgressHUDManager instance] hideHUDLoadingViewAfterHalfSecond];
                                  
                              }
                          }];
    _isNeedRefresh = YES;
    [UserInfoDBManager updateUserInfo:self.userInfo_save];
}
#pragma mark --- get
- (MineEditViewController *)editVC {
    if (!_editVC) {
        _editVC = [[MineEditViewController alloc]init];
        //_editVC.leftKey = [self getRowAryWith:indexPath][indexPath.row];
        //_editVC.rightValue = [NSString stringWithFormat:@"%@",[self getValueAryWith:indexPath][indexPath.row]];
        _editVC.isBackBtnShow = YES;
    }
    return _editVC;
}

@end
