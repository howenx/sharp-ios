//
//  GoodsPackData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsPackImageData : NSObject

@property (nonatomic) NSString * thumbUrl;
@property (nonatomic) NSString * url;

@end




@interface GoodsPackData : NSObject
@property (nonatomic) NSString * idCode;
@property (nonatomic) NSString * masterItemId;
@property (nonatomic) NSString * themeImg;
@property (nonatomic) NSString * themeUrl;
@property (nonatomic) NSInteger sortNu;
@property (nonatomic) NSArray * photoArray;

- (GoodsPackData *) initWithJSONNode: (id) node;
@end
