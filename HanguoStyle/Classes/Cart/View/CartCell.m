//
//  CartCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CartCell.h"
#import "UIImageView+WebCache.h"
#import "HSGlobal.h"
#import "ShoppingCart.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@implementation CartCell
{
    CartData * cartData;
    BOOL isLogin;
    FMDatabase *database;
    
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setData:(CartData *)data{
    database = [HSGlobal shareDatabase];
    isLogin = [HSGlobal checkLogin];
//    isLogin = 0;
    cartData = data;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:data.invImg]];
    self.title.text = data.invTitle;
    self.price.text = [NSString stringWithFormat:@"￥%.2f",data.itemPrice];
    if([@"I" isEqualToString: data.state]){//未选中
        [self.stateBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }else if([@"G" isEqualToString: data.state]){//选中
        [self.stateBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else if([@"S" isEqualToString: data.state]){
        [self.stateBtn setTitle:@"失效" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundColor:[UIColor grayColor]];
        self.stateBtn.enabled=NO;
        self.stateBtn.alpha=0.4;
        self.jianBtn.enabled=NO;
        self.jianBtn.alpha=0.4;
        self.jiaBtn.enabled=NO;
        self.jiaBtn.alpha=0.4;
    }
    if(data.amount == 1){
        self.jianBtn.enabled=NO;
        self.jianBtn.alpha=0.4;
    }else{
        self.jianBtn.enabled=YES;
        self.jianBtn.alpha=1;
    }
    [self.stateBtn addTarget:self action:@selector(stateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.jianBtn addTarget:self action:@selector(jianBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.jiaBtn addTarget:self action:@selector(jiaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.amountLab.text = [NSString stringWithFormat:@"%ld",(long)data.amount];

}

//未登录状态下做选中或者修改或者删除操作只操作本地数据库，然后再次请求后台传过的data刷新页面

//登陆状态下做选中或者修改或者删除操作，发给后台一条数据，用后台再次传过的data刷新页面。
- (void) stateBtnClicked: (UIButton *) button
{
    //登陆状态
    if(isLogin){
        CartData * data  = [CartData new];
        data =cartData;
        if([@"I" isEqualToString: data.state]){//未选中
            data.state = @"G";
        }else if([@"G" isEqualToString: data.state]){//选中
            data.state = @"I";
        }
        [self.delegate sendUpdateData:data];
    }else{
        
        ShoppingCart * sc = [[ShoppingCart alloc]init];
        if([@"I" isEqualToString: cartData.state]){//未选中
            sc.state = @"G";
        }else if([@"G" isEqualToString: cartData.state]){//选中
            sc.state = @"I";
        }
        sc.pid = cartData.skuId;
        sc.cartId = cartData.cartId;
        sc.amount = cartData.amount;
        [self updataCart:sc];
        [self.delegate loadDataNotify];
    }
}
- (void) jianBtnClicked: (UIButton *) button
{
    //登陆状态
    if(isLogin){
        
        CartData * data  = [CartData new];
        data =cartData;
        data.amount = data.amount-1;
        [self.delegate sendUpdateData:data];
        
    }else{
        ShoppingCart * sc = [[ShoppingCart alloc]init];
        sc.pid = cartData.skuId;
        sc.cartId = cartData.cartId;
        sc.amount = cartData.amount - 1;
        sc.state = cartData.state;
        [self updataCart:sc];
        [self.delegate loadDataNotify];
    }
}
- (void) jiaBtnClicked: (UIButton *) button
{
    //登陆状态
    if(isLogin){
        
        CartData * data  = [CartData new];
        data =cartData;
        data.amount = data.amount+1;
        [self.delegate sendUpdateData:data];
        
    }else{
        ShoppingCart * sc = [[ShoppingCart alloc]init];
        sc.pid = cartData.skuId;
        sc.cartId = cartData.cartId;
        sc.amount = cartData.amount + 1;
        sc.state = cartData.state;
        [self updataCart:sc];
        [self.delegate loadDataNotify];
    }
}


- (void) delBtnClicked: (UIButton *) button
{
    //登陆状态
    if(isLogin){
        [self.delegate sendDelUrl:cartData.cartDelUrl];
    }else{
        [self delCart:cartData.skuId];
        [self.delegate loadDataNotify];
    }
}
-(void)delCart :(NSInteger) pid{
    [database beginTransaction];
    [database executeUpdate:@"DELETE FROM Shopping_Cart WHERE pid =?",[NSNumber numberWithLong:pid]];
    [database commit];
}
-(void)updataCart :(ShoppingCart *) shopCart{
    
    [database beginTransaction];
    [database executeUpdate:@"UPDATE Shopping_Cart SET pid_amount = ? ,state = ? WHERE pid = ?",[NSNumber numberWithLong:shopCart.amount],shopCart.state,[NSNumber numberWithLong:shopCart.pid]];


    FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
    while ([rs next]){
        NSLog(@"____________后台获取数据start___________________");
        NSLog(@"pid=%d",[rs intForColumn:@"pid"]);
        NSLog(@"cart_id=%d",[rs intForColumn:@"cart_id"]);
        NSLog(@"pid_amount=%d",[rs intForColumn:@"pid_amount"]);
        NSLog(@"state=%@",[rs stringForColumn:@"state"]);
    }
    NSLog(@"____________后台获取数据end___________________");
    
    //提交事务
    [database commit];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
