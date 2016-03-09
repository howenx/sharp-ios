//
//  MyPinTeamCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/29.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MyPinTeamCell.h"
@interface MyPinTeamCell()
@property (weak, nonatomic) IBOutlet UIImageView *invImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *pinStatusLab;
@property (weak, nonatomic) IBOutlet UIButton *teamBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

@end
@implementation MyPinTeamCell
- (void)setData:(PinTeamData *)data{
    _data = data;
    self.titleLab.text = data.pinTitle;
    [self.invImageView sd_setImageWithURL:[NSURL URLWithString:data.pinImg]];

    self.priceLab.text = [NSString stringWithFormat:@"成员价：￥%@",data.pinPrice];
    if([_data.status isEqualToString:@"C"]){
        self.orderBtn.enabled=YES;
        self.orderBtn.alpha=1;
    }else{
        self.orderBtn.enabled=NO;
        self.orderBtn.alpha=0.4;
    }
    if([_data.status isEqualToString:@"C"]){
        self.pinStatusLab.text = @"拼团成功";
    }else if([_data.status isEqualToString:@"Y"]){
        self.pinStatusLab.text = @"拼团中";
    }else if([_data.status isEqualToString:@"F"]){
        self.pinStatusLab.text = @"拼团失败";
    }else if([_data.status isEqualToString:@"N"]){
        self.pinStatusLab.text = @"拼团取消";
    }
    [self.teamBtn addTarget:self action:@selector(teamBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.orderBtn addTarget:self action:@selector(orderBtnClicked) forControlEvents:UIControlEventTouchUpInside];

}
- (void)teamBtnClicked {
    [self.delegate sendTeamDetailUrl:_data.pinUrl];
}
- (void)orderBtnClicked {
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
