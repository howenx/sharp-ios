//
//  FeedbackViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/3/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"
@interface FeedbackViewController ()<UIWebViewDelegate>
{
    PlaceholderTextView *view;
}
@end


@implementation FeedbackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"意见反馈";
    
    UIImage *searchimage=[UIImage imageNamed:@"redStore"];
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(saveButton:)];
    barbtn.image=searchimage;
    self.navigationItem.rightBarButtonItem=barbtn;
    
    [self createWebView];
}
-(void)createWebView{
//    UITextField  * fieldText = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)
//                       ];
//    
//    fieldText.placeholder = @"请输入您宝贵的意见吧~";
//    
//    [self.view addSubview:fieldText];
    view=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    view.placeholder=@"请输入您宝贵的意见吧~";
    view.font=[UIFont boldSystemFontOfSize:14];
    view.placeholderFont=[UIFont boldSystemFontOfSize:13];
    view.keyboardType = UIKeyboardTypeDefault;
    view.layer.borderWidth=0.5;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
}

-(void)saveButton:(UIBarButtonItem *)btn
{
    
    if ([view.text isEqualToString:@"请输入您宝贵的意见吧~"] || [view.text isEqualToString:@""]) {
                return;
           }else{

               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               
               hud.labelFont = [UIFont systemFontOfSize:11];
               hud.margin = 10.f;
               hud.removeFromSuperViewOnHide = YES;
               hud.labelText = @"正在提交请稍等...";
               [hud hide:YES afterDelay:1];
               
               [self performSelector:@selector(popViewControl) withObject:nil afterDelay:1];

    }
   
}

-(void)popViewControl
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
