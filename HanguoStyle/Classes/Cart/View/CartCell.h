//
//  CartCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartData.h"
@protocol CartCellDelegate <NSObject>

//通知重新刷新数据
-(void)loadDataNotify;

@end
@interface CartCell : UITableViewCell

@property (nonatomic, weak) id <CartCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *jianBtn;

@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (nonatomic, weak) CartData * data;
@end
