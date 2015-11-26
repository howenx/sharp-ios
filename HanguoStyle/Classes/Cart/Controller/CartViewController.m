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
@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,CartCellDelegate>
{
    MBProgressHUD *HUD;
    BOOL isLogin;
    FMDatabase * database;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CartViewController
- (void)viewWillAppear:(BOOL)animated{
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
    
    database = [HSGlobal shareDatabase];
    isLogin = [HSGlobal checkLogin];
    isLogin = 0;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"CartCell" bundle:nil] forCellReuseIdentifier:@"CartCell"];
    self.data  = [NSMutableArray array];
    [self headerRefresh];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
}
- (void) headerRefresh
{
    //登陆状态
    if(isLogin){
        [self getDataWhenLogin];
    }else{
        [self getDataWhenNotLogin];
    }
}
-(void)getDataWhenLogin{

    NSString * url = [HSGlobal getCartUrl];
    NSLog(@"CartViewUrlLogin   ++++++++++++%@",url);
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        [self.data removeAllObjects];
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * dataArray = [object objectForKey:@"cartList"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"message= %@",message);
        
        for (id node in dataArray) {
            CartData * data = [[CartData alloc] initWithJSONNode:node];
            [self.data addObject:data];
        }
        if(self.data.count>0){
            [self updataCart:self.data];
        }
        [self.tableView reloadData];
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [HUD hide:YES];
        [HSGlobal printAlert:@"数据加载失败"];
        
    }];

}
-(void)getDataWhenNotLogin{
    
    //开始添加事务
    [database beginTransaction];
    
    FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
    NSMutableArray * mutArray = [NSMutableArray array];
    while ([rs next]){
        
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid"]] forKey:@"skuId"];
        [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"cart_id"]] forKey:@"cartId"];
        [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid_amount"]] forKey:@"amount"];
        [myDict setObject:[rs stringForColumn:@"state"] forKey:@"state"];
        [mutArray addObject:myDict];
        
    }
    
    //提交事务
    [database commit];
    
    
    if(mutArray.count >0){
        NSString * urlString =[HSGlobal getCartByPidUrl];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //此处设置后返回的默认是NSData的数据
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
//        NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
//        [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
        
        [manager POST:urlString  parameters:[mutArray copy] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            [self.tableView.header endRefreshing];
            [self.data removeAllObjects];
            NSArray * dataArray = [object objectForKey:@"cartList"];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"message= %@",message);

            NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
            for (id node in dataArray) {
                CartData * data = [[CartData alloc] initWithJSONNode:node];
                [self.data addObject:data];
            }
            if(self.data.count>0){
                [self updataCart:self.data];
            }
            [self.tableView reloadData];
            [HUD hide:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [HSGlobal printAlert:@"发送购物车数据失败"];
        }];
        
    }
    

}
-(void)updataCart :(NSArray *) array{

    
    
    [database beginTransaction];
    
    [database executeUpdate:@"DELETE FROM Shopping_Cart"];
    FMResultSet * rs1 = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
    NSLog(@"____________删除数据后start___________________");
    while ([rs1 next]){
        NSLog(@"pid=%d",[rs1 intForColumn:@"pid"]);
        NSLog(@"cart_id=%d",[rs1 intForColumn:@"cart_id"]);
        NSLog(@"pid_amount=%d",[rs1 intForColumn:@"pid_amount"]);
        NSLog(@"state=%@",[rs1 stringForColumn:@"state"]);
        
    }
    NSLog(@"____________删除数据后end___________________");
    NSString * sql = @"insert into Shopping_Cart (pid,cart_id,pid_amount,state) values (?,?,?,?)";
    
    for (int i=0; i<array.count; i++) {
        CartData * cData = array[i];
        [database executeUpdate:sql,[NSNumber numberWithLong:cData.skuId],[NSNumber numberWithLong:cData.cartId],[NSNumber numberWithLong:cData.amount],cData.state];
    }
    
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
    cell.delegate =self;
    cell.data = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到商品展示页面
    
//    _pushUrl = ((ThemeData *)self.data[indexPath.section]).themeUrl;
//    [self pushGoodShowView];
}


-(void)loadDataNotify{
    [self headerRefresh];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
