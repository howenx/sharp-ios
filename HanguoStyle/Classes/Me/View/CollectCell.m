//
//  CollectCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "CollectCell.h"
@interface CollectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end
@implementation CollectCell
- (void)setData:(CollectData *)data
{
    self.titleLab.text = data.skuTitle;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:data.invImg]];
    self.sizeLab.text = data.skuTitle;
    if([data.skuType isEqualToString:@"pin"]){
        self.pinImageView.hidden = NO;
        self.priceTitleLab.text = @"最低至:";
    }else{
        self.pinImageView.hidden = YES;
        self.priceTitleLab.text = @"单价 :";
    }
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",data.price];
    self.sizeLab.text = data.skuTitle;
    self.sizeLab.text = [NSString stringWithFormat:@"%@  %@",data.itemColor,data.itemSize];


    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
