//
//  AddressCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/4.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AddressCell.h"
@interface AddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *consigneeLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *idCardNumLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;

@end
@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setData:(AddressData *)data{
    self.consigneeLab.text = data.name;
    self.phoneNumLab.text = data.tel;
    self.idCardNumLab.text = data.idCardNum;
    self.addressLab.text = [NSString stringWithFormat:@"%@,%@",data.deliveryCity,data.deliveryDetail];
    if (data.orDefault) {
        [self.defaultImage setImage:[UIImage imageNamed:@"defaultSelect"]];
    }else{
        [self.defaultImage setImage:nil];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
