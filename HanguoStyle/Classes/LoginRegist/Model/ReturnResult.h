//
//  ReturnResult.h
//  GiftGuide
//
//  Created by qianfeng on 15-8-18.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnResult : NSObject

@property (copy,nonatomic) NSString * message;
@property (nonatomic) NSInteger  code;
@property (copy,nonatomic) NSString * token;
@property (assign,nonatomic) NSInteger expired;

- (ReturnResult *) initWithJSONNode: (id) node;
@end
