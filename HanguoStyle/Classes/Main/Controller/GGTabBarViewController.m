//
//  GGTabBarViewController.m
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import "GGTabBarViewController.h"
#import "GGTabBar.h"
//控制器
#import "GoodsViewController.h"
#import "CartViewController.h"
#import "MeViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "GGNavigationViewController.h"
#import "HSGlobal.h"
#import "GoodsDetailViewController.h"
#import "PublicMethod.h"
#import "UIImage+GG.h"
@interface GGTabBarViewController ()<GGTabBarDelegate>
{
    FMDatabase *database;
}
//自定义的TabBar
@property (nonatomic,weak) GGTabBar * coustomTabBar;
@end

@implementation GGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [PublicMethod shareDatabase];
    //1.初始化自定义tabBar
    [self setupTabBar];
    //2.初始所有化子控件
    [self setupAllChildViewControllers];
    [self createCart];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTabBarButton) name:@"PopViewControllerNotification" object:nil];
}

-(void)createCart{
    [database beginTransaction];
    NSString *sql = @"create table if not exists Shopping_Cart (pid integer, cart_id integer, pid_amount integer, state text,sku_type text ,sku_type_id integer)";    
    //执行sql
    [database executeUpdate:sql];
    [database commit];

}
//初始化自定义tabBar
-(void)setupTabBar
{
    GGTabBar * newTabBar = [[GGTabBar alloc]init];
    newTabBar.frame = self.tabBar.bounds;
    newTabBar.delegate = self;
    [self.tabBar addSubview:newTabBar];
    
    //加一条黑线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.tabBar addSubview:lineView];
    
    
    self.coustomTabBar = newTabBar;
}

//初始所有化子控件
-(void)setupAllChildViewControllers
{
    //1.精选商品
    GoodsViewController * gContro = [[GoodsViewController alloc]init];
//    gContro.tabBarItem.badgeValue = @"21";
    [self setupChildViewController:gContro title:@"首页" imageName:@"rm_tab" selectImageName:@"rm_tab_selected"];
    //2.购物车
    CartViewController *  cContro = [[CartViewController alloc]init];
//    messageContro.tabBarItem.badgeValue = @"400";
    [self setupChildViewController:cContro title:@"购物车" imageName:@"gs_tab" selectImageName:@"gs_tab_selected"];
    
    //3.我
    MeViewController * meContro = [[MeViewController alloc]init];
//    meContro.tabBarItem.badgeValue = @"23";
    [self setupChildViewController:meContro title:@"我的" imageName:@"me_tab" selectImageName:@"me_tab_selected"];
}

#pragma mark - 导航控制器的属性
//初始化一个子控件
-(void)setupChildViewController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    
    
    GGNavigationViewController * nav = [[GGNavigationViewController alloc] initWithRootViewController:controller];
    //1.设置导航控制器的皮肤属性

    UINavigationBar * navgationBar  = [UINavigationBar appearance];
    //导航栏颜色
//    controller.edgesForExtendedLayout = UIRectEdgeTop;
//    controller.edgesForExtendedLayout = UIRectEdgeNone;
    [navgationBar setBackgroundImage:[[UIImage createImageWithColor:GGNavColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
//    navgationBar.translucent = NO;
    
//    navgationBar.barTintColor=GGMainColor;
    // 字体的属性
    NSDictionary * dict = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName :UIColorFromRGB(0x242424)};
    [navgationBar setTitleTextAttributes:dict];
    
    
    //    // 设置导航按钮文字颜色
    UIBarButtonItem *barButton = [UIBarButtonItem appearance];
    NSMutableDictionary * attrsDict = [[NSMutableDictionary alloc] init];
    attrsDict[NSForegroundColorAttributeName] = UIColorFromRGB(0x242424);
    attrsDict[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [barButton setTitleTextAttributes:attrsDict forState:UIControlStateNormal];
    
    
    //状态栏的颜色被遮挡
    //
    //    另辟蹊径
    //
    //    创建一个UIView，
    //    设置该UIView的frame.size 和statusBar大小一样，
    //    设置该UIView的frame.origin 为{0,-20},
    //    设置该UIView的背景色为你希望的statusBar的颜色，
    //    在navigationBar上addSubView该UIView即可。
//    UIView * statusbar = [[UIView alloc]init];
//    //4.屏幕的宽度style-ios
//    
//    statusbar.frame = CGRectMake(0, -20,GGUISCREENWIDTH,20);
//    statusbar.backgroundColor = GGMainColor;
//    [nav.navigationBar addSubview:statusbar];
  
    
    //2.设置导航控制器按钮皮肤属性
    UIBarButtonItem * barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTintColor:UIColorFromRGB(0x242424)];
    

    controller.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    [controller.navigationItem setTitle: @"KakaoGift"];//这个要设置到controller.title后面才生效
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
    //为下面购物车tabbar的显示的数量用的
    if([title isEqualToString:@"购物车"]){
        //添加tabBar
        [self.coustomTabBar addTabBarItem:controller.tabBarItem andController:@"cust"];
    }else{
        [self.coustomTabBar addTabBarItem:controller.tabBarItem andController:@""];}
    
    }

//删除原来的TbaBar
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self removeTabBarButton];
}

#pragma mark - GGTabBarDelegate
-(void)tabBarDelagate:(GGTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to - 10000;
    if(to-10000 == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadRootPage" object:nil];
    }
    
}

-(void) removeTabBarButton {
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
@end
