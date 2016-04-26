//
//  MyOrderMoreCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/29.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//
#import "BaseView.h"
#import "MyOrderData.h"
@protocol MyOrderMoreCellDelegate <NSObject>

-(void)checkOrder:(MyOrderData *)orderData;
-(void)reloadData;

@end
@interface MyOrderMoreCell : UITableViewCell
@property (nonatomic, weak) id <MyOrderMoreCellDelegate> delegate;
@property (nonatomic, weak) MyOrderData * data;
@end
