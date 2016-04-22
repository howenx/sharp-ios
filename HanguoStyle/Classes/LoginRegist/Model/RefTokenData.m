//
//  RefTokenData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/14.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "RefTokenData.h"
#import "NSString+GG.h"
@implementation RefTokenData
- (RefTokenData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.message = [node objectForKey:@"message"];
        if(![NSString isNSNull:[node objectForKey:@"result"]]){
            self.result = [[node objectForKey:@"result"] boolValue];
        }
        
        self.token = [node objectForKey:@"token"];
        if(![NSString isNSNull:[node objectForKey:@"expired"]]){
            self.expired = [[node objectForKey:@"expired"]integerValue];
        }
        
    }
    return self;
}
@end
