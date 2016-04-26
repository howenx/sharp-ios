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
        if(![NSString isNSNull:[imageDict objectForKey:@"width"]]){
            self.width = [[imageDict objectForKey:@"width"]floatValue];
        }
        
        if(![NSString isNSNull:[imageDict objectForKey:@"height"]]){
            self.height = [[imageDict objectForKey:@"height"]floatValue];
        }
        
        
        self.itemTitle = [node objectForKey:@"itemTitle"];
        if(![NSString isNSNull:[node objectForKey:@"itemPrice"]]){
            self.itemPrice = [[node objectForKey:@"itemPrice"]floatValue];
        }
        
        if(![NSString isNSNull:[node objectForKey:@"itemSrcPrice"]]){
            self.itemSrcPrice = [[node objectForKey:@"itemSrcPrice"]floatValue];
        }
        
        if(![NSString isNSNull:[node objectForKey:@"itemDiscount"]]){
            self.itemDiscount = [[node objectForKey:@"itemDiscount"]floatValue];
        }
        
        
        
        self.itemSoldAmount = [node objectForKey:@"itemSoldAmount"];
        if(![NSString isNSNull:[node objectForKey:@"collectCount"]]){
            self.collectCount = [[node objectForKey:@"collectCount"] integerValue];
        }
        
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
                if(![NSString isNSNull:[tag objectForKey:@"angle"]]){
                    tagData.angle = [[tag objectForKey:@"angle"]floatValue];
                }
                
                if(![NSString isNSNull:[tag objectForKey:@"top"]]){
                    tagData.top = [[tag objectForKey:@"top"]floatValue];
                }
                
                if(![NSString isNSNull:[tag objectForKey:@"left"]]){
                   tagData.left = [[tag objectForKey:@"left"]floatValue];
                }
                
                
                [array addObject:tagData];
            }
            
            self.masterItemTag = array;
        }
        
    }

    return self;
}
@end
