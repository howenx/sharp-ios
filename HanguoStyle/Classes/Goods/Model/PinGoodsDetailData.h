//
//  PinGoodsDetailData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/17.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PinTieredPricesData : NSObject

@property (nonatomic) NSString * pinTieredId;
@property (nonatomic) NSString * masterCouponClassName;
@property (nonatomic) NSString * masterCouponStartAt;
@property (nonatomic) NSString * masterCouponEndAt;

@property (nonatomic) NSString * memberCouponClassName;
@property (nonatomic) NSString * memberCouponStartAt;
@property (nonatomic) NSString * memberCouponEndAt;

@property (nonatomic) float masterCouponQuota;
@property (nonatomic) float masterCoupon;
@property (nonatomic) float masterMinPrice;

@property (nonatomic) float memberCoupon;
@property (nonatomic) float memberCouponQuota;
@property (nonatomic) float memberMinPrice;

@property (nonatomic) NSString * price;
@property (nonatomic) NSInteger peopleNum;

@end



@interface ItemPreviewImgsData : NSObject

@property (nonatomic) NSString * url;
@property (nonatomic) float width;
@property (nonatomic) float height;
@end


@interface PinGoodsDetailData : NSObject
/**
 *  主数据
 */

@property (nonatomic) NSString * mainId;//商品ID
@property (nonatomic) NSString * itemTitle;//商品标题
@property (nonatomic) NSString  * itemDetailImgs;//商品详细图
@property (nonatomic) NSDictionary * itemFeatures;//商品属性
//@property (nonatomic) NSMutableArray * itemFeaturesKeyArray;//商品属性Key
@property (nonatomic) NSString * itemNotice;//商品重要布告
@property (nonatomic) NSArray * publicity;//包邮等信息

@property (nonatomic) NSString * sizeId;
@property (nonatomic) NSString * shareUrl;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * pinTitle;
@property (nonatomic) NSString * startAt;
@property (nonatomic) NSString * endAt;
@property (nonatomic) NSInteger restrictAmount;
@property (nonatomic) NSDictionary * floorPrice;
@property (nonatomic) NSString * pinDiscount;
@property (nonatomic) NSString * pinRedirectUrl;
@property (nonatomic) NSString * invArea;
@property (nonatomic) NSInteger restAmount;

@property (nonatomic) NSString * invWeight;
@property (nonatomic) NSString * invCustoms;
@property (nonatomic) NSString * postalTaxRate;
@property (nonatomic) NSString * postalStandard;
@property (nonatomic) NSString * invAreaNm;
@property (nonatomic) NSInteger collectCount;
//@property (nonatomic) NSInteger  browseCount;
@property (nonatomic) NSInteger  soldAmount;//已售
@property (nonatomic) NSString * invImg;
@property (nonatomic) NSString * invPrice;
@property (nonatomic) NSString * skuType;
@property (nonatomic) long skuTypeId;
@property (nonatomic) long collectId;

@property (nonatomic) NSMutableArray  * itemPreviewImgs;//预览图

@property (nonatomic) NSMutableArray * pinTieredPricesArray;//拼购的种类


@property (nonatomic) NSMutableArray * pushArray;//推荐列表
- (PinGoodsDetailData *) initWithJSONNode: (id) node;
@end
