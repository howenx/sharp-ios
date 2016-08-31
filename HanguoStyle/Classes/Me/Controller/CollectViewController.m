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
#import "GoodsShowCell.h"
@interface CollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIView * bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray * collectionData;
@end

@implementation CollectViewController
- (void)viewWillAppear:(BOOL)animated{
    [self headerRefresh];
}
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

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self createNoCollectView];
    
    
}
-(void)createNoCollectView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _bgView.backgroundColor = GGBgColor;
//    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH -162)/2, GGUISCREENHEIGHT/8, 162, 190)];
//    bgImageView.image = [UIImage imageNamed:@"no_collect"];
//    [_bgView addSubview:bgImageView];
    [self.view addSubview:_bgView];
    _bgView.hidden = YES;
    [self collectionViewDidLoad];
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
        [self.tableView.header endRefreshing];
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        
        if(code == 200){
            [self.data removeAllObjects];
            NSArray * dataArray = [object objectForKey:@"collectList"];
            
            for (id node in dataArray) {
                CollectData * data = [[CollectData alloc] initWithJSONNode:node];
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
            hud.labelText = message;
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
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
    headerView.backgroundColor =  GGBgColor;
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

                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
                if(self.data.count == 0){
                    [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                    _bgView.hidden = NO;
                }else{
                    _bgView.hidden = YES;
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
    [self collectionRefresh];
}


/*没数据时，展示可能喜欢的商品*/

-(void)collectionViewDidLoad{
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsShowCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsShowCell"];
    _collectionData = [NSMutableArray array];
    _collectionView.backgroundColor = GGBgColor;
    [self collectionRefresh];
    
}
- (void) collectionRefresh
{
    
    NSString * collectionUrl = [HSGlobal emptyDataUrl:3];// 1-空购物车 2-空订单 3-空收藏
    
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager GET:collectionUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            
            //判断是否有商品
            if(![NSString isNSNull:[object objectForKey:@"themeItemList"]]){
                NSArray * dataArray = [object objectForKey:@"themeItemList"];
                for (id node in dataArray) {
                    GoodsShowData * data = [[GoodsShowData alloc] initWithJSONNode:node];
                    [_collectionData addObject:data];
                }
            }
            
            [self.collectionView reloadData];
        }
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.collectionView.footer endRefreshing];
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
    }];
}



// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = header;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 255)];
        view.backgroundColor = [UIColor whiteColor];
        [reusableView addSubview:view];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((GGUISCREENWIDTH-76)/2, 60, 76, 62)];
        imageView.image = [UIImage imageNamed:@"emptyCollect"];
        [view addSubview:imageView];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.height+imageView.y+22, GGUISCREENWIDTH, 30)];
        lab.text = @"暂无收藏商品";
        lab.font = [UIFont systemFontOfSize:17];
        lab.textColor = UIColorFromRGB(0xc8c8c8);
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        
        UIImageView * tjImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, view.height +11, GGUISCREENWIDTH-30, 13)];
        tjImageView.image = [UIImage imageNamed:@"tuijian"];
        [reusableView addSubview:tjImageView];
    }
    reusableView.backgroundColor = GGBgColor;
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor purpleColor];
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
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        //上下两个item的空隙
        layout.minimumLineSpacing = 10;
        //左右2个item的空隙
        layout.minimumInteritemSpacing = 0;
        //上左下右的空隙
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layout.headerReferenceSize = CGSizeMake(GGUISCREENWIDTH, 291);
        
        
        //创建一个collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = GGBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_bgView addSubview:_collectionView];
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
    return _collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     复用机制
     */
    
    GoodsShowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsShowCell" forIndexPath:indexPath];
    
    if(_collectionData.count>0){
        GoodsShowData *goodsShowData = _collectionData[indexPath.item];
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
    NSString * _pushUrl = ((GoodsShowData *)_collectionData[indexPath.item]).itemUrl;
    NSString * itemType = ((GoodsShowData *)_collectionData[indexPath.item]).itemType;
    if ([@"pin" isEqualToString:itemType]) {
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = _pushUrl;
        [self.navigationController pushViewController:pinViewController animated:YES];
    }else{
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = _pushUrl;
        [self.navigationController pushViewController:gdViewController animated:YES];
    }
}

@end
