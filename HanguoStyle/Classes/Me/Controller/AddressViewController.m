//
//  AddressViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/22.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "AddressViewController.h"
#import "AppendAddrViewController.h"
#import "AddressCell.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,AddressCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray * data;
@property (nonatomic) UIView * bgView;
@end

@implementation AddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [self headerRefresh];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.scrollsToTop = YES;
    self.navigationItem.title=@"收货地址";
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"AddressCell"];
    self.data = [NSMutableArray array];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self createNoAddressView];
    
    //右上角添加按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGB(0x242424) forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addAddress)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
}
-(void)createNoAddressView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _bgView.backgroundColor = GGBgColor;
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH -162)/2, GGUISCREENHEIGHT/8, 162, 190)];
    bgImageView.image = [UIImage imageNamed:@"no_address"];
    [_bgView addSubview:bgImageView];
    [self.view addSubview:_bgView];
    _bgView.hidden = YES;
}

-(void)addAddress{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    AppendAddrViewController * aaViewController = [[AppendAddrViewController alloc]init];
    [self.navigationController pushViewController:aaViewController animated:YES];
}
- (void) headerRefresh
{
    NSString * url = [HSGlobal getAddressListInfo];
    
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }

    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        [self.data removeAllObjects];
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",object);
        NSArray * dataArray = [object objectForKey:@"address"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if(200 == code || 1005 == code){//1005是没有数据的时候返回的
            for (id node in dataArray) {
                AddressData * data = [[AddressData alloc] initWithJSONNode:node];

                if(self.addId != nil && [self.addId isEqualToString:data.addId]){
                    data.isOrderDefault = YES;
                }
                [self.data addObject:data];
            }
            if(self.data.count == 0){
                _bgView.hidden = NO;
            }else{
                _bgView.hidden = YES;
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
        
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
    cell.delegate =self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([@"order" isEqualToString:self.comeFrom]){
        cell.comeFrom = self.comeFrom;
    }
    cell.data = self.data[indexPath.row];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    if([@"order" isEqualToString:self.comeFrom]){
        
        [self.delegate backAddressData:self.data[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(((AddressData *)_data[indexPath.row]).isOrderDefault){
        return NO;
    }else{
        return YES;
    }
    
}
//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(![PublicMethod isConnectionAvailable]){
            return;
        }
        AddressData * data1 = self.data[indexPath.row];
        
        
        NSMutableDictionary * myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithFloat:[data1.addId floatValue]] forKey:@"addId"];
        if(data1.orDefault){
            [myDict setObject:@(true) forKey:@"orDefault"];
        }else{
            [myDict setObject:@(false) forKey:@"orDefault"];
        }

        NSString * url = [HSGlobal delAddressInfo];
        
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        if(manager == nil){
            NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
            noNetView.delegate = self;
            [self.view addSubview:noNetView];
            return;
        }
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
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
                [hud hide:YES afterDelay:1];
                [self.data removeObjectAtIndex:[indexPath row]];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                if(self.data.count == 0){
                    _bgView.hidden = NO;
                }else{
                    _bgView.hidden = YES;
                }
            }else{
                hud.labelText = @"删除失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"删除失败"];
            
        }];
        
        
    }
}

-(void)updateAddr:(AddressData *)data{

    AppendAddrViewController * gsViewController = [[AppendAddrViewController alloc]init];
    gsViewController.data = data;
    [self.navigationController pushViewController:gsViewController animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)backController{
    [self headerRefresh];
}


@end
