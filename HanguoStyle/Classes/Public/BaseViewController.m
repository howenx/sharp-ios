//
//  BaseViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setAlpha:1];
    [GiFHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
