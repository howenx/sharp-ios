//
//  GoodsPackData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsPackData.h"
@implementation GoodsPackImageData

@end


@implementation GoodsPackData
- (GoodsPackData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.idCode = [node objectForKey:@"id"];
        self.masterItemId = [node objectForKey:@"masterItemId"];
        self.themeImg = [node objectForKey:@"themeImg"];
        self.themeUrl = [node objectForKey:@"themeUrl"];
        self.sortNu = [[node objectForKey:@"sortNu"] integerValue];

        
        
        NSMutableArray * array = [NSMutableArray new];
        
        NSArray * photos = [node objectForKey:@"photos"];
        for (id photo in photos) {
            GoodsPackImageData * imageData = [GoodsPackImageData new];
            imageData.thumbUrl = [photo objectForKey:@"thumb_url"];
            imageData.url = [photo objectForKey:@"mobile_large_url"];
            
            [array addObject:imageData];
        }
        
        self.photoArray = array;
    }
    
    return self;
}

@end
