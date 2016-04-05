//
//  PayTypeCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/18.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "PayTypeCell.h"
#import "ResetButton.h"
@implementation PayTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createView{
    
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH, 40)];
    titleLab.text = @"支付方式";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor grayColor];
    [self.contentView addSubview:titleLab];
    
    
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
    line1.backgroundColor = GGBgColor;
    [self.contentView addSubview:line1];
    
    
    UIView * payTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, GGUISCREENWIDTH, 50)];
    [self.contentView addSubview:payTypeView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    imageView.image = [UIImage imageNamed:@"defaultSelect"];
    [payTypeView addSubview:imageView];
    
    
    _payTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, GGUISCREENWIDTH, 50)];
    _payTypeLab.text = _payType;
    _payTypeLab.font = [UIFont systemFontOfSize:14];
    _payTypeLab.textColor = [UIColor grayColor];
    [payTypeView addSubview:_payTypeLab];
    
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(GGUISCREENWIDTH-50, 0, 40, 50);
    if(_isPayTypeEdit){
        [_editBtn setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [_editBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [payTypeView addSubview:_editBtn];
    
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, GGUISCREENWIDTH, 1)];
    line2.backgroundColor = GGBgColor;
    [payTypeView addSubview:line2];
    if(_isPayTypeEdit){
        
        UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, GGUISCREENWIDTH, 40)];
        selectView.backgroundColor = GGBgColor;
        [self.contentView addSubview:selectView];
        
        
        ResetButton * oneBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(10, 0, GGUISCREENWIDTH-10, 40);
        [oneBtn setTitle:@"在线支付" forState:UIControlStateNormal];
        [oneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [oneBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [oneBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [oneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        oneBtn.tag = 10001;
        if([_payType isEqualToString:[oneBtn currentTitle]]){
            oneBtn.selected = YES;
        }
        [selectView addSubview:oneBtn];
        
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
        line3.backgroundColor = [UIColor lightGrayColor];
        
        [selectView addSubview:line3];
        
        
        
//        ResetButton * twoBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
//        
//        twoBtn.frame = CGRectMake(10, 40, GGUISCREENWIDTH-10, 40);
//        [twoBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
//        [twoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        twoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        
//        [twoBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//        [twoBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//        [twoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        twoBtn.tag = 10002;
//        if([_payType isEqualToString:[twoBtn currentTitle]]){
//            twoBtn.selected = YES;
//        }
//        [selectView addSubview:twoBtn];
//        
//        
//        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 79, GGUISCREENWIDTH, 1)];
//        line4.backgroundColor = [UIColor lightGrayColor];
//        [selectView addSubview:line4];
//        
//        
//        ResetButton * threeBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
//        threeBtn.frame = CGRectMake(10, 80, GGUISCREENWIDTH-10, 40);
//        [threeBtn setTitle:@"微信支付" forState:UIControlStateNormal];
//        [threeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        threeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        
//        [threeBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//        [threeBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//        [threeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        threeBtn.tag = 10003;
//        if([_payType isEqualToString:[threeBtn currentTitle]]){
//            threeBtn.selected = YES;
//        }
//        [selectView addSubview:threeBtn];
//        
//        
//        UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 119, GGUISCREENWIDTH, 1)];
//        line5.backgroundColor = [UIColor lightGrayColor];
//        [selectView addSubview:line5];
        
    }
    
    
}
-(void)btnClick:(UIButton *)button{
    for(int i = 1; i < 4; i++){
        UIButton * btn = (UIButton *)[self.contentView viewWithTag:10000+i];
        btn.selected = NO;
    }
    button.selected = YES;
    _payTypeLab.text = [button currentTitle];
    [self.delegate payTypeFlag:_payTypeLab.text];
}

@end
