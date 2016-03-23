//
//  RefTokenData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/14.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "RefTokenData.h"

@implementation RefTokenData
- (RefTokenData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.message = [node objectForKey:@"message"];
        self.result = [[node objectForKey:@"result"] boolValue];
        self.token = [node objectForKey:@"token"];
        self.expired = [[node objectForKey:@"expired"]integerValue];
    }
    return self;
}
@end
