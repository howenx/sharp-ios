//
//  CartData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/24.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CartDetailData : NSObject
@property (nonatomic) NSInteger cartId;
@property (nonatomic) NSInteger skuId;//库存id
@property (nonatomic) NSInteger amount;//购物车数量
@property (nonatomic) NSString * itemColor;//颜色
@property (nonatomic) NSString * itemSize;//尺码
@property (nonatomic) float itemPrice;//商品价格
@property (nonatomic) NSString * state;//S失效，G勾选，I未勾选，N删除
@property (nonatomic) NSString * invArea;//库存区域区分：'B'保税区仓库发货，‘Z’韩国直邮
@property (nonatomic) NSString * invAreaNm;
@property (nonatomic) NSInteger restrictAmount;//限购数量
@property (nonatomic) NSInteger restAmount;//商品余量
@property (nonatomic) NSString * invImg;//sku主图
@property (nonatomic) NSString * invUrl;//用于方便前段获取库存跳转链接
@property (nonatomic) NSString * invTitle;//sku标题
@property (nonatomic) NSString * cartDelUrl;//sku标题
@property (nonatomic) NSString * postalTaxRate;//行邮税
@property (nonatomic) NSString * invCustoms;//保税区
@property (nonatomic) NSString * skuType;//
@property (nonatomic) long skuTypeId;//


@end
@interface CartData : NSObject
- (CartData *) initWithJSONNode: (id) node;

@property (nonatomic) NSString * invAreaNm;
@property (nonatomic) NSString * invCustoms;
@property (nonatomic) NSString * invArea;
@property (nonatomic) NSMutableArray * cartDetailArray;
@property (nonatomic) float postalStandard;//免行邮税标准
@property (nonatomic) float selectPostalTaxRate;//在同一保税区勾选的商品行邮税(自己加的字段，不是后台传的)
@end
