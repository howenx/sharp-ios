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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
