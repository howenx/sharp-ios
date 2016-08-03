//
//  TableHeadView.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/21.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "CartData.h"
@protocol TableHeadViewDelegate <NSObject>

//登陆或者未登录重新刷新数据
-(void)loadDataNotify;

@end

@interface TableHeadView : UIView
@property(nonatomic) UILabel * label;
@property(nonatomic) UILabel * postalTaxLabel;
@property(nonatomic) UIButton * selectAllBtn;
@property (nonatomic,weak) CartData * cartData;
@property (nonatomic, weak) id <TableHeadViewDelegate> delegate;
@end
