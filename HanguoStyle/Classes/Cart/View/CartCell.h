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

//登陆或者未登录状态通知重新刷新数据
-(void)loadDataNotify;
//登录状态回传更新数据
-(void)sendUpdateData:(CartDetailData *)data;
//登陆状态回传删除链接
-(void)sendDelUrl:(NSString *)url;

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
@property (nonatomic, weak) CartDetailData * data;
@end
