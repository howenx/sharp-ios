//
//  CartData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/24.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CartData.h"
@implementation CartDetailData

@end
@implementation CartData
- (CartData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        
        self.invArea = [node objectForKey:@"invArea"];
        self.invCustoms = [node objectForKey:@"invCustoms"];
        self.cartDetailArray = [NSMutableArray array];
        
        
        NSArray * tags = [node objectForKey:@"carts"];
        for (id tag in tags) {
            CartDetailData * detailData = [[CartDetailData alloc]init];
            detailData.cartId = [[tag objectForKey:@"cartId"]integerValue];
            detailData.skuId = [[tag objectForKey:@"skuId"]integerValue];
            detailData.amount = [[tag objectForKey:@"amount"]integerValue];
            detailData.itemColor = [tag objectForKey:@"itemColor"];
            detailData.itemSize = [tag objectForKey:@"itemSize"];
            detailData.itemPrice = [[tag objectForKey:@"itemPrice"]floatValue];
            detailData.state = [tag objectForKey:@"state"];
            detailData.shipFee = [[tag objectForKey:@"shipFee"]integerValue];
            detailData.invArea = [tag objectForKey:@"invArea"];
            detailData.restrictAmount = [[tag objectForKey:@"restrictAmount"]integerValue];
            detailData.restAmount = [[tag objectForKey:@"restAmount"]integerValue];
            detailData.invImg = [tag objectForKey:@"invImg"];
            detailData.invUrl = [tag objectForKey:@"invUrl"];
            detailData.invTitle = [tag objectForKey:@"invTitle"];
            detailData.cartDelUrl = [tag objectForKey:@"cartDelUrl"];
            detailData.invCustoms = [tag objectForKey:@"invCustoms"];
            detailData.postalTaxRate = [tag objectForKey:@"postalTaxRate"];
            [self.cartDetailArray addObject:detailData];
        }
    }
    return self;
}

@end
