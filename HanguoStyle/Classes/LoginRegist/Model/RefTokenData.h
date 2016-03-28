//
//  RefTokenData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/14.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefTokenData : NSObject
@property (nonatomic) BOOL result;
@property (copy,nonatomic) NSString * message;
@property (copy,nonatomic) NSString * token;
@property (assign,nonatomic) NSInteger expired;

- (RefTokenData *) initWithJSONNode: (id) node;
@end
