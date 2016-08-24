//
//  GiftViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/8/23.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "GiftViewController.h"
#import "HeadView.h"
#import "GoodsShowViewController.h"
#import "GoodsDetailViewController.h"
#import "GGTabBarViewController.h"
#import "GoodsShowH5ViewController.h"
#import "PinGoodsDetailViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"

#import "KKGgoodsViewCell.h"
#import "KKGbutton.h"
#import "UIImage+GG.h"
@interface GiftViewController ()
{
    NSArray *_imageUrls;
    NSInteger totalPageCount;
    NSInteger _cnt;
    Boolean isMaxZero;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString * pushUrl;
@property (nonatomic,assign) NSInteger addon;
@end

@implementation GiftViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:GGMainColor] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:GGNavColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];//初始化图片视图控件
    imageView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    UIImage *image = [UIImage imageNamed:@"kakaogift_logo"];//初始化图像视图
    [imageView setImage:image];
    self.navigationItem.titleView = imageView;//设置导航栏的titleView为imageView
    
    
    _tableView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _addon = 1;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    //    [_tableView registerNib:[UINib nibWithNibName:@"GoodsPackCell" bundle:nil] forCellReuseIdentifier:@"GoodsPackCell"];
    [self footerRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.data = [NSMutableArray array];
    [self queryCustNum];
}
-(void)queryCustNum{
    
    BOOL isLogin = [PublicMethod checkLogin];
    
    if(!isLogin){
        FMDatabase * database = [PublicMethod shareDatabase];
        FMResultSet * rs = [database executeQuery:@"SELECT SUM(pid_amount) as amount FROM Shopping_Cart "];
        //购物车如果存在这件商品，就更新数量
        while ([rs next]){
            _cnt = [rs intForColumn:@"amount"] ;
            if (_cnt != 0) {
                
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_cnt],@"badgeValue", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];
            }
            
        }
    }else{
        NSString * url = [HSGlobal queryCustNum];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        if(manager == nil){
            NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
            noNetView.delegate = self;
            [self.view addSubview:noNetView];
            return;
        }
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            
            if(code == 200){
                
                _cnt = [[object objectForKey:@"cartNum"]integerValue];
                if (_cnt != 0) {
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_cnt],@"badgeValue", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }
}
- (void) footerRefresh
{
    if(_addon >= totalPageCount && totalPageCount != 0){
        [self.tableView.footer removeFromSuperview];
    }
    NSString * url = [HSGlobal goodsPackMoreUrl: _addon];
    _addon++;
    
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
        if(_addon == 2){
            [self.data removeAllObjects];
        }
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        GoodsPackData * data = [[GoodsPackData alloc] initWithJSONNode:object];
        if(data.code == 200){
            
            
            totalPageCount = data.pageCount;
            [self.data addObjectsFromArray:[data.themeArray mutableCopy]];

            [self.tableView reloadData];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = data.message;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * identID = @"KKGgoodsViewCell";
    KKGgoodsViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identID];
    if (cell == nil) {
        cell = [[KKGgoodsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identID];
    }
    
    [cell bindWithObject:(ThemeData * )self.data[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [KKGgoodsViewCell bindWithObjectHeigh:(ThemeData * )self.data[indexPath.row]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //进入到商品展示页面
    
    
    _pushUrl =  ((ThemeData *)self.data[indexPath.row]).themeUrl;
    if([((ThemeData *)self.data[indexPath.row]).type isEqualToString:@"ordinary"]){
        [self pushGoodShowView];
    }else if([((ThemeData *)self.data[indexPath.row]).type isEqualToString:@"h5"]){
        [self pushH5GoodShowView];
    }
    else if ([((ThemeData *)self.data[indexPath.row]).type isEqualToString:@"detail"])
    {
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = _pushUrl;
        [self.navigationController pushViewController:gdViewController animated:YES];
    }else if([((ThemeData *)self.data[indexPath.row]).type isEqualToString:@"pin"])
    {
        
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = _pushUrl;
        [self.navigationController pushViewController:pinViewController animated:YES];
        
    }
    
}
-(void)pushH5GoodShowView {
    GoodsShowH5ViewController * showContr = [[GoodsShowH5ViewController alloc]init];
    showContr.url = _pushUrl;
    [self.navigationController pushViewController:showContr animated:YES];
}
-(void)pushGoodShowView {
    
    GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
    //    gsViewController.navigationItem.title = @"商品展示";
    //下个页面要跳转的url
    gsViewController.url = _pushUrl;
    [self.navigationController pushViewController:gsViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
