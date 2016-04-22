//
//  OrderCartCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/16.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "OrderCartCell.h"
#import "CartData.h"

@interface OrderCartCell()


@end

@implementation OrderCartCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setData:(OrderData *)data{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 10)];
    backView.backgroundColor = GGBgColor;
    [self.contentView addSubview:backView];
    CGFloat bottom = 10;
    for(int i = 0 ;i<data.singleCustomsArray.count; i++){
        OrderDetailData * orderDetailData = data.singleCustomsArray[i];
        int cartCount = (int)orderDetailData.cartDataArray.count;
        [self createCartView:CGRectMake(0, bottom, GGUISCREENWIDTH, cartCount*100 + 80) andOrderDetailData:orderDetailData];
        bottom = bottom + cartCount*100 + 80;
    }

}
-(void) createCartView :(CGRect)frame andOrderDetailData:(OrderDetailData*)orderDetailData{
    float low = 0;
    UIView * view = [[UIView alloc]initWithFrame:frame];
    [self.contentView addSubview:view];
    
    
    UILabel * headLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
    headLab.text = orderDetailData.invAreaNm;
    headLab.font = [UIFont systemFontOfSize:15];
    headLab.textColor = [UIColor grayColor];
    headLab.textAlignment = NSTextAlignmentCenter;
    UIView * backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
    backView1.backgroundColor = GGBgColor;
    [self.contentView addSubview:backView1];

    [view addSubview:headLab];
    [view addSubview:backView1];
    
    low = backView1.y + backView1.height;
    NSArray * cartDataArray = orderDetailData.cartDataArray;
    for (int i = 0; i < cartDataArray.count; i++) {
        
        CartDetailData * cdData = cartDataArray[i];
        UIView * cartView = [[UIView alloc]initWithFrame:CGRectMake(0, low, GGUISCREENWIDTH, 100)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:cdData.invImg]];
        [cartView addSubview:imageView];
        
        
        UILabel  * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, GGUISCREENWIDTH-110, 40)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.numberOfLines = 2;
        titleLabel.text = cdData.invTitle;
//        titleLabel.textColor = [UIColor grayColor];
        [cartView addSubview:titleLabel];
        
        
        
        UILabel  * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 30)];
        priceLabel.font = [UIFont systemFontOfSize:15];
        priceLabel.numberOfLines = 1;
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f",cdData.itemPrice];
        priceLabel.textColor = GGMainColor;
        [cartView addSubview:priceLabel];
        
        
        UILabel  * amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 60, GGUISCREENWIDTH -210, 30)];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.font = [UIFont systemFontOfSize:13];
        amountLabel.numberOfLines = 1;
        amountLabel.textColor = [UIColor grayColor];
        amountLabel.text = [NSString stringWithFormat:@"购买数量:%li",(long)cdData.amount];
        [cartView addSubview:amountLabel];
        
        
        UIView * backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99, GGUISCREENWIDTH, 1)];
        backView2.backgroundColor = GGBgColor;
        [cartView addSubview:backView2];
        
        [view addSubview:cartView];
        
        low = low + cartView.height;
    }
    NSLog(@"-%@",orderDetailData.portalSingleCustomsFee);
    
    
    UILabel * footLab = [[UILabel alloc]initWithFrame:CGRectMake( 10, low, GGUISCREENWIDTH-20, 40)];
    
    footLab.font = [UIFont systemFontOfSize:15];
    footLab.textColor = [UIColor grayColor];
    [view addSubview:footLab];
    
    NSString * strFoot = [NSString stringWithFormat:@"运费:￥%@ 行邮税:￥%@",orderDetailData.factSingleCustomsShipFee,orderDetailData.factPortalFeeSingleCustoms];
    if ([orderDetailData.factPortalFeeSingleCustoms isEqualToString:@"0"]) {
        NSLog(@"+%@",orderDetailData.portalSingleCustomsFee);
        strFoot = [NSString stringWithFormat:@"%@  免:￥%@",strFoot,orderDetailData.portalSingleCustomsFee];
        
        UIView * delLine = [[UIView alloc]initWithFrame:CGRectMake(175, 20, 45, 1)];
        delLine.backgroundColor = [UIColor grayColor];
        [footLab addSubview:delLine];
    }
    footLab.text = strFoot;
    
    
    low = footLab.y +footLab.height;
    
    UIView * backView3 = [[UIView alloc]initWithFrame:CGRectMake(0, low-1, GGUISCREENWIDTH, 1)];
    backView3.backgroundColor = GGBgColor;

    
    [view addSubview:backView3];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
