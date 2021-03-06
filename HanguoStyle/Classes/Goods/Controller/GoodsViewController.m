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
#import "LoginViewController.h"

#import "KKGgoodsViewCell.h"
#import "KKGbutton.h"
#import "UIImage+GG.h"
#import "NewGoodsShowViewController.h"
#import "HMMRefreshHeader.h"
#import "HMMRefreshAutoGifFooter.h"
#define  BUTTONHigh 180

@interface GoodsViewController ()<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate,MBProgressHUDDelegate>
{
    NSArray *_imageUrls;
    NSInteger totalPageCount;
    NSInteger _cnt;
    Boolean isMaxZero;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString * pushUrl;
@property (nonatomic,strong) UIView * nothingView;

@property (nonatomic,assign) NSInteger addon;

@end

@implementation GoodsViewController
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

//       [self backTopButton];
    
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
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(ReloadRootPage)];
//    self.tableView.mj_footer = [HMMRefreshAutoGifFooter footerWithRefreshingBlock:^{
//        [self footerRefresh];
//    }];
    self.tableView.mj_header = [HMMRefreshHeader headerWithRefreshingBlock:^{
        [self ReloadRootPage];
    } ];
    self.data = [NSMutableArray array];
    [self queryCustNum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadRootPage) name:@"ReloadRootPage" object:nil];
}

-(void)ReloadRootPage{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
//    self.tableView.mj_footer = [HMMRefreshAutoGifFooter footerWithRefreshingBlock:^{
//        [self footerRefresh];
//    }];
    _addon = 1;
    totalPageCount = 0;
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.tableFooterView = nil;
    [self.nothingView removeFromSuperview];
    [self footerRefresh];
}
//消息盒子
-(void)rightBarButton:(UIBarButtonItem *)bar
{
    BOOL isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        LoginViewController * login = [[LoginViewController alloc]init];
        login.comeFrom = @"GoodsVC";
        [self.navigationController pushViewController:login animated:NO];
        
    }else
    {
        MessageViewController * vc = [MessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
        [vc setSelectButtonBlock:^(NSString * str) {
            NSString * url = [HSGlobal goodsPackMoreUrl: _addon];
            AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                GoodsPackData * data = [[GoodsPackData alloc] initWithJSONNode:object];
                if(data.code == 200){
                    
                    if ([[object objectForKey:@"msgRemind"] integerValue]>0) {
                        isMaxZero = YES;
                        
                        //右侧按钮
                        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"messagebutton2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton:)];
                        self.navigationItem.rightBarButtonItem = anotherButton;
                        
                    }else
                    {
                        isMaxZero = NO;
                        //右侧按钮
                        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"messagebutton"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton:)];
                        self.navigationItem.rightBarButtonItem = anotherButton;
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];

        }];
    }
    
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


-(void)backTopButton
{
    UIButton * butn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-180, 40, 40)];
    butn.backgroundColor = [UIColor redColor];
    [butn addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view bringSubviewToFront:butn];
    [self.view insertSubview:butn atIndex:99];
}
-(void)backTop
{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)createHeadScrollView{
    
    _scrollArr = [_imageUrls mutableCopy];
    
    if(_scrollArr.count>1){
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH*105/375 + BUTTONHigh+5)];
        bgView.backgroundColor = GGBgColor;
        
        NSMutableArray * imageArr = [NSMutableArray array];
        HeadView * hView = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENWIDTH*105/375)];
        hView.delegate = self;
        [hView shouldAutoShow:YES];
        for (int i = 0; i < _scrollArr.count; i++)
        {
            UIImageView *imv = [[UIImageView alloc] init];
            if(![NSString isNSNull:((SliderData *)_scrollArr[i]).url]){
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((SliderData *)_scrollArr[i]).url]];
                imv.image = [UIImage imageWithData:data];
            }
            [imageArr addObject:imv];
        }
        hView.imageViewAry = imageArr;
        hView.scrollView.scrollsToTop = NO;
        [bgView addSubview:hView];
        
        UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(hView, 10), GGUISCREENWIDTH, BUTTONHigh-15)];
        downView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:downView];
        
        

        int totalloc=4;
        CGFloat marginW = 0;
        CGFloat appvieww=(SCREEN_WIDTH - (totalloc+1)*marginW)/totalloc;
        CGFloat appviewh=70;
        CGFloat marginH = 10;
        
        NSUInteger count=self.sliderNavData.count;
        
        for (int i=0; i<count; i++) {
            int row=i/totalloc;//行号
            int loc=i%totalloc;//列号
            
            
            
            KKGbutton * Btn = [[KKGbutton alloc]initWithFrame:CGRectZero fontSize:12 imageAndTitleSpaceing:2 baifenbi:0.6];
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((SliderNavData *)self.sliderNavData[i]).url]];
            [Btn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            
            [Btn setTitle:((SliderNavData *)self.sliderNavData[i]).navText forState:UIControlStateNormal];
            
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            Btn.titleLabel.font = [UIFont systemFontOfSize:10];
            Btn.tag = i;
            Btn.width = appvieww;//设置按钮坐标及大小
            Btn.height = appviewh;
            Btn.x = loc*(appvieww+marginW)+marginW;
            Btn.y = floor(row)*(appviewh+marginH)+marginH;
            
            [Btn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [downView addSubview:Btn];
            
        }
    
        
        
        UIView * rowView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 0.5)];
        rowView1.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.06];
        [downView addSubview:rowView1];

        //线
        UIView * rowView2 = [[UIView alloc]initWithFrame:CGRectMake(0, (BUTTONHigh-15)/2, GGUISCREENWIDTH, 0.5)];
        rowView2.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.06];
        [downView addSubview:rowView2];
        
        UIView * rowView3 = [[UIView alloc]initWithFrame:CGRectMake(0, BUTTONHigh-15-0.5, GGUISCREENWIDTH, 0.5)];
        rowView3.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.06];
        [downView addSubview:rowView3];
        
        //竖着3根线
        
        UIView * locView1 = [[UIView alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH/4)-0.5, 0, 0.5, BUTTONHigh-15)];
        locView1.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.06];
        [downView addSubview:locView1];
        
        
        UIView * locView2 = [[UIView alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH/4)*2, 0, 0.5, BUTTONHigh-15)];
        locView2.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.06];
        
        [downView addSubview:locView2];
        
        UIView * locView3 = [[UIView alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH/4)*3, 0, 0.5, BUTTONHigh-15)];
        locView3.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.06];
        [downView addSubview:locView3];

        _tableView.tableHeaderView = bgView;
    }else if(_scrollArr.count == 1){
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 120 + BUTTONHigh)];
        bgView.backgroundColor = GGBgColor;
        
        UIView * heView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH,  120)];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:heView.frame];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((SliderData *)_scrollArr[0]).url]];
        imv.image = [UIImage imageWithData:data];
        [heView addSubview: imv];
        [heView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneImageTouch:)]];
        
        [bgView addSubview:heView];
        
        UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, PosYFromView(heView, 10), GGUISCREENWIDTH, BUTTONHigh-15)];
        downView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:downView];
        
    
 
        
        int totalloc=4;
        CGFloat marginW = 0.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ;
        CGFloat appvieww=(SCREEN_WIDTH - (totalloc+1)*marginW)/totalloc;
        CGFloat appviewh=70;
        CGFloat marginH = 10;
        
        NSUInteger count=self.sliderNavData.count;
        
        for (int i=0; i<count; i++) {
            int row=i/totalloc;//行号
            int loc=i%totalloc;//列号
            
            
            
            KKGbutton * Btn = [[KKGbutton alloc]initWithFrame:CGRectZero fontSize:12 imageAndTitleSpaceing:0 baifenbi:0.6];
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:((SliderNavData *)self.sliderNavData[i]).url]];
           
            [Btn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            [Btn setTitle:((SliderNavData *)self.sliderNavData[i]).navText forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            Btn.titleLabel.font = [UIFont systemFontOfSize:10];
            Btn.tag = i;
            Btn.width = appvieww;//设置按钮坐标及大小
            Btn.height = appviewh;
            Btn.x = loc*(appvieww+marginW)+marginW;
            Btn.y = floor(row)*(appviewh+marginH)+marginH;
            
            [Btn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [downView addSubview:Btn];
            
        }

        //线
        UIView * rowView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 0.5)];
        rowView1.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.15];
        [downView addSubview:rowView1];
        
        //线
        UIView * rowView2 = [[UIView alloc]initWithFrame:CGRectMake(0, (BUTTONHigh-15)/2, GGUISCREENWIDTH, 0.5)];
        rowView2.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.15];
        [downView addSubview:rowView2];
        
        UIView * rowView3 = [[UIView alloc]initWithFrame:CGRectMake(0, (BUTTONHigh-15-0.5), GGUISCREENWIDTH, 0.5)];
        rowView3.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.15];
        [downView addSubview:rowView3];
        //竖着3根线
        
        UIView * locView1 = [[UIView alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH/4)-0.5, 0, 0.5, BUTTONHigh-15)];
        locView1.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.15];
        [downView addSubview:locView1];
        
        
        UIView * locView2 = [[UIView alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH/4)*2, 0, 0.5, BUTTONHigh-15)];
        locView2.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.15];
        [downView addSubview:locView2];
        
        UIView * locView3 = [[UIView alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH/4)*3, 0, 0.5, BUTTONHigh-15)];
        
        locView3.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.15];
        [downView addSubview:locView3];
        
        
        _tableView.tableHeaderView = bgView;
    }
}



-(void)typeClick:(UIButton *)btn
{
    
    _pushUrl =  ((SliderNavData *)self.sliderNavData[btn.tag]).itemTarget;
    if([((SliderNavData *)self.sliderNavData[btn.tag]).targetType isEqualToString:@"T"]){
        [self pushGoodShowView];
    }
    else if([((SliderNavData *)self.sliderNavData[btn.tag]).targetType isEqualToString:@"U"])
    {
        [self pushH5GoodShowView];
    }else if ([((SliderNavData *)self.sliderNavData[btn.tag]).targetType isEqualToString:@"D"])
    {
        [self pushGoodsDetailView];
    }else if([((SliderNavData *)self.sliderNavData[btn.tag]).targetType isEqualToString:@"P"])
    {
        [self pushPinGoodsDetailView];
    }else if([((SliderNavData *)self.sliderNavData[btn.tag]).targetType isEqualToString:@"M"]){//跳到列表页,和“T”不同的是这个有上拉加载
        [self pushNewGoodsShowView];
    }

}


-(void) oneImageTouch:(UITapGestureRecognizer *)recognizer{
    [self sliderJump:0];
}
-(void) sliderJump :(NSInteger)index{
    SliderData * sliderData = _imageUrls[index];
    _pushUrl = sliderData.itemTarget;
    if(![NSString isNSNull:sliderData.targetType]){
        if([sliderData.targetType isEqualToString:@"D"]){//跳到普通商品详情页
            [self pushGoodsDetailView];
        }else if([sliderData.targetType isEqualToString:@"P"]){//跳到拼购商品详情页
            [self pushPinGoodsDetailView];
        }else if([sliderData.targetType isEqualToString:@"T"]){//跳到列表页
            [self pushGoodShowView];
        }else if([sliderData.targetType isEqualToString:@"U"]){//跳到h5
            [self pushH5GoodShowView];
        }else if([sliderData.targetType isEqualToString:@"M"]){//跳到列表页,和“T”不同的是这个有上拉加载
            [self pushNewGoodsShowView];
        }

    }
    
}
- (void)didClickPage:(HeadView *)view atIndex:(NSInteger)index
{
    [self sliderJump:index];
}
- (void) footerRefresh
{
    if(_addon >= totalPageCount && totalPageCount != 0){
        [self.tableView.footer removeFromSuperview];
        
        
       self.nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28+45+15)];

        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 28, SCREEN_WIDTH-30, 45)];
        imageView.image = [UIImage imageNamed:@"home_no_more"];
        [self.nothingView addSubview:imageView];
        
        self.tableView.tableFooterView = self.nothingView;
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
        [self.tableView.header endRefreshing];
        //为了刷新的时候清理数据
        if(_addon == 2){
            [self.data removeAllObjects];
        }
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        GoodsPackData * data = [[GoodsPackData alloc] initWithJSONNode:object];
        if(data.code == 200){
            
            if ([[object objectForKey:@"msgRemind"] integerValue]>0) {
            
                isMaxZero = YES;
                
                //右侧按钮
                UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"messagebutton2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton:)];
                self.navigationItem.rightBarButtonItem = anotherButton;
                
            }else
            {
                isMaxZero = NO;
                //右侧按钮
                UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"messagebutton"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton:)];
                self.navigationItem.rightBarButtonItem = anotherButton;
            }
            
            totalPageCount = data.pageCount;
            [self.data addObjectsFromArray:[data.themeArray mutableCopy]];
            //八个导航
            self.sliderNavData = data.sliderNavArray;
            
            
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
    
//    GoodsPackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPackCell" forIndexPath:indexPath];
//    cell.data = self.data[indexPath.section];


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
//    return ((ThemeData * )self.data[indexPath.section]).height*GGUISCREENWIDTH/((ThemeData * )self.data[indexPath.section]).width;
//    return 144;
    return [KKGgoodsViewCell bindWithObjectHeigh:(ThemeData * )self.data[indexPath.row]];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.data.count;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =  GGBgColor;
    return headerView;
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
        [self pushGoodsDetailView];
    }else if([((ThemeData *)self.data[indexPath.row]).type isEqualToString:@"pin"])
    {
        [self pushPinGoodsDetailView];
    }
    
}
-(void)pushH5GoodShowView {
    GoodsShowH5ViewController * showContr = [[GoodsShowH5ViewController alloc]init];
    showContr.url = _pushUrl;
    [self.navigationController pushViewController:showContr animated:YES];
}
-(void)pushGoodShowView {

    GoodsShowViewController * gsViewController = [[GoodsShowViewController alloc]init];
    //下个页面要跳转的url
    gsViewController.url = _pushUrl;
    [self.navigationController pushViewController:gsViewController animated:YES];
}
-(void)pushPinGoodsDetailView {
    
    PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
    pinViewController.url = _pushUrl;
    [self.navigationController pushViewController:pinViewController animated:YES];
}

-(void)pushGoodsDetailView {
    
    GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
    gdViewController.url = _pushUrl;
    [self.navigationController pushViewController:gdViewController animated:YES];
}
-(void)pushNewGoodsShowView {
    
    NewGoodsShowViewController * ngdViewController = [[NewGoodsShowViewController alloc]init];
    ngdViewController.url = _pushUrl;
    [self.navigationController pushViewController:ngdViewController animated:YES];
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
