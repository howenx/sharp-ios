//
//  LoginViewController.h
//  登录
//
//  Created by qianfeng on 15-8-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//


#import "BaseViewController.h"
@protocol  LoginViewDelegate <NSObject>
-(void)backMe;
@end
@interface LoginViewController : BaseViewController
@property(nonatomic,weak) id <LoginViewDelegate> delegate;
@end
