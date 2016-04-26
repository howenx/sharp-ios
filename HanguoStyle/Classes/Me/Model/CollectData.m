//
//  CollectData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/25.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "CollectData.h"
#import <JSONKit.h>
#import "NSString+GG.h"
@implementation CollectData
- (CollectData *) initWithJSONNode: (id) node
{
    
    self = [super init];
    if (self) {

        if(![NSString isNSNull:[node objectForKey:@"collectId"]]){
            self.collectId = [[node objectForKey:@"collectId"]longValue];
        }
        if(![NSString isNSNull:[node objectForKey:@"createAt"]]){
            self.createAt = [[node objectForKey:@"createAt"]longValue];
        }
        self.skuType = [node objectForKey:@"skuType"];
        if(![NSString isNSNull:[node objectForKey:@"skuTypeId"]]){
            self.skuTypeId = [[node objectForKey:@"skuTypeId"]longValue];
        }
        id tag = [node objectForKey:@"cartSkuDto"];
        
        self.price = [tag objectForKey:@"price"];
        self.itemColor = [tag objectForKey:@"itemColor"];
        if(![NSString isNSNull:[tag objectForKey:@"amount"]]){
            self.amount = [[tag objectForKey:@"amount"]integerValue];
        }
        self.invImg = [[[tag objectForKey:@"invImg"]objectFromJSONString]objectForKey:@"url"];
        self.invUrl = [tag objectForKey:@"invUrl"];
        self.skuTitle = [tag objectForKey:@"skuTitle"];
        self.itemSize = [tag objectForKey:@"itemSize"];
        if(![NSString isNSNull:[tag objectForKey:@"skuId"]]){
            self.skuId = [[tag objectForKey:@"skuId"]longValue];
        }
    }
    return self;
}
@end
