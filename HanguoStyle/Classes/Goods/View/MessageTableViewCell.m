//
//  MessageTableViewCell.m
//  HanguoStyle
//
//  Created by wayne on 16/4/6.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MessageTableViewCell.h"
#define space 15
#define top 10
#define wight 48
#define dianW 12
@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
//property (nonatomic ,strong) UIImageView * iconImageView_;
//@property (nonatomic, strong) UILabel     * titleLabel_;
//@property (nonatomic ,strong) UILabel     *detailLabel_;
//@property (nonatomic ,strong) UILabel     * timeLabel_;
//@property (nonatomic ,strong) UIView      * lineView_;

-(void)initSubViews
{
    self.iconImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(space, top, wight, wight)];
    [self.contentView addSubview:self.iconImageView_];
    
    
    
    self.dianImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(wight-dianW/2+15, 4, dianW, dianW)];
    
    [self.contentView addSubview:self.dianImageView_];
    
    self.dianLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, dianW, dianW)];
    self.dianLabel_.textColor = [UIColor whiteColor];
    self.dianLabel_.font = [UIFont systemFontOfSize:10];
    self.dianLabel_.textAlignment = NSTextAlignmentCenter;
    [self.dianImageView_ addSubview:self.dianLabel_];
    
    
    self.titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.iconImageView_, 15), top, GGUISCREENWIDTH - wight - 2*space - 15 -40-15, 34/2)];
    self.titleLabel_.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel_.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel_];
    
    
    self.detailLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.iconImageView_, 15), PosYFromView(self.titleLabel_, 10), GGUISCREENWIDTH - wight - 2 *space -2, 15)];
    self.detailLabel_.font = [UIFont systemFontOfSize:14];
    self.detailLabel_.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.detailLabel_];
    
    self.timeLabel_ =[[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.titleLabel_, 15), top, 40-2, 15)];
    self.timeLabel_.font = [UIFont systemFontOfSize:14];
    self.timeLabel_.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.timeLabel_];
    
    self.lineView_ = [[UIView alloc]initWithFrame:CGRectMake(15, 138/2-0.5, GGUISCREENWIDTH-15, 0.5)];
    self.lineView_.backgroundColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.lineView_];
}

-(void)setData:(NSInteger)row
{
    self.iconImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"message%ld",(long)row]];
    self.dianImageView_.image = [UIImage imageNamed:@"dian"];
    if (row == 0) {
    self.titleLabel_.text = @"系统消息";
        self.detailLabel_.text = @"测试数据";
        self.timeLabel_.text = @"2:30";
        self.dianLabel_.text = @"1";
    }
    if (row == 1) {
    self.titleLabel_.text = @"商品提醒";
        self.detailLabel_.text = @"测试数据";
        self.timeLabel_.text = @"2:30";
        self.dianLabel_.text = @"1";
    }
    if (row == 2) {
        self.titleLabel_.text = @"优惠促销";
        self.detailLabel_.text = @"测试数据";
        self.timeLabel_.text = @"2:30";
        self.dianLabel_.text = @"1";
    }
    if (row == 3) {
        self.titleLabel_.text = @"物流通知";
        self.detailLabel_.text = @"测试数据";
        self.timeLabel_.text = @"2:30";
        self.dianLabel_.text = @"1";
    }
    if (row == 4) {
        self.titleLabel_.text = @"我的资产";
        self.detailLabel_.text = @"测试数据";
        self.timeLabel_.text = @"2:30";
        self.dianLabel_.text = @"12";
    }
}
@end
