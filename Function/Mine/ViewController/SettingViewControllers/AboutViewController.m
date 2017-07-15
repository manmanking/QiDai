//
//  AboutViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/31.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTitleViewWithString:@"关于骑待"];

    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HCDW, HCDH)];
    backgroundView.image = [UIImage imageNamed:@"aboutBackground"];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 45, 40, 40)];
    iconImageView.centerX = self.view.centerX;
    iconImageView.image = [UIImage imageNamed:@"login_icon_img"];
    [self.view addSubview:iconImageView];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake720(0, 0, 0, 0)];
    bgImageView.top = iconImageView.bottom + 35;
    [self.view addSubview:bgImageView];
    
    UILabel *versionLabel = [UILabel qd_labelWithFrame:CGRectMake720(0, 0, 720, 20) title:@"" titleColor:kColorForfff textAlignment:NSTextAlignmentCenter font:10];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    versionLabel.font = [UIFont systemFontOfSize:17.0f];
    versionLabel.height = 20.0f;
    versionLabel.top = iconImageView.bottom + 15;
    versionLabel.text = [NSString stringWithFormat:@"V%@",appVersion];
    [self.view addSubview:versionLabel];
    
    
    UILabel *webLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, HCDW-100, 20)];
    webLabel.textColor = [UIColor whiteColor];
    webLabel.textAlignment = NSTextAlignmentCenter;
    webLabel.text = @"www.7dbike.com";
    [bgImageView addSubview:webLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, HCDW-20, 30)];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"商务合作 产品意见 service@7dbike.com";
    textLabel.font = UIFontOfSize720(35);
    [bgImageView addSubview:textLabel];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, HCDH-40 -64, HCDW-80, 30)];
    bottomLabel.font = [UIFont systemFontOfSize:10.0f];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    //bottomLabel.text = @"Copyright © 2015-2016 北京趣骑科技有限公司";
    bottomLabel.text = [NSString stringWithFormat:@"Copyright © 2015-%ld 北京趣骑科技有限公司",year];
    [self.view addSubview:bottomLabel];

    // Do any additional setup after loading the view.
}
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
