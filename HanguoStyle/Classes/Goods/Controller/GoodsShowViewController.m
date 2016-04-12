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
#import "GoodsDetailViewController.h"
#import "PinGoodsDetailViewController.h"
#import "CartViewController.h"
//section之间空隙，和item的空隙，这里都设置成5
#define gap 5



@interface GoodsShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,GoodsShowCellDelegate>
{
    NSInteger _cnt;
    BOOL isLogin;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) UILabel * cntLabel;

@end

@implementation GoodsShowViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    [self queryCustNum];
    [self headerRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    //注册xib
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsShowCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsShowCell"];
    _collectionView.backgroundColor = GGBgColor;
    self.data  = [NSMutableArray array];
    self.hidesBottomBarWhenPushed = YES;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self makeCustNumLab];

}
-(void)makeCustNumLab{
    
    //右上角添加按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [rightButton setImage:[UIImage imageNamed:@"shopping_cart_top"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(enterCust)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(17 , -5, 15, 15)];
    _cntLabel.textColor = GGMainColor;
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont boldSystemFontOfSize:11];
    _cntLabel.backgroundColor = [UIColor whiteColor];
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = GGMainColor.CGColor;

    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }
    
    [rightButton addSubview:_cntLabel];

}
-(void)enterCust{
    BOOL orJumpTab = NO;
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CartViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
            orJumpTab = YES;
            break;
        }
    }
    
    if(!orJumpTab){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"cart",@"jumpKey", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToTabbar" object:nil userInfo:dict];
    }
}
-(void)queryCustNum{
    isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        FMDatabase * database = [PublicMethod shareDatabase];
        FMResultSet * rs = [database executeQuery:@"SELECT SUM(pid_amount) as amount FROM Shopping_Cart "];
        //购物车如果存在这件商品，就更新数量
        while ([rs next]){
            _cnt = [rs intForColumn:@"amount"] ;
            if (_cnt == 0) {
                _cntLabel.hidden = YES;
            }else{
                _cntLabel.hidden = NO;
                _cntLabel.text= [NSString stringWithFormat:@"%ld",(long)_cnt];
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
                if (_cnt == 0) {
                    _cntLabel.hidden = YES;
                }else{
                    _cntLabel.hidden = NO;
                    _cntLabel.text= [NSString stringWithFormat:@"%ld",(long)_cnt];
                }
                
            }
         
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }
}



- (void) headerRefresh
{
    
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.collectionView.header endRefreshing];
        
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            [self.data removeAllObjects];
            NSDictionary * themeDict = [NSDictionary dictionaryWithObjectsAndKeys:[[object objectForKey:@"themeList"] objectForKey:@"themeImg"],@"itemImg",[[object objectForKey:@"themeList"] objectForKey:@"masterItemTag"],@"masterItemTag",@"Y",@"state",nil];
            
            NSArray * dataArray = [[object objectForKey:@"themeList"]objectForKey:@"themeItemList"];
            GoodsShowData * data1 = [[GoodsShowData alloc] initWithJSONNode:themeDict];
            [self.data addObject:data1];
            
            for (id node in dataArray) {
                GoodsShowData * data = [[GoodsShowData alloc] initWithJSONNode:node];
                [self.data addObject:data];
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
        [self.collectionView.header endRefreshing];
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
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
        layout.minimumLineSpacing = gap*2;
        //左右2个item的空隙
        layout.minimumInteritemSpacing = 0;
        //上左下右的空隙
//        layout.sectionInset = UIEdgeInsetsMake(0, gap, gap, gap);
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        
        //创建一个collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64) collectionViewLayout:layout];
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
            cell.delegate = self;
            
        }else{
            goodsShowData = _data[indexPath.section + indexPath.item];
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
        return CGSizeMake(GGUISCREENWIDTH, ((GoodsShowData*)_data[indexPath.section]).height*GGUISCREENWIDTH/((GoodsShowData*)_data[indexPath.section]).width);
    }
    else //其他组
    {
        return CGSizeMake(GGUISCREENWIDTH/2,GGUISCREENWIDTH/2);
    }
}

/**
 点击了某个item会调用
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        //正常状态才能进入到详情页面
//        if([@"Y" isEqualToString:((GoodsShowData *)_data[indexPath.item + indexPath.section]).state]||[@"P" isEqualToString:((GoodsShowData *)_data[indexPath.item + indexPath.section]).state]){
            NSString * _pushUrl = ((GoodsShowData *)_data[indexPath.item + indexPath.section]).itemUrl;
            NSString * itemType = ((GoodsShowData *)_data[indexPath.item + indexPath.section]).itemType;
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
//        }
       
    }
    
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
    [self headerRefresh];
    [self queryCustNum];
}

@end
