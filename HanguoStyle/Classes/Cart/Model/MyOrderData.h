//
//  MyOrderData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/29.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressData.h"

@interface OrderInfo : NSObject


@property (nonatomic) long orderId;
@property (nonatomic) NSString * payTotal;//应付金额（包括各种税）
@property (nonatomic) NSString * payMethod;
@property (nonatomic) NSString * orderCreateAt;
@property (nonatomic) NSString * orderStatus;
@property (nonatomic) NSString * discount;//以优惠金额
@property (nonatomic) NSString * orderDesc;
@property (nonatomic) NSString * addId;
@property (nonatomic) NSString * shipFee;//邮费
@property (nonatomic) NSString * confirmReceiveAt;
@property (nonatomic) NSString * orderDetailUrl;
@property (nonatomic) NSString * postalFee;//行邮税
@property (nonatomic) NSString * totalFee;//商品总费用
@property (nonatomic) long orderSplitId;
@property (nonatomic) long countDown;
@property (nonatomic) NSInteger orderAmount;//商品总数量

@end




@interface SkuData : NSObject


@property (nonatomic) long skuId;
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSString * price;
@property (nonatomic) NSString * skuTitle;
@property (nonatomic) NSString * invImg;
@property (nonatomic) NSString * invUrl;
@property (nonatomic) NSString * itemColor;
@property (nonatomic) NSString * itemSize;

@end

@interface Refund : NSObject
@property (nonatomic) NSString * orderId;
@property (nonatomic) NSString * splitOrderId;
@property (nonatomic) NSString * payBackFee;
@property (nonatomic) NSString * reason;
@property (nonatomic) NSString * state;
@property (nonatomic) NSString * contactTel;
@property (nonatomic) NSString * rejectReason;
@property (nonatomic) NSString * refundType;
@end


@interface MyOrderData : NSObject

@property (nonatomic) AddressData * addressData;
@property (nonatomic) OrderInfo * orderInfo;
@property (nonatomic) Refund * refund;
@property (nonatomic) NSMutableArray * skuArray;

//cell的高度
@property (nonatomic) float cellHeight;



- (MyOrderData *) initWithJSONNode: (id) node;
@end
