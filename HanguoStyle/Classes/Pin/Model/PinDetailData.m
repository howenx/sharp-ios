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
#import "GoodsShowData.h"
@implementation PinUsersData

@end

@implementation PinDetailData
- (PinDetailData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        NSDictionary * activityDict = [node objectForKey:@"activity"];

        self.pinUrl = [activityDict objectForKey:@"pinUrl"];
        if(![NSString isNSNull:[activityDict objectForKey:@"pinActiveId"]]){
            self.pinActiveId = [[activityDict objectForKey:@"pinActiveId"]longValue];
        }
        if(![NSString isNSNull:[activityDict objectForKey:@"pinId"]]){
            self.pinId = [[activityDict objectForKey:@"pinId"]longValue];
        }
        if(![NSString isNSNull:[activityDict objectForKey:@"masterUserId"]]){
            self.masterUserId = [[activityDict objectForKey:@"masterUserId"]longValue];
        }
        if(![NSString isNSNull:[activityDict objectForKey:@"personNum"]]){
            self.personNum = [[activityDict objectForKey:@"personNum"]integerValue];
        }

        if(![NSString isNSNull:[activityDict objectForKey:@"endCountDown"]]){
            self.endCountDown = [[activityDict objectForKey:@"endCountDown"]longValue];
        }
        self.pinPrice = [activityDict objectForKey:@"pinPrice"];
        self.joinPersons = [[activityDict objectForKey:@"joinPersons"]integerValue];
        self.status = [activityDict objectForKey:@"status"];
        self.pay = [activityDict objectForKey:@"pay"];
        
        
        self.userType = [activityDict objectForKey:@"userType"];

        if(![NSString isNSNull:[activityDict objectForKey:@"orJoinActivity"]]){
            self.orJoinActivity = [[activityDict objectForKey:@"orJoinActivity"]integerValue];
        }
        
        if(![NSString isNSNull:[activityDict objectForKey:@"orMaster"]]){
            self.orMaster = [[activityDict objectForKey:@"orMaster"]integerValue];
        }
        self.pinImg = [[[activityDict objectForKey:@"pinImg"]objectFromJSONString]objectForKey:@"url"];
        self.pinSkuUrl = [activityDict objectForKey:@"pinSkuUrl"];
        self.invArea = [activityDict objectForKey:@"invArea"];
        self.invCustoms = [activityDict objectForKey:@"invCustoms"];
        self.invAreaNm = [activityDict objectForKey:@"invAreaNm"];
        self.postalTaxRate = [activityDict objectForKey:@"postalTaxRate"];
        self.postalStandard = [activityDict objectForKey:@"postalStandard"];
        self.pinTitle = [activityDict objectForKey:@"pinTitle"];

        if(![NSString isNSNull:[activityDict objectForKey:@"skuId"]]){
            self.skuId = [[activityDict objectForKey:@"skuId"]longValue];
        }
        self.skuType = [activityDict objectForKey:@"skuType"];
        if(![NSString isNSNull:[activityDict objectForKey:@"skuTypeId"]]){
            self.skuTypeId = [[activityDict objectForKey:@"skuTypeId"]integerValue];
        }
        
        if(![NSString isNSNull:[activityDict objectForKey:@"pinTieredPriceId"]]){
            self.pinTieredPriceId = [[activityDict objectForKey:@"pinTieredPriceId"]longValue];
        }
        
        
        self.pinUsersArray = [NSMutableArray array];
        
        
        NSArray * tags = [activityDict objectForKey:@"pinUsers"];
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

        
        //推荐商品
        self.pushArray = [NSMutableArray array];
        if (![NSString isNSNull:[node objectForKey:@"themeList"]]) {
            NSArray * pushArray = [node objectForKey:@"themeList"];
            for(id tag in pushArray){
                GoodsShowData * data = [[GoodsShowData alloc] initWithJSONNode:tag];
                [self.pushArray addObject:data];
            }
        }
        
    }
    return self;
}


@end
