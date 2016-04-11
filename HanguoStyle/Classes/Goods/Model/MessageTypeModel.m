//
//  MessageTypeModel.m
//  HanguoStyle
//
//  Created by wayne on 16/4/7.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MessageTypeModel.h"

//@property  (nonatomic , strong)NSString * ID;
//@property  (nonatomic , strong)NSString * msgContent;
//@property  (nonatomic , strong)NSString * msgImg;
//@property  (nonatomic , strong)NSString * createAt;
//@property  (nonatomic , strong)NSString * msgTitle;
//@property  (nonatomic , strong)NSString * msgType;
//@property  (nonatomic , strong)NSString * msgUrl;
//@property  (nonatomic , strong)NSString * targetType;


@implementation MessageTypeModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             @"msgContent" : @"msgContent",
             @"msgImg" : @"msgImg",
             @"createAt" : @"createAt",
             @"msgTitle" : @"msgTitle",
             @"msgType" : @"msgType",
             @"msgUrl" : @"msgUrl",
             @"targetType" : @"targetType"
             };
}
@end
