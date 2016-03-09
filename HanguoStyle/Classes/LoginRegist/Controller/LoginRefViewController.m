//
//  LoginRefViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/18.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "LoginRefViewController.h"
#import "ReturnResult.h"
#import "GGTabBarViewController.h"
#import "LoginViewController.h"
@interface LoginRefViewController ()

@end

@implementation LoginRefViewController

- (void)viewDidLoad {
    self.tabBarController.tabBar.hidden=YES;
    [super viewDidLoad];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
    imageView.image = [UIImage imageNamed:@"4"];
    [self.view addSubview:imageView];
    [self getData];
    // Do any additional setup after loading the view.
}
//发送注册数据
-(void)getData{
    
    NSString * urlString =[HSGlobal refreshToken];
    AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
    NSString * oldToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [manager POST:urlString  parameters:@{@"token":oldToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //转换为词典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //创建数据模型对象,加入数据数组
        ReturnResult * returnResult = [[ReturnResult alloc]initWithJSONNode:dict];
        
        if(returnResult.code == 200){
            //把用户账号存到内存中
            [[NSUserDefaults standardUserDefaults]setObject:returnResult.token forKey:@"userToken"];
            NSDate * lastDate = [[NSDate alloc] initWithTimeInterval:returnResult.expired sinceDate:[NSDate date]];
            [[NSUserDefaults standardUserDefaults]setObject:lastDate forKey:@"expired"];
            //1.登陆成功,跳转到下主页面
            GGTabBarViewController * tabBar = [[GGTabBarViewController alloc]init];
            [self presentViewController:tabBar animated:YES completion:nil];
            
        }else{
            LoginViewController * login = [[LoginViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [PublicMethod printAlert:@"登陆失败"];
    }];
    
    //    /**
    //     *  测试用
    //     */
    //    GGTabBarViewController * tabBar = [[GGTabBarViewController alloc]init];
    //    [self presentViewController:tabBar animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
