//
//  MyOrderOneCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/29.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "MyOrderData.h"
@protocol MyOrderOneCellDelegate <NSObject>

-(void)checkOrder:(MyOrderData *)orderData;

@end
@interface MyOrderOneCell : UITableViewCell
@property (nonatomic, weak) id <MyOrderOneCellDelegate> delegate;
@property (nonatomic, weak) MyOrderData * data;
@end
