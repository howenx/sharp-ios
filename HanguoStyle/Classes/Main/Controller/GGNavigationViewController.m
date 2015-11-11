//
//  GGNavigationViewController.m
//  GiftGuide
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import "GGNavigationViewController.h"
#import "UIBarButtonItem+GG.h"
@interface GGNavigationViewController ()

@end

@implementation GGNavigationViewController

//+ (void)initialize{
//    // 设置导航栏
//    UINavigationBar *nvBar = [UINavigationBar appearance];
//    // 设置导航栏背景
//    [nvBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
//    // 设置导航栏字体颜色
//    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [nvBar setTitleTextAttributes:attrs];
//    // 设置导航栏返回箭头颜色
//    nvBar.tintColor = [UIColor whiteColor];
//    
//    // 设置导航按钮文字颜色
//    UIBarButtonItem *barButton = [UIBarButtonItem appearance];
//    NSMutableDictionary *attrsDict = [[NSMutableDictionary alloc] init];
//    attrsDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    attrsDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [barButton setTitleTextAttributes:attrsDict forState:UIControlStateNormal];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//
//+ (instancetype)navigationController{
//    RCTabBarViewController * tabBarVC =(RCTabBarViewController *)   [UIApplication sharedApplication].keyWindow.rootViewController;
//    RCNavigationController * navVC = ( RCNavigationController *)tabBarVC.selectedViewController;
//    return navVC;
//}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >0 ) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem
                                                           itemWithImage:@"icon_back" highImage:@"icon_back" target:self action:@selector(back)];
        
            //   viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];

}
- (void)back{
    
    [self popViewControllerAnimated:YES];
}



@end
