//
//  CartData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/24.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CartData.h"
#import <JSONKit.h>
@implementation CartDetailData

@end
@implementation CartData
- (CartData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        
        self.invAreaNm = [node objectForKey:@"invAreaNm"];
        self.invArea = [node objectForKey:@"invArea"];
        self.invCustoms = [node objectForKey:@"invCustoms"];
        self.postalStandard = [[node objectForKey:@"postalStandard"]floatValue];
        self.cartDetailArray = [NSMutableArray array];
        self.selectPostalTaxRate = 0;
        
        NSArray * tags = [node objectForKey:@"carts"];
        for (id tag in tags) {
            CartDetailData * detailData = [[CartDetailData alloc]init];
            detailData.cartId = [[tag objectForKey:@"cartId"]integerValue];
            detailData.skuId = [[tag objectForKey:@"skuId"]longValue];
            detailData.amount = [[tag objectForKey:@"amount"]integerValue];
            detailData.itemColor = [tag objectForKey:@"itemColor"];
            detailData.itemSize = [tag objectForKey:@"itemSize"];
            detailData.itemPrice = [[tag objectForKey:@"itemPrice"]floatValue];
            detailData.state = [tag objectForKey:@"state"];
            detailData.invArea = [tag objectForKey:@"invArea"];
            detailData.invAreaNm = [node objectForKey:@"invAreaNm"];
            detailData.restrictAmount = [[tag objectForKey:@"restrictAmount"]integerValue];
            detailData.restAmount = [[tag objectForKey:@"restAmount"]integerValue];
            detailData.invImg = [[[tag objectForKey:@"invImg"]objectFromJSONString]objectForKey:@"url"];
            detailData.invUrl = [tag objectForKey:@"invUrl"];
            detailData.invTitle = [tag objectForKey:@"invTitle"];
            detailData.cartDelUrl = [tag objectForKey:@"cartDelUrl"];
            detailData.invCustoms = [tag objectForKey:@"invCustoms"];
            detailData.postalTaxRate = [tag objectForKey:@"postalTaxRate"];
            detailData.skuType = [tag objectForKey:@"skuType"];
            
            detailData.skuTypeId = [[tag objectForKey:@"skuTypeId"]longValue];
            
            
            
            if([detailData.state isEqualToString:@"G"]){
                self.selectPostalTaxRate = self.selectPostalTaxRate + detailData.itemPrice * detailData.amount * [detailData.postalTaxRate intValue] * 0.01;
            }
            [self.cartDetailArray addObject:detailData];
        }
    }
    return self;
}

@end
