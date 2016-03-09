//
//  PinTeamData.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/29.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinTeamData : NSObject
- (PinTeamData *) initWithJSONNode: (id) node;
@property (nonatomic) NSString * pinTitle;
@property (nonatomic) NSInteger personNum;
@property (nonatomic) NSInteger joinPersons;
@property (nonatomic) long pinActiveId;
@property (nonatomic) long endCountDown;
@property (nonatomic) NSString * pinImg;
@property (nonatomic) long orderId;
@property (nonatomic) NSString * pinPrice;
@property (nonatomic) NSString * pinSkuUrl;
@property (nonatomic) NSString * pinUrl;
@property (nonatomic) long orMaster;
@property (nonatomic) NSString * status;

@end
