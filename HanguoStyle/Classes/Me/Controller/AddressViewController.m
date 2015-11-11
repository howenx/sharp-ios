//
//  AddressViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/22.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AddressViewController.h"
#import "AppendAddrViewController.h"

@interface AddressViewController ()

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"收货地址";
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addAddress)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)addAddress{
    AppendAddrViewController * aaViewController = [[AppendAddrViewController alloc]init];
    [self.navigationController pushViewController:aaViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
