//
//  RefundViewController.h
//  HanguoStyle
//
//  Created by wayne on 16/4/14.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
#import "MyOrderData.h"
@interface RefundViewController : BaseViewController
@property (nonatomic,strong)MyOrderData * orderData;

@property (nonatomic,copy) void (^selectButtonBlock)(NSString * str);
@end
