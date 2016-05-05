//
//  SearchLogisticsData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/15.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowData : NSObject

@property (nonatomic) NSString * time;
@property (nonatomic) NSString * location;
@property (nonatomic) NSString * context;

@end

@interface SearchLogisticsData : NSObject
@property (nonatomic) NSString * nu;
@property (nonatomic) NSString * com;
@property (nonatomic) NSString * state;
@property (nonatomic) NSString * expressName;
@property (nonatomic) NSString * message;
@property (nonatomic) NSMutableArray * flowArray;
- (SearchLogisticsData *) initWithJSONNode: (id) node;
@end
