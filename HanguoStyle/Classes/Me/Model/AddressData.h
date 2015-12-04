//
//  AddressData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/4.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressData : NSObject

@property (nonatomic) NSString * addId;//
@property (nonatomic) NSString * tel;//
@property (nonatomic) NSString * name;//
@property (nonatomic) NSString * deliveryCity;//
@property (nonatomic) NSString * deliveryDetail;//
@property (nonatomic) NSInteger userId;//
@property (nonatomic) BOOL orDefault;//
@property (nonatomic) NSString * idCardNum;//
- (AddressData *) initWithJSONNode: (id) node;
@end