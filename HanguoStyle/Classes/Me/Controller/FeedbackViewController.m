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
    
    UIImage *searchimage=[UIImage imageNamed:@"icon_save"];
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
    view=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"内容不能为空." message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        
                return;
           }else{

               NSMutableDictionary * myDict = [NSMutableDictionary dictionary];
               [myDict setObject:[NSString stringWithFormat:@"%@",view.text] forKey:@"content"];
       
               NSString * url = [HSGlobal FeeddbackUrl];
               
               
               
               AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
               if(manager == nil){
                   NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
                   noNetView.delegate = self;
                   [self.view addSubview:noNetView];
                   return;
               }
               [GiFHUD setGifWithImageName:@"hmm.gif"];
               [GiFHUD show];
               [manager POST:url parameters:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                   NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
                   NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
                   NSLog(@"message = %@",message);
                   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                   hud.mode = MBProgressHUDModeText;
                   
                   hud.labelFont = [UIFont systemFontOfSize:11];
                   hud.margin = 10.f;
                   //    hud.yOffset = 150.f;
                   hud.removeFromSuperViewOnHide = YES;
                   if(200 == code){
                       hud.labelText = @"发送成功";
                       [hud hide:YES afterDelay:1];
                       [self performSelector:@selector(popViewControl) withObject:nil afterDelay:1];
                   }else{
                       hud.labelText = @"发送失败";
                       [hud hide:YES afterDelay:1];
                   }
                   
                   [GiFHUD dismiss];
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   [GiFHUD dismiss];
                   [PublicMethod printAlert:@"发送失败"];
                   
               }];
               

    }
   
}

-(void)popViewControl
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
