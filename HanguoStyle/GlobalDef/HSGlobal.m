//
//  HSGlobal.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "HSGlobal.h"
//wayne
//#define SERVERY1 @"http://172.28.3.78:9003"
//#define SERVERY2 @"http://172.28.3.78:9001"
//#define SERVERY3 @"http://172.28.3.78:9004"
//#define SERVERY4 @"http://172.28.3.78:9005"

//#define SERVERY1 @"http://172.28.3.66:9003"
//#define SERVERY2 @"http://172.28.3.66:9001"
//#define SERVERY3 @"http://172.28.3.66:9004"
//#define SERVERY4 @"http://172.28.3.66:9005"

//#define SERVERY1 @"http://172.28.3.18:9003"
//#define SERVERY2 @"http://172.28.3.18:9001"
//#define SERVERY3 @"http://172.28.3.18:9004"
//#define SERVERY4 @"http://172.28.3.18:9005"

#define SERVERY1 @"https://shopping.hanmimei.com"
#define SERVERY2 @"https://api.hanmimei.com"
#define SERVERY3 @"https://id.hanmimei.com"
#define SERVERY4 @"https://promotion.hanmimei.com"


//#define SERVERY1 @"http://172.28.3.51:9003"
//#define SERVERY2 @"http://172.28.3.51:9001"
//#define SERVERY3 @"http://172.28.3.51:9004"
//#define SERVERY4 @"http://172.28.3.51:9005"

@implementation HSGlobal


//接到商品分享口令时，拼接口令前面的地址
+ (NSString *) shareGoodsHeaderUrl
{
    NSString * url = [NSString stringWithFormat:@"%@",SERVERY2];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//接到团购分享口令时，拼接口令前面的地址
+ (NSString *) shareTuanHeaderUrl
{
    NSString * url = [NSString stringWithFormat:@"%@",SERVERY4];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//拼购
+ (NSString *) pinListUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/promotion/pin/activity/list",SERVERY4];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 优惠券
+ (NSString *) couponUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/coupons/list",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// 取消订单
+ (NSString *) cancelOrderUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/order/cancel/",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 删除订单
+ (NSString *) delOrderUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/order/del/",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


// 判断订单是否过期
+ (NSString *) checkOrderUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/order/verify/",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 我的订单接口
+ (NSString *) myOrderUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/order",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// 查询购物车商品数量接口
+ (NSString *) queryCustNum
{
    NSString * url = [NSString stringWithFormat:@"%@/comm/cart/amount",SERVERY2];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 去支付给后台发订单数据接口
+ (NSString *) payUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/pay/order/get/",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 去支付给后台发订单数据接口
+ (NSString *) sendOrderInfo
{
    NSString * url = [NSString stringWithFormat:@"%@/client/order/submit",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// 去结算给后台发送购物车数据接口
+ (NSString *) sendCartToOrder
{
    NSString * url = [NSString stringWithFormat:@"%@/client/settle",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// 添加购物车校验数量（未登陆状态）
+ (NSString *) checkAddCartAmount
{
    NSString * url = [NSString stringWithFormat:@"%@/client/cart/nologin/verify/amount",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// 获取购物车数据地址（未登陆状态）
+ (NSString *) getCartByPidUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/cart/get/sku/list",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//详情页面加入购物车地址（登陆状态）
+ (NSString *) addToCartUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/cart",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//获取购物车数据地址（登陆状态）
+ (NSString *) sendCartUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/client/cart/list",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//主页地址
+ (NSString *) goodsPackMoreUrl: (NSInteger)addon
{
    NSString * url = [NSString stringWithFormat:@"%@/index/%ld",SERVERY2,(long)addon];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//获取验证码地址
+ (NSString *) testingCodeUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/api/send_code",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//注册地址
+ (NSString *) registUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/api/reg",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//登陆地址
+ (NSString *) loginUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/api/login_phone_num",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//刷新token
+ (NSString *) refreshToken
{
    NSString * url = [NSString stringWithFormat:@"%@/api/refresh_token",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//重置密码地址
+ (NSString *) resetPwdUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/api/reset_password",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//登录获取验证码
+ (NSString *) verifyCodeUrl
{
    NSString * url = [NSString stringWithFormat:@"%@/getImageCodes/%u",SERVERY3,arc4random() % 10000000];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


//注册和找回密码的时候校验是否已经注册地址
+ (NSString *) checkRegist
{
    NSString * url = [NSString stringWithFormat:@"%@/api/verify",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}





//删除收货地址 的地址
+ (NSString *) delAddressInfo{
    NSString * url = [NSString stringWithFormat:@"%@/api/address/del",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//修改收货地址 的地址
+ (NSString *) updateAddressInfo{
    NSString * url = [NSString stringWithFormat:@"%@/api/address/update",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//新增收货地址 的地址
+ (NSString *) AddAddressInfo{
    NSString * url = [NSString stringWithFormat:@"%@/api/address/add",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//查询收货地址列表的地址
+ (NSString *) getAddressListInfo{
    NSString * url = [NSString stringWithFormat:@"%@/api/address/list",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//更新基本信息（用户名和头像）的地址
+ (NSString *) updateUserInfo{
    NSString * url = [NSString stringWithFormat:@"%@/api/user/update",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//我的的地址
+ (NSString *) mineUrl{
    NSString * url = [NSString stringWithFormat:@"%@/api/user/get/info",SERVERY3];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//收藏地址
+ (NSString *) collectUrl{
    NSString * url = [NSString stringWithFormat:@"%@/client/collect/submit",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//取消收藏地址
+ (NSString *) unCollectUrl{
    NSString * url = [NSString stringWithFormat:@"%@/client/collect/del/",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//收藏列表地址
+ (NSString *) collectListUrl{
    NSString * url = [NSString stringWithFormat:@"%@/client/collect/get/collect/list",SERVERY1];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}



@end
