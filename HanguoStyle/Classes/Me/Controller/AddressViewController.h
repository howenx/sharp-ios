//
//  AddressViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/22.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AddressData.h"
#import "BaseViewController.h"
@protocol AddressViewControllerDelegate <NSObject>
//回传给订单页面的地址信息
-(void)backAddressData:(AddressData *)addressData;
@end
@interface AddressViewController : BaseViewController
@property (weak,nonatomic) id <AddressViewControllerDelegate> delegate;
@property(nonatomic) NSString * addId;
@property(nonatomic) NSString * comeFrom;
@end
