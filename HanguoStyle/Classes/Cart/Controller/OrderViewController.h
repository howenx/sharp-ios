//
//  OrderViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/15.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//


#import "OrderData.h"
#import "BaseViewController.h"
@interface OrderViewController : BaseViewController
@property(nonatomic) OrderData * orderData;
@property(nonatomic) NSString * realityPay;
@property(nonatomic) NSMutableArray * mutArray;
@property(nonatomic) int buyNow;//支付方式
@property(nonatomic) NSString * pinType;
@end
