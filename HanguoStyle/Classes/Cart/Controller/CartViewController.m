//
//  CartViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CartViewController.h"
#import "MBProgressHUD.h"
#import "CartCell.h"
#import "CartData.h"
#import "MJRefresh.h"
#import "HSGlobal.h"
#import "AFNetworking.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "GoodsDetailViewController.h"
#import "LoginViewController.h"
@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,CartCellDelegate>
{
    MBProgressHUD *HUD;
    BOOL isLogin;
    FMDatabase * database;
    BOOL isSelectAll;
    NSMutableArray * sArray;//存放失效状态的数据
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
- (IBAction)allSelectBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *realityPay;
@property (weak, nonatomic) IBOutlet UILabel *save;
- (IBAction)settlementBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *footView;

@end

@implementation CartViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    [self headerRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc]  initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    self.navigationItem.title = @"购物车";
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    self.hidesBottomBarWhenPushed=NO;
    sArray = [NSMutableArray array];
    isLogin = [HSGlobal checkLogin];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"CartCell" bundle:nil] forCellReuseIdentifier:@"CartCell"];
    self.data  = [NSMutableArray array];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
}

-(void)headerRefresh{
    
    NSMutableArray *mutArray = [NSMutableArray array];
    for (int i=0; i<sArray.count; i++){
        CartDetailData * cdData = sArray[i];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithLong:cdData.skuId] forKey:@"skuId"];
        [dict setObject:[NSNumber numberWithLong:cdData.cartId] forKey:@"cartId"];
        [dict setObject:[NSNumber numberWithLong:cdData.amount] forKey:@"amount"];
        [dict setObject:@"N" forKey:@"state"];//把失效状态的数据变成删除状态，发给后台，他再也不给发回来了
        
        [mutArray addObject:dict];
        
    }
    [sArray removeAllObjects];
    
    //未登陆时从数据库获取数据
    if (!isLogin) {
        
        FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
        while ([rs next]){
            
            NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
            [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid"]] forKey:@"skuId"];
            [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"cart_id"]] forKey:@"cartId"];
            [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid_amount"]] forKey:@"amount"];
            [myDict setObject:[rs stringForColumn:@"state"] forKey:@"state"];
            [mutArray addObject:myDict];
        }
    }
    
    [self requestData:[mutArray copy]];
}


-(void)requestData:(NSArray *) array{
   
    NSString * urlString;
    AFHTTPRequestOperationManager *manager = nil;
    //此处设置后返回的默认是NSData的数据
    
    if(isLogin){
        manager = [HSGlobal shareRequestManager];
        urlString =[HSGlobal sendCartUrl];
    }else{
        manager = [HSGlobal shareNoHeadRequestManager];
        urlString =[HSGlobal getCartByPidUrl];
    }

    
    if(array.count <=0){
        array = nil;
    }
    [manager POST:urlString  parameters:array success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        [self.tableView.header endRefreshing];
        [self.data removeAllObjects];
        NSArray * dataArray = [object objectForKey:@"cartList"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
        if(code ==200){
            for (id node in dataArray) {
                CartData * data = [[CartData alloc] initWithJSONNode:node];
                [self.data addObject:data];
            }
            if(_data.count > 0){
                [self updateOtherMessage:_data];
            }else{
                [self.footView setHidden:YES];
            }
            [self.tableView reloadData];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"库存不足";
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            //    hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [HUD hide:YES];
        [self.footView setHidden:YES];
        [HSGlobal printAlert:@"请求购物车数据失败"];
    }];
}

-(void)updateOtherMessage :(NSArray *) array{

    for (int i=0; i<array.count; i++) {
        CartData * cData = array[i];
        for(int j=0; j < cData.cartDetailArray.count; j++){
            CartDetailData * cdData = cData.cartDetailArray[j];
            if([@"S" isEqualToString: cdData.state]){
                [sArray addObject:cData];
            }
        }
    }
    
    
    
    
//    NSInteger gCartAmount = 0;//勾选的商品种类数量
//    NSInteger iCartAmount = 0;//未勾选的商品种类数量
//    NSInteger sCartAmount = 0;//失效商品种类数量
//    NSInteger gCount = 0;//所有商品件数
//    float money =0;
//    for (int i=0; i<array.count; i++) {
//        CartData * cData = array[i];
//        if([@"G" isEqualToString: cData.state]){
//            gCount = gCount + cData.amount;
//            money = money + cData.amount * cData.itemPrice;
//            gCartAmount = gCartAmount+1;
//        }else if([@"I" isEqualToString: cData.state]){
//            iCartAmount = iCartAmount+1;
//        }
//        else if([@"S" isEqualToString: cData.state]){
//            sCartAmount= sCartAmount+1;
//            [sArray addObject:cData];
//        }
//    }
//    
//
//    
//    self.goodsCount.text = [NSString stringWithFormat:@"商品数量:%ld",(long)gCount];
//    
//    self.totalAmount.text = [NSString stringWithFormat:@"￥%.2f",money];
//    
//    self.realityPay.text = [NSString stringWithFormat:@"应付:￥%.2f",money];
//    
//    self.save.text = [NSString stringWithFormat:@"以节省:￥0"];
//    if( gCartAmount + sCartAmount == array.count){
//        [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//        isSelectAll = true;
//    }else {
//        [self.selectBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//        isSelectAll = false;
//    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 20)];
    view.backgroundColor = GGColor(254, 99, 108);
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:3.0];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 20)];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.text = ((CartData *)_data[section]).invArea;
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((CartData *)_data[section]).cartDetailArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
    cell.delegate =self;
    cell.data = (CartDetailData *)((CartData *)_data[indexPath.section]).cartDetailArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString * _pushUrl = ((SizeData *)((CartData *)_data[indexPath.section]).cartDetailArray[indexPath.row]).invUrl;
    //进入到商品展示页面
    self.hidesBottomBarWhenPushed=YES;
    GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
    gdViewController.isFromCart = YES;
    gdViewController.url = _pushUrl;
    [self.navigationController pushViewController:gdViewController animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}


-(void)loadDataNotify{
    [self headerRefresh];
}
-(void)sendUpdateData:(CartDetailData *)data{
    
    NSMutableArray * mutArray = [NSMutableArray array];
    
    NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
    [myDict setObject:[NSNumber numberWithLong:data.skuId] forKey:@"skuId"];
    [myDict setObject:[NSNumber numberWithLong:data.cartId] forKey:@"cartId"];
    [myDict setObject:[NSNumber numberWithLong:data.amount] forKey:@"amount"];
    [myDict setObject:data.state forKey:@"state"];
    [mutArray addObject:myDict];

    for (int i=0; i<sArray.count; i++){
        CartDetailData * cData = sArray[i];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithLong:cData.skuId] forKey:@"skuId"];
        [dict setObject:[NSNumber numberWithLong:cData.cartId] forKey:@"cartId"];
        [dict setObject:[NSNumber numberWithLong:cData.amount] forKey:@"amount"];
        [dict setObject:@"N" forKey:@"state"];//把失效状态的数据变成删除状态，发给后台，他再也不给发回来了

        [mutArray addObject:dict];
        
    }
    [sArray removeAllObjects];
    [self requestData:[mutArray copy]];
}

-(void)sendDelUrl:(NSString *)url{

    AFHTTPRequestOperationManager *manager = [HSGlobal shareRequestManager];
  
    [manager GET:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"message= %@",message);
        [self headerRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [HSGlobal printAlert:@"删除数据失败"];
    }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)allSelectBtn:(UIButton *)sender {
//    isSelectAll=!isSelectAll;
//    if(isLogin){
//        NSMutableArray * mutArray = [NSMutableArray array];
//        for (int i = 0; i < _data.count; i++) {
//            NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
//            [myDict setObject:[NSNumber numberWithLong:((CartData *)_data[i]).skuId] forKey:@"skuId"];
//            [myDict setObject:[NSNumber numberWithLong:((CartData *)_data[i]).cartId] forKey:@"cartId"];
//            [myDict setObject:[NSNumber numberWithLong:((CartData *)_data[i]).amount] forKey:@"amount"];
//            if(isSelectAll && ![@"S" isEqualToString:((CartData *)_data[i]).state]){
//                [myDict setObject:@"G" forKey:@"state"];
//            }else if(!isSelectAll  && ![@"S" isEqualToString:((CartData *)_data[i]).state]){
//                [myDict setObject:@"I" forKey:@"state"];
//            }else{
//                [myDict setObject:((CartData *)_data[i]).state forKey:@"state"];
//            }
//            [mutArray addObject:myDict];
//            [sArray removeAllObjects];
//            [self requestData:[mutArray copy]];
//        }
//    }else{
//        [database beginTransaction];
//        if(isSelectAll){
//            [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//            [database executeUpdate:@"UPDATE Shopping_Cart SET state = ? WHERE state = ?",@"G",@"I"];
//        }else{
//            [self.selectBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
//            [database executeUpdate:@"UPDATE Shopping_Cart SET state = ? WHERE state = ?",@"I",@"G"];
//        }
//        [database commit];
//        [self headerRefresh];
//    }
//
    
    
}
//去结算
- (IBAction)settlementBtn:(UIButton *)sender {
    if(!isLogin){
        self.hidesBottomBarWhenPushed=YES;
        LoginViewController * login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}
@end
