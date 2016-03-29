//
//  AboutOurViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/3/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "AboutOurViewController.h"

@interface AboutOurViewController ()<UIWebViewDelegate>

@end

@implementation AboutOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"关于我们";
    [self createWebView];
}
-(void)createWebView{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    request = [mutableRequest copy];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
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
