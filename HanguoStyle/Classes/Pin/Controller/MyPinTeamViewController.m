//
//  MyPinTeamViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/29.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MyPinTeamViewController.h"
#import "PinTeamData.h"
#import "MyPinTeamCell.h"
#import "PinDetailViewController.h"
#import "OrderDetailsPinViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsShowCell.h"
#import "PinGoodsDetailViewController.h"
@interface MyPinTeamViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,MyPinTeamCellDelegate>

@property (nonatomic) UITableView * tableView;
@property (nonatomic) UIScrollView * scrollView;
@property (nonatomic) UIView * lineView;
@property (nonatomic) UIView * totalView;//我的开团
@property (nonatomic) UIView * obligationView;//我的参团
@property (nonatomic) UIView * bgView;//没有订单的背景

@property (nonatomic) int pageNum;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray * collectionData;
@end

@implementation MyPinTeamViewController
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.scrollsToTop = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.navigationItem.title=@"我的拼购";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.data = [NSMutableArray array];
    [self createHeadView];
    [self createScrollView];
    [self createTableView];
    [self requestData];
    [self createNoOrderView];

}
-(void)createNoOrderView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _bgView.backgroundColor = GGBgColor;
//    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH -152)/2, GGUISCREENHEIGHT/8, 152, 190)];
//    bgImageView.image = [UIImage imageNamed:@"no_groupon"];
//    [_bgView addSubview:bgImageView];
    [self collectionViewDidLoad];
}
- (void) requestData
{

    NSString * url = [HSGlobal pinListUrl];
    
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

        [self.data removeAllObjects];

        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        
        if(code == 200){
            [self.data removeAllObjects];
            NSArray * dataArray = [object objectForKey:@"activityList"];
            
            
            for (id node in dataArray) {
                PinTeamData * data = [[PinTeamData alloc] initWithJSONNode:node];
                if (_pageNum == 0 && data.orMaster==1) {//我的开团
                    [_data addObject:data];
                }else if(_pageNum == 1 && data.orMaster==0){//我的参团
                    [_data addObject:data];
                }
            }
            
            [self.tableView reloadData];
            if (_pageNum == 0) {
                [_totalView addSubview:_tableView];
                [_totalView addSubview:_bgView];
                if(self.data.count == 0){
                    _bgView.hidden = NO;
                }else{
                    _bgView.hidden = YES;
                }
            }else if(_pageNum == 1){
                [_obligationView addSubview:_tableView];
                [_obligationView addSubview:_bgView];
                if(self.data.count == 0){
                    _bgView.hidden = NO;
                }else{
                    _bgView.hidden = YES;
                }
            }

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


-(void)createHeadView{
    UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
    barView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton * totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.tag = 16000;
    totalBtn.frame = CGRectMake(10, 10, (GGUISCREENWIDTH-20)/2, 20);
    [totalBtn setTitle:@"我的开团" forState:UIControlStateNormal];
    [totalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    totalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [totalBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * obligationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    obligationBtn.tag = 16001;
    obligationBtn.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)/2, 10, (GGUISCREENWIDTH-20)/2, 20);
    [obligationBtn setTitle:@"我的参团" forState:UIControlStateNormal];
    [obligationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    obligationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [obligationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    [barView addSubview:totalBtn];
    [barView addSubview:obligationBtn];
    
    
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 40-2, (GGUISCREENWIDTH-20)/2, 2)];
    _lineView.backgroundColor = GGMainColor;
    [barView addSubview:_lineView];
    [self.view addSubview:barView];
    
    
}
-(void)btnClick :(UIButton *)button{
    _pageNum = (int)button.tag - 16000;
    [self changeView];
}


-(void)createScrollView{
    
    //设置scrollview
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 40, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40);
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(GGUISCREENWIDTH * 2, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _totalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40)];
    _totalView.backgroundColor = GGBgColor;
    [_scrollView addSubview:_totalView];
    
    _obligationView = [[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40)];
    _obligationView.backgroundColor = GGBgColor;
    [_scrollView addSubview:_obligationView];
    
    
}
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.backgroundColor = GGBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"MyPinTeamCell" bundle:nil] forCellReuseIdentifier:@"MyPinTeamCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]] && ![scrollView isKindOfClass:[UICollectionView class]]) {
        _pageNum =  scrollView.contentOffset.x/GGUISCREENWIDTH;
        [self changeView];
    }
}

- (void) changeView{
    [self requestData];
    _tableView.contentOffset = CGPointMake(0, 0);
    if(_pageNum==0){
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.frame = CGRectMake(10, 40-2, (GGUISCREENWIDTH-20)/2, 2);
        }];
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }else if(_pageNum==1){//
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)/2, 40-2, (GGUISCREENWIDTH-20)/2, 2);
        }];
        _scrollView.contentOffset = CGPointMake(GGUISCREENWIDTH, 0);
        
        
    }
}






-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyPinTeamCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyPinTeamCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.data = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setSelectButtonBlock:^(NSString * str) {
        NSLog(@"查看订单");
       PinTeamData * data = [_data objectAtIndex:indexPath.row]
        ;
        OrderDetailsPinViewController * vc = [OrderDetailsPinViewController new];
        vc.orderId = data.orderId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
//代理方法
-(void)sendTeamDetailUrl:(NSString *)url{
    PinDetailViewController * detailVC = [[PinDetailViewController alloc]init];
    detailVC.url = url;
    [self.navigationController pushViewController:detailVC animated:YES];
}


-(void)backController{
    [self requestData];
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
    
    NSString * collectionUrl = [HSGlobal emptyDataUrl:3];// 1-空购物车 2-空订单 3-空收藏 4-空拼团 5-空优惠券
    
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
        imageView.image = [UIImage imageNamed:@"emptyDd"];
        [view addSubview:imageView];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.height+imageView.y+22, GGUISCREENWIDTH, 30)];
        lab.text = @"暂无拼购";
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40) collectionViewLayout:layout];
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
