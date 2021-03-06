//
//  GoodsPackCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsPackCell.h"


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
    if(![NSString isNSNull:data.themeImg]){
        [self.preImageView sd_setImageWithURL:[NSURL URLWithString:data.themeImg] placeholderImage:[UIImage  imageNamed:@"load1ing"]];
    }
    self.preImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.preImageView setImage:[UIImage imageNamed:@"zhanwei"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
