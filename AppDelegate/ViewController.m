//
//  ViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "ViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface ViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置用户Key
    //[MAMapServices sharedServices].apiKey = kGAODELBS_KEY;
    
    [AMapServices sharedServices].apiKey = kGAODELBS_KEY;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
