//
//  MessageTypeSystemTableViewCell.m
//  HanguoStyle
//
//  Created by wayne on 16/4/7.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MessageTypeSystemTableViewCell.h"
#define sapce 10
#define conH 200
@implementation MessageTypeSystemTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
//    @property (nonatomic,strong) UILabel * timeLabel_;
//    @property (nonatomic,strong) UILabel * titleLabel_;
//    @property (nonatomic,strong) UIView * bgView_;
//    
//    @property (nonatomic,strong) UILabel * contentLabel_;
//    @property (nonatomic,strong) UIView * lineView_;
//    @property (nonatomic,strong) UIButton * detailLabel_;
    
    
    self.timeLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(0,0,GGUISCREENWIDTH ,78/2)];
    self.timeLabel_.font = [UIFont systemFontOfSize:12];
    self.timeLabel_.textAlignment = NSTextAlignmentCenter;
    self.timeLabel_.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.timeLabel_];
    
    self.bgView_ = [[UIView alloc]initWithFrame:CGRectMake(sapce, PosYFromView(self.timeLabel_, 0), GGUISCREENWIDTH - sapce*2, 0)];
    self.bgView_.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView_];
    
    //标题
    self.titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(15, 25/2,GGUISCREENWIDTH - 50 , 15)];
    self.titleLabel_.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel_.textColor = [UIColor blackColor];
    [self.bgView_ addSubview:self.titleLabel_];
    
    self.contentLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(15, PosYFromView(self.titleLabel_, 25/2), GGUISCREENWIDTH - 50, 20)];
    self.contentLabel_.font = [UIFont systemFontOfSize:12];
    self.contentLabel_.textColor = UIColorFromRGB(0x666666);
    [self.bgView_ addSubview:self.contentLabel_];
    
    
    self.lineView_ = [[UIView alloc]initWithFrame:CGRectMake(15, PosYFromView(self.contentLabel_, 25/2), GGUISCREENWIDTH - 50, 0.5)];
    self.lineView_.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self.bgView_ addSubview:self.lineView_];
    
    self.detailLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(15, PosYFromView(self.lineView_, 30/2), GGUISCREENWIDTH - 50, 15)];
    self.detailLabel_.font = [UIFont boldSystemFontOfSize:14];
    self.detailLabel_.textColor = UIColorFromRGB(0x333333);
    self.detailLabel_.text = @"查看详情";
    [self.bgView_ addSubview:self.detailLabel_];
    
    
    self.moreImageveiw_ = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH - 30-15/2-5, PosYFromView(self.lineView_, 30/2), 15/2, 25/2)];
    self.moreImageveiw_.image = [UIImage imageNamed:@"fanye"];
    [self.bgView_ addSubview:self.moreImageveiw_]
    ;
}


-(void)setMessageModel:(MessageTypeModel *)messageModel
{
    _messageModel = messageModel;
    
    
    NSString * timeStampString = messageModel.createAt;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.timeLabel_.text = [objDateformat stringFromDate: date];
    self.titleLabel_.text = messageModel.msgTitle;
    self.contentLabel_.text = messageModel.msgContent;
    
    
    CGSize maxSize1 = CGSizeMake(GGUISCREENWIDTH - 50, MAXFLOAT);
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize  lastSize1 = [messageModel.msgContent boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    
    self.contentLabel_.frame = CGRectMake(15, PosYFromView(self.titleLabel_, 25/2), lastSize1.width, lastSize1.height);
    
    
    self.bgView_.frame = CGRectMake(sapce, PosYFromView(self.timeLabel_, 0), GGUISCREENWIDTH - sapce*2, lastSize1.height + 25/2 + 15 + 25/2 + 25/2+0.5+15+15+15);
}


+(CGFloat)cellH:(MessageTypeModel *)model
{
    
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize  lastSize1 = [model.msgContent boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    
    
    return lastSize1.height + 78/2 + 25/2 + 15 + 25/2 + 25/2+0.5+15+15+15;
}
@end
