//
//  ShowEvaluateModel.m
//  HanguoStyle
//
//  Created by wayne on 16/4/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "ShowEvaluateModel.h"
#import <JSONKit.h>
#import "NSString+GG.h"
@implementation ShowEvaluateModel

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"createAt" : @"createAt",
//             @"content" : @"content",
//             @"picture" : @"picture",
//             @"grade" : @"grade",
//             @"userImg" : @"userImg",
//             @"userName" : @"userName"
//             };
//}

- (ShowEvaluateModel *) initWithJSONNode: (id) node
{

    
    self = [super init];
    if (self) {
//        @property  (nonatomic , strong) NSString * createAt;//评价时间
//        @property  (nonatomic , strong) NSString * content;//评价内容
//        @property  (nonatomic , strong) NSMutableArray * picture;//晒图
//        @property  (nonatomic , assign) NSInteger grade;//评分1,2,3,4,5
//        @property  (nonatomic , strong) NSString * userImg;//用户头像
//        @property  (nonatomic , strong) NSString * userName;//用户名
        
        
        self.createAt = [node objectForKey:@"createAt"];
        self.content = [node objectForKey:@"content"];
        self.grade = [[node objectForKey:@"grade"] integerValue];
        self.userImg = [node objectForKey:@"userImg"];
        self.userName = [node objectForKey:@"userName"];
        self.buyAt = [node objectForKey:@"buyAt"];
        self.size = [node objectForKey:@"size"];
        
        if (![NSString isNSNull:[node objectForKey:@"picture"]]) {
            self.picture = [NSMutableArray array];
            self.picture = [[node objectForKey:@"picture"]  objectFromJSONString];
        }

    }
    return self;
}
@end
