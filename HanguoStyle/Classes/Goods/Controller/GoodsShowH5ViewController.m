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
#import "CartViewController.h"
#import "LoginViewController.h"
@interface GoodsShowH5ViewController ()<UIWebViewDelegate>
{
    NSInteger _cnt;
}
@property (nonatomic) UILabel * cntLabel;
@end

@implementation GoodsShowH5ViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    [self queryCustNum];
//    [self.navigationController.navigationBar setAlpha:0.1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"";
    [self makeCustNumLab];
    [self createWebView];
}


-(void)makeCustNumLab{
    
    //右上角添加按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [rightButton setImage:[UIImage imageNamed:@"shopping_cart_top"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(enterCust)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(11 , -2, 15, 15)];
    _cntLabel.textColor = [UIColor whiteColor];
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont systemFontOfSize:10];
    _cntLabel.backgroundColor = GGRedColor;
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = GGBgColor.CGColor;
    
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }
    
    [rightButton addSubview:_cntLabel];
    
}
-(void)enterCust{
    BOOL orJumpTab = NO;
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CartViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
            orJumpTab = YES;
            break;
        }
    }
    
    if(!orJumpTab){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"cart",@"jumpKey", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToTabbar" object:nil userInfo:dict];
    }
}




-(void)createWebView{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    webView.delegate = self;
    [ (UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    request = [mutableRequest copy];
    
    [self hideGradientBackground:webView];
    
    
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
}

-(void)hideGradientBackground:(UIView *)theView
{
    for (UIView * subView in  theView.subviews ) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            subView.hidden = YES;
        }
        [self hideGradientBackground:subView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('header')[0].style.display='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"$('.banner').css(\"margin-top\",\"-44px\");"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"function appRedirect(urlStr) { "
     "var field = '/showWeb' + urlStr;"
     "window.location = field;"
     "}"];
    
    //获取优惠券等功能
    [webView stringByEvaluatingJavaScriptFromString:@"function getCouponIos(urlStr) { "
     "var field = '/getOther' + urlStr;"
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
    //获取优惠券等功能
    if ([request.mainDocumentURL.relativePath rangeOfString:@"/getOther"].location != NSNotFound) {
        NSArray *array = [request.mainDocumentURL.relativePath componentsSeparatedByString:@"getOther"]; //从字符A中分隔成2个元素的数组
        
        BOOL isLogin = [PublicMethod checkLogin];
        if(!isLogin){
            LoginViewController * login = [[LoginViewController alloc]init];
            login.comeFrom = @"GoodsShowH5VC";
            [self.navigationController pushViewController:login animated:NO];
            
            
        }else
        {
            
            NSString * url = array[1];
            AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = message;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];


            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [PublicMethod printAlert:@"数据加载失败"];
            }];

        }
        return false;
    }
    return  true;
}

-(void)queryCustNum{
    BOOL isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        FMDatabase * database = [PublicMethod shareDatabase];
        FMResultSet * rs = [database executeQuery:@"SELECT SUM(pid_amount) as amount FROM Shopping_Cart "];
        //购物车如果存在这件商品，就更新数量
        while ([rs next]){
            _cnt = [rs intForColumn:@"amount"] ;
            if (_cnt == 0) {
                _cntLabel.hidden = YES;
            }else{
                _cntLabel.hidden = NO;
                _cntLabel.text= [NSString stringWithFormat:@"%ld",(long)_cnt];
            }
            
        }
    }else{
        NSString * url = [HSGlobal queryCustNum];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        if(manager == nil){
            NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
            noNetView.delegate = self;
            [self.view addSubview:noNetView];
            return;
        }
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            
            if(code == 200){
                _cnt = [[object objectForKey:@"cartNum"]integerValue];
                if (_cnt == 0) {
                    _cntLabel.hidden = YES;
                }else{
                    _cntLabel.hidden = NO;
                    _cntLabel.text= [NSString stringWithFormat:@"%ld",(long)_cnt];
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
