//
//  OrderData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/15.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressData.h"
/**
 *  保税区包括购买商品的信息
 */
@interface OrderDetailData : NSObject

@property (nonatomic) NSString * invCustoms;
@property (nonatomic) NSString * portalSingleCustomsFee;
@property (nonatomic) NSString * shipSingleCustomsFee;
@property (nonatomic) NSString * factPortalFeeSingleCustoms;
@property (nonatomic) NSString * singleCustomsSumFee;
@property (nonatomic) NSString * invArea;
@property (nonatomic) NSString * invAreaNm;
@property (nonatomic) NSString * factSingleCustomsShipFee;
@property (nonatomic) NSInteger singleCustomsSumAmount;
@property (nonatomic) NSMutableArray * cartDataArray;
@end



/**
 *  优惠券
 */
@interface CouponsData : NSObject

@property (nonatomic) NSString * coupId;
@property (nonatomic) NSString * denomination;
@property (nonatomic) NSString * startAt;
@property (nonatomic) NSString * endAt;
@property (nonatomic) NSString * useAt;
@property (nonatomic) NSString * state;
@property (nonatomic) NSString * limitQuota;
@property (nonatomic) NSString * cateNm;

@end



/**
 地址等信息
 */
@interface OrderData : NSObject
- (OrderData *) initWithJSONNode: (id) node;
@property (nonatomic) AddressData * addressData;
@property (nonatomic) NSString * shipFee;
@property (nonatomic) NSString * factPortalFee;
@property (nonatomic) NSString * portalFee;
@property (nonatomic) NSString * factShipFee;

@property (nonatomic) NSMutableArray * singleCustomsArray;
@property (nonatomic) NSMutableArray * couponsArray;
@end




