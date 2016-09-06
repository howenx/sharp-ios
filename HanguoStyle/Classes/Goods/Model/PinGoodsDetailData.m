//
//  PinGoodsDetailData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/17.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "PinGoodsDetailData.h"
#import <JSONKit.h>
#import "NSString+GG.h"
#import "GoodsShowData.h"
@implementation ItemPreviewImgsData

@end
@implementation PinTieredPricesData

@end

@implementation PinGoodsDetailData

- (PinGoodsDetailData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        NSDictionary * mainDict = [node objectForKey:@"main"];
        self.mainId = [mainDict objectForKey:@"id"];
        self.itemTitle = [mainDict objectForKey:@"itemTitle"];
        self.itemDetailImgs = [mainDict objectForKey:@"itemDetailImgs"];
//        self.itemFeatures = [[mainDict objectForKey:@"itemFeatures"] objectFromJSONString];
        self.itemFeatures = [NSMutableDictionary dictionary];
        self.itemFeaturesKeyArray = [NSMutableArray array];
        NSString * itemFeaturesStr = [mainDict objectForKey:@"itemFeatures"];
        if(![NSString isBlankString:itemFeaturesStr] ){
            //去掉大括号后在字符串前面加一个空格，保持第一对和后面的键值对格式一致，后面好解析
            NSArray  * itemFeaturesArray= [[@" " stringByAppendingString:[itemFeaturesStr substringWithRange:NSMakeRange(1,itemFeaturesStr.length-2)]] componentsSeparatedByString:@","];
            for(NSString * singleStr in itemFeaturesArray){
                NSArray  * singleArray = [singleStr componentsSeparatedByString:@":"];
                //去掉前面的空格和单引号，去掉后面单引号
                NSString * key =  [singleArray[0]substringWithRange:NSMakeRange(2,((NSString *)singleArray[0]).length-3)];
                [self.itemFeaturesKeyArray addObject:key];
                NSString * value = [singleArray[1]substringWithRange:NSMakeRange(2,((NSString *)singleArray[1]).length-3)];
                [self.itemFeatures setObject:value forKey:key];
            }
        }
        self.itemNotice = [mainDict objectForKey:@"itemNotice"];
        if(![NSString isNSNull:[mainDict objectForKey:@"publicity"]]){
            self.publicity = [[mainDict objectForKey:@"publicity"] objectFromJSONString];
        }
        
        NSDictionary * stockDict = [node objectForKey:@"stock"];
        
        self.sizeId = [stockDict objectForKey:@"id"];
        self.shareUrl = [stockDict objectForKey:@"shareUrl"];
        self.status = [stockDict objectForKey:@"status"];
        self.pinTitle = [stockDict objectForKey:@"pinTitle"];
        self.startAt = [stockDict objectForKey:@"startAt"];
        self.endAt = [stockDict objectForKey:@"endAt"];
        if(![NSString isNSNull:[stockDict objectForKey:@"restrictAmount"]]){
            self.restrictAmount = [[stockDict objectForKey:@"restrictAmount"]integerValue];
        }
        
        self.floorPrice = [[stockDict objectForKey:@"floorPrice"]objectFromJSONString];
        self.pinDiscount = [stockDict objectForKey:@"pinDiscount"];
        self.pinRedirectUrl = [stockDict objectForKey:@"pinRedirectUrl"];
        self.invArea = [stockDict objectForKey:@"invArea"];
        if(![NSString isNSNull:[stockDict objectForKey:@"restAmount"]]){
            self.restAmount = [[stockDict objectForKey:@"restAmount"]integerValue];
        }
        
        self.itemPreviewImgs = [NSMutableArray array];
        NSArray * tags = [[stockDict objectForKey:@"itemPreviewImgs"]objectFromJSONString];
        for (id tag in tags) {
            ItemPreviewImgsData * tagData = [[ItemPreviewImgsData alloc]init];
            
            tagData.url = [tag objectForKey:@"url"];
            if(![NSString isNSNull:[tag objectForKey:@"collectId"]]){
                
            }
            tagData.width = [[tag objectForKey:@"width"]floatValue];
            if(![NSString isNSNull:[tag objectForKey:@"collectId"]]){
                
            }
            tagData.height = [[tag objectForKey:@"height"]floatValue];
            
            [self.itemPreviewImgs addObject:tagData];
        }
        self.invWeight = [stockDict objectForKey:@"invWeight"];
        self.invCustoms = [stockDict objectForKey:@"invCustoms"];
        self.postalTaxRate = [stockDict objectForKey:@"postalTaxRate"];
        self.postalStandard = [stockDict objectForKey:@"postalStandard"];
        self.invAreaNm = [stockDict objectForKey:@"invAreaNm"];
        if(![NSString isNSNull:[stockDict objectForKey:@"collectCount"]]){
            self.collectCount = [[stockDict objectForKey:@"collectCount"]integerValue];
        }
//        self.browseCount = [[stockDict objectForKey:@"browseCount"]integerValue];
        if(![NSString isNSNull:[stockDict objectForKey:@"soldAmount"]]){
            self.soldAmount = [[stockDict objectForKey:@"soldAmount"]integerValue];
        }
        
        self.invImg = [[[stockDict objectForKey:@"invImg"]objectFromJSONString]objectForKey:@"url"];
        self.invPrice = [stockDict objectForKey:@"invPrice"];
        self.skuType = [stockDict objectForKey:@"skuType"];
        if(![NSString isNSNull:[stockDict objectForKey:@"skuTypeId"]]){
            self.skuTypeId = [[stockDict objectForKey:@"skuTypeId"]longValue];
        }
        
        if(![NSString isNSNull:[stockDict objectForKey:@"collectId"]]){
            self.collectId = [[stockDict objectForKey:@"collectId"]longValue];
        }
        


        self.pinTieredPricesArray = [NSMutableArray array];
        NSArray * pinArray = [stockDict objectForKey:@"pinTieredPrices"];
        for (id tag in pinArray) {
            PinTieredPricesData * tagData = [[PinTieredPricesData alloc]init];
            tagData.pinTieredId = [tag objectForKey:@"id"];
            tagData.masterCouponClassName = [tag objectForKey:@"masterCouponClassName"];
            tagData.masterCouponStartAt = [tag objectForKey:@"masterCouponStartAt"];
            tagData.masterCouponEndAt = [tag objectForKey:@"masterCouponEndAt"];
            tagData.memberCouponClassName = [tag objectForKey:@"memberCouponClassName"];
            tagData.memberCouponStartAt = [tag objectForKey:@"memberCouponStartAt"];
            tagData.memberCouponEndAt = [tag objectForKey:@"memberCouponEndAt"];
            
            if(![NSString isNSNull:[tag objectForKey:@"masterCouponQuota"]]){
                tagData.masterCouponQuota = [[tag objectForKey:@"masterCouponQuota"]floatValue];
            }
            if(![NSString isNSNull:[tag objectForKey:@"masterCoupon"]]){
                tagData.masterCoupon = [[tag objectForKey:@"masterCoupon"]floatValue];
            }
            if(![NSString isNSNull:[tag objectForKey:@"masterMinPrice"]]){
                tagData.masterMinPrice = [[tag objectForKey:@"masterMinPrice"]floatValue];
            }
            if(![NSString isNSNull:[tag objectForKey:@"memberCouponQuota"]]){
                tagData.memberCouponQuota = [[tag objectForKey:@"memberCouponQuota"]floatValue];
            }
            if(![NSString isNSNull:[tag objectForKey:@"memberCoupon"]]){
                tagData.memberCoupon = [[tag objectForKey:@"memberCoupon"]floatValue];
            }
            if(![NSString isNSNull:[tag objectForKey:@"memberMinPrice"]]){
                tagData.memberMinPrice = [[tag objectForKey:@"memberMinPrice"]floatValue];
            }

            
            tagData.price = [tag objectForKey:@"price"];
            if(![NSString isNSNull:[tag objectForKey:@"peopleNum"]]){
                tagData.peopleNum = [[tag objectForKey:@"peopleNum"]integerValue];
            }
            
            
            [self.pinTieredPricesArray addObject:tagData];
        }
        
        
        
        self.pushArray = [NSMutableArray array];
//        if(![self.status isEqualToString:@"Y"] && ![self.status isEqualToString:@"P"] ){
            if (![NSString isNSNull:[node objectForKey:@"push"]]) {
                NSArray * pushArray = [node objectForKey:@"push"];
                for(id tag in pushArray){
                    GoodsShowData * data = [[GoodsShowData alloc] initWithJSONNode:tag];
                    [self.pushArray addObject:data];
                }
            }

//        }
    }
    return self;
}

@end
