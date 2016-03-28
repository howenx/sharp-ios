//
//  TableHeadView.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/21.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "CartData.h"
@interface TableHeadView : UIView
@property(nonatomic) UILabel * label;
@property(nonatomic) UILabel * postalTaxLabel;
@property (nonatomic) CartData * cartData;
@end
