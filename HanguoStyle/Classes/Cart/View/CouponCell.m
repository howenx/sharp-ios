//
//  CouponCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/18.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CouponCell.h"
#import "ResetButton.h"
#import "UIView+frame.h"
@interface CouponCell()
{

    NSString * couponSave;
}
@end
@implementation CouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(OrderData *)data{
    
    _data = data;
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 10)];
    backView.backgroundColor = GGColor(240, 240, 240);
    [self.contentView addSubview:backView];
    

    
    UIView * couponView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, GGUISCREENWIDTH, 50)];
    [self.contentView addSubview:couponView];

    
    
    
    
    
    UILabel *  titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH/2, 50)];
    titleLab.text = @"可使用优惠券(每次限一张)";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor grayColor];
    [couponView addSubview:titleLab];
    
    
    _couponLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH/2, 0, GGUISCREENWIDTH/2-30, 50)];
    if([_coupon isEqualToString:@"不使用优惠券"] || [_coupon isEqualToString:@"未选择"]){
        _couponLab.text =  _coupon;
    }else{
        _couponLab.text = [@"-" stringByAppendingString: _coupon];
    }
    
    _couponLab.textAlignment = NSTextAlignmentRight;
    _couponLab.font = [UIFont systemFontOfSize:14];
    _couponLab.textColor = [UIColor grayColor];
    [couponView addSubview:_couponLab];

    
    
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(GGUISCREENWIDTH-30, 15, 20, 20);
    if(_isCouponEdit){
        [_editBtn setImage:[UIImage imageNamed:@"icon_more_up_hui"] forState:UIControlStateNormal];
    }else{
        [_editBtn setImage:[UIImage imageNamed:@"icon_more_down_hui"] forState:UIControlStateNormal];
    }
    
//    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _editBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [couponView addSubview:_editBtn];
    
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, GGUISCREENWIDTH, 1)];
    line2.backgroundColor = GGColor(240, 240, 240);
    [couponView addSubview:line2];
    if(_isCouponEdit){
        int couponCount = (int)data.couponsArray.count;
        UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, GGUISCREENWIDTH, (couponCount+1)*40)];
        selectView.backgroundColor = GGColor(240, 240, 240);
        [self.contentView addSubview:selectView];
        
        
        ResetButton * oneBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(10, 0, GGUISCREENWIDTH-10, 40);
        [oneBtn setTitle:@"不使用优惠券" forState:UIControlStateNormal];
        [oneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [oneBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [oneBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [oneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        oneBtn.tag = 10000;
        if([_coupon isEqualToString:[oneBtn currentTitle]]){
            oneBtn.selected = YES;
        }
        [selectView addSubview:oneBtn];
        
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
        line3.backgroundColor = [UIColor lightGrayColor];
        
        [selectView addSubview:line3];
        for(int i = 1;i <= data.couponsArray.count;i++){
            CouponsData * couponsData = data.couponsArray[i-1];
            NSString * str = [NSString stringWithFormat:@"满%@减%@",couponsData.limitQuota , couponsData.denomination];
            
            
            ResetButton * btn = [ResetButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 40 * i, GGUISCREENWIDTH-10, 40);
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            
            [btn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 10000+i;
            if([_coupon isEqualToString:couponsData.denomination]){
                btn.selected = YES;
            }
            [selectView addSubview:btn];
            
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, btn.y + btn.height - 1, GGUISCREENWIDTH, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            [selectView addSubview:line];

        }
    }
    
    
    UIView * lastView = [[UIView alloc]init];
    
    if(_isCouponEdit){
        lastView.frame = CGRectMake(0, 60 + ((int)data.couponsArray.count + 1) * 40 , GGUISCREENWIDTH, 160);
    }else{
        lastView.frame = CGRectMake(0, 60, GGUISCREENWIDTH, 160);
    }
    [self.contentView addSubview:lastView];
    
    //商品总价
    UIView * totalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
    [lastView addSubview:totalView];
    UILabel * totalLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
    totalLab.text = @"商品总价";
    totalLab.font = [UIFont systemFontOfSize:14];
    totalLab.textColor = [UIColor grayColor];
    [totalView addSubview:totalLab];
    
    UILabel * totalPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-100, 0, 90, 40)];
    totalPriceLab.text = [NSString stringWithFormat:@"￥%@",_realityPay];
    totalPriceLab.textAlignment = NSTextAlignmentRight;
    totalPriceLab.font = [UIFont systemFontOfSize:14];
    totalPriceLab.textColor = GGMainColor;
    [totalView addSubview:totalPriceLab];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 40 - 1, GGUISCREENWIDTH, 1)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [totalView addSubview:line4];
    
    
    
    
    //优惠金额
    UIView * discountAmtView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, GGUISCREENWIDTH, 40)];
    [lastView addSubview:discountAmtView];
    UILabel * discountAmtLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
    discountAmtLab.text = @"优惠金额";
    discountAmtLab.font = [UIFont systemFontOfSize:14];
    discountAmtLab.textColor = [UIColor grayColor];
    [discountAmtView addSubview:discountAmtLab];
    
    UILabel * discountAmtPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-100, 0, 90, 40)];
    if([_coupon isEqualToString:@"不使用优惠券"] || [_coupon isEqualToString:@"未选择"]){
        discountAmtPriceLab.text = @"￥0";
    }else{
        discountAmtPriceLab.text = [NSString stringWithFormat:@"￥%@",_coupon];
    }
    discountAmtPriceLab.textAlignment = NSTextAlignmentRight;
    discountAmtPriceLab.font = [UIFont systemFontOfSize:14];
    discountAmtPriceLab.textColor = GGMainColor;
    [discountAmtView addSubview:discountAmtPriceLab];
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 40 - 1, GGUISCREENWIDTH, 1)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [discountAmtView addSubview:line5];
    
    
    //行邮税
    UIView * portalFeeView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, GGUISCREENWIDTH, 40)];
    [lastView addSubview:portalFeeView];
    UILabel * portalFeeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
    portalFeeLab.text = @"行邮税";
    portalFeeLab.font = [UIFont systemFontOfSize:14];
    portalFeeLab.textColor = [UIColor grayColor];
    [portalFeeView addSubview:portalFeeLab];
    
    UILabel * portalFeePriceLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-100, 0, 90, 40)];
    portalFeePriceLab.text = [NSString stringWithFormat:@"￥%@",data.factPortalFee];
    portalFeePriceLab.textAlignment = NSTextAlignmentRight;
    portalFeePriceLab.font = [UIFont systemFontOfSize:14];
    portalFeePriceLab.textColor = GGMainColor;
    [portalFeeView addSubview:portalFeePriceLab];
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 40 - 1, GGUISCREENWIDTH, 1)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [portalFeeView addSubview:line6];

    
    //运费
    UIView * shipView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, GGUISCREENWIDTH, 40)];
    [lastView addSubview:shipView];
    UILabel * shipLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
    shipLab.text = @"运费";
    shipLab.font = [UIFont systemFontOfSize:14];
    shipLab.textColor = [UIColor grayColor];
    [shipView addSubview:shipLab];
    
    UILabel * shipPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-100, 0, 90, 40)];
    shipPriceLab.text = [NSString stringWithFormat:@"￥%@",data.factShipFee];
    shipPriceLab.textAlignment = NSTextAlignmentRight;
    shipPriceLab.font = [UIFont systemFontOfSize:14];
    shipPriceLab.textColor = GGMainColor;
    [shipView addSubview:shipPriceLab];
    UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake(0, 40 - 1, GGUISCREENWIDTH, 1)];
    line7.backgroundColor = [UIColor lightGrayColor];
    [shipView addSubview:line7];

}
-(void)btnClick:(UIButton *)button{
    for(int i = 0;i <= _data.couponsArray.count;i++){
        UIButton * btn = (UIButton *)[self.contentView viewWithTag:10000+i];
        btn.selected = NO;
        if(button.tag == 10000){
            _couponLab.text = @"不使用优惠券";
            [self.delegate couponFlag:@"不使用优惠券"  andCouponId:@""];
            
        }else if(button.tag == btn.tag){
            _couponLab.text = [@"-" stringByAppendingString: ((CouponsData *)_data.couponsArray[i-1]).denomination];
            [self.delegate couponFlag:((CouponsData *)_data.couponsArray[i-1]).denomination andCouponId:((CouponsData *)_data.couponsArray[i-1]).coupId];
        }
    }
    button.selected = YES;

}

@end
