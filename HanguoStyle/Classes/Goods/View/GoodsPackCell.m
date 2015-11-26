//
//  GoodsPackCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsPackCell.h"
#import "UIImageView+WebCache.h"


@interface GoodsPackCell()

@property (weak, nonatomic) IBOutlet UIImageView *preImageView;

@end
@implementation GoodsPackCell
//+(id)subjectCell
//{
//    UINib * nib = [UINib nibWithNibName:@"GoodsPackCell" bundle:[NSBundle mainBundle]];
//    return [[nib instantiateWithOwner:self options:nil]lastObject];
//}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setData:(ThemeData *)data
{
    [self.preImageView sd_setImageWithURL:[NSURL URLWithString:data.themeImg]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
