//
//  MessageTypeGoodsTableViewCell.h
//  HanguoStyle
//
//  Created by wayne on 16/4/8.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTypeModel.h"
@interface MessageTypeGoodsTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * iconImageView_;
@property (nonatomic,strong)UILabel * titleLabel_;
@property (nonatomic,strong)UILabel * countLabel_;
@property (nonatomic,strong)UILabel * danweiLabel_;

@property (nonatomic,strong) MessageTypeModel * messageModel;

@end
