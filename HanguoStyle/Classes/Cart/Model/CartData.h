//
//  CartData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/24.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartData : NSObject
@property (nonatomic) NSInteger cartId;
@property (nonatomic) NSInteger skuId;//库存id
@property (nonatomic) NSInteger amount;//购物车数量
@property (nonatomic) NSString * itemColor;//颜色
@property (nonatomic) NSString * itemSize;//尺码
@property (nonatomic) float itemPrice;//商品价格
@property (nonatomic) NSString * state;//S失效，G勾选，I未勾选，N删除
@property (nonatomic) NSInteger shipFee;//邮费
@property (nonatomic) NSString * invArea;//库存区域区分：'B'保税区仓库发货，‘Z’韩国直邮
@property (nonatomic) NSInteger restrictAmount;//限购数量
@property (nonatomic) NSInteger restAmount;//商品余量
@property (nonatomic) NSString * invImg;//sku主图
@property (nonatomic) NSString * invUrl;//用于方便前段获取库存跳转链接
@property (nonatomic) NSString * invTitle;//sku标题
@property (nonatomic) NSString * cartDelUrl;//sku标题
- (CartData *) initWithJSONNode: (id) node;
@end
