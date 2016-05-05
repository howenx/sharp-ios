//
//  AssessListData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderLine : NSObject
@property (nonatomic) long skuId;//库存id
@property (nonatomic) NSString * itemColor;//颜色
@property (nonatomic) NSString * itemSize;//尺码
@property (nonatomic) NSString * invImg;//sku主图
@property (nonatomic) NSString * price;//

@property (nonatomic) NSString * invUrl;//用于方便前段获取库存跳转链接
@property (nonatomic) NSString * skuTitle;//sku标题
@property (nonatomic) NSString * skuType;//
@property (nonatomic) long skuTypeId;//
@property (nonatomic) long orderId;//
@property (nonatomic) long amount;//
@end
@interface Comment : NSObject

@property (nonatomic) long skuTypeId;
@property (nonatomic) NSString * createAt;
@property (nonatomic) NSString * content;
@property (nonatomic) NSInteger grade;//
@property (nonatomic) NSString * skuType;
@property (nonatomic) NSMutableArray * picArray;
@end
@interface AssessListData : NSObject
@property (nonatomic) OrderLine * orderLine;
@property (nonatomic) Comment * comment;
- (AssessListData *) initWithJSONNode: (id) node;

@end
