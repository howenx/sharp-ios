//
//  HSGlobal.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HSGlobal : NSObject

+ (NSString *) goodsPackMoreUrl: (NSInteger)addon;
+ (NSString *) testingCodeUrl;
+ (NSString *) registUrl;
+ (NSString *) loginUrl;
+ (NSString *) addToCartUrl;
+ (NSString *) sendCartUrl;
+ (NSString *) resetPwdUrl;
+ (NSString *) refreshToken;
//+ (NSString *) getCartUrl;
+ (NSString *) getCartByPidUrl;
+ (NSString *) mineUrl;
+ (NSString *) updateUserInfo;
+ (NSString *) getAddressListInfo;
+ (NSString *) updateAddressInfo;
+ (NSString *) delAddressInfo;
+ (NSString *) AddAddressInfo;
+ (NSString *) checkAddCartAmount;
+ (NSString *) sendCartToOrder;
+ (NSString *) sendOrderInfo;
+ (NSString *) payUrl;
+ (NSString *) myOrderUrl;
+ (NSString *) checkOrderUrl;
+ (NSString *) cancelOrderUrl;
+ (NSString *) delOrderUrl;
+ (NSString *) queryCustNum;
+ (NSString *) verifyCodeUrl;
+ (NSString *) checkRegist;
+ (NSString *) couponUrl;
+ (NSString *) collectUrl;
+ (NSString *) unCollectUrl;
+ (NSString *) collectListUrl;
+ (NSString *) pinListUrl;
+ (NSString *) shareTuanHeaderUrl;
+ (NSString *) shareGoodsHeaderUrl;
@end
