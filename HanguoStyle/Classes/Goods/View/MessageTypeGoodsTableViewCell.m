//
//  MessageTypeGoodsTableViewCell.m
//  HanguoStyle
//
//  Created by wayne on 16/4/8.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MessageTypeGoodsTableViewCell.h"
#define H 100
@implementation MessageTypeGoodsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [self initSubViews];
    }
    return self;
}

//@property (nonatomic,strong)UIImageView * iconImageView_;
//@property (nonatomic,strong)UILabel * titleLabel_;
//@property (nonatomic,strong)UILabel * countLabel_;
//@property (nonatomic,strong)UILabel * danweiLabel_;

-(void)initSubViews
{
    self.iconImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(10, 23, 48, 48)];
    self.iconImageView_.image = [UIImage imageNamed:@"icon_coupon"];
    [self.contentView addSubview:self.iconImageView_];
    
    
    self.titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.iconImageView_, 16), (H-22)/2, SCREEN_WIDTH-20-48-16, 22)];
    self.titleLabel_.font = [UIFont boldSystemFontOfSize:21];
    self.titleLabel_.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:self.titleLabel_];
    
    
    self.countLabel_ =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -10 - 40 - 16 , (H-22)/2, 40, 22)];
    self.countLabel_.font = [UIFont boldSystemFontOfSize:21];
    self.countLabel_.textAlignment =  NSTextAlignmentRight;
    self.countLabel_.textColor = UIColorFromRGB(0xff5359);
    [self.contentView addSubview:self.countLabel_];
    
    
    self.danweiLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(self.countLabel_, 0) , (H-16)/2, 16, 16)];
    self.danweiLabel_.font = [UIFont boldSystemFontOfSize:15];
    self.danweiLabel_.textAlignment =  NSTextAlignmentLeft;
    self.danweiLabel_.text = @"张";
    self.danweiLabel_.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:self.danweiLabel_];
}

-(void)setMessageModel:(MessageTypeModel *)messageModel
{
    _messageModel = messageModel;
    self.titleLabel_.text = messageModel.msgTitle;
    self.countLabel_.text = messageModel.msgType;
     
}
@end
