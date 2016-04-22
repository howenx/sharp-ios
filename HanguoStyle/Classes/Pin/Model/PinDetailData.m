//
//  PinDetailData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/2.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "PinDetailData.h"
#import "NSString+GG.h"
#import <JSONKit.h>
@implementation PinUsersData

@end

@implementation PinDetailData
- (PinDetailData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {


        self.pinUrl = [node objectForKey:@"pinUrl"];
        if(![NSString isNSNull:[node objectForKey:@"pinActiveId"]]){
            self.pinActiveId = [[node objectForKey:@"pinActiveId"]longValue];
        }
        if(![NSString isNSNull:[node objectForKey:@"pinId"]]){
            self.pinId = [[node objectForKey:@"pinId"]longValue];
        }
        if(![NSString isNSNull:[node objectForKey:@"masterUserId"]]){
            self.masterUserId = [[node objectForKey:@"masterUserId"]longValue];
        }
        if(![NSString isNSNull:[node objectForKey:@"personNum"]]){
            self.personNum = [[node objectForKey:@"personNum"]integerValue];
        }

        if(![NSString isNSNull:[node objectForKey:@"endCountDown"]]){
            self.endCountDown = [[node objectForKey:@"endCountDown"]longValue];
        }
        self.pinPrice = [node objectForKey:@"pinPrice"];
        self.joinPersons = [[node objectForKey:@"joinPersons"]integerValue];
        self.status = [node objectForKey:@"status"];
        self.pay = [node objectForKey:@"pay"];
        
        
        self.userType = [node objectForKey:@"userType"];

        if(![NSString isNSNull:[node objectForKey:@"orJoinActivity"]]){
            self.orJoinActivity = [[node objectForKey:@"orJoinActivity"]integerValue];
        }
        
        if(![NSString isNSNull:[node objectForKey:@"orMaster"]]){
            self.orMaster = [[node objectForKey:@"orMaster"]integerValue];
        }
        self.pinImg = [[[node objectForKey:@"pinImg"]objectFromJSONString]objectForKey:@"url"];
        self.pinSkuUrl = [node objectForKey:@"pinSkuUrl"];
        self.invArea = [node objectForKey:@"invArea"];
        self.invCustoms = [node objectForKey:@"invCustoms"];
        self.invAreaNm = [node objectForKey:@"invAreaNm"];
        self.postalTaxRate = [node objectForKey:@"postalTaxRate"];
        self.postalStandard = [node objectForKey:@"postalStandard"];
        self.pinTitle = [node objectForKey:@"pinTitle"];

        if(![NSString isNSNull:[node objectForKey:@"skuId"]]){
            self.skuId = [[node objectForKey:@"skuId"]longValue];
        }
        self.skuType = [node objectForKey:@"skuType"];
        if(![NSString isNSNull:[node objectForKey:@"skuTypeId"]]){
            self.skuTypeId = [[node objectForKey:@"skuTypeId"]integerValue];
        }
        
        if(![NSString isNSNull:[node objectForKey:@"pinTieredPriceId"]]){
            self.pinTieredPriceId = [[node objectForKey:@"pinTieredPriceId"]longValue];
        }
        
        
        self.pinUsersArray = [NSMutableArray array];
        
        
        NSArray * tags = [node objectForKey:@"pinUsers"];
        for (id tag in tags) {

            PinUsersData * detailData = [[PinUsersData alloc]init];
            if(![NSString isNSNull:[tag objectForKey:@"orMaster"]]){
                detailData.orMaster = [[tag objectForKey:@"orMaster"]longValue];
            }
            detailData.joinAt = [tag objectForKey:@"joinAt"];
            detailData.userImg = [tag objectForKey:@"userImg"];
            detailData.userNm = [tag objectForKey:@"userNm"];
            
            [self.pinUsersArray addObject:detailData];
        }

        
        
        
    }
    return self;
}


@end
