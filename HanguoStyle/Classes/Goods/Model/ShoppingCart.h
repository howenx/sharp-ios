//
//  ShoppingCart.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/22.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCart : NSObject
@property (nonatomic) NSInteger pid;//商品id
@property (nonatomic) NSInteger cartId;//购物车id
@property (nonatomic) NSInteger  amount;//数量
@property (nonatomic) NSString * state;//
@property (nonatomic) NSString * skuType;//
@property (nonatomic) long skuTypeId;//
@end
