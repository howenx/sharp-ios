//
//  SearchLogisticsData.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/15.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "SearchLogisticsData.h"
@implementation FlowData

@end
@implementation SearchLogisticsData
- (SearchLogisticsData *) initWithJSONNode: (id) node{
    self = [super init];
    if (self) {
        self.nu = [node objectForKey:@"nu"];
        self.com = [node objectForKey:@"com"];
        NSString * stateId = [node objectForKey:@"state"];
        //0在途中、1已揽收、2疑难、3已签收、4退签、5同城派送中、6退回、7转单
        if([@"0"isEqualToString:stateId]){
            self.state = @"在途中";
        }else if([@"1"isEqualToString:stateId]){
            self.state = @"已揽收";
        }else if([@"2"isEqualToString:stateId]){
            self.state = @"疑难";
        }else if([@"3"isEqualToString:stateId]){
            self.state = @"已签收";
        }else if([@"4"isEqualToString:stateId]){
            self.state = @"退签";
        }else if([@"5"isEqualToString:stateId]){
            self.state = @"同城派送中";
        }else if([@"6"isEqualToString:stateId]){
            self.state = @"退回";
        }else if([@"7"isEqualToString:stateId]){
            self.state = @"转单";
        }
        self.expressName = [node objectForKey:@"expressName"];
        self.flowArray = [NSMutableArray array];
        NSArray * tags = [node objectForKey:@"data"];
        for (id tag in tags) {
            FlowData * flowData = [[FlowData alloc]init];
            flowData.time = [tag objectForKey:@"time"];
            flowData.location = [tag objectForKey:@"location"];
            flowData.context = [tag objectForKey:@"context"];
            [self.flowArray addObject:flowData];
        }
    }
    return self;
}
@end
