//
//  ReturnResult.m
//  GiftGuide
//
//  Created by qianfeng on 15-8-18.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import "ReturnResult.h"

@implementation ReturnResult
- (ReturnResult *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.message = [[node objectForKey:@"message"] objectForKey:@"message"];
        self.code = [[[node objectForKey:@"message"] objectForKey:@"code"]integerValue];
        self.token = [node objectForKey:@"token"];
        self.expired = [[node objectForKey:@"expired"]integerValue];
    }
    return self;
}
@end
