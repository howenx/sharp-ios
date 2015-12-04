//
//  GoodsViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "HSGlobal.h"
#import "GoodsPackData.h"
#import "GoodsPackCell.h"
#import "HeadView.h"
#import "GoodsShowViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
@interface GoodsViewController ()<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate,MBProgressHUDDelegate>
{
    NSArray *_imageUrls;

    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic)  UIScrollView *headScrollView;
@property (weak, nonatomic)  UIPageControl *pageControl;
@property (nonatomic,strong) NSString * pushUrl;

@property (nonatomic,assign) NSInteger addon;

@end

@implementation GoodsViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    HUD = [HSGlobal getHUD:self];
    [HUD show:YES];
    _addon = 1;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"GoodsPackCell" bundle:nil] forCellReuseIdentifier:@"GoodsPackCell"];
    [self footerRefresh];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.data = [NSMutableArray array];
}

- (void)createHeadScrollView{
    
    _scrollArr = [_imageUrls mutableCopy];
    
    if(_scrollArr.count>1){
        NSMutableArray * imageArr = [NSMutableArray array];
        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH/3.2)];
        hView.delegate = self;
        [hView shouldAutoShow:YES];
        for (int i = 0; i < _scrollArr.count; i++)
        {
            UIImageView *imv = [[UIImageView alloc] init];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((SliderData *)_scrollArr[i]).url]];
            imv.image = [UIImage imageWithData:data];
            [imageArr addObject:imv];
        }
        hView.imageViewAry = imageArr;
        _tableView.tableHeaderView = hView;
    }else if(_scrollArr.count == 1){
        UIView * heView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH/3.2)];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:heView.frame];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((SliderData *)_scrollArr[0]).url]];
        imv.image = [UIImage imageWithData:data];
        [heView addSubview: imv];
        _tableView.tableHeaderView = heView;
    }

    
    

}
- (void)didClickPage:(HeadView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击滚动视图");
}
- (void) footerRefresh
{
    NSString * url = [HSGlobal goodsPackMoreUrl: _addon];
    _addon++;
    
    AFHTTPRequestOperationManager * manager = [HSGlobal shareRequestManager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.footer endRefreshing];
        
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if (!object) {
            return;
        }
        GoodsPackData * data = [[GoodsPackData alloc] initWithJSONNode:object];
        [self.data addObjectsFromArray:[data.themeArray mutableCopy]];
//        self.data = [data.themeArray mutableCopy];
//        NSArray * dataArray = object[@"theme"];
//        for (id node in dataArray) {
//            GoodsPackData * data = [[GoodsPackData alloc] initWithJSONNode:node];
//            [self.data addObject:data];
//        }
        if(_imageUrls==nil){
            _imageUrls = data.sliderArray;
            //headview
            [self createHeadScrollView];
        }
        [self.tableView reloadData];
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        [HUD hide:YES];
        [HSGlobal printAlert:@"数据加载失败"];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsPackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPackCell" forIndexPath:indexPath];
    cell.data = self.data[indexPath.section];


    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return (GGUISCREENWIDTH-10)/2.43;//因为后台传过来图片宽度和高度比例是730：300=2.43, 10是屏幕两边各有5个像素的宽度
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =  GGColor(240, 240, 240);
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到商品展示页面
    
    _pushUrl =  ((ThemeData *)self.data[indexPath.section]).themeUrl;
    [self pushGoodShowView];
}
-(void)pushGoodShowView {

    GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
    gsViewController.navigationItem.title = @"商品展示";
    //下个页面要跳转的url
    gsViewController.url = _pushUrl;
    [self.navigationController pushViewController:gsViewController animated:YES];
}

// 判断是否联网
-(BOOL)isConnectNetWork{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            NSLog(@"正在使用wifi网络");
            break;
    }
    return isExistenceNetwork;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
