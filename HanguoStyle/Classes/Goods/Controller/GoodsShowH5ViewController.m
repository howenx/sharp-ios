//
//  GoodsShowH5ViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/22.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "GoodsShowH5ViewController.h"
#import "GoodsDetailViewController.h"
#import "PinGoodsDetailViewController.h"
#import "UIImage+GG.h"
@interface GoodsShowH5ViewController ()<UIWebViewDelegate>

@end

@implementation GoodsShowH5ViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
//    [self.navigationController.navigationBar setAlpha:0.1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"商品展示";
    [self createWebView];
}
-(void)createWebView{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, GGUISCREENWIDTH, GGUISCREENHEIGHT-20)];
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    request = [mutableRequest copy];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('header')[0].style.display='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"function appRedirect(urlStr) { "
     "var field = '/showWeb' + urlStr;"
     "window.location = field;"
     "}"];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"-------%@",request.mainDocumentURL.relativePath);
    NSLog(@"+++++++%@",[[request URL] absoluteString]);
    
    if ([request.mainDocumentURL.relativePath rangeOfString:@"/showWeb/detail/item"].location != NSNotFound) {
        NSArray *array = [request.mainDocumentURL.relativePath componentsSeparatedByString:@"showWeb/detail/item"]; //从字符A中分隔成2个元素的数组
        
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = [NSString stringWithFormat:@"%@/comm/detail/item%@",[HSGlobal shareGoodsHeaderUrl],array[1]];
        [self.navigationController pushViewController:gdViewController animated:YES];
        return false;
    }else if([request.mainDocumentURL.relativePath rangeOfString:@"/showWeb/detail/pin"].location != NSNotFound) {
        NSArray *array = [request.mainDocumentURL.relativePath componentsSeparatedByString:@"showWeb/detail/pin"]; //从字符A中分隔成2个元素的数组
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = [NSString stringWithFormat:@"%@/comm/detail/pin%@",[HSGlobal shareGoodsHeaderUrl],array[1]];
        [self.navigationController pushViewController:pinViewController animated:YES];
        return false;
    }
    if ([request.mainDocumentURL.relativePath rangeOfString:@"detail/item"].location != NSNotFound || [request.mainDocumentURL.relativePath rangeOfString:@"detail/pin"].location != NSNotFound) {
        return false;
    }
    return  true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
