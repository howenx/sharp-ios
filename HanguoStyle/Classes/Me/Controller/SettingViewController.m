//
//  SettingViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/14.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "SettingViewController.h"
#import "ResetButton.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = GGColor(240, 240, 240);
    [self createSettingView];
}
-(void)createSettingView{
    ResetButton   * aboutBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(10, 64, GGUISCREENWIDTH, 40);
    [aboutBtn setTitle:@"关于我们" forState:UIControlStateNormal];
    aboutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [aboutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aboutBtn setImage:[UIImage imageNamed:@"icon_about"] forState:UIControlStateNormal];
    
    [self.view addSubview:aboutBtn];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(10,aboutBtn.y+aboutBtn.height, GGUISCREENWIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    
    
    BOOL isLogin = [PublicMethod checkLogin];
    
    if(isLogin){
        UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.frame = CGRectMake(20, 364, GGUISCREENWIDTH-40, 30);
        exitBtn.backgroundColor = GGMainColor;
        [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
        exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:exitBtn];

    }
}

-(void)exitBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expired"];
//    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"haveLoseTokenOnce"];
    [self.delegate backMeFromSetting];
    [self.navigationController popViewControllerAnimated:YES];
    //修改购物车tabbar的badgeValue
    PublicMethod * pm = [[PublicMethod alloc]init];
    [pm sendCustNum];
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
