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
+ (NSString *) messageListUrl;
+ (NSString *) messageListType;
+ (NSString *) searchLogisticsUrl;
+ (NSString *) refundUrl;
+ (NSString *) confirmReceiptUrl;
+(NSString *) deleteMessageListType;
+(NSString *) deleteMessageOne;

+ (NSString *) assessCenterUrl;
+ (NSString *) assessUrl;

+(NSString *)ShowEvaluateUrl;
+(NSString *)ShowgoodEvaluateUrl;
+(NSString *)ShowbadEvaluateUrl;
+(NSString *)ShowimageEvaluateUrl;
+ (NSString *) checkThreeLoginUrl;
+ (NSString *) hmmClauseUrl;
+ (NSString *) selectCustUrl;
+ (NSString *) shareWebUrlHead;
+(NSString *)FeeddbackUrl;
+ (NSString *) pinGoodsUrl: (NSInteger)addon;
+ (NSString *) giftUrl: (NSInteger)addon;
+ (NSString *) emptyDataUrl: (NSInteger)flag;
@end
