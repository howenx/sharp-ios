//
//  CouponData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/26.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponData : NSObject
- (CouponData *) initWithJSONNode: (id) node;
@property (nonatomic) NSString * cateNm;
@property (nonatomic) NSString * coupId;
@property (nonatomic) NSString * denomination;
@property (nonatomic) NSString * limitQuota;
@property (nonatomic) NSString * endAt;
@property (nonatomic) NSString * startAt;
@property (nonatomic) NSString * state;
@property (nonatomic) NSString * useAt;

@end
