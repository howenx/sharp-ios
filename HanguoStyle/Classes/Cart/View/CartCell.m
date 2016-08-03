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
    
}
-(void) touchUpInside:(UITapGestureRecognizer *)recognizer{
    
    [self.delegate enterDetail:_data.invUrl];
    
}
- (void)setData:(CartDetailData *)data{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_jiaBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _jiaBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _jiaBtn.layer.mask = maskLayer;
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_jianBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _jianBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    _jianBtn.layer.mask = maskLayer1;

    _data = data;
    isLogin = [PublicMethod checkLogin];
    database = [PublicMethod shareDatabase];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:data.invImg]];
    self.title.text = data.invTitle;

    self.price.text = [NSString stringWithFormat:@"%.2f",data.itemPrice];
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
    self.stateBtn.imageEdgeInsets = UIEdgeInsetsMake(49,10,49,3);
    if([@"I" isEqualToString: data.state]){//未选中
        [self.stateBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        self.shixiaoImageView.hidden = YES;
        self.contentView.backgroundColor =  [UIColor whiteColor];
    }else if([@"G" isEqualToString: data.state]){//选中
        [self.stateBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        self.shixiaoImageView.hidden = YES;
        self.contentView.backgroundColor =  [UIColor whiteColor];
    }else if([@"S" isEqualToString: data.state]){
        [self.stateBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        self.shixiaoImageView.hidden = NO;
        self.contentView.backgroundColor =  UIColorFromRGB(0xe7e7e7);
//        [self.stateBtn setBackgroundColor:[UIColor grayColor]];
//        [self.stateBtn.layer setMasksToBounds:YES];
//        [self.stateBtn.layer setCornerRadius:10.0];
        
        self.stateBtn.enabled=NO;
//        self.stateBtn.alpha=0.4;
        self.jianBtn.enabled=NO;
//        self.jianBtn.alpha=0.4;
        self.jiaBtn.enabled=NO;
//        self.jiaBtn.alpha=0.4;
    }
    
    [self.stateBtn addTarget:self action:@selector(stateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.jianBtn addTarget:self action:@selector(jianBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.jiaBtn addTarget:self action:@selector(jiaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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

        //给后台发送勾选信息
        NSString * urlString =[HSGlobal selectCustUrl];
        NSMutableArray * mutArray = [NSMutableArray array];
        
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithLong:_data.skuId] forKey:@"skuId"];
        [myDict setObject:[NSNumber numberWithInteger:_data.cartId] forKey:@"cartId"];
        [myDict setObject:[NSNumber numberWithInteger:_data.amount] forKey:@"amount"];
        if([@"I" isEqualToString: _data.state]){//未选中
            [myDict setObject:@"G" forKey:@"state"];
        }else if([@"G" isEqualToString: _data.state]){//选中
            [myDict setObject:@"I" forKey:@"state"];
        }
        
        [myDict setObject:[NSNumber numberWithLong:_data.skuTypeId] forKey:@"skuTypeId"];
        [myDict setObject:_data.skuType forKey:@"skuType"];
        //未修改之前未勾选给后台传想要勾选
        if([@"I" isEqualToString: _data.state]){
            [myDict setObject:@"Y" forKey:@"orCheck"];
        }else if([@"G" isEqualToString: _data.state]){
            [myDict setObject:@"N" forKey:@"orCheck"];
        }
        
        [myDict setObject:[NSNumber numberWithInt:3] forKey:@"cartSource"];
        
        [mutArray addObject:myDict];
        
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
        [manager POST:urlString  parameters:mutArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            NSLog(@"message= %@",message);
            if(code == 200 ){
                if([@"I" isEqualToString: _data.state]){//未选中
                    _data.state = @"G";
                    [self.stateBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                }else if([@"G" isEqualToString: _data.state]){//选中
                    _data.state = @"I";
                    [self.stateBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
                }
                [self.delegate sendSelectData:_data];
                
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
        [self.delegate sendUpdateData:_data andJJFlag:@"jian"];
        
    }else{
        
        NSString * checkUrl = [HSGlobal checkAddCartAmount];
        
        AFHTTPRequestOperationManager * manager = [PublicMethod shareNoHeadRequestManager];
        
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithLong:_data.skuId] forKey:@"skuId"];
        [myDict setObject:[NSNumber numberWithInteger:_data.amount - 1] forKey:@"amount"];
        [myDict setObject:[NSNumber numberWithLong:_data.skuTypeId] forKey:@"skuTypeId"];
        [myDict setObject:_data.skuType forKey:@"skuType"];
        
        [manager POST:checkUrl  parameters:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [self.delegate sendUpdateData:_data andJJFlag:@"jia"];
        
    }else{

        NSString * checkUrl = [HSGlobal checkAddCartAmount];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareNoHeadRequestManager];
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithLong:_data.skuId] forKey:@"skuId"];
        [myDict setObject:[NSNumber numberWithInteger:_data.amount + 1] forKey:@"amount"];
        [myDict setObject:[NSNumber numberWithLong:_data.skuTypeId] forKey:@"skuTypeId"];
        [myDict setObject:_data.skuType forKey:@"skuType"];
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
        
        [manager POST:checkUrl  parameters:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
