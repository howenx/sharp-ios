//
//  GoodsPackData.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeData : NSObject

@property (nonatomic) NSString * idCode;
@property (nonatomic) NSString * themeImg;
@property (nonatomic) NSString * type;
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) NSString * themeUrl;

@end


@interface SliderData : NSObject

@property (nonatomic) NSString * itemTarget;
@property (nonatomic) NSString * url;
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) NSString * targetType;


@end




@interface GoodsPackData : NSObject

@property (nonatomic) NSString * message;
@property (nonatomic) NSInteger code;
@property (nonatomic) NSArray * themeArray;
@property (nonatomic) NSArray * sliderArray;
@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger * msgRemind;



- (GoodsPackData *) initWithJSONNode: (id) node;
@end
