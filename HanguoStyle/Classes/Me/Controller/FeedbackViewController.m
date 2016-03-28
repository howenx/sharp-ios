//
//  FeedbackViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/3/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "FeedbackViewController.h"
@interface FeedbackViewController ()<UIWebViewDelegate>

@end


@implementation FeedbackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"意见反馈";
    [self createWebView];
}
-(void)createWebView{
    UITextField  * fieldText = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)
                       ];
    
    fieldText.placeholder = @"请输入您宝贵的意见吧~";
    
    [self.view addSubview:fieldText];

}

@end
