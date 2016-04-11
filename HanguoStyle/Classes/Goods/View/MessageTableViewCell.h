//
//  MessageTableViewCell.h
//  HanguoStyle
//
//  Created by wayne on 16/4/6.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView * iconImageView_;
@property (nonatomic, strong) UILabel     * titleLabel_;
@property (nonatomic ,strong) UILabel     *detailLabel_;
@property (nonatomic ,strong) UILabel     * timeLabel_;
@property (nonatomic ,strong) UIView      * lineView_;


//消息点
@property (nonatomic ,strong) UIImageView * dianImageView_;
@property (nonatomic ,strong) UILabel * dianLabel_;

-(void)setData:(MessageModel *)messageModel Row:(NSInteger)row;
@end
