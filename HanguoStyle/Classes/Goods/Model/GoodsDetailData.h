//
//  GoodsDetailData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/13.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface itemPreviewImgsData : NSObject

@property (nonatomic) NSString * url;
@property (nonatomic) float width;
@property (nonatomic) float height;
@end

@interface SizeData : NSObject
@property (nonatomic) NSString * sizeId;//库存ID
@property (nonatomic) NSString * itemColor;//颜色
@property (nonatomic) NSString * itemSize;//尺寸
@property (nonatomic) NSString * itemPrice;//售价
@property (nonatomic) NSString * itemSrcPrice;//原价
@property (nonatomic) NSString * itemDiscount;//折扣
@property (nonatomic) NSInteger  restAmount;//剩余数量
//@property (nonatomic) BOOL       orSoldOut;//是否卖光
@property (nonatomic) NSMutableArray  * itemPreviewImgs;//预览图
@property (nonatomic) NSString * invTitle;//商品标题,数据库不使用
@property (nonatomic) NSString * invCollection;//商品收藏数,数据库不使用
@property (nonatomic) BOOL       orMasterInv;//是否是主sku
@property (nonatomic) NSString * invUrl;//加入购物车跳转的url
@property (nonatomic) NSString * state;//状态，D下架，Y正常

@property (nonatomic) NSString * invArea;//邮递方式（韩国直邮）
@property (nonatomic) NSString * invWeight;//重量
@property (nonatomic) NSString * postalTaxRate;//税率,百分比
@property (nonatomic) NSString * postalStandard;
@property (nonatomic) NSString * invCustoms;
@property (nonatomic) NSString * shipFee;
@property (nonatomic) NSString * invImg;
@property (nonatomic) NSString * invAreaNm;

@property (nonatomic) NSString * shareUrl;//分享的地址
@property (nonatomic) NSInteger  collectCount;//收藏数
//@property (nonatomic) NSInteger  browseCount;//
@property (nonatomic) NSString * skuType;
@property (nonatomic) long skuTypeId;
@property (nonatomic) NSString * startAt;
@property (nonatomic) NSString * endAt;
@property (nonatomic) long collectId;//是否已经收藏，0为未收藏

@property (nonatomic) NSInteger  restrictAmount;//限购数量




@end


@interface GoodsDetailData : NSObject


/**
 *  主数据
 */

@property (nonatomic) NSString * mainId;//商品ID
@property (nonatomic) NSString * itemTitle;//商品标题
@property (nonatomic) NSString * onShelvesAt;//商品销售起始时间
@property (nonatomic) NSString * offShelvesAt;//商品销售终止时间
@property (nonatomic) NSString  * itemDetailImgs;//商品详细图
@property (nonatomic) NSDictionary * itemFeatures;//商品属性
//@property (nonatomic) NSMutableArray * itemFeaturesKeyArray;//商品属性Key
@property (nonatomic) NSString * themeId;//主题ID
@property (nonatomic) NSString * state;//商品状态
@property (nonatomic) BOOL       orFreeShip;//是否包邮
@property (nonatomic) NSString * deliveryArea;//发货区域
@property (nonatomic) NSString * deliveryTime;//配送时间
@property (nonatomic) BOOL       orRestrictBuy;//是否限购
//@property (nonatomic) NSInteger  restrictAmount;//限购数量
@property (nonatomic) BOOL       orShoppingPoll;//是否拼购
@property (nonatomic) NSString * shareImg;//分享的图片


@property (nonatomic) NSString * itemNotice;//商品重要布告
@property (nonatomic) NSArray * publicity;//包邮等信息

//自己加的字段，是否已经收藏

@property (nonatomic) NSMutableArray * sizeArray;//大小等属性


//@property (nonatomic) NSMutableArray * colorArray;//颜色的种类


@property (nonatomic) NSMutableArray * pushArray;//推荐列表
@property (nonatomic) NSString * remarkRate;
@property (nonatomic) long remarkCount;
- (GoodsDetailData *) initWithJSONNode: (id) node;
@end
