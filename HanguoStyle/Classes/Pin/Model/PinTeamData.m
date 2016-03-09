//
//  PinTeamData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/29.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "PinTeamData.h"
#import "NSString+GG.h"
#import <JSONKit.h>
@implementation PinTeamData

- (PinTeamData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        
        self.pinTitle = [node objectForKey:@"pinTitle"];
        if(![NSString isNSNull:[node objectForKey:@"personNum"]]){
            self.personNum = [[node objectForKey:@"personNum"]integerValue];
        }
        if(![NSString isNSNull:[node objectForKey:@"joinPersons"]]){
            self.joinPersons = [[node objectForKey:@"joinPersons"]integerValue];
        }
        if(![NSString isNSNull:[node objectForKey:@"pinActiveId"]]){
            self.pinActiveId = [[node objectForKey:@"pinActiveId"]longValue];
        }
        if(![NSString isNSNull:[node objectForKey:@"endCountDown"]]){
            self.endCountDown = [[node objectForKey:@"endCountDown"]longValue];
        }
        
        self.pinImg = [[[node objectForKey:@"pinImg"]objectFromJSONString]objectForKey:@"url"];
        if(![NSString isNSNull:[node objectForKey:@"orderId"]]){
            self.orderId = [[node objectForKey:@"orderId"]longValue];
        }
        self.pinPrice = [node objectForKey:@"pinPrice"];
        self.pinSkuUrl = [node objectForKey:@"pinSkuUrl"];
        self.pinUrl = [node objectForKey:@"pinUrl"];
        if(![NSString isNSNull:[node objectForKey:@"orMaster"]]){
            self.orMaster = [[node objectForKey:@"orMaster"]longValue];
        }
        self.status = [node objectForKey:@"status"];

    }
    return self;
}


@end
