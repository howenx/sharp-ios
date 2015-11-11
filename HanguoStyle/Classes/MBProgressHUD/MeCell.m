//
//  MeCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/21.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MeCell.h"
@interface MeCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation MeCell
+(id)subjectCell
{
    UINib * nib = [UINib nibWithNibName:@"MeCell" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:self options:nil]lastObject];
}

- (void)setData:(MeData *)data
{
    self.titleLab.text = data.title;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
