//
//  AddressData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/4.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AddressData.h"

@implementation AddressData
- (AddressData *) initWithJSONNode: (id) node
{

    self = [super init];
    if (self) {
        
        self.addId = [node objectForKey:@"addId"];
        self.tel = [node objectForKey:@"tel"];
        self.name = [node objectForKey:@"name"];
        self.deliveryCity = [node objectForKey:@"deliveryCity"];
        
        self.deliveryDetail = [node objectForKey:@"deliveryDetail"];
        self.orDefault = [[node objectForKey:@"orDefault"] boolValue];
        self.userId = [[node objectForKey:@"userId"] integerValue];
        self.idCardNum = [node objectForKey:@"idCardNum"];
    }
    return self;
}
@end
