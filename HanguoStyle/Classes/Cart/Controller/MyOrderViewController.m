//
//  MyOrderViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MyOrderViewController.h"
#import "UIBarButtonItem+GG.h"
#import "MyOrderData.h"
#import "MyOrderOneCell.h"
#import "PayViewController.h"
#import "MyOrderMoreCell.h"
#import "OrderDetailViewController.h"
#import "GoodsDetailViewController.h"
@interface MyOrderViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MyOrderOneCellDelegate,MyOrderMoreCellDelegate>
{
    long selectOrderId;//被选中进到详情页的订单
    NSInteger _obligationCount;
    NSInteger _receiptGoodsCount;
    UILabel * emptyLab;
}
@property (nonatomic) UIScrollView * scrollView;
@property (nonatomic) UIView * lineView;

@property (nonatomic) UIView * totalView;//全部
@property (nonatomic) UIView * obligationView;//待付款
@property (nonatomic) UIView * receiptGoodsView;//待收货
@property (nonatomic) int pageNum;
@property (nonatomic) UITableView * tableView;
@property (nonatomic) UILabel * obligationLabel;
@property (nonatomic) UILabel * receiptGoodsLabel;
@end

@implementation MyOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.scrollsToTop = NO;
    self.navigationItem.title = @"我的订单";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back" target:self action:@selector(backViewController)];
    [self createHeadView];
    [self createScrollView];
    _data = [NSMutableArray array];
    [self createTableView];

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    emptyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (GGUISCREENHEIGHT-104)/2-40, GGUISCREENWIDTH, 40)];
    emptyLab.textAlignment = NSTextAlignmentCenter;
    emptyLab.textColor = [UIColor grayColor];
    emptyLab.font = [UIFont systemFontOfSize:15];
    emptyLab.text =@"暂无订单";

}
-(void)requestData{
    NSString * urlString;
    if (selectOrderId == 0) {
        urlString = [HSGlobal myOrderUrl];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%ld",[HSGlobal myOrderUrl],selectOrderId];
    }
    
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }

    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        [self.tableView.header endRefreshing];
        NSArray * dataArray = [object objectForKey:@"orderList"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
        if(code == 200){
            //进入到订单详情
            if (selectOrderId != 0) {
                OrderDetailViewController * odViewController = [[OrderDetailViewController alloc]init];
                for (id node in dataArray) {
                    MyOrderData * singleData = [[MyOrderData alloc] initWithJSONNode:node];
                    
                    odViewController.orderData = singleData;
                }

                selectOrderId = 0;
                [self.navigationController pushViewController:odViewController animated:YES];
            }else{
                [self.data removeAllObjects];
                for (id node in dataArray) {
                    MyOrderData * data = [[MyOrderData alloc] initWithJSONNode:node];
                    if (_pageNum == 0) {
                        [_data addObject:data];
                    }else if(_pageNum == 1 && [data.orderInfo.orderStatus isEqualToString:@"I"]){
                        [_data addObject:data];
                    }else if(_pageNum == 2 && [data.orderInfo.orderStatus isEqualToString:@"D"]){
                        [_data addObject:data];
                    }
                    
                    
                    
                    if([data.orderInfo.orderStatus isEqualToString:@"I"]){
                        _obligationCount++;
                    }else if([data.orderInfo.orderStatus isEqualToString:@"D"]){
                        _receiptGoodsCount++;
                    }
                    
                }
                
                
                if(_obligationCount>0){
                    _obligationLabel.hidden = NO;
                    _obligationLabel.text = [NSString stringWithFormat:@"%ld",_obligationCount];
                }else{
                    _obligationLabel.hidden = YES;
                }
                if(_receiptGoodsCount>0){
                    _receiptGoodsLabel.hidden = NO;
                    _receiptGoodsLabel.text = [NSString stringWithFormat:@"%ld",_receiptGoodsCount];
                }else{
                    _receiptGoodsLabel.hidden = YES;
                }
                _obligationCount = 0;
                _receiptGoodsCount = 0;
                
                
                [self.tableView reloadData];
                if (_pageNum == 0) {
                    [_totalView addSubview:_tableView];
                    [_totalView addSubview:emptyLab];
                    if(self.data.count == 0){
                        emptyLab.hidden = NO;
                    }else{
                        emptyLab.hidden = YES;
                    }

                }else if(_pageNum == 1){
                    [_obligationView addSubview:_tableView];
                    [_obligationView addSubview:emptyLab];
                    if(self.data.count == 0){
                        emptyLab.hidden = NO;
                    }else{
                        emptyLab.hidden = YES;
                    }

                }else if(_pageNum == 2){
                    [_receiptGoodsView addSubview:_tableView];
                    [_receiptGoodsView addSubview:emptyLab];
                    if(self.data.count == 0){
                        emptyLab.hidden = NO;
                    }else{
                        emptyLab.hidden = YES;
                    }

                }

            }
            
            
        }else{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        [GiFHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"请求订单数据失败"];
    }];
}

-(void)createHeadView{
    UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
    barView.backgroundColor = [UIColor whiteColor];

    
    UIButton * totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.tag = 15000;
    totalBtn.frame = CGRectMake(10, 10, (GGUISCREENWIDTH-20)/3, 20);
    [totalBtn setTitle:@"全部" forState:UIControlStateNormal];
    [totalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    totalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [totalBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * obligationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    obligationBtn.tag = 15001;
    obligationBtn.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)/3, 10, (GGUISCREENWIDTH-20)/3, 20);
    [obligationBtn setTitle:@"待付款" forState:UIControlStateNormal];
    [obligationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    obligationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [obligationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _obligationLabel = [[UILabel alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH-20)/6+20 , 0, 15, 15)];
    _obligationLabel.textColor = GGMainColor;
    _obligationLabel.textAlignment = NSTextAlignmentCenter;
    _obligationLabel.font = [UIFont boldSystemFontOfSize:11];
    _obligationLabel.backgroundColor = [UIColor whiteColor];
    _obligationLabel.layer.cornerRadius = CGRectGetHeight(_obligationLabel.bounds)/2;
    _obligationLabel.layer.masksToBounds = YES;
    _obligationLabel.layer.borderWidth = 1.0f;
    _obligationLabel.layer.borderColor = GGMainColor.CGColor;
    
    if (_obligationCount == 0) {
        _obligationLabel.hidden = YES;
    }
    
    [obligationBtn addSubview:_obligationLabel];


    
    
    UIButton * receiptGoodsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    receiptGoodsBtn.tag= 15002;
    receiptGoodsBtn.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)*2/3, 10, (GGUISCREENWIDTH-20)/3, 20);
    [receiptGoodsBtn setTitle:@"待收货" forState:UIControlStateNormal];
    [receiptGoodsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    receiptGoodsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [receiptGoodsBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _receiptGoodsLabel = [[UILabel alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH-20)/6+20 , 0, 15, 15)];
    _receiptGoodsLabel.textColor = GGMainColor;
    _receiptGoodsLabel.textAlignment = NSTextAlignmentCenter;
    _receiptGoodsLabel.font = [UIFont boldSystemFontOfSize:11];
    _receiptGoodsLabel.backgroundColor = [UIColor whiteColor];
    _receiptGoodsLabel.layer.cornerRadius = CGRectGetHeight(_obligationLabel.bounds)/2;
    _receiptGoodsLabel.layer.masksToBounds = YES;
    _receiptGoodsLabel.layer.borderWidth = 1.0f;
    _receiptGoodsLabel.layer.borderColor = GGMainColor.CGColor;
    
    if (_receiptGoodsCount == 0) {
        _receiptGoodsLabel.hidden = YES;
    }
    
    [receiptGoodsBtn addSubview:_receiptGoodsLabel];

    
    
    [barView addSubview:totalBtn];
    [barView addSubview:obligationBtn];
    [barView addSubview:receiptGoodsBtn];

    
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 40-2, (GGUISCREENWIDTH-20)/3, 2)];
    _lineView.backgroundColor = GGMainColor;
    [barView addSubview:_lineView];
    [self.view addSubview:barView];


}
-(void)btnClick :(UIButton *)button{
    _pageNum = (int)button.tag - 15000;
    [self changeView];
}
-(void)createScrollView{

    //设置scrollview
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 40, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40);
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(GGUISCREENWIDTH * 3, 0);
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
    

    
    _receiptGoodsView = [[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH*2, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40)];
    _receiptGoodsView.backgroundColor = GGBgColor;
    [_scrollView addSubview:_receiptGoodsView];
    



}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        _pageNum =  scrollView.contentOffset.x/GGUISCREENWIDTH;
        [self changeView];
    }
}

- (void) changeView{
    [self requestData];
    _tableView.contentOffset = CGPointMake(0, 0);
    if(_pageNum==0){//全部
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.frame = CGRectMake(10, 40-2, (GGUISCREENWIDTH-20)/3, 2);
        }];
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }else if(_pageNum==1){//待付款
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)/3, 40-2, (GGUISCREENWIDTH-20)/3, 2);
        }];
        _scrollView.contentOffset = CGPointMake(GGUISCREENWIDTH, 0);

        
    }else if(_pageNum==2){
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)*2/3, 40-2, (GGUISCREENWIDTH-20)/3, 2);
        }];
        _scrollView.contentOffset = CGPointMake(GGUISCREENWIDTH * 2, 0);
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)backViewController{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[GoodsDetailViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            break;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
}
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.backgroundColor = GGBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(((MyOrderData *)_data[indexPath.row]).skuArray.count==1){
        static NSString *identifierOne = @"cellOneID";
        MyOrderOneCell *cell = (MyOrderOneCell*)[tableView dequeueReusableCellWithIdentifier: identifierOne];
        if(cell == nil){
            cell = [[MyOrderOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierOne];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.delegate = self;
        }
        
        cell.data = _data[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *identifierMore = @"cellMoreID";
        MyOrderMoreCell *cell1 = (MyOrderMoreCell*)[tableView dequeueReusableCellWithIdentifier: identifierMore];
        if(cell1 == nil){
            cell1 = [[MyOrderMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierMore];
            cell1.accessoryType = UITableViewCellAccessoryNone;
            cell1.delegate = self;
        }
        
        cell1.data = _data[indexPath.row];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ((MyOrderData *)_data[indexPath.row]).cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectOrderId = ((MyOrderData *)_data[indexPath.row]).orderInfo.orderId;
    [self requestData];
    

}
//代理方法
-(void)checkOrder:(MyOrderData *)orderData{
    NSString * urlString =  [NSString stringWithFormat:@"%@%ld",[HSGlobal checkOrderUrl],orderData.orderInfo.orderId];
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];

    [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            PayViewController * pay = [[PayViewController alloc]init];
            pay.orderId = orderData.orderInfo.orderId;
            pay.payType = @"item";
            [self.navigationController pushViewController:pay animated:YES];
            
        }else{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            [self requestData];
        }
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"请求订单数据失败"];
    }];

}

-(void)backController{
    [self requestData];
}
@end
