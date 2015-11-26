//
//  MyBaseViewController.m
//  NewZhuaMa
//
//  Created by admin on 15/6/1.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyBaseViewController.h"

@interface MyBaseViewController ()
{
    
}
@end

@implementation MyBaseViewController
@synthesize mlbTitle, delegate, mShadowImage, mTopColor, mTopImage, mLoadMsg, mTitleColor, mbLightNav, mFontSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  UIColorFromRGB(0xE9E9E9);
    self.title = @"";

    if (IOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        //去掉边缘化 适配
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.translucent = YES;
    }
    
    UIImage *image = [UIImage imageNamed:@"红包透明导航"];
    UIImage *stretchedImage = [image stretchableImageWithLeftCapWidth:0 topCapHeight:0];
     [self.navigationController.navigationBar setBackgroundImage:stretchedImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    
    mShadowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, sWIDTH, 64)];
    mShadowView.image = [UIImage imageNamed:@"导航"];;
    [self.view addSubview:mShadowView];
    
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:mShadowView];
}
- (void)GoHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)GoBack {

    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        //[self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
- (void)ClearNavItem {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)dealloc {
    self.mShadowImage = nil;
    self.mTopColor = nil;
    self.mTopImage = nil;
    self.mLoadMsg = nil;
}

- (void)StartLoading
{
    if (mLoadView) {
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
        mLoadView.labelText = mLoadMsg;
        
    }
    mLoadView.dimBackground = YES;
    [self.view addSubview:mLoadView];
    [self.view bringSubviewToFront:mLoadView];

    [mLoadView show:YES];
}

- (void)StopLoading
{
    mLoadView.dimBackground = NO;
    [mLoadView hide:YES];
    mLoadView = nil;
}

- (void)showMsg:(NSString *)msg
{
    if (mLoadView) {
        [self StopLoading];
    }
    if ([msg isEqualToString:@"验证失败，请重新登录"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:LOGINFROMOTHERDEVICE object:nil];
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mLoadView];
    
    [self.view bringSubviewToFront:mLoadView];
    mLoadView.mode = MBProgressHUDModeCustomView;
    mLoadView.labelText = msg;
    [mLoadView show:YES];
    [mLoadView hide:YES afterDelay:1];
    mLoadView = nil;
    
    
}

-(void)AddRightImageBtn:(CGRect)frame Image:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)AddLeftImageBtn:(CGRect)frame Image:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)showRemindLabel:(NSString *)remindWord inView:(UIView *)fatherView
{
    if (!remindWordLabel) {
        remindWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, sWIDTH-40, 80)];
    }
    remindWordLabel.hidden = NO;
    remindWordLabel.textAlignment = NSTextAlignmentCenter;
    remindWordLabel.center = CGPointMake(sWIDTH/2, self.view.center.y-64-30-30);
    remindWordLabel.textColor = UIColorFromRGB(0X666666);
    remindWordLabel.text = remindWord;
    remindWordLabel.numberOfLines = 0;
    [fatherView addSubview:remindWordLabel];
    [fatherView bringSubviewToFront:remindWordLabel];
}
-(void)hideRemindLabel
{
    remindWordLabel.hidden = YES;
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
