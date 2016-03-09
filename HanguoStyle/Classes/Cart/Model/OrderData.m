//
//  OrderData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/15.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "OrderData.h"
#import "NSString+GG.h"
@implementation OrderDetailData

@end


@implementation CouponsData

@end

@implementation OrderData

- (OrderData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        NSDictionary * dict = [node objectForKey:@"address"];
        if (![dict isKindOfClass:[NSNull class]]) {
            self.addressData = [[AddressData alloc]init];
            self.addressData.addId = [[dict objectForKey:@"addId"]stringValue];
            self.addressData.tel = [dict objectForKey:@"tel"];
            self.addressData.name = [dict objectForKey:@"name"];
            self.addressData.deliveryCity = [dict objectForKey:@"deliveryCity"];
            self.addressData.deliveryDetail = [dict objectForKey:@"deliveryDetail"];
            self.addressData.idCardNum = [dict objectForKey:@"idCardNum"];
            self.addressData.orDefault = YES;
        }
        
        self.shipFee = [node objectForKey:@"shipFee"];
        self.factPortalFee = [node objectForKey:@"factPortalFee"];
        self.portalFee = [node objectForKey:@"portalFee"];
        self.factShipFee = [node objectForKey:@"factShipFee"];
        
        self.singleCustomsArray = [NSMutableArray array];
        
        
        NSArray * tags = [node objectForKey:@"singleCustoms"];
        for (id tag in tags) {
            OrderDetailData * detailData = [[OrderDetailData alloc]init];
            detailData.factSingleCustomsShipFee = [tag objectForKey:@"factSingleCustomsShipFee"];
            detailData.singleCustomsSumAmount = [[tag objectForKey:@"singleCustomsSumAmount"]integerValue];
            detailData.invCustoms = [tag objectForKey:@"invCustoms"];
            detailData.portalSingleCustomsFee = [tag objectForKey:@"portalSingleCustomsFee"];
            detailData.shipSingleCustomsFee = [tag objectForKey:@"shipSingleCustomsFee"];
            detailData.factPortalFeeSingleCustoms = [tag objectForKey:@"factPortalFeeSingleCustoms"];
            detailData.singleCustomsSumFee = [tag objectForKey:@"singleCustomsSumFee"];
            detailData.invArea = [tag objectForKey:@"invArea"];
            detailData.invAreaNm = [tag objectForKey:@"invAreaNm"];
            
            detailData.cartDataArray = [NSMutableArray array];

            [self.singleCustomsArray addObject:detailData];
        }
        
        
        if (![[node objectForKey:@"coupons"] isKindOfClass:[NSNull class]]) {
            
            self.couponsArray = [NSMutableArray array];
            NSArray * couponsTags = [node objectForKey:@"coupons"];
            for (id tag in couponsTags) {
                CouponsData * couponsData = [[CouponsData alloc]init];
                couponsData.coupId = [tag objectForKey:@"coupId"];
                couponsData.denomination = [tag objectForKey:@"denomination"];
                couponsData.startAt = [tag objectForKey:@"startAt"];
                couponsData.endAt = [tag objectForKey:@"endAt"];
                couponsData.useAt = [tag objectForKey:@"useAt"];
                couponsData.state = [tag objectForKey:@"state"];
                couponsData.limitQuota = [tag objectForKey:@"limitQuota"];
                couponsData.cateNm = [tag objectForKey:@"cateNm"];
                
                
                [self.couponsArray addObject:couponsData];
            }

        }
       
        
    }
    return self;
}

@end
