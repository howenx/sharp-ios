//
//  HSGlobal.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "HSGlobal.h"

@implementation HSGlobal

// 获取购物车数据地址（未登陆状态）
+ (NSString *) getCartByPidUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9003/client/cart/get/sku/list"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// 获取购物车数据地址（登陆状态）
+ (NSString *) getCartUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9003/client/cart/list"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//发送购物车数据地址
+ (NSString *) sendCartUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9003/client/cart"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//主页地址
+ (NSString *) goodsPackMoreUrl: (NSInteger)addon
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9001/index/%ld",(long)addon];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//获取验证码地址
+ (NSString *) testingCodeUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9004/api/send_code"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//注册地址
+ (NSString *) registUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9004/api/reg"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//登陆地址
+ (NSString *) loginUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9004/api/login_user_name"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//刷新token
+ (NSString *) refreshToken
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9004/api/refresh_token"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//重置密码地址
+ (NSString *) resetPwdUrl
{
    NSString * url = [NSString stringWithFormat:@"http://172.28.3.18:9004/api/reset_password"];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//打印
+(void)printAlert:(NSString *) message{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
//获取一段文字占得大小
+(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeofstr]} context:nil].size;
    }
    else
    {
        size = [str sizeWithFont:[UIFont systemFontOfSize:sizeofstr]constrainedToSize:CGSizeMake(width, height)];
    }
    return size;
}

+(BOOL)checkLogin{
    //判断用户token是否过期，或者将要过期
    NSDate * expiredDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"expired"];
    if(expiredDate==nil){
        return NO;
    }else{
        NSString * loginFlag = [self intervalSinceNow:expiredDate];
        if([@"2" isEqualToString:loginFlag]){//不需要重新登录
            return YES;
        }else if([@"1" isEqualToString:loginFlag]){//需要重新登录或者刷新登录
           return NO;
        }
        else if([@"0" isEqualToString:loginFlag]){//需要刷新登录
            return YES;
        }
    }
    
    return NO;
}
+ (NSString *)intervalSinceNow: (NSDate *) theDate
{
    
    NSTimeInterval late=[theDate timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    
    NSTimeInterval cha = late - now;
    
    if (cha/86400 < 1 && cha/86400 > 0)//86400 = 60*60*24 代表一天
    {
        return @"0";//表示需要调用刷新登陆接口
    }else if(cha/86400 <= 0){
        return @"1";//表示需要调用重新登陆接口
    }else{
        return @"2";//表示不需要重新登陆
    }
}
+(FMDatabase *)shareDatabase{
    static FMDatabase * database = nil;
    if (!database) {
        NSString *doucmentpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString * dataPath =  [doucmentpath stringByAppendingPathComponent:@"data.db"];
        database = [FMDatabase databaseWithPath:dataPath];
        [database open];
    }
    return database;
}
@end
