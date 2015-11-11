//
//  GoodsShowData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/19.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsShowData.h"
#import <JSONKit.h>
@implementation MasterItemTagData

@end


@implementation GoodsShowData
- (GoodsShowData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.themeId = [node objectForKey:@"themeId"];
        self.itemId = [node objectForKey:@"itemId"];
        self.itemImg = [node objectForKey:@"itemImg"];
        self.itemUrl = [node objectForKey:@"itemUrl"];
        
        
        self.itemTitle = [node objectForKey:@"itemTitle"];
        self.itemPrice = [[node objectForKey:@"itemPrice"]floatValue];
        self.itemCostPrice = [[node objectForKey:@"itemCostPrice"]floatValue];
        self.itemDiscount = [[node objectForKey:@"itemDiscount"]floatValue];
        
        
        self.itemSoldAmount = [node objectForKey:@"itemSoldAmount"];
        self.isMasterItem = [[node objectForKey:@"isMasterItem"] boolValue];
        self.collectCount = [[node objectForKey:@"collectCount"] integerValue];
        
        
        
        NSMutableArray * array = [NSMutableArray new];
        NSLog(@"masterItemTag=%@",[node objectForKey:@"masterItemTag"]);
        if(self.isMasterItem){
            NSArray * tags = [[node objectForKey:@"masterItemTag"] objectFromJSONString];
            for (id tag in tags) {
                MasterItemTagData * tagData = [MasterItemTagData new];
                
                tagData.name = [tag objectForKey:@"name"];
                tagData.angle = [[tag objectForKey:@"angle"]floatValue];
                tagData.top = [[tag objectForKey:@"top"]floatValue];
                tagData.left = [[tag objectForKey:@"left"]floatValue];
                
                [array addObject:tagData];
            }
            
            self.masterItemTag = array;
            self.masterItemImg = [node objectForKey:@"masterItemImg"];
        }
        
    }

    return self;
}
@end
