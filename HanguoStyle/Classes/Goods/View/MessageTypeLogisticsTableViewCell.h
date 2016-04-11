//
//  MessageTypeLogisticsTableViewCell.h
//  HanguoStyle
//
//  Created by wayne on 16/4/8.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTypeModel.h"
@interface MessageTypeLogisticsTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * timeLabel_;
@property (nonatomic,strong) UILabel * titleLabel_;
@property (nonatomic,strong) UIView * bgView_;


@property (nonatomic,strong) UIImageView * iconImageView;
@property (nonatomic,strong) UILabel * contentLabel_;
@property (nonatomic,strong)UILabel * huoIdLabel_;
@property (nonatomic,strong)UILabel * logIdLabel_;




@property (nonatomic,strong) UIView * lineView_;
@property (nonatomic,strong) UILabel * detailLabel_;
@property (nonatomic,strong) UIImageView * moreImageveiw_;

@property (nonatomic,strong) MessageTypeModel * messageModel;

//+(CGFloat)cellH:(MessageTypeModel *)model;
@end
