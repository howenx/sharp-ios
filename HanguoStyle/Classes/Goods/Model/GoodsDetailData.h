//
//  GoodsDetailData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/13.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface SaleMsg : NSObject
//@property (nonatomic) NSString * name;//颜色名称
//@property (nonatomic) BOOL saleOut;//是否售完
//@end



//@interface ColorData : NSObject
//@property (nonatomic) NSString * colorName;//颜色名称
//@property (nonatomic) NSMutableArray * sizeArray;//大小等属性
//@property (nonatomic) BOOL orSelect;//是否被选中
//
//@end


@interface SizeData : NSObject
@property (nonatomic) NSString * sizeId;//库存ID
@property (nonatomic) NSString * itemColor;//颜色
@property (nonatomic) NSString * itemSize;//尺寸
@property (nonatomic) float      itemPrice;//原价
@property (nonatomic) float      itemSrcPrice;//售价
@property (nonatomic) float      itemDiscount;//折扣
@property (nonatomic) NSInteger  restAmount;//剩余数量
@property (nonatomic) BOOL       orSoldOut;//是否卖光
@property (nonatomic) NSArray  * itemPreviewImgs;//预览图
@property (nonatomic) NSString * invTitle;//商品标题,数据库不使用
@property (nonatomic) NSString * invCollection;//商品收藏数,数据库不使用
@property (nonatomic) BOOL       orMasterInv;//是否是主sku
@property (nonatomic) NSString * invUrl;//加入购物车跳转的url
@property (nonatomic) NSString * state;//状态，D下架，Y正常
@end


@interface GoodsDetailData : NSObject


/**
 *  主数据
 */

@property (nonatomic) NSString * mainId;//商品ID
@property (nonatomic) NSString * itemTitle;//商品标题
@property (nonatomic) NSString * onShelvesAt;//商品销售起始时间
@property (nonatomic) NSString * offShelvesAt;//商品销售终止时间
@property (nonatomic) NSArray  * itemDetailImgs;//商品详细图
@property (nonatomic) NSDictionary * itemFeatures;//商品属性
@property (nonatomic) NSString * themeId;//主题ID
@property (nonatomic) NSString * state;//商品状态
@property (nonatomic) BOOL       orFreeShip;//是否包邮
@property (nonatomic) NSString * deliveryArea;//发货区域
@property (nonatomic) NSString * deliveryTime;//配送时间
@property (nonatomic) BOOL       orRestrictBuy;//是否限购
@property (nonatomic) NSInteger  restrictAmount;//限购数量
@property (nonatomic) BOOL       orShoppingPoll;//是否拼购
@property (nonatomic) NSString * shareImg;//分享的图片
@property (nonatomic) NSString * shareUrl;//分享的地址
@property (nonatomic) NSInteger  collectCount;//收藏数
@property (nonatomic) NSString * itemNotice;//商品重要布告
@property (nonatomic) NSArray * publicity;//包邮等信息

//自己加的字段，是否已经收藏
@property (nonatomic) BOOL       orCollect;//是否已经收藏
@property (nonatomic) NSMutableArray * sizeArray;//大小等属性
//@property (nonatomic) NSMutableArray * colorArray;//颜色的种类



- (GoodsDetailData *) initWithJSONNode: (id) node;
@end
