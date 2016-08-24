//
//  KKGgoodsViewCell.m
//  HanguoStyle
//
//  Created by wayne on 16/7/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "KKGgoodsViewCell.h"

@implementation KKGgoodsViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
//    self.titleLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 20)];
//    self.titleLabel_.font = [UIFont systemFontOfSize:17];
//  
//    self.titleLabel_.textColor = UIColorFromRGB(0x333333);
//    [self.contentView addSubview:self.titleLabel_];
//    
//    
//    
//    self.detailLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(0, PosYFromView(self.titleLabel_, 5), GGUISCREENWIDTH, 14)];
//    self.detailLabel_.font = [UIFont systemFontOfSize:10];
//   
//    self.detailLabel_.textColor =  UIColorFromRGB(0xadadad);
//    [self.contentView addSubview:self.detailLabel_];
    
    
    
    self.bgImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 100)];
//    self.bgImageView_.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.bgImageView_];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.bgView.backgroundColor = GGBgColor;
    [self.contentView addSubview:self.bgView];
}


-(void)bindWithObject:(ThemeData *) obj
{

    
    
    
//    self.titleLabel_.text = obj.title;
//    self.titleLabel_.numberOfLines = 0;
//    CGSize maxSize1 = CGSizeMake(GGUISCREENWIDTH-42, MAXFLOAT);
//    NSDictionary *attribute1 = @{NSFontAttributeName: self.titleLabel_.font};
//    CGSize  lastSize1 = [self.titleLabel_.text boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
//    
//    
//    
//    self.detailLabel_.text = obj.themeConfigInfo;
//    self.detailLabel_.numberOfLines = 0;
//    CGSize maxSize2 = CGSizeMake(GGUISCREENWIDTH-42, MAXFLOAT);
//    NSDictionary *attribute2 = @{NSFontAttributeName: self.detailLabel_.font};
//    CGSize  lastSize2 = [self.detailLabel_.text boundingRectWithSize:maxSize2 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
    
    [self.bgImageView_ sd_setImageWithURL:[NSURL URLWithString:obj.themeImg] placeholderImage:[UIImage  imageNamed:@"load1ing"]];
    self.bgImageView_.contentMode = UIViewContentModeScaleToFill;
    
//    self.titleLabel_.frame = CGRectMake(21, 22, GGUISCREENWIDTH-42, lastSize1.height);
//    self.detailLabel_.frame = CGRectMake(21,PosYFromView(self.titleLabel_, 7) , GGUISCREENWIDTH-42, lastSize2.height);
//    self.bgImageView_.frame = CGRectMake(21, PosYFromView(self.detailLabel_, 17), GGUISCREENWIDTH-42, (obj.height*(GGUISCREENWIDTH-42))/obj.width);
    

    
//    self.bgView.frame = CGRectMake(0,lastSize1.height + lastSize2.height + (obj.height*(GGUISCREENWIDTH-42))/obj.width  + 24+22 +20, GGUISCREENWIDTH, 10);
//
    
    self.bgImageView_.frame = CGRectMake(0, 0, GGUISCREENWIDTH, (obj.height*(GGUISCREENWIDTH))/obj.width);
    self.bgView.frame = CGRectMake(0,PosYFromView(self.bgImageView_, 0), GGUISCREENWIDTH, 10);
    
    
}
//计算高度
+(float)bindWithObjectHeigh:(ThemeData *) obj
{
    //图片高度 +  标题高度 +  文本高度 +间隔的高度
//    
//    CGSize maxSize1 = CGSizeMake(GGUISCREENWIDTH-42, MAXFLOAT);
//    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
//    CGSize  lastSize1 = [obj.title boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
//    
//    CGSize maxSize2 = CGSizeMake(GGUISCREENWIDTH-42, MAXFLOAT);
//    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:10]
//                                 };
//    CGSize  lastSize2 = [obj.themeConfigInfo boundingRectWithSize:maxSize2 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
//
//    
//    
//    return  lastSize1.height + lastSize2.height + (obj.height*(GGUISCREENWIDTH-42))/obj.width  + 24+22 +10+20;
    
    return (obj.height*(GGUISCREENWIDTH))/obj.width + 10;
}


@end
