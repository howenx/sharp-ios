//
//  PayViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//


#import "BaseViewController.h"
@interface PayViewController : BaseViewController
@property(nonatomic) long orderId;
@property(nonatomic) NSString * payType;
@property (nonatomic,strong)     UIAlertView *alertPayResult;
@property (nonatomic,strong)  UIAlertView *alertViewJD;
@property (nonatomic,strong)     UIAlertView *alertAliResult;
@end
