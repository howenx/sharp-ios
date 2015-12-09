//
//  GoodsDetailData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/13.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsDetailData.h"
#import <JSONKit.h>
//@implementation SaleMsg
//
//@end
//@implementation ColorData
//
//@end
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
        self.onShelvesAt = [mainDict objectForKey:@"onShelvesAt"];
        self.offShelvesAt = [mainDict objectForKey:@"offShelvesAt"];
        self.itemDetailImgs = [[mainDict objectForKey:@"itemDetailImgs"]objectFromJSONString];
        self.itemFeatures = [[mainDict objectForKey:@"itemFeatures"] objectFromJSONString];
        self.themeId = [mainDict objectForKey:@"themeId"];
        self.state = [mainDict objectForKey:@"state"];
        self.orFreeShip = [[mainDict objectForKey:@"orFreeShip"]boolValue];
        self.deliveryArea = [mainDict objectForKey:@"deliveryArea"];
        self.deliveryTime = [mainDict objectForKey:@"deliveryTime"];
        self.orRestrictBuy = [[mainDict objectForKey:@"orRestrictBuy"]boolValue];

        self.restrictAmount = [[mainDict objectForKey:@"restrictAmount"]integerValue];

        self.orShoppingPoll = [[mainDict objectForKey:@"orShoppingPoll"]boolValue];
        self.shareImg = [mainDict objectForKey:@"shareImg"];
        self.shareUrl = [mainDict objectForKey:@"shareUrl"];
        self.collectCount = [[mainDict objectForKey:@"collectCount"]integerValue];
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
            sizeData.orSoldOut = [[tag objectForKey:@"orSoldOut"]boolValue];
            sizeData.itemPreviewImgs = [[tag objectForKey:@"itemPreviewImgs"]objectFromJSONString];
            sizeData.invTitle = [tag objectForKey:@"invTitle"];
            sizeData.invCollection = [tag objectForKey:@"invCollection"];
            sizeData.orMasterInv = [[tag objectForKey:@"orMasterInv"]boolValue];
            sizeData.invUrl = [tag objectForKey:@"invUrl"];
            sizeData.state = [tag objectForKey:@"state"];
            sizeData.invArea = [tag objectForKey:@"invArea"];
            sizeData.invWeight = [tag objectForKey:@"invWeight"];
            sizeData.postalTaxRate = [tag objectForKey:@"postalTaxRate"];
            [self.sizeArray addObject:sizeData];
        }

        


    }
    return self;
}
@end
