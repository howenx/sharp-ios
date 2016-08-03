//
//  PublicMethod.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/22.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "PublicMethod.h"
#import "GiFHUD.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])
@implementation PublicMethod

//打印
+(void)printAlert:(NSString *) message{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
//获取一段文字占得大小
+(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height
{
    CGSize size;
    size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeofstr]} context:nil].size;
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
        }else if([@"1" isEqualToString:loginFlag]){//需要重新登录
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
+(AFHTTPRequestOperationManager *)shareRequestManager{
    if(![self isConnectionAvailable]){
        return nil;
    }
    static AFHTTPRequestOperationManager * manager = nil;
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
    return manager;
}

+(AFHTTPRequestOperationManager *)shareNoHeadRequestManager{
    if(![self isConnectionAvailable]){
        return nil;
    }
    static AFHTTPRequestOperationManager * manager = nil;
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    return manager;
}
+(MBProgressHUD *)getHUD :(UIViewController *)controller{
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.navigationController.view addSubview:HUD];
    HUD.margin =10.f;
    controller.tabBarController.tabBar.hidden=NO;
    HUD.delegate = controller;
    HUD.labelText = @"Loading";
    return HUD;
}


-(void)sendCustNum{
    
    BOOL isLogin = [PublicMethod checkLogin];
    
    if(!isLogin){
        FMDatabase * database = [PublicMethod shareDatabase];
        FMResultSet * rs = [database executeQuery:@"SELECT SUM(pid_amount) as amount FROM Shopping_Cart "];
        //购物车如果存在这件商品，就更新数量
        while ([rs next]){
            _cnt = [rs intForColumn:@"amount"] ;
            if (_cnt != 0) {
                
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_cnt],@"badgeValue", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];
            }else{
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"badgeValue", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];
            }
            
        }
    }else{
        NSString * url = [HSGlobal queryCustNum];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        if(manager == nil){
            return;
        }
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            
            if(code == 200){
                _cnt = [[object objectForKey:@"cartNum"]integerValue];
                if (_cnt != 0) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_cnt],@"badgeValue", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];
                }else{
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"badgeValue", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }
}

+(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:APPDELEGATE.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络不可用，请检查网络连接!";
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 11.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
    
    return isExistenceNetwork;
}
@end
