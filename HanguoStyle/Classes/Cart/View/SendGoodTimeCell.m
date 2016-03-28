//
//  SendGoodTimeCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/17.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "SendGoodTimeCell.h"
#import "ResetButton.h"
@implementation SendGoodTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createView{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 10)];
    backView.backgroundColor = GGColor(240, 240, 240);
    [self.contentView addSubview:backView];
    
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, GGUISCREENWIDTH, 40)];
    titleLab.text = @"发货时间";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:titleLab];
    
    
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, GGUISCREENWIDTH, 1)];
    line1.backgroundColor = GGColor(240, 240, 240);
    [self.contentView addSubview:line1];
    
    
    UIView * timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, GGUISCREENWIDTH, 50)];
    [self.contentView addSubview:timeView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    imageView.image = [UIImage imageNamed:@"defaultSelect"];
    [timeView addSubview:imageView];
    
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, GGUISCREENWIDTH, 50)];
    _timeLab.text = _sendTime;
    _timeLab.font = [UIFont systemFontOfSize:14];
    _timeLab.textColor = [UIColor grayColor];
    [timeView addSubview:_timeLab];
    
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(GGUISCREENWIDTH-50, 0, 40, 50);
    if(_isTimeEdit){
        [_editBtn setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [_editBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [timeView addSubview:_editBtn];
    
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, GGUISCREENWIDTH, 1)];
    line2.backgroundColor = GGColor(240, 240, 240);
    [timeView addSubview:line2];
    if(_isTimeEdit){
        
        UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, GGUISCREENWIDTH, 120)];
        selectView.backgroundColor = GGColor(240, 240, 240);
        [self.contentView addSubview:selectView];
        
        
        ResetButton * oneBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(10, 0, GGUISCREENWIDTH-10, 40);
        [oneBtn setTitle:@"工作日双休日与假期均可送货" forState:UIControlStateNormal];
        [oneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [oneBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [oneBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [oneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        oneBtn.tag = 10001;
        if([_sendTime isEqualToString:[oneBtn currentTitle]]){
            oneBtn.selected = YES;
        }
        [selectView addSubview:oneBtn];
        
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
        line3.backgroundColor = [UIColor lightGrayColor];
        
        [selectView addSubview:line3];
        
        
        
        ResetButton * twoBtn = [ResetButton buttonWithType:UIButtonTypeCustom];

        twoBtn.frame = CGRectMake(10, 40, GGUISCREENWIDTH-10, 40);
        [twoBtn setTitle:@"只工作日送货" forState:UIControlStateNormal];
        [twoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        twoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [twoBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [twoBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [twoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        twoBtn.tag = 10002;
        if([_sendTime isEqualToString:[twoBtn currentTitle]]){
            twoBtn.selected = YES;
        }
        [selectView addSubview:twoBtn];
        
        
        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 79, GGUISCREENWIDTH, 1)];
        line4.backgroundColor = [UIColor lightGrayColor];
        [selectView addSubview:line4];
        
        
        ResetButton * threeBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
        threeBtn.frame = CGRectMake(10, 80, GGUISCREENWIDTH-10, 40);
        [threeBtn setTitle:@"只双休日与假期送货" forState:UIControlStateNormal];
        [threeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        threeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [threeBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [threeBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [threeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        threeBtn.tag = 10003;
        if([_sendTime isEqualToString:[threeBtn currentTitle]]){
            threeBtn.selected = YES;
        }
        [selectView addSubview:threeBtn];
        
        
        UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 119, GGUISCREENWIDTH, 1)];
        line5.backgroundColor = [UIColor lightGrayColor];
        [selectView addSubview:line5];

    }


}
-(void)btnClick:(UIButton *)button{
    for(int i = 1; i < 4; i++){
        UIButton * btn = (UIButton *)[self.contentView viewWithTag:10000+i];
        btn.selected = NO;
    }
    button.selected = YES;
    _timeLab.text = [button currentTitle];
    [self.delegate sendTimeFlag:_timeLab.text];
}
@end
