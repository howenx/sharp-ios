//
//  LoginViewController.h
//  登录
//
//  Created by qianfeng on 15-8-16.
//  Copyright (c) 2015年 qf. All rights reserved.
//


#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property(nonatomic,copy) NSString * phone;
@property(nonatomic,copy) NSString * comeFrom;

@property(nonatomic,copy) NSString * accessToken;
@property(nonatomic,copy) NSString * openId;
@property(nonatomic,copy) NSString * idType;
@property(nonatomic,copy) NSString * unionId;
@end
