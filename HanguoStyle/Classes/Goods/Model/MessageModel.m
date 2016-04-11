//
//  MessageModel.m
//  HanguoStyle
//
//  Created by wayne on 16/4/6.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"msgType" : @"msgType",
             @"num" : @"num",
             @"content" : @"content",
             @"createAt" : @"createAt"
             };
}
@end
