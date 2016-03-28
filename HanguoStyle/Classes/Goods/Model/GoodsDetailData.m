//
//  GoodsDetailData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/13.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsDetailData.h"
#import <JSONKit.h>
#import "NSString+GG.h"
#import "GoodsShowData.h"

@implementation itemPreviewImgsData

@end
@implementation SizeData

@end

@implementation GoodsDetailData
- (GoodsDetailData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        NSDictionary * mainDict = [node objectForKey:@"main"];
        self.mainId = [mainDict objectForKey:@"id"];
        self.itemTitle = [mainDict objectForKey:@"itemTitle"];
//        self.onShelvesAt = [mainDict objectForKey:@"onShelvesAt"];
//        self.offShelvesAt = [mainDict objectForKey:@"offShelvesAt"];
        self.itemDetailImgs = [mainDict objectForKey:@"itemDetailImgs"];
        self.itemFeatures = [[mainDict objectForKey:@"itemFeatures"] objectFromJSONString];
//        self.themeId = [mainDict objectForKey:@"themeId"];
//        self.state = [mainDict objectForKey:@"state"];
//        self.orFreeShip = [[mainDict objectForKey:@"orFreeShip"]boolValue];
//        self.deliveryArea = [mainDict objectForKey:@"deliveryArea"];
//        self.deliveryTime = [mainDict objectForKey:@"deliveryTime"];
//        self.orRestrictBuy = [[mainDict objectForKey:@"orRestrictBuy"]boolValue];

//        self.restrictAmount = [[mainDict objectForKey:@"restrictAmount"]integerValue];
//
//        self.orShoppingPoll = [[mainDict objectForKey:@"orShoppingPoll"]boolValue];
//        self.shareImg = [mainDict objectForKey:@"shareImg"];
        
        self.itemNotice = [mainDict objectForKey:@"itemNotice"];
        self.publicity = [[mainDict objectForKey:@"publicity"] objectFromJSONString];
        
        self.sizeArray = [NSMutableArray array];
        NSArray * tags = [node objectForKey:@"stock"];
        for (id tag in tags) {
            SizeData * sizeData = [[SizeData alloc]init];
            sizeData.sizeId = [tag objectForKey:@"id"];
            sizeData.itemColor = [tag objectForKey:@"itemColor"];
            sizeData.itemSize = [tag objectForKey:@"itemSize"];
            sizeData.itemSize = [sizeData.itemColor stringByAppendingString:sizeData.itemSize];//吧颜色和尺寸拼接到一起作为一个选项显示
            sizeData.itemPrice = [[tag objectForKey:@"itemPrice"]floatValue];
            sizeData.itemSrcPrice = [[tag objectForKey:@"itemSrcPrice"]floatValue];
            sizeData.itemDiscount = [[tag objectForKey:@"itemDiscount"]floatValue];
            sizeData.restAmount = [[tag objectForKey:@"restAmount"]integerValue];
//            sizeData.orSoldOut = [[tag objectForKey:@"orSoldOut"]boolValue];
            
            sizeData.invTitle = [tag objectForKey:@"invTitle"];
            sizeData.invCollection = [tag objectForKey:@"invCollection"];
            sizeData.orMasterInv = [[tag objectForKey:@"orMasterInv"]boolValue];
            sizeData.invUrl = [tag objectForKey:@"invUrl"];
            sizeData.state = [tag objectForKey:@"state"];
            sizeData.invArea = [tag objectForKey:@"invArea"];
            sizeData.invWeight = [tag objectForKey:@"invWeight"];
            sizeData.postalTaxRate = [tag objectForKey:@"postalTaxRate"];
            sizeData.postalStandard = [tag objectForKey:@"postalStandard"];
            sizeData.invCustoms = [tag objectForKey:@"invCustoms"];
            sizeData.shipFee = [tag objectForKey:@"shipFee"];
            sizeData.invImg = [[[tag objectForKey:@"invImg"]objectFromJSONString]objectForKey:@"url"];
            sizeData.invAreaNm = [tag objectForKey:@"invAreaNm"];
            
            sizeData.itemPreviewImgs = [NSMutableArray array];
            NSArray * tags = [[tag objectForKey:@"itemPreviewImgs"]objectFromJSONString];
            for (id tag in tags) {
                itemPreviewImgsData * tagData = [[itemPreviewImgsData alloc]init];
                
                tagData.url = [tag objectForKey:@"url"];
                tagData.width = [[tag objectForKey:@"width"]floatValue];
                tagData.height = [[tag objectForKey:@"height"]floatValue];
                
                [sizeData.itemPreviewImgs addObject:tagData];
            }
            
            sizeData.shareUrl = [tag objectForKey:@"shareUrl"];
            if(![NSString isNSNull:[tag objectForKey:@"collectCount"]]){
                 sizeData.collectCount = [[tag objectForKey:@"collectCount"]integerValue];
            }
           
//            sizeData.browseCount = [[tag objectForKey:@"browseCount"]integerValue];
            sizeData.skuType = [tag objectForKey:@"skuType"];
            sizeData.skuTypeId = [[tag objectForKey:@"skuTypeId"]longValue];
            sizeData.startAt = [tag objectForKey:@"startAt"];
            sizeData.endAt = [tag objectForKey:@"endAt"];
            sizeData.collectId = [[tag objectForKey:@"collectId"]longValue];
            

            
            [self.sizeArray addObject:sizeData];
        }
        self.pushArray = [NSMutableArray array];
//        if(![self.state isEqualToString:@"Y"] && ![self.state isEqualToString:@"P"] ){
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
