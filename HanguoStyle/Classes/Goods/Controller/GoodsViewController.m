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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
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
    _scrollArr = _imageUrls;
    NSMutableArray * imageArr = [NSMutableArray array];
    HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH/3.2)];
    hView.delegate = self;
    [hView shouldAutoShow:YES];
    for (int i = 0; i < _scrollArr.count; i++)
    {
        UIImageView *imv = [[UIImageView alloc] init];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_scrollArr[i]]];
        imv.image = [UIImage imageWithData:data];
        [imageArr addObject:imv];
    }
    hView.imageViewAry = imageArr;
    _tableView.tableHeaderView = hView;

}
- (void)didClickPage:(HeadView *)view atIndex:(NSInteger)index
{
    NSLog(@"点击滚动视图");
}
- (void) footerRefresh
{
    NSString * url = [HSGlobal goodsPackMoreUrl: _addon];
    _addon++;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.footer endRefreshing];
        
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if (!object) {
            return;
        }
        
        NSArray * dataArray = object[@"theme"];
        for (id node in dataArray) {
            GoodsPackData * data = [[GoodsPackData alloc] initWithJSONNode:node];
            [self.data addObject:data];
        }
        if(_imageUrls==nil){
            _imageUrls = object[@"slider"];
            //headview
            [self createHeadScrollView];
        }
        [self.tableView reloadData];
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        NSLog(@"Append Data Error");
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

    return GGUISCREENHEIGHT/4.4;//这个4.4 是因为后台传过来图片高度和宽度比例是300：730=0.41，然后0.41*iphone6屏幕宽度375（ip6和ip5的屏幕比例是差不多的，是1.775）等于153，再用ip6屏幕高度667/153= 4.4。
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
    
    _pushUrl = ((GoodsPackData *)self.data[indexPath.section]).themeUrl;
    [self pushGoodShowView];
}
-(void)pushGoodShowView {
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.navigationController.view addSubview:HUD];
//    
//    HUD.delegate = self;
//    HUD.labelText = @"Loading";
//    
//    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self myTask];
}
-(void)myTask {
    GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
    gsViewController.navigationItem.title = @"商品展示";
    //下个页面要跳转的url
    gsViewController.url = _pushUrl;
    [self.navigationController pushViewController:gsViewController animated:YES];
//    sleep(2);
    
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
