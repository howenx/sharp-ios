//
//  AddressViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/22.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AddressViewController.h"
#import "AppendAddrViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "HSGlobal.h"
#import "MBProgressHUD.h"
#import "AddressData.h"
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{

    MBProgressHUD * HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray * data;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"收货地址";
    
    HUD = [HSGlobal getHUD:self];
    [HUD show:YES];
    [_tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"AddressCell"];
    self.data = [NSMutableArray array];
    [self headerRefresh];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];

    
    //右上角添加按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addAddress)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)addAddress{
    AppendAddrViewController * aaViewController = [[AppendAddrViewController alloc]init];
    [self.navigationController pushViewController:aaViewController animated:YES];
}
- (void) headerRefresh
{
    NSString * url = [HSGlobal getAddressListInfo];
    
    AFHTTPRequestOperationManager * manager = [HSGlobal shareRequestManager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        [self.data removeAllObjects];
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * dataArray = [object objectForKey:@"address"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if(200 == code){
            for (id node in dataArray) {
                AddressData * data = [[AddressData alloc] initWithJSONNode:node];
                [self.data addObject:data];
            }
            [self.tableView reloadData];

        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            //    hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            hud.labelText = @"获取失败";
            [hud hide:YES afterDelay:1];
        }
        
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [HUD hide:YES];
        [HSGlobal printAlert:@"数据加载失败"];
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    GoodsPackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPackCell" forIndexPath:indexPath];
//    cell.data = self.data[indexPath.section];
//    
//    
//    return cell;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (GGUISCREENWIDTH-10)/2.43;//因为后台传过来图片宽度和高度比例是730：300=2.43, 10是屏幕两边各有5个像素的宽度
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //进入到商品展示页面
//    
//    NSString * _pushUrl =  ((ThemeData *)self.data[indexPath.section]).themeUrl;
//    [self pushGoodShowView];
//}
//-(void)pushGoodShowView {
//    
//    GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
//    gsViewController.navigationItem.title = @"商品展示";
//    //下个页面要跳转的url
//    gsViewController.url = _pushUrl;
//    [self.navigationController pushViewController:gsViewController animated:YES];
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSLog(@"%d", indexPath.row);
//        //        [self.myArray removeObjectAtIndex:[indexPath row]];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
