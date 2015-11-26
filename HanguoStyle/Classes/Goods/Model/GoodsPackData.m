//
//  GoodsPackData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsPackData.h"
@implementation ThemeData

@end

@implementation SliderData

@end


@implementation GoodsPackData
- (GoodsPackData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.message = [node objectForKey:@"message"];
        self.code = [[node objectForKey:@"code"]integerValue];
        
        
        NSMutableArray * arrayS = [NSMutableArray array];
        
        NSArray * sliders = [node objectForKey:@"slider"];
        for (id slider in sliders) {
            SliderData * sliderData = [SliderData new];
            sliderData.itemTarget = [slider objectForKey:@"itemTarget"];
            sliderData.url = [slider objectForKey:@"url"];
            
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
            [arrayT addObject:themeData];
        }
        
        self.themeArray = [arrayT copy];

        
    }
    
    return self;
}

@end
