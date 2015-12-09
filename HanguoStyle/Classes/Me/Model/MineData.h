//
//  MineData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/1.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineData : NSObject
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * photo;
@property (nonatomic) NSString * realYn;
@property (nonatomic) NSString * phoneNum;
@property (nonatomic) NSString * gender;
- (MineData *) initWithJSONNode: (id) node;
@end
