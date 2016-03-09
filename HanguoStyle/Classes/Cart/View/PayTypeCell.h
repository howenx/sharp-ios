//
//  PayTypeCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/18.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
@protocol PayTypeCellDelegate <NSObject>

-(void)payTypeFlag:(NSString *)payTypeFlag;

@end
@interface PayTypeCell : UITableViewCell
@property (nonatomic, weak) id <PayTypeCellDelegate> delegate;

@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic) BOOL isPayTypeEdit;
@property (nonatomic, strong) UILabel * payTypeLab;
@property (nonatomic, strong) NSString * payType;

-(void)createView;
@end
