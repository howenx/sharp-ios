//
//  LoginRefViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/18.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "LoginRefViewController.h"
#import "GGTabBarViewController.h"
#import "ReturnResult.h"
@interface LoginRefViewController ()

@end

@implementation LoginRefViewController

- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden=YES;
    [super viewDidLoad];
//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
//    imageView.image = [UIImage imageNamed:@"4"];
//    [self.view addSubview:imageView];
//    [self getData];
    // Do any additional setup after loading the view.
}
//发送注册数据
-(void)getData{
    
    NSString * urlString =[HSGlobal refreshToken];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
//    NSString * oldToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        
        if(returnResult.code == 200){
            //给极光发送别名
            [JPUSHService setAlias:returnResult.alias callbackSelector:nil object:self];
            
            //把用户账号存到内存中
            [[NSUserDefaults standardUserDefaults]setObject:returnResult.token forKey:@"userToken"];
            NSDate * lastDate = [[NSDate alloc] initWithTimeInterval:returnResult.expired sinceDate:[NSDate date]];
            [[NSUserDefaults standardUserDefaults]setObject:lastDate forKey:@"expired"];
        }else{
            [self showHud:returnResult.message];
        }
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        NSLog(@"Error: %@", error);
        [PublicMethod printAlert:@"登录失败"];
    }];

}
-(void)showHud:(NSString *) message{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:11];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
    hud.labelText = message;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
