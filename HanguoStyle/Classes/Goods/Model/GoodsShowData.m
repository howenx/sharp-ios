//
//  GoodsShowData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/19.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsShowData.h"
#import <JSONKit.h>
#import "NSString+GG.h"
@implementation MasterItemTagData

@end


@implementation GoodsShowData
- (GoodsShowData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
//        self.themeId = [node objectForKey:@"themeId"];
        self.itemId = [node objectForKey:@"itemId"];
        self.itemUrl = [node objectForKey:@"itemUrl"];

        NSDictionary * imageDict = [[node objectForKey:@"itemImg"] objectFromJSONString];
        self.itemImg = [imageDict objectForKey:@"url"];
        self.width = [[imageDict objectForKey:@"width"]floatValue];
        self.height = [[imageDict objectForKey:@"height"]floatValue];
        
        self.itemTitle = [node objectForKey:@"itemTitle"];
        self.itemPrice = [[node objectForKey:@"itemPrice"]floatValue];
        self.itemSrcPrice = [[node objectForKey:@"itemSrcPrice"]floatValue];
        self.itemDiscount = [[node objectForKey:@"itemDiscount"]floatValue];
        
        
        self.itemSoldAmount = [node objectForKey:@"itemSoldAmount"];
        self.collectCount = [[node objectForKey:@"collectCount"] integerValue];
        self.state = [node objectForKey:@"state"];
        
        
        self.itemType = [node objectForKey:@"itemType"];
        self.startAt = [node objectForKey:@"startAt"];
        self.endAt = [node objectForKey:@"endAt"];
        
        
        NSMutableArray * array = [NSMutableArray new];
        if([node objectForKey:@"masterItemTag"]!=nil && ![[node objectForKey:@"masterItemTag"] isKindOfClass:[NSNull class]]){
            NSArray * tags = [[node objectForKey:@"masterItemTag"] objectFromJSONString];
            for (id tag in tags) {
                MasterItemTagData * tagData = [MasterItemTagData new];
                
                tagData.name = [tag objectForKey:@"name"];
                tagData.url = [tag objectForKey:@"url"];
                tagData.angle = [[tag objectForKey:@"angle"]floatValue];
                tagData.top = [[tag objectForKey:@"top"]floatValue];
                tagData.left = [[tag objectForKey:@"left"]floatValue];
                
                [array addObject:tagData];
            }
            
            self.masterItemTag = array;
            
//            NSDictionary * tagDict = [[node objectForKey:@"itemMasterImg"] objectFromJSONString];
//            self.itemMasterImg = [tagDict objectForKey:@"url"];
//            self.width = [[tagDict objectForKey:@"width"]floatValue];
//            self.height = [[tagDict objectForKey:@"height"]floatValue];
        }
        
    }

    return self;
}
@end
