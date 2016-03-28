//
//  AddAddrCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/17.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AddAddrCell.h"

@implementation AddAddrCell
+(id)subjectCell
{
    UINib * nib = [UINib nibWithNibName:@"AddAddrCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:self options:nil]lastObject];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
