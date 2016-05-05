//
//  AssessListViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"

@interface AssessListViewController : BaseViewController
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic,copy) void (^backButtonBlock)(NSString * str);
@end
