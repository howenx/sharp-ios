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
    
    
    self.titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.iconImageView_, 15), top+3, GGUISCREENWIDTH - wight - 2*space - 15 -150-15, 34/2)];
    self.titleLabel_.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel_.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel_];
    
    
    self.detailLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.iconImageView_, 15), PosYFromView(self.titleLabel_, 10), GGUISCREENWIDTH - wight - 2 *space -2, 15)];
    self.detailLabel_.font = [UIFont systemFontOfSize:14];
    self.detailLabel_.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.detailLabel_];
    
    self.timeLabel_ =[[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.titleLabel_, 15), top, 150, 15)];
    self.timeLabel_.textAlignment = NSTextAlignmentRight;
    
    self.timeLabel_.font = [UIFont systemFontOfSize:14];
    self.timeLabel_.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.timeLabel_];
    
    self.lineView_ = [[UIView alloc]initWithFrame:CGRectMake(15, 138/2-0.5, GGUISCREENWIDTH-15, 0.5)];
    self.lineView_.backgroundColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.lineView_];
}

-(void)setData:(MessageModel *)messageModel Row:(NSInteger)row;
{
    self.iconImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"message%ld",(long)row]];
    self.dianImageView_.image = [UIImage imageNamed:@"dian"];
    
    
    if ([messageModel.num isEqualToString:@"0"]) {
        self.dianImageView_.hidden = YES;
    }else
    {
        self.dianImageView_.hidden = NO;
    }
    self.dianLabel_.text = messageModel.num;
    
    
    
    
    NSString * timeStampString = messageModel.createAt;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.timeLabel_.text = [objDateformat stringFromDate: date];
    self.detailLabel_.text = messageModel.content;
    if ([messageModel.msgType isEqualToString:@"system"]) {
    self.titleLabel_.text = @"系统消息";

    }
    if ([messageModel.msgType isEqualToString:@"discount"]) {
    self.titleLabel_.text = @"优惠促销";
    }
    if ([messageModel.msgType isEqualToString:@"coupon"]) {
        self.titleLabel_.text = @"我的资产";
    }
    if ([messageModel.msgType isEqualToString:@"logistics"]) {
        self.titleLabel_.text = @"物流通知";
    }
    if ([messageModel.msgType isEqualToString:@"goods"]) {
        self.titleLabel_.text = @"商品提醒";
    }
}
@end
