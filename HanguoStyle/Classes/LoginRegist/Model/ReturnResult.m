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
        
        self.message = [node objectForKey:@"message"];
        self.result = [[node objectForKey:@"result"] boolValue];
        self.token = [node objectForKey:@"token"];
        self.expired = [[node objectForKey:@"expired"]integerValue];
    }
    return self;
}
@end
