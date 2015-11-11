//
//  HSGlobal.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "HSGlobal.h"

@implementation HSGlobal
//主页地址
+ (NSString *) goodsPackMoreUrl: (NSInteger *)addon
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9001/getthemes/%d",addon];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//获取验证码地址
+ (NSString *) testingCodeUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.32:9000/api/send_code"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//注册地址
+ (NSString *) registUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.32:9000/api/reg"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//登陆地址
+ (NSString *) loginUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.32:9000/api/login_user_name"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//重置密码地址
+ (NSString *) resetPwdUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.32:9000/api/reset_password"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
