//
//  GoodsPackData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsPackData.h"
#import <JSONKit.h>
#import "NSString+GG.h"
@implementation ThemeData

@end

@implementation SliderData

@end


@implementation GoodsPackData
- (GoodsPackData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.message = [[node objectForKey:@"message"] objectForKey:@"message"];
        if(![NSString isNSNull:[[node objectForKey:@"message"] objectForKey:@"code"]]){
            self.code = [[[node objectForKey:@"message"] objectForKey:@"code"]integerValue];
        }
        
        if(![NSString isNSNull:[node objectForKey:@"page_count"]]){
            self.pageCount = [[node objectForKey:@"page_count"] integerValue];
        }
        NSMutableArray * arrayS = [NSMutableArray array];
        
        NSArray * sliders = [node objectForKey:@"slider"];
        for (id slider in sliders) {
            SliderData * sliderData = [SliderData new];
            sliderData.itemTarget = [slider objectForKey:@"itemTarget"];
            sliderData.url = [slider objectForKey:@"url"];
            sliderData.targetType = [slider objectForKey:@"targetType"];
            NSDictionary * tagDict = [[slider objectForKey:@"url"] objectFromJSONString];
            sliderData.url = [tagDict objectForKey:@"url"];
            if(![NSString isNSNull:[tagDict objectForKey:@"width"]]){
                sliderData.width = [[tagDict objectForKey:@"width"]floatValue];
            }
            
            if(![NSString isNSNull:[tagDict objectForKey:@"height"]]){
                sliderData.height = [[tagDict objectForKey:@"height"]floatValue];
            }
            
            
            [arrayS addObject:sliderData];
        }
        
        self.sliderArray = [arrayS copy];
        
        
        NSMutableArray * arrayT = [NSMutableArray array];
        
        NSArray * themes = [node objectForKey:@"theme"];
        for (id theme in themes) {
            ThemeData * themeData = [ThemeData new];
            themeData.idCode = [theme objectForKey:@"id"];
            themeData.themeImg = [theme objectForKey:@"themeImg"];
            themeData.themeUrl = [theme objectForKey:@"themeUrl"];
            NSDictionary * tagDict = [[theme objectForKey:@"themeImg"] objectFromJSONString];
            themeData.themeImg = [tagDict objectForKey:@"url"];
            if(![NSString isNSNull:[tagDict objectForKey:@"width"]]){
                themeData.width = [[tagDict objectForKey:@"width"]floatValue];
            }
            if(![NSString isNSNull:[tagDict objectForKey:@"height"]]){
                themeData.height = [[tagDict objectForKey:@"height"]floatValue];
            }
            
            themeData.type = [theme objectForKey:@"type"];
            [arrayT addObject:themeData];
        }
        
        self.themeArray = [arrayT copy];

        
    }
    
    return self;
}

@end
