
//
//  ShowImageEvaluateModel.m
//  HanguoStyle
//
//  Created by wayne on 16/4/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "ShowImageEvaluateModel.h"

@implementation ShowImageEvaluateModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"createAt" : @"createAt",
             @"content" : @"content",
             @"picture" : @"picture",
             @"grade" : @"grade",
             @"userImg" : @"userImg",
             @"userName" : @"userName",
             @"buyAt" : @"buyAt",
             @"size" : @"size"
             };
}
@end
