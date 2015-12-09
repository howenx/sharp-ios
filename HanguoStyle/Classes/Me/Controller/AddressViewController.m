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
#import "AddressCell.h"
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{

    MBProgressHUD * HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray * data;
@end

@implementation AddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [self headerRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"收货地址";
    
    HUD = [HSGlobal getHUD:self];
    [HUD show:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        NSLog(@"%@",object);
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = self.data[indexPath.row];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到商品展示页面
    AppendAddrViewController * gsViewController = [[AppendAddrViewController alloc]init];
    gsViewController.data =self.data[indexPath.row];
    [self.navigationController pushViewController:gsViewController animated:YES];
    

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AddressData * data1 = self.data[indexPath.row];
        
        
        NSMutableDictionary * myDict = [NSMutableDictionary dictionary];
        [myDict setObject:data1.addId  forKey:@"addId"];
        if(data1.orDefault){
            [myDict setObject:@(true) forKey:@"orDefault"];
        }else{
            [myDict setObject:@(false) forKey:@"orDefault"];
        }

        NSString * url = [HSGlobal delAddressInfo];
        
        AFHTTPRequestOperationManager * manager = [HSGlobal shareRequestManager];
        [manager POST:url parameters:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"message = %@",message);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            //    hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            if(200 == code){
                hud.labelText = @"删除成功";
                [self.data removeObjectAtIndex:[indexPath row]];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
            }else{
                hud.labelText = @"删除失败";
                [hud hide:YES afterDelay:1];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HSGlobal printAlert:@"删除失败"];
            
        }];
        
        
    }
}

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
