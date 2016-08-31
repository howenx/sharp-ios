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
#import "ChooseTeamViewController.h"
#import "PinGoodsDetailViewController.h"

#import "WXApi.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Pingpp.h"

@interface PayViewController ()<UIAlertViewDelegate,UIWebViewDelegate,WXApiManagerDelegate>
{
    int count;
    
    UIWebView * webView;
}
@end

@implementation PayViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApiManager sharedManager].delegate = self;
    self.navigationItem.title = @"支付";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back" target:self action:@selector(backViewController)];
    
    [self createWebView];
    [GiFHUD dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOK:) name:@"payResult" object:nil];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backViewController{
    [GiFHUD dismiss];
    if([self.payType isEqualToString:@"item"]){
        self.alertViewJD = [[UIAlertView alloc] initWithTitle:@"确认要离开收银台" message:@"下单后24小时订单将被取消，请尽快完成支付" delegate:self cancelButtonTitle:@"继续支付" otherButtonTitles:@"确定离开", nil];
        
        [self.alertViewJD show];
    }else{
        self.alertViewJD = [[UIAlertView alloc] initWithTitle:@"确认要离开收银台" message:@"便宜商品不多了，三思而后离开哦" delegate:self cancelButtonTitle:@"继续支付" otherButtonTitles:@"确定离开", nil];
        [self.alertViewJD show];
        
    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
    if (alertView == self.alertPayResult) {
        
        if (buttonIndex == 0) {
            //继续支付
            NSLog(@"继续支付!!");
            [webView goBack];
        }else
        {
            //返回订单
            
            MyOrderViewController * myOrder = [[MyOrderViewController alloc]init];
            [self.navigationController pushViewController:myOrder animated:YES];
        }
        
        
    }else if(alertView == self.alertViewJD)
    {
        if (buttonIndex == 1) {
            if([self.payType isEqualToString:@"item"]){
                MyOrderViewController * myOrder = [[MyOrderViewController alloc]init];
                [self.navigationController pushViewController:myOrder animated:YES];
            }else{
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[ChooseTeamViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                        break;
                    }else if ([temp isKindOfClass:[PinDetailViewController class]]){
                        [self.navigationController popToViewController:temp animated:YES];
                        break;
                    }else if ([temp isKindOfClass:[PinGoodsDetailViewController class]]){//当只有一种拼团方式的时候，没有创建选择拼团页面，直接返回拼购商品详情页面
                        [self.navigationController popToViewController:temp animated:YES];
                        break;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
            }
            
        }
    }  else if (alertView == self.alertAliResult) {
        
        if (buttonIndex == 0) {
            //继续支付
            NSLog(@"继续支付!!");
            [webView goBack];
        }else
        {
            //返回订单
            
            MyOrderViewController * myOrder = [[MyOrderViewController alloc]init];
            [self.navigationController pushViewController:myOrder animated:YES];
        }
        
        
    }
    
}


-(void)createWebView{
    NSString * urlString =[NSString stringWithFormat:@"%@%ld",[HSGlobal payUrl],_orderId];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:userToken forHTTPHeaderField:@"id-token"];
    //3.把值覆给request4
    request = [mutableRequest copy];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"function openOrder() { "
     "window.location = '/openOrder';"
     "}"];
    [webView stringByEvaluatingJavaScriptFromString:@"function openHome() { "
     "window.location = '/openHome';"
     "}"];
    [webView stringByEvaluatingJavaScriptFromString:@"function pin(urlStr) { "
     "var field = '/pinSuccess' + urlStr;"
     "window.location = field;"
     "}"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"function weixinpay(appId,partnerId,prepayId,package,nonceStr,timeStamp,sign) { "
     //     "alert(appId);"
     //     "alert(partnerId);"
     //     "alert(prepayId);"
     //     "alert(package);"
     //     "alert(nonceStr);"
     //     "alert(timeStamp);"
     //     "alert(sign);"
     //
     "var field2 = '/wexinpay' +','+appId+ ',' + partnerId + ','+ prepayId + ','+ package + ','+ nonceStr + ','+ timeStamp + ','+ sign;"
     "window.location = field2;"
     "}"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"function alipayapp(orderStr) { "
     "var field3 = '/alipayapp' + orderStr;"
     "window.location = field3;"
     "}"];
    
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
    
    if ([request.mainDocumentURL.relativePath rangeOfString:@"/pinSuccess"].location != NSNotFound) {
        NSArray *array = [request.mainDocumentURL.relativePath componentsSeparatedByString:@"/pinSuccess"]; //从字符A中分隔成2个元素的数组
        
        NSString * url = array[1];
        PinDetailViewController * detailVC = [[PinDetailViewController alloc]init];
        detailVC.url = url;
        detailVC.isFrom = @"PayViewController";
        [self.navigationController pushViewController:detailVC animated:YES];
        return false;
    }
    if ([request.mainDocumentURL.relativePath rangeOfString:@"/wexinpay"].location != NSNotFound) {
        NSArray *array = [request.mainDocumentURL.relativePath componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = array[2];
        req.prepayId            = array[3];
        req.nonceStr            = array[5];
        req.timeStamp           = [NSString stringWithFormat:@"%@",array[6]].intValue;
        req.package             = array[4];
        req.sign                = array[7];
        [WXApi sendReq:req];
        
        
        return false;
    }
    
    
    
    if ([request.mainDocumentURL.relativePath rangeOfString:@"/alipayapp"].location != NSNotFound) {
        
        NSArray *array = [request.mainDocumentURL.relativePath componentsSeparatedByString:@"/alipayapp"]; //从字符A中分隔成2个元素的数组
        NSString * signedString = array[1];
        if (signedString != nil) {
            [[AlipaySDK defaultService] payOrder:signedString fromScheme:@"hmmapp" callback:^(NSDictionary *resultDic) {
                NSString* resultCode = resultDic[@"resultStatus"];
                
                if ([resultCode isEqualToString:@"9000"] ) {
                    //支付成功，返回app首页
                }else
                {
                    self.alertAliResult = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付结果：失败！" delegate:self cancelButtonTitle:@"继续支付" otherButtonTitles:@"放弃支付", nil];
                    [self.alertAliResult show];
                }
                
            }];
        }
        return false;
    }
    
    
    
    return  true;
}



- (void)payOK:(NSNotification *) notif
{
    //支付出错了.
    self.alertPayResult = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付结果：失败！" delegate:self cancelButtonTitle:@"继续支付" otherButtonTitles:@"放弃支付", nil];
    [self.alertPayResult show];
}
@end
