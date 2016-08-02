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
       
        self.backgroundColor = [UIColor whiteColor];
//        [self.layer setMasksToBounds:YES];
//        [self.layer setCornerRadius:3.0];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(38, 0, GGUISCREENWIDTH-50, 45)];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = UIColorFromRGB(0x242424);
        
        [self addSubview:_label];
        
        
        //行邮税
        _postalTaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-160, 0, 150, 20)];
        _postalTaxLabel.textAlignment = NSTextAlignmentRight;
        _postalTaxLabel.font = [UIFont systemFontOfSize:11];
        _postalTaxLabel.textColor = [UIColor blackColor];
        
//        [self addSubview:_postalTaxLabel];
        
       
    }
    return self;
}
-(void)setCartData:(CartData *)cartData{
    _label.text = cartData.invAreaNm;
    if(cartData.selectPostalTaxRate > cartData.postalStandard){
        NSString * postalTaxRate = [NSString stringWithFormat:@"行邮税:￥%.2f",cartData.selectPostalTaxRate];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:postalTaxRate];
        [str addAttribute:NSForegroundColorAttributeName value:GGMainColor range:NSMakeRange(4,postalTaxRate.length-4)];
        _postalTaxLabel.attributedText = str;

    }else{
        if([@"-0.0" isEqualToString:[NSString stringWithFormat:@"%.1f",cartData.selectPostalTaxRate]] || [@"0.0" isEqualToString:[NSString stringWithFormat:@"%.1f",cartData.selectPostalTaxRate]]){
            _postalTaxLabel.text = @"免税";
            _postalTaxLabel.textColor = GGMainColor;
        }else{
            NSString * postalTaxRate = [NSString stringWithFormat:@"行邮税:￥%.2f(免)",cartData.selectPostalTaxRate];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:postalTaxRate];
            [str addAttribute:NSForegroundColorAttributeName value:GGMainColor range:NSMakeRange(4,postalTaxRate.length-4)];
            _postalTaxLabel.attributedText = str;

        }
    }
    
}

@end
