//
//  CartData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/24.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CartData.h"

@implementation CartData
- (CartData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.cartId = [[node objectForKey:@"cartId"]integerValue];
        self.skuId = [[node objectForKey:@"skuId"]integerValue];
        self.amount = [[node objectForKey:@"amount"]integerValue];
        self.itemColor = [node objectForKey:@"itemColor"];
        self.itemSize = [node objectForKey:@"itemSize"];
        self.itemPrice = [[node objectForKey:@"itemPrice"]floatValue];
        self.state = [node objectForKey:@"state"];
        self.shipFee = [[node objectForKey:@"shipFee"]integerValue];
        self.invArea = [node objectForKey:@"invArea"];
        self.restrictAmount = [[node objectForKey:@"restrictAmount"]integerValue];
        self.restAmount = [[node objectForKey:@"restAmount"]integerValue];
        self.invImg = [node objectForKey:@"invImg"];
        self.invUrl = [node objectForKey:@"invUrl"];
        self.invTitle = [node objectForKey:@"invTitle"];
        self.cartDelUrl = [node objectForKey:@"cartDelUrl"];
        
    }
    
    return self;
}

@end
