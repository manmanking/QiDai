//
//  TabBarControllerConfig.m
//  QiDai
//
//  Created by 张汇丰 on 16/5/3.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "TabBarControllerConfig.h"

#import "SportHomePageViewController.h"
#import "TaskHomePageViewController.h"
#import "TaskHomeViewController.h"

#import "ShopHomePageViewController.h"
#import "MineViewController.h"
@interface TabBarControllerConfig ()<UITabBarControllerDelegate>
@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;
@end

@implementation TabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        SportHomePageViewController *firstViewController = [[SportHomePageViewController alloc] init];
        UINavigationController *firstNav = [[UINavigationController alloc]initWithRootViewController:firstViewController];

        
        // modify by manman on 2016-10-31 start of line
        // 更新任务页面 version 1.4
        TaskHomePageViewController *secondViewController = [[TaskHomePageViewController alloc] init];
        TaskHomeViewController *taskHome = [[TaskHomeViewController alloc]init];
        UINavigationController *secondNav = [[UINavigationController alloc]initWithRootViewController:taskHome];
        
        
        
    // end of line
        
        ShopHomePageViewController *thirdViewController = [[ShopHomePageViewController alloc] init];
        UINavigationController *thirdNav = [[UINavigationController alloc]initWithRootViewController:thirdViewController];
        
        MineViewController *fourthViewController = [[MineViewController alloc] init];
        UINavigationController *fourthNav = [[UINavigationController alloc]initWithRootViewController:fourthViewController];
        
        CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
        
        // 在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
        [self setUpTabBarItemsAttributesForController:tabBarController];
        
        [tabBarController setViewControllers:@[
                                               firstNav,
                                               secondNav,
                                               thirdNav,
                                               fourthNav
                                               ]];
        // 更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
        //[self customizeTabBarAppearance:tabBarController];
        
        _tabBarController = tabBarController;
        
    }
    return _tabBarController;
}

/**
 *  在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
 */
- (void)setUpTabBarItemsAttributesForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"骑行",
                            CYLTabBarItemImage : @"tabbar_sport_btn",
                            CYLTabBarItemSelectedImage : @"tabbar_sport_btn_p",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"任务",
                            CYLTabBarItemImage : @"tabbar_task_btn",
                            CYLTabBarItemSelectedImage : @"tabbar_task_btn_p",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"商城",
                            CYLTabBarItemImage : @"tabbar_shop_btn",
                            CYLTabBarItemSelectedImage : @"tabbar_shop_btn_p",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"tabbar_my_btn",
                            CYLTabBarItemSelectedImage : @"tabbar_my_btn_p"
                            };
    NSArray *tabBarItemsAttributes = @[
                                       dict1,
                                       dict2,
                                       dict3,
                                       dict4
                                       ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       UIColorFromRGB_16(0xd91c17),
                                                       NSForegroundColorAttributeName,
                                                       nil]
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       UIColorFromRGB_16(0x999999),
                                                       NSForegroundColorAttributeName,
                                                       nil]
                                             forState:UIControlStateNormal];
//    [[UITabBar appearance] setBackgroundColor:[UIColor redColor]];//colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:1]];
//    [UITabBar appearance].translucent = NO;
    
    //[UITabBarItem appearance].imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
    
    
    
}
@end
