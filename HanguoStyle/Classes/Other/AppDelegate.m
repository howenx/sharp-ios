//
//  AppDelegate.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LoginRefViewController.h"
#import "GGTabBarViewController.h"
#import "HSGlobal.h"
#import "InitAppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "MiPwdView.h"
#import "JPUSHService.h"
#import "GoodsShowViewController.h"
#import "GoodsDetailViewController.h"
#import "PinGoodsDetailViewController.h"
#import "PinDetailViewController.h"
#import "GoodsViewController.h"
#import <CrashMaster/CrashMaster.h>

@interface AppDelegate ()<UIScrollViewDelegate>

@end

@implementation AppDelegate
-(void) umConfig{
    [UMSocialData setAppKey:@"567bb26867e58e3f670002fd"];
    [UMSocialWechatHandler setWXAppId:@"wx578f993da4b29f97" appSecret:@"e78a99aec4b6860370107be78a5faf9d" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1105332776" appKey:@"CKevSfjxt0dXEq0y" url:@"http://www.drama.wang"];
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];//hmmapp://data/pinTieredPrice/pin/888361/112522
    if (result == FALSE) {
        //从网页跳转到app
        NSArray * enterArray = [[url absoluteString] componentsSeparatedByString:@"hmmapp://data"];
        if(enterArray.count>=2){
            UIViewController * controller = [self getCurrentVC];
            NSString * lastUrl = enterArray[1];
            if ([lastUrl rangeOfString:@"pin/activity"].location != NSNotFound) {
                
                PinDetailViewController * detailVC = [[PinDetailViewController alloc]init];
                detailVC.url = [NSString stringWithFormat:@"%@/promotion%@",[HSGlobal shareTuanHeaderUrl],lastUrl];
                [(UINavigationController *)controller pushViewController:detailVC animated:YES];
            } else {
                if([lastUrl rangeOfString:@"pin"].location != NSNotFound) {
                    PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
                    pinViewController.url = [NSString stringWithFormat:@"%@/comm/detail%@",[HSGlobal shareGoodsHeaderUrl],lastUrl];
                    [(UINavigationController *)controller pushViewController:pinViewController animated:YES];
                }else{
                    GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
                    gdViewController.url = [NSString stringWithFormat:@"%@/comm/detail%@",[HSGlobal shareGoodsHeaderUrl],lastUrl];
                    [(UINavigationController *)controller pushViewController:gdViewController animated:YES];
                }
            }
            return YES;
        }
    }
    return result;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self umConfig];
    [CrashMaster init:@"ee2bb0b0d95af384232362f254137920" channel:@"应用的渠道号" config:[CrashMasterConfig defaultConfig]];
    //1.是否隐藏状态栏 , 欢迎界面隐藏，其他界面不隐藏，根据需求自己设定
    NSLog(@"+++++++%@", NSHomeDirectory());
    application.statusBarHidden = NO;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    GGTabBarViewController * tabBar = [[GGTabBarViewController alloc]init];
    self.window.rootViewController = tabBar;

    [self.window makeKeyAndVisible];
        //判断滑动图是否出现过，第一次调用时“isScrollViewAppear” 这个key 对应的值是nil，会进入if中
    if (![@"YES" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"isScrollViewAppear"]]) {
        
        [self showScrollView];//显示滑动图
    }
    
    
    
    
    //*****************极光推送*******************
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
#else
    //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:@"a81748f2ead4ab0faef89329" channel:@"Publish channel" apsForProduction:0];
     //*****************极光推送*******************

    return YES;
}


-(void) showScrollView{
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
    _scrollView.contentSize = CGSizeMake(GGUISCREENWIDTH * 4, GGUISCREENHEIGHT);
    
    _scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    

    
    
    //在UIScrollView 上加入 UIImageView
    for (int i = 0 ; i < 4; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(GGUISCREENWIDTH * i , 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        
        //将要加载的图片放入imageView 中
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        imageView.image = image;
        
        [_scrollView addSubview:imageView];
        if(i == 3){
            UIImageView * enterImgV = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH * i +(GGUISCREENWIDTH-167)/2, GGUISCREENHEIGHT*0.8, 167, 40)];
            enterImgV.image = [UIImage imageNamed:@"openApp"];
            enterImgV.userInteractionEnabled = YES;
            [enterImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDisappear)]];
            [_scrollView addSubview:enterImgV];
        }
    }
    [self.window addSubview:_scrollView];
    
    
    //设置分页
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, GGUISCREENHEIGHT-50, GGUISCREENWIDTH, 40)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPageIndicatorTintColor = GGMainColor;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.numberOfPages = 4;
    [self.window addSubview:_pageControl];

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/GGUISCREENWIDTH;
    
    //根据scrollView 的位置对page 的当前页赋值
    _pageControl.currentPage = current;

}

-(void)scrollViewDisappear{
    [_pageControl removeFromSuperview];
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.window viewWithTag:101];
    
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:2.0f animations:^{
        
        scrollView.center = CGPointMake(self.window.frame.size.width/2, 1.5 * self.window.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [scrollView removeFromSuperview];
        
    }];
    
    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}
//设置app只能竖屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}
//当应用程序全新启动，或者在后台转到前台，完全激活时，都会调用这个方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    InitAppDelegate * initDale = [InitAppDelegate new];
    //判断用户token是否过期，或者将要过期
    NSDate * expiredDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"expired"];
    if(expiredDate!=nil){
        NSString * loginFlag = [initDale intervalSinceNow:expiredDate];

        if([@"2" isEqualToString:loginFlag]){//不需要重新登录

        }else if([@"1" isEqualToString:loginFlag]){//需要重新登录
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userToken"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expired"];

        }else if([@"0" isEqualToString:loginFlag]){//需要刷新登录
            LoginRefViewController * loginRef = [[LoginRefViewController alloc]init];
            [loginRef getData];
        }
    }

    
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSString * str = pboard.string;
    if(str.length>9 && [[str substringToIndex:9]isEqualToString:@"KAKAO-HMM"]){
        [[MiPwdView alloc]initWithDetail:str];
    }
    pboard.string = @"";

}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
     NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [JPUSHService handleRemoteNotification:userInfo];
    
}
//远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
     NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSString * targetType = [userInfo objectForKey:@"targetType"];
    NSString * url = [userInfo objectForKey:@"url"];
     UIViewController * controller = [self getCurrentVC];
    
    if([targetType isEqualToString:@"T"]){//主题
        GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
        gsViewController.navigationItem.title = @"商品展示";
        //下个页面要跳转的url
        gsViewController.url = url;
        [(UINavigationController *)controller pushViewController:gsViewController animated:YES];
    }else if([targetType isEqualToString:@"D"]){//普通商品详细页面
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = url;
        [(UINavigationController *)controller pushViewController:gdViewController animated:YES];
    }else if([targetType isEqualToString:@"P"]){//拼购商品详细页面
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = url;
        [(UINavigationController *)controller pushViewController:pinViewController animated:YES];
    }else if([targetType isEqualToString:@"V"]){//拼购结果页面
        PinDetailViewController * detailVC = [[PinDetailViewController alloc]init];
        detailVC.url = url;
        [(UINavigationController *)controller pushViewController:detailVC   animated:YES];
    }else if([targetType isEqualToString:@"A"]){//活动页面
        GoodsViewController * gContro = [[GoodsViewController alloc]init];
        [(UINavigationController *)controller pushViewController:gContro animated:YES];
    } else if([targetType isEqualToString:@"U"]){//一个促销活动的链接
        GoodsViewController * gContro = [[GoodsViewController alloc]init];
        [(UINavigationController *)controller pushViewController:gContro animated:YES];
    }


}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    UITabBarController *tab = (UITabBarController *)result;
    return tab.selectedViewController;
}

@end
