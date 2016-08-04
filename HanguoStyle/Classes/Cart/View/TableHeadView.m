//
//  TableHeadView.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/21.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "TableHeadView.h"

@implementation TableHeadView
{
    BOOL isSelectAll;
}
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
        
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllBtn.frame = CGRectMake(0, 0, 30, 45);
        _selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(14,10,14,3);
        [_selectAllBtn addTarget:self action:@selector(selectAllClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectAllBtn];
        
        //行邮税
//        _postalTaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-160, 0, 150, 20)];
//        _postalTaxLabel.textAlignment = NSTextAlignmentRight;
//        _postalTaxLabel.font = [UIFont systemFontOfSize:11];
//        _postalTaxLabel.textColor = [UIColor blackColor];
        
//        [self addSubview:_postalTaxLabel];
        
       
    }
    return self;
}
-(void)setCartData:(CartData *)cartData{
    _cartData = cartData;
    _label.text = cartData.invAreaNm;
    long selectCount = 0;
    long goodAmount = 0;
    for (int j = 0;j < cartData.cartDetailArray.count; j++) {
        CartDetailData * cdData = cartData.cartDetailArray[j];
        if([@"G" isEqualToString: cdData.state]){
            selectCount = selectCount + cdData.amount;
        }
        goodAmount = goodAmount + cdData.amount;
    }
    if( selectCount == goodAmount){
        isSelectAll = YES;
        [_selectAllBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        isSelectAll = NO;
        [_selectAllBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }
//    if(cartData.selectPostalTaxRate > cartData.postalStandard){
//        NSString * postalTaxRate = [NSString stringWithFormat:@"行邮税:￥%.2f",cartData.selectPostalTaxRate];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:postalTaxRate];
//        [str addAttribute:NSForegroundColorAttributeName value:GGMainColor range:NSMakeRange(4,postalTaxRate.length-4)];
//        _postalTaxLabel.attributedText = str;
//
//    }else{
//        if([@"-0.0" isEqualToString:[NSString stringWithFormat:@"%.1f",cartData.selectPostalTaxRate]] || [@"0.0" isEqualToString:[NSString stringWithFormat:@"%.1f",cartData.selectPostalTaxRate]]){
//            _postalTaxLabel.text = @"免税";
//            _postalTaxLabel.textColor = GGMainColor;
//        }else{
//            NSString * postalTaxRate = [NSString stringWithFormat:@"行邮税:￥%.2f(免)",cartData.selectPostalTaxRate];
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:postalTaxRate];
//            [str addAttribute:NSForegroundColorAttributeName value:GGMainColor range:NSMakeRange(4,postalTaxRate.length-4)];
//            _postalTaxLabel.attributedText = str;
//
//        }
//    }
    
}

-(void)selectAllClick{
    isSelectAll = !isSelectAll;
    BOOL isLogin = [PublicMethod checkLogin];
    if(isLogin){
        //给后台发送勾选信息
        NSString * urlString =[HSGlobal selectCustUrl];
        NSMutableArray * mutArray = [NSMutableArray array];
        
        for(int j=0; j < _cartData.cartDetailArray.count; j++){
            CartDetailData * cdData = _cartData.cartDetailArray[j];
            if(![@"S" isEqualToString: cdData.state]){
                NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
                [myDict setObject:[NSNumber numberWithLong:cdData.skuId] forKey:@"skuId"];
                [myDict setObject:[NSNumber numberWithInteger:cdData.cartId] forKey:@"cartId"];
                [myDict setObject:[NSNumber numberWithInteger:cdData.amount] forKey:@"amount"];
                if(isSelectAll){//未选中
                    [myDict setObject:@"G" forKey:@"state"];
                }else{//选中
                    [myDict setObject:@"I" forKey:@"state"];
                }
                
                [myDict setObject:[NSNumber numberWithLong:cdData.skuTypeId] forKey:@"skuTypeId"];
                [myDict setObject:cdData.skuType forKey:@"skuType"];
                //未修改之前未勾选给后台传想要勾选
                if(isSelectAll){
                    [myDict setObject:@"Y" forKey:@"orCheck"];
                }else{
                    [myDict setObject:@"N" forKey:@"orCheck"];
                }
                
                [myDict setObject:[NSNumber numberWithInt:3] forKey:@"cartSource"];
                
                [mutArray addObject:myDict];
                
            }
        }
        
        
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
        [manager POST:urlString  parameters:mutArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            NSLog(@"message= %@",message);
            if(code == 200 ){
                [self.delegate loadDataNotify];
            }else{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = message;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [GiFHUD dismiss];
        }];
    }else{
        [self updataCart];
        [self.delegate loadDataNotify];
    }
    
}
-(void)updataCart {
    FMDatabase * database = [PublicMethod shareDatabase];
    [database beginTransaction];
    if(isSelectAll){
        for(int j=0; j < _cartData.cartDetailArray.count; j++){
            CartDetailData * cdData = _cartData.cartDetailArray[j];
            if(![@"S" isEqualToString: cdData.state]){
                [database executeUpdate:@"UPDATE Shopping_Cart SET state = ? WHERE pid = ? and sku_type = ? and sku_type_id = ?",@"G",[NSNumber numberWithLong:cdData.skuId],cdData.skuType,[NSNumber numberWithLong:cdData.skuTypeId]];
            }
        }
    }else{
        for(int j=0; j < _cartData.cartDetailArray.count; j++){
            CartDetailData * cdData = _cartData.cartDetailArray[j];
            if(![@"S" isEqualToString: cdData.state]){
                [database executeUpdate:@"UPDATE Shopping_Cart SET state = ? WHERE pid = ? and sku_type = ? and sku_type_id = ?",@"I",[NSNumber numberWithLong:cdData.skuId],cdData.skuType,[NSNumber numberWithLong:cdData.skuTypeId]];
            }
        }
    }
        //提交事务
    [database commit];
    
    
}

@end
