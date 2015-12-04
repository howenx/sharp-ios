//
//  GoodsShowViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/16.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsShowViewController.h"
#import "GoodsShowCell.h"
#import "GoodsShowData.h"
#import "MBProgressHUD.h"
#import "GoodsDetailViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "HSGlobal.h"

//section之间空隙，和item的空隙，这里都设置成5
#define gap 5

//描述label的高度
#define detailLabH 20

//价格lable的高度
#define priceLabH 21

@interface GoodsShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation GoodsShowViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [HSGlobal getHUD:self];
    [HUD show:YES];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAnimationData) name:@"ReloadAnimationData" object:nil];
    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsShowCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsShowCell"];
    self.data  = [NSMutableArray array];
    [self headerRefresh];
    self.hidesBottomBarWhenPushed = YES;

    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];

}

-(void)reloadAnimationData{
    [self headerRefresh];
}
- (void) headerRefresh
{
    NSLog(@"showViewUrl  ++++++++++++%@",_url);
    
    AFHTTPRequestOperationManager * manager = [HSGlobal shareRequestManager];
    
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.collectionView.header endRefreshing];
        [self.data removeAllObjects];
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        NSArray * dataArray = [object objectForKey:@"themeList"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"message= %@",message);

        for (id node in dataArray) {
            GoodsShowData * data = [[GoodsShowData alloc] initWithJSONNode:node];
            [self.data addObject:data];
        }
        [self.collectionView reloadData];
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.collectionView.header endRefreshing];
        [HUD hide:YES];
        [HSGlobal printAlert:@"数据加载失败"];
        
    }];
}


- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        /**
         流式布局
         */
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        //上下两个item的空隙
        layout.minimumLineSpacing = gap;
        //左右2个item的空隙
        layout.minimumInteritemSpacing = gap;
        //上左下右的空隙
        layout.sectionInset = UIEdgeInsetsMake(0, gap, gap, gap);
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        
        //创建一个collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-49) collectionViewLayout:layout];
        _collectionView.backgroundColor = GGColor(240, 240, 240);
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
    return 2;
}

/**
 每组显示的item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(_data.count>0){
        if(section == 0){
            return 1;
        }
        return _data.count - 1;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     复用机制
     */

    GoodsShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsShowCell" forIndexPath:indexPath];
    
    if(_data.count>0){
        GoodsShowData *goodsShowData;
        if(indexPath.section == 0 ){
            goodsShowData = _data[indexPath.section];
            goodsShowData.itemImg = goodsShowData.itemMasterImg;
            
        }else{
            goodsShowData = _data[indexPath.item + indexPath.section];
        }
        
        //赋值
        [cell setData:goodsShowData];

    }
    
    return cell;
}




//返回item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //第0组
    if (indexPath.section == 0)
    {
        return CGSizeMake(GGUISCREENWIDTH-gap*2, ((GGUISCREENWIDTH-gap*2)/2) + detailLabH + priceLabH);
    }
    else //其他组
    {
        return CGSizeMake((GGUISCREENWIDTH-gap*3)/2, ((GGUISCREENWIDTH-gap*3)/2) + detailLabH + priceLabH);
    }}

/**
 点击了某个item会调用
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //正常状态才能进入到详情页面
    if([@"Y" isEqualToString:((GoodsShowData *)_data[indexPath.item + indexPath.section]).state]){
        NSString * _pushUrl = ((GoodsShowData *)_data[indexPath.item + indexPath.section]).itemUrl;
        //进入到商品展示页面
        self.hidesBottomBarWhenPushed=YES;
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = _pushUrl;
        [self.navigationController pushViewController:gdViewController animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
