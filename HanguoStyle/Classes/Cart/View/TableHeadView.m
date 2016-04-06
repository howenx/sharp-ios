//
//  TableHeadView.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/21.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "TableHeadView.h"

@implementation TableHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.backgroundColor = GGMainColor;
//        [self.layer setMasksToBounds:YES];
//        [self.layer setCornerRadius:3.0];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor whiteColor];
        
        [self addSubview:_label];
        
        
        //行邮税
        _postalTaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-160, 0, 150, 20)];
        _postalTaxLabel.textAlignment = NSTextAlignmentRight;
        _postalTaxLabel.font = [UIFont systemFontOfSize:11];
        _postalTaxLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:_postalTaxLabel];
 
       
    }
    return self;
}
-(void)setCartData:(CartData *)cartData{
    _label.text = cartData.invAreaNm;
    if(cartData.selectPostalTaxRate > cartData.postalStandard){
        _postalTaxLabel.text = [NSString stringWithFormat:@"行邮税￥%.2f",cartData.selectPostalTaxRate];
    }else{
        if(cartData.selectPostalTaxRate == 0){
            _postalTaxLabel.text = @"行邮税￥0";
        }else{
            _postalTaxLabel.text = [NSString stringWithFormat:@"行邮税￥%.2f(免)",cartData.selectPostalTaxRate];
        }
        
    }
    
}

@end
