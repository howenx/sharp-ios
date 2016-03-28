//
//  GoodsShowData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/19.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface MasterItemTagData : NSObject

@property (nonatomic) NSString * name;
@property (nonatomic) NSString * url;
@property (nonatomic) float angle;
@property (nonatomic) float top;
@property (nonatomic) float left;

@end


@interface GoodsShowData : NSObject
//@property (nonatomic) NSString * themeId;//主题ID(上级ID)
@property (nonatomic) NSString * itemId;//商品图片（本级ID）
@property (nonatomic) NSString * itemImg;//商品图片
@property (nonatomic) NSString * itemUrl;//商品详细页面链接

@property (nonatomic) NSString * itemTitle;//商品标题
@property (nonatomic) float  itemPrice;//商品价格
@property (nonatomic) float  itemSrcPrice;//商品原价
@property (nonatomic) float  itemDiscount;//商品折扣

@property (nonatomic) NSString * itemSoldAmount;//商品销量
@property (nonatomic) NSArray * masterItemTag;//如果是主打宣传商品，会需要tag json串

@property (nonatomic) float width;
@property (nonatomic) float height;

@property (nonatomic) NSInteger collectCount;//商品收藏数
@property (nonatomic) NSString * state;  // 状态  'Y'--正常,'D'--下架,'N'--删除,'K'--售空，'P'--预售



@property (nonatomic) NSString * itemType;  //"pin" "item"
@property (nonatomic) NSString * startAt;
@property (nonatomic) NSString * endAt;



- (GoodsShowData *) initWithJSONNode: (id) node;
@end
