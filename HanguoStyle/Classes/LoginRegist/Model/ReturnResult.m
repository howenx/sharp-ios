//
//  ReturnResult.m
//  GiftGuide
//
//  Created by qianfeng on 15-8-18.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import "ReturnResult.h"
#import "NSString+GG.h"
@implementation ReturnResult
- (ReturnResult *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.message = [[node objectForKey:@"message"] objectForKey:@"message"];
        if(![NSString isNSNull:[[node objectForKey:@"message"] objectForKey:@"code"]]){
            self.code = [[[node objectForKey:@"message"] objectForKey:@"code"]integerValue];
        }
        
        self.token = [[node objectForKey:@"result"] objectForKey:@"token"];
        if(![NSString isNSNull:[[node objectForKey:@"result"]objectForKey:@"expired"]]){
            self.expired = [[[node objectForKey:@"result"]objectForKey:@"expired"]integerValue];
        }
        
        if(![NSString isNSNull:[[node objectForKey:@"result"]objectForKey:@"id"]]){
            self.alias = [NSString stringWithFormat:@"%ld",[[[node objectForKey:@"result"]objectForKey:@"id"]longValue]];
        }
        
    }
    return self;
}
@end
