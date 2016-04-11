//
//  MessageModel.h
//  HanguoStyle
//
//  Created by wayne on 16/4/6.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property  (nonatomic , strong)NSString * msgType;
@property  (nonatomic , strong)NSString * num;
@property  (nonatomic , strong)NSString * content;
@property  (nonatomic , strong)NSString * createAt;
@end
