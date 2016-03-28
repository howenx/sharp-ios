//
//  InitAppDelegate.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/26.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "InitAppDelegate.h"

@implementation InitAppDelegate

- (NSString *)intervalSinceNow: (NSDate *) theDate
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
@end
