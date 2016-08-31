
//
//  NewGoodsShowViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/8/25.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "NewGoodsShowViewController.h"
#import "GoodsShowCell.h"
#import "GoodsShowData.h"
#import "GoodsDetailViewController.h"
#import "PinGoodsDetailViewController.h"
#import "CartViewController.h"
@interface NewGoodsShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,GoodsShowCellDelegate>
{
    BOOL isLogin;
    NSInteger totalPageCount;//数据总页数
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSInteger addon;
@property (nonatomic) UIView  * nothingView;
@property (nonatomic, strong)  UICollectionViewFlowLayout *layout;
@end

@implementation NewGoodsShowViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _addon = 1;
    _collectionView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsShowCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsShowCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];

    
    _collectionView.backgroundColor = GGBgColor;
    self.data  = [NSMutableArray array];
    self.hidesBottomBarWhenPushed = YES;
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self footerRefresh];
    
}

- (void) footerRefresh
{
    if(_addon >= totalPageCount && totalPageCount != 0){
        [self.collectionView.footer removeFromSuperview];
        self.layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 88);
    }
    NSString * url = [NSString stringWithFormat:@"%@%ld",_url,(long)_addon];
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
        [self.collectionView.footer endRefreshing];
        if(_addon == 2){
            [self.data removeAllObjects];
        }
        
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if(object!=nil && ![NSString isBlankString:[object objectForKey:@"title"]]){
            self.navigationItem.title  = [object objectForKey:@"title"];
        }
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            totalPageCount = [[object objectForKey:@"page_count"]integerValue];
            
            //判断是否有商品
            if(![NSString isNSNull:[object objectForKey:@"themeItemList"]]){
                NSArray * dataArray = [object objectForKey:@"themeItemList"];
                for (id node in dataArray) {
                    GoodsShowData * data = [[GoodsShowData alloc] initWithJSONNode:node];
                    [self.data addObject:data];
                }
            }
            if(totalPageCount<=1){
                [self.collectionView.footer removeFromSuperview];
            }
            [self.collectionView reloadData];
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
        [self.collectionView.footer endRefreshing];
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
    }];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        self.nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28+45+15)];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 28, SCREEN_WIDTH-30, 45)];
        imageView.image = [UIImage imageNamed:@"home_no_more"];
        [self.nothingView addSubview:imageView];
        
        
        [footerview addSubview:self.nothingView];
        
        
        reusableView = footerview;
    }
    return reusableView;
}




- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        /**
         流式布局
         */
         self.layout= [[UICollectionViewFlowLayout alloc] init];
        
        //上下两个item的空隙
        self.layout.minimumLineSpacing = 10;
        //左右2个item的空隙
        self.layout.minimumInteritemSpacing = 0;
        //上左下右的空隙
        self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        //滚动方向
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        
        //创建一个collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = GGBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
    }
    
    return _collectionView;
}
/**
 有多少组
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
  
}

/**
 每组显示的item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     复用机制
     */
    
    GoodsShowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsShowCell" forIndexPath:indexPath];
    
    if(_data.count>0){
        GoodsShowData *goodsShowData = _data[indexPath.item];
        //赋值
        [cell setData:goodsShowData];
        
    }
    
    return cell;
}




//返回item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(GGUISCREENWIDTH/2,GGUISCREENWIDTH/2+56);
    
}

/**
 点击了某个item会调用
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * _pushUrl = ((GoodsShowData *)_data[indexPath.item]).itemUrl;
    NSString * itemType = ((GoodsShowData *)_data[indexPath.item]).itemType;
    //进入到商品展示页面
    self.hidesBottomBarWhenPushed=YES;
    if ([@"pin" isEqualToString:itemType]) {
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = _pushUrl;
        [self.navigationController pushViewController:pinViewController animated:YES];
    }else{
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = _pushUrl;
        [self.navigationController pushViewController:gdViewController animated:YES];
    }
    self.hidesBottomBarWhenPushed=NO;
}
-(void)flagUrl:(NSString *)url{
    self.hidesBottomBarWhenPushed=YES;
    GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
    gdViewController.url = url;
    [self.navigationController pushViewController:gdViewController animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backController{
    [self ReloadRootPage];
}
-(void)ReloadRootPage{
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    _addon = 1;
    totalPageCount = 0;
    self.collectionView.contentOffset = CGPointMake(0, 0);
    [self footerRefresh];
}
@end
