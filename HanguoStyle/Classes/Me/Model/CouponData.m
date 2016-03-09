//
//  CouponData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/26.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "CouponData.h"

@implementation CouponData
- (CouponData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        self.cateNm = [node objectForKey:@"cateNm"];
        self.coupId = [node objectForKey:@"coupId"];
        self.denomination = [node objectForKey:@"denomination"];
        self.limitQuota = [node objectForKey:@"limitQuota"];
        self.endAt = [node objectForKey:@"endAt"];
        self.startAt = [node objectForKey:@"startAt"];
        self.state = [node objectForKey:@"state"];
        self.useAt = [node objectForKey:@"useAt"];
    }
    return self;
}

@end
