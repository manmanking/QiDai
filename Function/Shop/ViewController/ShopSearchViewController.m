//
//  ShopSearchViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ShopSearchViewController.h"
#import "HotSeachView.h"
#import "SeachHistoryView.h"
#import "ShopShowViewController.h"
#import "ReactiveCocoa.h"
@interface ShopSearchViewController ()<UITextFieldDelegate>
/** 导航栏中间的搜索框*/
@property (nonatomic,strong) UITextField *seachTextField;
/** 热门搜索的数据源（网络请求）*/
@property (nonatomic,strong) NSMutableArray *hotSeachArrayM;
/** 热门搜索view*/
@property (nonatomic,strong) HotSeachView *hotSeachView;
/** 历史搜索view*/
@property (nonatomic,strong) SeachHistoryView *historyView;
/** 导航栏搜索的btn*/
@property (nonatomic,strong) UIButton *searchBtn;
/** 导航栏取消的btn*/
@property (nonatomic,strong) UIButton *cancleBtn;
@end

@implementation ShopSearchViewController
#pragma mark --- life cycle
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.seachTextField resignFirstResponder];
     [MobClick endLogPageView:kSearchHome];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kSearchHome];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _hotSeachArrayM = @[].mutableCopy;
    
    [self setupNavigationView];
    [self setupView];

    
    

    
    [self getSeachData];
    // Do any additional setup after loading the view.
}



#pragma mark --- ui
- (void)setupNavigationView {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancleBtn];
    self.navigationItem.titleView = self.seachTextField;
}
- (void)setupView {
    [self.view addSubview:self.hotSeachView];
    
    NSArray* getHistoryArr=[kNSUSERDEFAULE objectForKey:kSHOPSEACHHISTORY];
    if (getHistoryArr.count == 0) {
        
    } else {
        self.hotSeachView.top = 412*SizeScaleSubjectTo720;
        //SeachHistoryView *historyView = [[SeachHistoryView alloc]initWithFrame:CGRectMake720(0, 0, 720, 412)];
        [self.view addSubview:self.historyView];
        [self.historyView setupViewWithArray:getHistoryArr];
    }
    
}
#pragma mark --- interface
/** 取热门搜索的数据*/
- (void)getSeachData {
    [QDHttpTool getWithURL:kUrl_hotsearch params:nil success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"%@",responseObject);
        NSArray *array = [responseObject valueForKey:@"data"];
        
        for (NSDictionary *dic in array) {
            [_hotSeachArrayM addObject:[dic valueForKey:@"name"]];
        }
        [self.hotSeachView setupViewWithArray:_hotSeachArrayM];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark --- private method
/** 点击搜索按钮*/
- (void)clickSearchBtnWithTitle:(NSString *)title {
    NSArray* getHistoryArr = [kNSUSERDEFAULE objectForKey:kSHOPSEACHHISTORY];
    NSMutableArray *arrayM = @[].mutableCopy;
    if (getHistoryArr.count == 0) {
        [arrayM addObject:title];
    } else {
        [arrayM addObjectsFromArray:getHistoryArr];
        if (![arrayM containsObject:title]) {
            
            if (arrayM.count >= 6) {
                [arrayM removeObjectAtIndex:0];
            }

            [arrayM addObject:title];
        }
    }
    
    [kNSUSERDEFAULE setObject:arrayM forKey:kSHOPSEACHHISTORY];
    [kNSUSERDEFAULE synchronize];
    
    ShopShowViewController *vc = [[ShopShowViewController alloc]init];
    vc.isBackBtnShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.titleStr = @"搜索";
    vc.searchTitle = title;
    vc.status = ShopShowSearch;
    [self.navigationController pushViewController:vc animated:YES];
    
}
/** 清除历史记录*/
- (void)clickClearHistoryBtn {
    [kNSUSERDEFAULE removeObjectForKey:kSHOPSEACHHISTORY];
    [kNSUSERDEFAULE synchronize];
    [UIView animateWithDuration:0.5 animations:^{
        self.historyView.left = HCDW;
        self.hotSeachView.top = 0;
    }];
}
/** 热门搜索或者历史搜索上的按钮的点击事件，点击跳转*/
- (void)clickHotSearchBtnWithTitle:(NSString *)title {
    [self clickSearchBtnWithTitle:title];
}
/** 导航栏改变*/
- (void)textFieldDidChange {
    if (self.seachTextField.text.length > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancleBtn];
    }
}
#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
/** 导航栏右边的按钮，点击搜索*/
- (void)clickRightBtn {
    [self.seachTextField resignFirstResponder];
    if (![self.seachTextField.text isExist]) {
        [[MBProgressHUDManager instance] showTextOnlyWithView:kGetKeyWindow withText:@"请输入搜索内容"];
        return ;
    }
    
    [self clickSearchBtnWithTitle:self.seachTextField.text];
}
#pragma mark --- UITextField Delegate
/** 点击空白收键盘*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.seachTextField resignFirstResponder];
}

#pragma mark --- lazy load
- (UITextField *)seachTextField {
    if (!_seachTextField) {
        _seachTextField = [[UITextField alloc]initWithFrame:CGRectMake720(0, 0, 560, 60)];
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake720(0, 0, 77, 60)];
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(20, 17, 26, 26)];
        leftImageView.image = [UIImage imageNamed:@"shop_seach_btn"];
        [paddingView addSubview:leftImageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake720(63, 17, 2, 26)];
        lineView.backgroundColor = kColorFor666;
        [paddingView addSubview:lineView];
        
        _seachTextField.leftView = paddingView;
        _seachTextField.leftViewMode = UITextFieldViewModeAlways;
        _seachTextField.backgroundColor = UIColorFromRGB_16(0x1c1c1c);
        _seachTextField.placeholder = @"输入搜索的内容";
        _seachTextField.layer.cornerRadius = 10*SizeScaleSubjectTo720;
        _seachTextField.delegate = self;
        _seachTextField.textAlignment = NSTextAlignmentLeft;
        _seachTextField.textColor = kColorForfff;
        _seachTextField.font = UIFontOfSize720(24);
        [_seachTextField setValue:UIColorFromRGB_16(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        UIFont *font = UIFontOfSize720(24);
        _seachTextField.font = font;
        [_seachTextField setValue:font forKeyPath:@"_placeholderLabel.font"];
        _seachTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_seachTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _seachTextField;
}
- (HotSeachView *)hotSeachView {
    if (!_hotSeachView) {
        _hotSeachView = [[HotSeachView alloc]initWithFrame:CGRectMake720(0, 0, 720, 412)];
        @weakify_self
        _hotSeachView.clickHotSeachBtnBlock = ^(NSString *text){
            @strongify_self
            [self clickHotSearchBtnWithTitle:text];
        };
    }
    return _hotSeachView;
}
- (SeachHistoryView *)historyView {
    if (!_historyView) {
        _historyView = [[SeachHistoryView alloc]initWithFrame:CGRectMake720(0, 0, 720, 412)];
        @weakify_self
        _historyView.clickClearBtnBlock = ^{
            @strongify_self
            [self clickClearHistoryBtn];
        };
        _historyView.clickHotSeachBtnBlock = ^(NSString *text){
            @strongify_self
            [self clickHotSearchBtnWithTitle:text];
        };
    }
    return _historyView;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setFrame:CGRectMake720(0,0,80,54)];
        _searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26*SizeScale];
        [_searchBtn setContentMode:UIViewContentModeRight];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:kColorForfff forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setFrame:CGRectMake720(0,0,80,54)];
        _cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26*SizeScale];
        [_cancleBtn setContentMode:UIViewContentModeRight];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:kColorForfff forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
