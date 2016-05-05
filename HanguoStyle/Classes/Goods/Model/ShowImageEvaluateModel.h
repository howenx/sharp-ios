//
//  ShowImageEvaluateModel.h
//  HanguoStyle
//
//  Created by wayne on 16/4/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowImageEvaluateModel : NSObject
@property  (nonatomic , strong) NSString * createAt;//评价时间
@property  (nonatomic , strong) NSString * content;//评价内容
@property  (nonatomic , strong) NSString * picture;//晒图
@property  (nonatomic , assign) NSInteger grade;//评分1,2,3,4,5
@property  (nonatomic , strong) NSString * userImg;//用户头像
@property  (nonatomic , strong) NSString * userName;//用户名
@property  (nonatomic , strong) NSString * buyAt;//购买时间
@property  (nonatomic , strong) NSString * size;//规格

@end
