//
//  AppendAddrViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/22.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AppendAddrViewController.h"

@interface AppendAddrViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *areaAddrLab;
@property (weak, nonatomic) IBOutlet UITextField *detailAddrLab;
@property (weak, nonatomic) IBOutlet UITextField *postCodeLab;

@end

@implementation AppendAddrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"添加收货地址";
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
