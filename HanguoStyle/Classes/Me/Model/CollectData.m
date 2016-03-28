//
//  CollectData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/25.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "CollectData.h"
#import <JSONKit.h>
@implementation CollectData
- (CollectData *) initWithJSONNode: (id) node
{
    
    self = [super init];
    if (self) {

        
        self.collectId = [[node objectForKey:@"collectId"]longValue];
        self.createAt = [[node objectForKey:@"createAt"]longValue];
        self.skuType = [node objectForKey:@"skuType"];
        self.skuTypeId = [[node objectForKey:@"skuTypeId"]longValue];
        
        id tag = [node objectForKey:@"cartSkuDto"];
        
        self.price = [tag objectForKey:@"price"];
        self.itemColor = [tag objectForKey:@"itemColor"];
        self.amount = [[tag objectForKey:@"amount"]integerValue];
        self.invImg = [[[tag objectForKey:@"invImg"]objectFromJSONString]objectForKey:@"url"];
        self.invUrl = [tag objectForKey:@"invUrl"];
        self.skuTitle = [tag objectForKey:@"skuTitle"];
        self.itemSize = [tag objectForKey:@"itemSize"];
        self.skuId = [[tag objectForKey:@"skuId"]longValue];
        
    }
    return self;
}
@end
