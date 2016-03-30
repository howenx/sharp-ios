//
//  CollectViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/25.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectData.h"
#import "CollectCell.h"
#import "GoodsDetailViewController.h"
#import "PinGoodsDetailViewController.h"
@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel * emptyLab;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    _tableView.scrollsToTop = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"我的收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"CollectCell"];
    
    self.data  = [NSMutableArray array];
    [self headerRefresh];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    emptyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT/2, GGUISCREENWIDTH, 40)];
    emptyLab.textAlignment = NSTextAlignmentCenter;
    emptyLab.textColor = [UIColor grayColor];
    emptyLab.font = [UIFont systemFontOfSize:15];
    emptyLab.text =@"暂无收藏商品";
    [self.view addSubview:emptyLab];
    emptyLab.hidden = YES;
}
-(void)headerRefresh{
    

    NSString * url = [HSGlobal collectListUrl];
    
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
        [self.tableView.footer endRefreshing];
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        
        if(code == 200){
            NSArray * dataArray = [object objectForKey:@"collectList"];
            
            for (id node in dataArray) {
                CollectData * data = [[CollectData alloc] initWithJSONNode:node];
                [self.data addObject:data];
            }
            if(self.data.count == 0){
                emptyLab.hidden = NO;
            }else{
                emptyLab.hidden = YES;
            }
            [self.tableView reloadData];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = self.data[indexPath.section];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =  GGColor(240, 240, 240);
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到商品展示页面

    CollectData* collectData =_data[indexPath.section];
    if ([@"pin" isEqualToString:collectData.skuType]) {
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = collectData.invUrl;
        [self.navigationController pushViewController:pinViewController animated:YES];
    }else{
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = collectData.invUrl;
        [self.navigationController pushViewController:gdViewController animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(![PublicMethod isConnectionAvailable]){
            return;
        }
        CollectData* collectData =_data[indexPath.section];
        NSString * urlString = [NSString stringWithFormat:@"%@%ld",[HSGlobal unCollectUrl],collectData.collectId];
        
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
        AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //转换为词典数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            if(200 == code){
                hud.labelText = @"取消收藏成功";
                [hud hide:YES afterDelay:1];
                [self.data removeObjectAtIndex:[indexPath section]];
                NSLog(@"%d",[indexPath section]);
                NSLog(@"%d",[indexPath row]);

                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                if(self.data.count == 0){
                    emptyLab.hidden = NO;
                }else{
                    emptyLab.hidden = YES;
                }
            }else{
                hud.labelText = @"取消收藏失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"取消收藏失败"];
            
        }];
        
        
    }
}


-(void)backController{
    [self headerRefresh];
}

@end
