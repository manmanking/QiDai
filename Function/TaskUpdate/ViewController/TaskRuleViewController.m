//
//  TaskRuleViewController.m
//  QiDai
//
//  Created by manman'swork on 16/11/4.
//  Copyright © 2016年 manman. All rights reserved.
//

#import "TaskRuleViewController.h"
#import "UIImageView+WebCache.h"

#import "TaskStandardDetailView.h"

@interface TaskRuleViewController ()

@property (nonatomic,strong)UIScrollView *backgroundScrollView;

@property (nonatomic,strong)TaskStandardDetailView *taskStandardDetailView;



@property (nonatomic,strong) UIImageView *myOutfitOfBikeInfoImageView;

@end

@implementation TaskRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationView];
    [self.view addSubview:self.backgroundScrollView];
    
    
    [self.backgroundScrollView addSubview:self.taskStandardDetailView];
    self.taskStandardDetailView.taskDetailDescripModel = _taskRuleModel;
    NSLog(@"task detail info %@",_taskRuleModel.helpPageImage);
    [self.myOutfitOfBikeInfoImageView sd_setImageWithURL:[NSURL URLWithString:_taskRuleModel.helpPageImage] placeholderImage:[UIImage imageNamed:@"taskDetailInfoNew"]];
    [self.backgroundScrollView addSubview:self.myOutfitOfBikeInfoImageView];
    
   // [self.taskStandardDetailView customUIView:@"2"];
    
    
}

- (void)setupNavigationView {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_image"] forBarMetrics:UIBarMetricsDefault];
    [self creatTitleViewWithString:@"挑战规则"];
   // [self creatShareBtn];
    
}






- (UIScrollView *)backgroundScrollView
{
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _backgroundScrollView.backgroundColor = [UIColor blackColor];
        
    }
    return _backgroundScrollView;    
}


- (TaskStandardDetailView *)taskStandardDetailView
{
    if (!_taskStandardDetailView) {
        _taskStandardDetailView = [[TaskStandardDetailView alloc]initWithFrame:CGRectMake750(20,0, 710, 730)];
        
        
    }
    return _taskStandardDetailView;
    
}

- (UIImageView *)myOutfitOfBikeInfoImageView
{
    if (!_myOutfitOfBikeInfoImageView) {
        _myOutfitOfBikeInfoImageView = [[UIImageView alloc]initWithFrame:CGRectMake750(20,713, 710,496)];
        //_myOutfitOfBikeInfoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _myOutfitOfBikeInfoImageView.image = [UIImage imageNamed:@"taskDetailInfoNew"];
    }
    
    return _myOutfitOfBikeInfoImageView;
    
    
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
