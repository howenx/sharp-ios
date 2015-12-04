//
//  MineData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/1.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MineData.h"

@implementation MineData
- (MineData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        self.name = [node objectForKey:@"name"];
        self.photo = [node objectForKey:@"photo"];
        self.realYn = [node objectForKey:@"realYn"];
        self.phoneNum = [node objectForKey:@"phoneNum"];
    }
    return self;
}

@end
