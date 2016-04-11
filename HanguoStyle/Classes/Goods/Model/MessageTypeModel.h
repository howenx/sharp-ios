//
//  MessageTypeModel.h
//  HanguoStyle
//
//  Created by wayne on 16/4/7.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTypeModel : NSObject
//createAt = 1460013464515;
//id = 1642;
//msgContent = "System Coupon content";
//msgImg = "http://img.hanmimei.com//uploads/minify/f4e65749a1b0407f977d25d1f9ec5c841445411170985.jpg";
//msgTitle = "System title";
//msgType = system;
//msgUrl = "http://172.28.3.78:9001/comm/detail/888301/111324";
//targetType = D;

@property  (nonatomic , strong)NSString * ID;
@property  (nonatomic , strong)NSString * msgContent;
@property  (nonatomic , strong)NSString * msgImg;
@property  (nonatomic , strong)NSString * createAt;
@property  (nonatomic , strong)NSString * msgTitle;
@property  (nonatomic , strong)NSString * msgType;
@property  (nonatomic , strong)NSString * msgUrl;
@property  (nonatomic , strong)NSString * targetType;
@end
