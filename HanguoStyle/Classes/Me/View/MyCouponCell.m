//
//  MyCouponCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MyCouponCell.h"
@interface MyCouponCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *couponTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *limitQuotaLab;

@property (weak, nonatomic) IBOutlet UILabel *denominationLab;
@property (weak, nonatomic) IBOutlet UILabel *endAtLab;

@end
@implementation MyCouponCell
- (void)setData:(CouponData *)data{
    _data = data;
    self.couponTypeLab.text = data.cateNm;
    self.limitQuotaLab.text = [NSString stringWithFormat:@"满%@可用",data.limitQuota];
    self.denominationLab.text = [NSString stringWithFormat:@"￥%@",data.denomination];
    self.endAtLab.text = [NSString stringWithFormat:@"有效期至：%@",data.endAt];
    if([data.state isEqualToString:@"N"]){
        [self.bgImageView setImage:[UIImage imageNamed:@"weiyong" ]];
    }else if([data.state isEqualToString:@"Y"]){
        [self.bgImageView setImage:[UIImage imageNamed:@"yiyong" ]];
    }else if([data.state isEqualToString:@"S"]){
        [self.bgImageView setImage:[UIImage imageNamed:@"yiyong" ]];
    }
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
