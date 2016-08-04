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
//@property (weak, nonatomic) IBOutlet UILabel *idCardNumLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
- (IBAction)updateAddrBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIImageView *jumpImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabHConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *morenImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consigneeWConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *dizhiImageView;

@end
@implementation AddressCell
+(id)subjectCell
{
    UINib * nib = [UINib nibWithNibName:@"AddressCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:self options:nil]lastObject];
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setData:(AddressData *)data{
   

    _data = data;
    self.consigneeLab.text = data.name;
    
    CGSize consigneeSize  = [PublicMethod getSize:self.consigneeLab.text Font:13 Width:GGUISCREENWIDTH-180 Height:21];
    _consigneeWConstraint.constant = consigneeSize.width+1;
    
    
    self.phoneNumLab.text = [NSString stringWithFormat:@"%@****%@",[data.tel substringToIndex:3],[data.tel substringFromIndex:8]];
//    self.idCardNumLab.text = [NSString stringWithFormat:@"%@****%@",[data.idCardNum substringToIndex:10],[data.idCardNum substringFromIndex:14]];
//    self.idCardNumLab.text = data.idCardNum;
    self.addressLab.text = [NSString stringWithFormat:@"%@,%@",data.deliveryCity,data.deliveryDetail];
    CGSize size  = [PublicMethod getSize:self.addressLab.text Font:12 Width:GGUISCREENWIDTH-135 Height:1000];
    if(size.height>29){
        _detailLabHConstraint.constant = 29+1;//不加1不显示下一行
    }else{
        _detailLabHConstraint.constant = size.height+1;//不加1不显示下一行
    }
    if (data.orDefault) {
        self.morenImageView.hidden = NO;
        self.dizhiImageView.hidden = NO;
    }else{
        self.morenImageView.hidden = YES;
        self.dizhiImageView.hidden = YES;
    }
    if(data.isOrderDefault){
        self.defaultImage.image = [UIImage imageNamed:@"defaultSelect"];
    }else{
        self.defaultImage.image = nil;
    }
    if([@"orderAddr" isEqualToString:_from]){
        self.jumpImageView.image = [UIImage imageNamed:@"icon_more_hui"];
        self.setButton.hidden = YES;
        self.defaultImage.hidden = YES;
        self.dizhiImageView.hidden = NO;
    }
    if ([@"order" isEqualToString:self.comeFrom]) {
        self.titleImageView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)updateAddrBtn:(UIButton *)sender {
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    [self.delegate updateAddr:_data];
}
@end
