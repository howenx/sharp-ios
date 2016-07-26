//
//  HmmClauseViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/6/2.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "HmmClauseViewController.h"

@interface HmmClauseViewController ()<UIWebViewDelegate>

@end

@implementation HmmClauseViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    //    [self.navigationController.navigationBar setAlpha:0.1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"KakaoGift服务条款";
    [self createWebView];
}
-(void)createWebView{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    webView.delegate = self;
    [ (UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    NSString * url = [HSGlobal hmmClauseUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    request = [mutableRequest copy];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
