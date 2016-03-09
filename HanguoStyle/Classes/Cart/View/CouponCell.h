//
//  CouponCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/18.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "OrderData.h"
@protocol CouponCellDelegate <NSObject>

-(void)couponFlag:(NSString *)couponFlag andCouponId :(NSString *)couponId;

@end
@interface CouponCell : UITableViewCell
@property (nonatomic, weak) id <CouponCellDelegate> delegate;
@property (nonatomic, strong) UIButton * editBtn;

@property (nonatomic) BOOL isCouponEdit;
@property (nonatomic, strong) UILabel * couponLab;
@property (nonatomic, strong) NSString * coupon;
@property(nonatomic) NSString * realityPay;
@property (nonatomic, weak) OrderData * data;
@end
