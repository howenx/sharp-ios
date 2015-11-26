    //
//  GoodsDetailViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ThreeViewCell.h"
#import "DetaileOneCell.h"
#import "DetailTwoCell.h"
#import "DetailThreeCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "HSGlobal.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "ShoppingCart.h"
#import "CartData.h"
@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ThreeViewCellDelegate,MBProgressHUDDelegate,DetailTwoCellDelegate,DetailThreeCellDelegate>
{

//    NSMutableArray * _dataSource;
    NSInteger _pageNum; //最后一个section里面有scrollview里面有三个view，这个标示是表示哪个view
//    CGFloat _rowHeight;//最后一个section的高度（这个高度是是随着section里面scrollview里面分别三个view的高度而变化的）
    CGFloat _otherRowHeight;//除了最后一组，其他section的高度和
    UIView *_lineView;//最后一个组的组头里面三个按钮下面的线
    CGFloat _sectionZeroHeight;//第0个分组的高度
    MBProgressHUD *HUD;
    
    DetaileOneCell * oneCell;
    DetailTwoCell * twoCell;
    DetailThreeCell * threeCell;

    ThreeViewCell * oneView;//存放图文详情的cell
    ThreeViewCell * twoView;//存放商品参数的cell
    ThreeViewCell * threeView;//存放热卖商品的cell
    
    CGFloat twoCellHeight;//第二个cell的高度
    CGFloat threeCellHeight;//第三个cell的高度
    
    CGFloat oneViewHeight;//第四个cell的第一个view高度
    CGFloat twoViewHeight;//第四个cell的第二个view高度
    CGFloat threeViewHeight;//第四个cell的第三个view高度
    
    NSInteger numberOfSection;//共几个section
    //只有第一个cell 数据会改变，并且只有点击尺寸的时候变，滚动的时候所有的数据都不重新加载，下面参数就是为了做这个
    BOOL oneCellAlreadyLoad;
    BOOL twoCellAlreadyLoad;
    BOOL threeCellAlreadyLoad;
    BOOL oneViewAlreadyLoad;
    BOOL twoViewAlreadyLoad;
    BOOL threeViewAlreadyLoad;
    
    BOOL oneCellAgainLoad;//当点击尺寸的时候，置为true，刷新第一个cell
    
    CGFloat tableContOffSet;
    FMDatabase * database;
    BOOL isLogin;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addToShoppingCart:(UIButton *)sender;

- (IBAction)buyNow:(UIButton *)sender;

@property (nonatomic) BOOL globleIsStore;
@property (nonatomic,assign) NSInteger globleStoreCount;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setAlpha:0.2];
    isLogin = [HSGlobal checkLogin];
    isLogin = 0;
    database = [HSGlobal shareDatabase];
    HUD = [[MBProgressHUD alloc]  initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hidesBottomBarWhenPushed = NO;
    self.navigationItem.title = @"商品详情";
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self prepareDataSource];
    _pageNum = 0;
    _otherRowHeight = 0;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40-2, GGUISCREENWIDTH/3, 2)];
    _lineView.backgroundColor = GGColor(254, 99, 108);
    
}


-(void)prepareDataSource
{
    
    
    NSLog(@"detailViewUrl  ++++++++++++%@",_url);
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
    numberOfSection = 3;
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        _detailData = [[GoodsDetailData alloc] initWithJSONNode:dict];
        if(_detailData.publicity ==nil){
            numberOfSection = 3;
        }else{
            numberOfSection = 4;
        }
        _globleIsStore = _detailData.orCollect;//这个将来要在加字段，从对象里面取
        _globleStoreCount = _detailData.collectCount;
        oneCellAlreadyLoad = true;
        twoCellAlreadyLoad = true;
        threeCellAlreadyLoad = true;
        oneViewAlreadyLoad = true;
        twoViewAlreadyLoad = true;
        threeViewAlreadyLoad = true;
        [self.tableView reloadData];
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        [HSGlobal printAlert:@"数据加载失败"];
        
    }];

    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numberOfSection;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(oneCell == nil || oneCellAlreadyLoad ||oneCellAgainLoad){
            oneCell = [DetaileOneCell subjectCell];
            oneCell.data = _detailData;
            [oneCell.storeBtn addTarget:self action:@selector(storeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [oneCell.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            oneCellAlreadyLoad = false;
            oneCellAgainLoad = false;
        }
        return oneCell;
        
    }else if(indexPath.section == 1){
        if(twoCell == nil || twoCellAlreadyLoad){
            twoCell = [[DetailTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            twoCell.delegate = self;
            twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            twoCell.data = _detailData;
            twoCellAlreadyLoad = false;
        }
        return twoCell;
    }
    
    if(indexPath.section==2 && numberOfSection == 4){
        if(threeCell == nil || threeCellAlreadyLoad){
            threeCell = [[DetailThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            threeCell.delegate = self;
            threeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            threeCell.data = _detailData;
            threeCellAlreadyLoad = false;
        }
        return threeCell;
    }
    
    if((indexPath.section == 3 && numberOfSection == 4)|| (numberOfSection == 3 &&indexPath.section == 2)){
        // _otherRowHeight是上面三个cell的高度
        _otherRowHeight =_sectionZeroHeight + twoCellHeight + threeCellHeight;


        //64为导航条和状态栏，40为下面购物车一行高度
        if(_tableView.contentOffset.y > _otherRowHeight - 64){
            
            [_tableView setContentOffset:CGPointMake(0, _otherRowHeight - 64 )];
        }
        tableContOffSet = 0;
        if(_pageNum == 0){
            if(oneView == nil || oneViewAlreadyLoad){
                oneView  = [ThreeViewCell subjectCell];
                oneView.pageNum = _pageNum;
                oneView.delegate = self;
                oneView.data = _detailData;
                oneViewAlreadyLoad = false;
            }
            [oneView.scrollView setContentOffset:CGPointMake(0, 0)];
            return oneView;
        }
        if(_pageNum == 1){
            if(twoView == nil || twoViewAlreadyLoad){
                twoView  = [ThreeViewCell subjectCell];
                twoView.pageNum = _pageNum;
                twoView.delegate = self;
                twoView.data = _detailData;
                twoViewAlreadyLoad = false;
            }
            [twoView.scrollView setContentOffset:CGPointMake(GGUISCREENWIDTH, 0)];
            return twoView;
        }
        if(_pageNum == 2){
            if(threeView == nil || threeViewAlreadyLoad){
                threeView  = [ThreeViewCell subjectCell];
                threeView.pageNum = _pageNum;
                threeView.delegate = self;
                threeView.data = _detailData;
                threeViewAlreadyLoad = false;
            }
            [threeView.scrollView setContentOffset:CGPointMake(GGUISCREENWIDTH * 2, 0)];
            return threeView;
        }
        return nil;
    }
    
    return nil;
}
- (void) storeBtnClicked: (UIButton *) button
{

    _globleIsStore = !_globleIsStore;
    UIImage * image;
    if (_globleIsStore) {
        image = [UIImage imageNamed:@"redStore"];
       [ oneCell.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",_globleStoreCount + 1] forState:UIControlStateNormal];
        _globleStoreCount++;
    }else{
        image = [UIImage imageNamed:@"grayStore"];
        [ oneCell.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",_globleStoreCount - 1] forState:UIControlStateNormal];
        _globleStoreCount--;
    }
    [oneCell.storeBtn setImage:image forState:UIControlStateNormal];

}
- (void) shareBtnClicked: (UIButton *) button{

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if((section==3 && numberOfSection == 4) || (section ==2 && numberOfSection == 3)){
        UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
        barView.backgroundColor = [UIColor whiteColor];
        //    barView.backgroundColor = [UIColor whiteColor];
        UIButton * tuWenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tuWenBtn.frame = CGRectMake(0, 10, GGUISCREENWIDTH/3, 20);
        [tuWenBtn setTitle:@"图文详情" forState:UIControlStateNormal];
        [tuWenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tuWenBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [tuWenBtn addTarget:self action:@selector(tuWenClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *canShuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        canShuBtn.frame = CGRectMake(GGUISCREENWIDTH/3, 10, GGUISCREENWIDTH/3, 20);
        [canShuBtn setTitle:@"商品参数" forState:UIControlStateNormal];
        [canShuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        canShuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [canShuBtn addTarget:self action:@selector(canShuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *reMaiBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        reMaiBtn.frame = CGRectMake(GGUISCREENWIDTH*2/3, 10, GGUISCREENWIDTH/3, 20);
        [reMaiBtn setTitle:@"热卖商品" forState:UIControlStateNormal];
        [reMaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        reMaiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [reMaiBtn addTarget:self action:@selector(reMaiClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [barView addSubview:tuWenBtn];
        [barView addSubview:canShuBtn];
        [barView addSubview:reMaiBtn];
        
        
        
        [barView addSubview:_lineView];
        
        return barView;
    }
    return nil;
}

- (void) tuWenClick:(UIButton *)button
{
    [self scrollPage:0];
}

- (void) canShuClick:(UIButton *)button
{
    [self scrollPage:1];
}

- (void) reMaiClick:(UIButton *)button
{
    [self scrollPage:2];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if((section==3 && numberOfSection == 4) || (section==2 && numberOfSection == 3)){
        //设置页眉视图的高度
        return 40.0f;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        _sectionZeroHeight = GGUISCREENWIDTH + 40 + 1 + 80 + 8;
        return _sectionZeroHeight;
    }
    if(indexPath.section == 1){
        return twoCellHeight;
    }

    if(indexPath.section == 2 && numberOfSection == 4){
        return threeCellHeight;
    }
    
    if((indexPath.section == 3 && numberOfSection == 4) || (indexPath.section == 2 && numberOfSection == 3)){
        if(_pageNum == 0){
            return oneViewHeight;
        }else if(_pageNum == 1){
            return twoViewHeight;
        }else if (_pageNum == 2){
            return threeViewHeight;
        }
    }

    return 0;
}


-(void)scrollPage:(NSInteger)page{
    _pageNum = page;
    tableContOffSet = _tableView.contentOffset.y;
    if(numberOfSection == 4){
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else if(numberOfSection == 3){
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if(tableContOffSet != 0){
        if(tableContOffSet >= _otherRowHeight - 64){
            [_tableView setContentOffset:CGPointMake(0,_otherRowHeight + 20)];//为了刷新下这个section，不然不会刷新
        }else{
            [_tableView setContentOffset:CGPointMake(0,tableContOffSet)];
        }
    }

    if(page ==0){
        _lineView.frame = CGRectMake(0, 40-2, GGUISCREENWIDTH/3, 2);
    }else if(page == 1){
        _lineView.frame = CGRectMake(GGUISCREENWIDTH/3, 40-2, GGUISCREENWIDTH/3, 2);
    }else if(page == 2){
        _lineView.frame = CGRectMake(GGUISCREENWIDTH*2/3, 40-2, GGUISCREENWIDTH/3, 2);
    }
}
//实现代理方法
-(void)getTwoCellH:(CGFloat)cellHeight{

    twoCellHeight = cellHeight;
}
-(void)getNewData:(GoodsDetailData *)newData{
    
    _detailData = newData;
    oneCellAgainLoad = true;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


-(void)getThreeCellH:(CGFloat)cellHeight{
    
    threeCellHeight = cellHeight;
}
-(void)getFourCellH:(CGFloat)cellHeight{
    if(_pageNum == 0 ){
        oneViewHeight = cellHeight;
    }else if(_pageNum == 1){
        twoViewHeight = cellHeight;
    }else if (_pageNum == 2){
        threeViewHeight = cellHeight;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addToShoppingCart:(UIButton *)sender {
    
    NSString * sizeId;
    for(SizeData * sizeData in _detailData.sizeArray){
        if(sizeData.orMasterInv){
            sizeId = sizeData.sizeId;
            
        }
    }
    //登陆状态
    if(isLogin){
        [self sendCart:sizeId.integerValue];
    }else{
    
    }
//    [database executeUpdate:@"DELETE FROM Shopping_Cart "];
    NSLog(@"---------事务开始");
    
    //开始添加事务
    [database beginTransaction];
    
    
    FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart where pid = ?",[NSNumber numberWithInt:[sizeId intValue]]];
    //购物车如果存在这件商品，就更新数量
    while ([rs next]){

        int amount = [rs intForColumn:@"pid_amount"] ;
        BOOL isUpdateOK = [database executeUpdate:@"UPDATE Shopping_Cart SET pid_amount = ? WHERE pid = ?",[NSNumber numberWithInt:amount+1],[NSNumber numberWithInt:[sizeId intValue]]];
        if (isUpdateOK) {
            FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
            while ([rs next]){
                NSLog(@"pid=%d",[rs intForColumn:@"pid"]);
                NSLog(@"cart_id=%d",[rs intForColumn:@"cart_id"]);
                NSLog(@"pid_amount=%d",[rs intForColumn:@"pid_amount"]);
                NSLog(@"state=%@",[rs stringForColumn:@"state"]);
                NSLog(@"--------------------------");
            }

        }
        [database commit];
        return;
    }
    
    
    
    
    NSString * sql = @"insert into Shopping_Cart (pid,cart_id,pid_amount,state) values (?,?,?,?)";
    
    //插入
    BOOL isInsertOK = [database executeUpdate:sql,[NSNumber numberWithInt:[sizeId intValue]],0,[NSNumber numberWithInt:1],@"I"];
    
    if (isInsertOK)
    {
        FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
        while ([rs next]){
            NSLog(@"pid=%d",[rs intForColumn:@"pid"]);
            NSLog(@"cart_id=%d",[rs intForColumn:@"cart_id"]);
            NSLog(@"pid_amount=%d",[rs intForColumn:@"pid_amount"]);
            NSLog(@"state=%@",[rs stringForColumn:@"state"]);
            NSLog(@"_______________________________");
        }

    }


    //提交事务
    [database commit];

    NSLog(@"---------事务结束");

}
-(void)sendCart :(NSInteger)pid{
    
    
    
    
    //开始添加事务
    [database beginTransaction];
    

    NSMutableArray * mutArray = [NSMutableArray array];

        
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithLong:pid] forKey:@"skuId"];
        [myDict setObject:[NSNumber numberWithInt:0] forKey:@"cartId"];
        [myDict setObject:[NSNumber numberWithInt:1] forKey:@"amount"];
        [myDict setObject:@"I" forKey:@"state"];
        [mutArray addObject:myDict];

    
    //提交事务
    [database commit];
    
    
    if(mutArray.count >0){
        NSString * urlString =[HSGlobal sendCartUrl];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //此处设置后返回的默认是NSData的数据
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
        [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"id-token"];
        
        [manager POST:urlString  parameters:[mutArray copy] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * dataArray = [object objectForKey:@"cartList"];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"message= %@",message);
            NSMutableArray * cartArray = [NSMutableArray array];
            NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
            for (id node in dataArray) {
                CartData * data = [[CartData alloc] initWithJSONNode:node];
                [cartArray addObject:data];
            }
            if(cartArray.count>0){
                
                
                [database beginTransaction];
                
                [database executeUpdate:@"DELETE FROM Shopping_Cart"];
                FMResultSet * rs1 = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
                NSLog(@"____________删除数据后start___________________");
                while ([rs1 next]){
                    NSLog(@"pid=%d",[rs1 intForColumn:@"pid"]);
                    NSLog(@"cart_id=%d",[rs1 intForColumn:@"cart_id"]);
                    NSLog(@"pid_amount=%d",[rs1 intForColumn:@"pid_amount"]);
                    NSLog(@"state=%@",[rs1 stringForColumn:@"state"]);
                    
                }
                NSLog(@"____________删除数据后end___________________");
                NSString * sql = @"insert into Shopping_Cart (pid,cart_id,pid_amount,state) values (?,?,?,?)";
                
                for (int i=0; i<cartArray.count; i++) {
                    CartData * cData = cartArray[i];
                    [database executeUpdate:sql,[NSNumber numberWithLong:cData.skuId],[NSNumber numberWithLong:cData.cartId],[NSNumber numberWithLong:cData.amount],cData.state];
                }
                
                FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
                while ([rs next]){
                    NSLog(@"____________后台获取数据start___________________");
                    NSLog(@"pid=%d",[rs intForColumn:@"pid"]);
                    NSLog(@"cart_id=%d",[rs intForColumn:@"cart_id"]);
                    NSLog(@"pid_amount=%d",[rs intForColumn:@"pid_amount"]);
                    NSLog(@"state=%@",[rs stringForColumn:@"state"]);
                }
                NSLog(@"____________后台获取数据end___________________");
                
                //提交事务
                [database commit];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [HSGlobal printAlert:@"发送购物车数据失败"];
        }];
        
    }
    
    
}

- (IBAction)buyNow:(UIButton *)sender {
}

@end
