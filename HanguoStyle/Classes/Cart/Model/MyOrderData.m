//
//  MyOrderData.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/29.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MyOrderData.h"
#import "NSString+GG.h"
#import <JSONKit.h>
@implementation OrderInfo

@end

@implementation SkuData

@end
@implementation Refund

@end
@implementation MyOrderData
- (MyOrderData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        self.cellHeight = 160;
        NSDictionary * dict = [node objectForKey:@"address"];

        self.addressData = [[AddressData alloc]init];
        self.addressData.addId = [dict objectForKey:@"addId"];
        self.addressData.tel = [dict objectForKey:@"tel"];
        self.addressData.name = [dict objectForKey:@"name"];
        self.addressData.deliveryCity = [dict objectForKey:@"deliveryCity"];
        self.addressData.deliveryDetail = [dict objectForKey:@"deliveryDetail"];
        self.addressData.idCardNum = [dict objectForKey:@"idCardNum"];
        self.addressData.orDefault = YES;

        //退款状态
        NSDictionary * refundDict = [node objectForKey:@"refund"];
        
        if (refundDict!=nil) {
            self.refund = [[Refund alloc]init];
            self.refund.orderId = [refundDict objectForKey:@"orderId"];
            self.refund.splitOrderId = [refundDict objectForKey:@"splitOrderId"];
            self.refund.payBackFee = [refundDict objectForKey:@"payBackFee"];
            self.refund.reason = [refundDict objectForKey:@"reason"];
            self.refund.state = [refundDict objectForKey:@"state"];
            self.refund.contactTel = [refundDict objectForKey:@"rejectReason"];
            self.refund.refundType = [refundDict objectForKey:@"refundType"];
        }
        
        
        
        //订单信息
        NSDictionary * orderDict = [node objectForKey:@"order"];
        self.orderInfo = [[OrderInfo alloc]init];
        self.orderInfo.orderId = [[orderDict objectForKey:@"orderId"]longValue];
        self.orderInfo.payTotal = [orderDict objectForKey:@"payTotal"];
        self.orderInfo.payMethod = [orderDict objectForKey:@"payMethod"];
        self.orderInfo.orderCreateAt = [orderDict objectForKey:@"orderCreateAt"];
        self.orderInfo.orderStatus = [orderDict objectForKey:@"orderStatus"];
        self.orderInfo.discount = [orderDict objectForKey:@"discount"];
        self.orderInfo.orderDesc = [orderDict objectForKey:@"orderDesc"];
        self.orderInfo.addId = [orderDict objectForKey:@"addId"];
        self.orderInfo.shipFee = [orderDict objectForKey:@"shipFee"];
        self.orderInfo.confirmReceiveAt = [orderDict objectForKey:@"confirmReceiveAt"];
        self.orderInfo.orderDetailUrl = [orderDict objectForKey:@"orderDetailUrl"];
        self.orderInfo.postalFee = [orderDict objectForKey:@"postalFee"];
        self.orderInfo.totalFee = [orderDict objectForKey:@"totalFee"];
        if(![NSString isNSNull:[orderDict objectForKey:@"orderSplitId"]]){
            self.orderInfo.orderSplitId = [[orderDict objectForKey:@"orderSplitId"]longValue];
        }
        
        if([[orderDict objectForKey:@"orderStatus"] isEqualToString:@"I"]){
             self.orderInfo.countDown = [[orderDict objectForKey:@"countDown"]longValue];
        }
       
        
        self.orderInfo.orderAmount = [[orderDict objectForKey:@"orderAmount"]integerValue];
        //待付款和代收货下面分别有付款和查看物流
        if([self.orderInfo.orderStatus isEqualToString:@"I"]||[self.orderInfo.orderStatus isEqualToString:@"D"]){
            self.cellHeight = self.cellHeight + 50;
        }
        //商品信息
        self.skuArray = [NSMutableArray array];
        NSArray * tags = [node objectForKey:@"sku"];
        for (id tag in tags) {
            SkuData * detailData = [[SkuData alloc]init];
            detailData.skuId = [[tag objectForKey:@"skuId"]longValue];
            detailData.amount = [[tag objectForKey:@"amount"]integerValue];
            detailData.price = [tag objectForKey:@"price"];
            detailData.skuTitle = [tag objectForKey:@"skuTitle"];
            detailData.invImg = [[[tag objectForKey:@"invImg"]objectFromJSONString]objectForKey:@"url"];
            detailData.invUrl = [tag objectForKey:@"invUrl"];
            detailData.itemColor = [tag objectForKey:@"itemColor"];
            detailData.itemSize = [tag objectForKey:@"itemSize"];

            [self.skuArray addObject:detailData];
        }
        
        
    }
    return self;
}

@end
