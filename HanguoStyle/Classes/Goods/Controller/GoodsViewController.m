//
//  GoodsViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsPackData.h"
#import "GoodsPackCell.h"
#import "HeadView.h"
#import "GoodsShowViewController.h"
#import "GoodsDetailViewController.h"
#import "GGTabBarViewController.h"
#import "GoodsShowH5ViewController.h"
#import "PinGoodsDetailViewController.h"
#import "MessageViewController.h"
@interface GoodsViewController ()<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate,MBProgressHUDDelegate>
{
    NSArray *_imageUrls;
    NSInteger totalPageCount;
    NSInteger _cnt;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString * pushUrl;

@property (nonatomic,assign) NSInteger addon;

@end

@implementation GoodsViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //右侧按钮
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"messagebutton"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    
    
    _tableView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _addon = 1;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"GoodsPackCell" bundle:nil] forCellReuseIdentifier:@"GoodsPackCell"];
    [self footerRefresh];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.data = [NSMutableArray array];
    [self queryCustNum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadRootPage) name:@"ReloadRootPage" object:nil];
}
-(void)ReloadRootPage{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    _addon = 1;
    totalPageCount = 0;
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    [self footerRefresh];
}
//消息盒子
-(void)rightBarButton:(UIBarButtonItem *)bar
{
//    NSLog(@"消息盒子");
    MessageViewController * vc = [MessageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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


- (void)createHeadScrollView{
    
    _scrollArr = [_imageUrls mutableCopy];
    
    if(_scrollArr.count>1){
        
        
        NSMutableArray * imageArr = [NSMutableArray array];
        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, ((SliderData *)_scrollArr[0]).height *GGUISCREENWIDTH/((SliderData *)_scrollArr[0]).width)];
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
        
        hView.scrollView.scrollsToTop = NO;
        _tableView.tableHeaderView = hView;
    }else if(_scrollArr.count == 1){
        UIView * heView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH,  ((SliderData *)_scrollArr[0]).height *GGUISCREENWIDTH/((SliderData *)_scrollArr[0]).width)];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:heView.frame];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((SliderData *)_scrollArr[0]).url]];
        imv.image = [UIImage imageWithData:data];
        [heView addSubview: imv];
        _tableView.tableHeaderView = heView;
    }

    
    

}
- (void)didClickPage:(HeadView *)view atIndex:(NSInteger)index
{
    
    SliderData * sliderData = _imageUrls[index];
    if([sliderData.targetType isEqualToString:@"D"]){//跳到普通商品详情页
        self.hidesBottomBarWhenPushed=YES;
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = sliderData.itemTarget;
        [self.navigationController pushViewController:gdViewController animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else if([sliderData.targetType isEqualToString:@"P"]){//跳到拼购商品详情页
        self.hidesBottomBarWhenPushed=YES;
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = _pushUrl;
        [self.navigationController pushViewController:pinViewController animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else if([sliderData.targetType isEqualToString:@"T"]){//跳到列表页，后台控制不会跳到h5的列表页
        self.hidesBottomBarWhenPushed=YES;
        GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
        gsViewController.navigationItem.title = @"商品展示";
        //下个页面要跳转的url
        gsViewController.url = sliderData.itemTarget;
        [self.navigationController pushViewController:gsViewController animated:YES];
        self.hidesBottomBarWhenPushed=NO;
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
            
            if(_imageUrls==nil){
                _imageUrls = data.sliderArray;
                //headview
                [self createHeadScrollView];
            }
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsPackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPackCell" forIndexPath:indexPath];
    cell.data = self.data[indexPath.section];


    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ((ThemeData * )self.data[indexPath.section]).height*GGUISCREENWIDTH/((ThemeData * )self.data[indexPath.section]).width;
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
    _pushUrl =  ((ThemeData *)self.data[indexPath.section]).themeUrl;
    if([((ThemeData *)self.data[indexPath.section]).type isEqualToString:@"ordinary"]){
        [self pushGoodShowView];
    }else if([((ThemeData *)self.data[indexPath.section]).type isEqualToString:@"h5"]){
        [self pushH5GoodShowView];
    }
}
-(void)pushH5GoodShowView {
    GoodsShowH5ViewController * showContr = [[GoodsShowH5ViewController alloc]init];
    showContr.url = _pushUrl;
    [self.navigationController pushViewController:showContr animated:YES];
}
-(void)pushGoodShowView {

    GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
    gsViewController.navigationItem.title = @"商品展示";
    //下个页面要跳转的url
    gsViewController.url = _pushUrl;
    [self.navigationController pushViewController:gsViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backController{
    [self ReloadRootPage];
    [self queryCustNum];
}
@end
