//
//  PayViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "PayViewController.h"
#import "UIBarButtonItem+GG.h"
#import "MyOrderViewController.h"
#import "PinDetailViewController.h"
@interface PayViewController ()<UIAlertViewDelegate,UIWebViewDelegate>
{
    UIWebView * webView;
}
@end

@implementation PayViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back" target:self action:@selector(backViewController)];

    [self createWebView];
    [GiFHUD dismiss];
}
-(void)backViewController{
    if([self.payType isEqualToString:@"normal"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认要离开收银台" message:@"下单后24小时订单将被取消，请尽快完成支付" delegate:self cancelButtonTitle:@"继续支付" otherButtonTitles:@"确定离开", nil];
        
        [alertView show];
    }else{
//        [webView goBack];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        MyOrderViewController * myOrder = [[MyOrderViewController alloc]init];
        [self.navigationController pushViewController:myOrder animated:YES];
    }
}
-(void)createWebView{
    NSString * urlString =[NSString stringWithFormat:@"%@%ld",[HSGlobal payUrl],_orderId];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:userToken forHTTPHeaderField:@"id-token"];
    //3.把值覆给request
    request = [mutableRequest copy];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    
}
#pragma mark - webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"-------%@",request.mainDocumentURL.relativePath);
    NSLog(@"+++++++%@",[[request URL] absoluteString]);

    //获取URL并且做比较，判断是否触发了JS事件，注意有"/"
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/openOrder"]) {
        MyOrderViewController * myOrder = [[MyOrderViewController alloc]init];
        [self.navigationController pushViewController:myOrder animated:YES];
        return false;
    }
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/openHome"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
        return false;
    }
    NSArray *components = [request.mainDocumentURL.relativePath componentsSeparatedByString:@"|"];
    if ([components count] >1  && [(NSString *)[components objectAtIndex:0] isEqualToString:@"/openPinOrder/"]) {
        NSString * url = (NSString *)[components objectAtIndex:1];
        PinDetailViewController * detailVC = [[PinDetailViewController alloc]init];
        detailVC.url = url;
        [self.navigationController pushViewController:detailVC animated:YES];
        return false;
    }
    return  true;
}
//-(void) webViewDidFinishLoad:(UIWebView *)webView {
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
//    [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
//    
//    webView.request.URL.absoluteString;
//    NSLog(@"title-%@--url-%@--",self.title,self.currentURL);
//    
//    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
//    self.currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
