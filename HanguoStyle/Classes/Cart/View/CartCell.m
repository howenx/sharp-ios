//
//  CartCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CartCell.h"
#import "ShoppingCart.h"

@implementation CartCell
{
//    CartDetailData * cartDetailData;
    BOOL isLogin;
    FMDatabase *database;
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void) touchUpInside:(UITapGestureRecognizer *)recognizer{
    
    [self.delegate enterDetail:_data.invUrl];
    
}
- (void)setData:(CartDetailData *)data{
    _data = data;
    isLogin = [PublicMethod checkLogin];
    database = [PublicMethod shareDatabase];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:data.invImg]];
    self.title.text = data.invTitle;

    self.price.text = [NSString stringWithFormat:@"￥%.2f",data.itemPrice];
    self.colorAndSizeLab.text = [NSString stringWithFormat:@"%@  %@",data.itemColor,data.itemSize];
    
    if(data.amount == 1){
        self.jianBtn.enabled=NO;
        self.jianBtn.alpha=0.4;
    }else{
        self.jianBtn.enabled=YES;
        self.jianBtn.alpha=1;
    }
    self.stateBtn.enabled=YES;
    self.jiaBtn.enabled=YES;
    self.stateBtn.alpha=1;
    self.jiaBtn.alpha=1;
    if([@"I" isEqualToString: data.state]){//未选中
        [self.stateBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }else if([@"G" isEqualToString: data.state]){//选中
        [self.stateBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else if([@"S" isEqualToString: data.state]){
        [self.stateBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//        [self.stateBtn setBackgroundColor:[UIColor grayColor]];
//        [self.stateBtn.layer setMasksToBounds:YES];
//        [self.stateBtn.layer setCornerRadius:10.0];
        
        self.stateBtn.enabled=NO;
        self.stateBtn.alpha=0.4;
        self.jianBtn.enabled=NO;
        self.jianBtn.alpha=0.4;
        self.jiaBtn.enabled=NO;
        self.jiaBtn.alpha=0.4;
    }
    
    [self.stateBtn addTarget:self action:@selector(stateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.jianBtn addTarget:self action:@selector(jianBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.jiaBtn addTarget:self action:@selector(jiaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.amountLab.text = [NSString stringWithFormat:@"%ld",(long)data.amount];
    //添加单击手势
    self.title.userInteractionEnabled=YES;
    [self.title addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)]];
    self.goodsImage.userInteractionEnabled=YES;
    [self.goodsImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)]];

}

//未登录状态下做选中或者修改或者删除操作只操作本地数据库，然后再次请求后台传过的data刷新页面

//登陆状态下做选中或者修改或者删除操作，发给后台一条数据，用后台再次传过的data刷新页面。
- (void) stateBtnClicked: (UIButton *) button
{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    //登陆状态
    if(isLogin){
//        CartDetailData * data  = [[CartDetailData alloc]init];
//        data = self.data;
        if([@"I" isEqualToString: _data.state]){//未选中
            _data.state = @"G";
            [self.stateBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        }else if([@"G" isEqualToString: _data.state]){//选中
            _data.state = @"I";
            [self.stateBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        }
        [self.delegate sendSelectData:_data];
    
    }else{
        
        ShoppingCart * sc = [[ShoppingCart alloc]init];
        if([@"I" isEqualToString: _data.state]){//未选中
            sc.state = @"G";
        }else if([@"G" isEqualToString: _data.state]){//选中
            sc.state = @"I";
        }
        sc.pid = _data.skuId;
        sc.cartId = _data.cartId;
        sc.amount = _data.amount;
        sc.skuType = _data.skuType;
        sc.skuTypeId = _data.skuTypeId;
        [self updataCart:sc];
        [self.delegate loadDataNotify];
    }
}
- (void) jianBtnClicked: (UIButton *) button
{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    //商品不限购，并且修改后数量大于限购数量
    if(_data.restrictAmount !=0 && _data.amount -1 > _data.restrictAmount){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.labelText = @"亲，您购买的数量已超过限购数量";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
        return;
    }
    isLogin = [PublicMethod checkLogin];
    //登陆状态
    if(isLogin){
        
//        CartDetailData * data  = [CartDetailData new];
//        data = cartDetailData;
        _data.amount = _data.amount-1;
        [self.delegate sendUpdateData:_data andJJFlag:@"jian"];
        
    }else{
        
        NSInteger amount = _data.amount ;
        NSString * checkUrl = [HSGlobal checkAddCartAmount];
        checkUrl = [NSString stringWithFormat:@"%@/%ld/%ld",checkUrl,(long)_data.skuId,amount-1];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareNoHeadRequestManager];
        
        [manager GET:checkUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"message = %@",message);
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            
            if(code == 200){
                ShoppingCart * sc = [[ShoppingCart alloc]init];
                sc.pid = _data.skuId;
                sc.cartId = _data.cartId;
                sc.amount = _data.amount - 1;
                sc.state = _data.state;
                sc.skuType = _data.skuType;
                sc.skuTypeId = _data.skuTypeId;
                //更新数据库，在刷新界面
                [self updataCart:sc];
                [self.delegate loadDataNotify];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.labelText = message;
                hud.margin = 10.f;
                //        hud.yOffset = 150.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [PublicMethod printAlert:@"修改失败"];
        }];
        
    }
}
- (void) jiaBtnClicked: (UIButton *) button
{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    //商品不限购，并且修改后数量大于限购数量
    if(_data.restrictAmount !=0 && _data.amount +1 > _data.restrictAmount){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.labelText = @"数量超过限购数量";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];

        return;
    }
    isLogin = [PublicMethod checkLogin];
    //登陆状态
    if(isLogin){
        _data.amount = _data.amount+1;
        [self.delegate sendUpdateData:_data andJJFlag:@"jia"];
        
    }else{

        NSInteger amount = _data.amount ;
        NSString * checkUrl = [HSGlobal checkAddCartAmount];
        checkUrl = [NSString stringWithFormat:@"%@/%ld/%ld",checkUrl,(long)_data.skuId,amount+1];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareNoHeadRequestManager];
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
        
        [manager GET:checkUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"message = %@",message);
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];

            if(code == 200){
                ShoppingCart * sc = [[ShoppingCart alloc]init];
                sc.pid = _data.skuId;
                sc.cartId = _data.cartId;
                sc.amount = _data.amount + 1;
                sc.state = _data.state;
                sc.skuType = _data.skuType;
                sc.skuTypeId = _data.skuTypeId;
                //更新数据库，在刷新界面
                [self updataCart:sc];

                [self.delegate loadDataNotify];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.labelText = message;
                hud.margin = 10.f;
                //        hud.yOffset = 150.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
            
          [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            NSLog(@"Error: %@", error);
            [PublicMethod printAlert:@"修改失败"];
        }];
        
    }
}


- (void) delBtnClicked: (UIButton *) button
{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        isLogin = [PublicMethod checkLogin];
        //登陆状态
        if(isLogin){
            [self.delegate sendDelUrl:_data];
        }else{
            [self delCart];
            [self.delegate loadDataNotify];
        }

    }
}

-(void)delCart{
    [database beginTransaction];
    [database executeUpdate:@"DELETE FROM Shopping_Cart WHERE pid =? and sku_type = ? and sku_type_id = ?",[NSNumber numberWithLong:_data.skuId],_data.skuType,[NSNumber numberWithLong:_data.skuTypeId]];
    [database commit];
}
-(void)updataCart :(ShoppingCart *) shopCart{
    
    [database beginTransaction];
    [database executeUpdate:@"UPDATE Shopping_Cart SET pid_amount = ? ,state = ? WHERE pid = ? and sku_type = ? and sku_type_id = ?",[NSNumber numberWithLong:shopCart.amount],shopCart.state,[NSNumber numberWithLong:shopCart.pid],shopCart.skuType,[NSNumber numberWithLong:shopCart.skuTypeId]];


    FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
    while ([rs next]){
        NSLog(@"____________后台获取数据start___________________");
        NSLog(@"pid=%d",[rs intForColumn:@"pid"]);
        NSLog(@"cart_id=%d",[rs intForColumn:@"cart_id"]);
        NSLog(@"pid_amount=%d",[rs intForColumn:@"pid_amount"]);
        NSLog(@"state=%@",[rs stringForColumn:@"state"]);
         NSLog(@"sku_type=%@",[rs stringForColumn:@"sku_type"]);
         NSLog(@"sku_type=%@",[rs stringForColumn:@"sku_type_id"]);
    }
    NSLog(@"____________后台获取数据end___________________");
    
    //提交事务
    [database commit];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
