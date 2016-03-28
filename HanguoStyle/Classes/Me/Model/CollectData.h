//
//  CollectData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/25.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectData : NSObject
@property (nonatomic) long collectId;
@property (nonatomic) long createAt;
@property (nonatomic) NSString *  skuType;
@property (nonatomic) long skuTypeId;
@property (nonatomic) long skuId;
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSString * price;
@property (nonatomic) NSString * skuTitle;
@property (nonatomic) NSString * invImg;
@property (nonatomic) NSString * invUrl;
@property (nonatomic) NSString * itemColor;
@property (nonatomic) NSString * itemSize;
- (CollectData *) initWithJSONNode: (id) node;
@end
