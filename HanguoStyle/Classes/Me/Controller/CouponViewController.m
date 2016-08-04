//
//  CouponViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/26.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponData.h"
#import "MyCouponCell.h"
@interface CouponViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    int Ncount;
    int Ycount;
    int Scount;
    UIButton * totalBtn;
    UIButton * obligationBtn;
    UIButton * receiptGoodsBtn;
}
@property (nonatomic) UIScrollView * scrollView;
@property (nonatomic) UIView * lineView;

@property (nonatomic) UIView * totalView;//全部
@property (nonatomic) UIView * obligationView;//已使用
@property (nonatomic) UIView * receiptGoodsView;//未使用
@property (nonatomic) int pageNum;
@property (nonatomic) UITableView * tableView;
@property (nonatomic) UIView * bgView;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.view.backgroundColor = GGBgColor;
    _scrollView.scrollsToTop = NO;
    self.navigationItem.title = @"优惠券";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createHeadView];
    [self createScrollView];
    _data = [NSMutableArray array];
    [self createTableView];
    [self requestData];
    [self createNoCouponView];
    
    
}
-(void)createNoCouponView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
    _bgView.backgroundColor = GGBgColor;
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH -162)/2, GGUISCREENHEIGHT/8, 162, 190)];
    bgImageView.image = [UIImage imageNamed:@"no_coupon"];
    [_bgView addSubview:bgImageView];
}
-(void)requestData{
    NSString * urlString = [HSGlobal couponUrl];
    
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
        NSArray * dataArray = [object objectForKey:@"coupons"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
        if(code == 200){
            Ncount = 0;
            Ycount = 0;
            Scount = 0;
            [self.data removeAllObjects];
            for (id node in dataArray) {
                CouponData * data = [[CouponData alloc] initWithJSONNode:node];
                if (_pageNum == 0 && [data.state isEqualToString:@"N"]) {//未使用
                    [_data addObject:data];
                }else if(_pageNum == 1 && [data.state isEqualToString:@"Y"]){//已使用
                    [_data addObject:data];
                }else if(_pageNum == 2 && [data.state isEqualToString:@"S"]){//已过期
                    [_data addObject:data];
                }
                
                
                if ([data.state isEqualToString:@"N"]) {//未使用
                    Ncount++;
                }else if([data.state isEqualToString:@"Y"]){//已使用
                    Ycount++;
                }else if([data.state isEqualToString:@"S"]){//已过期
                    Scount++;
                }
            }
            [totalBtn setTitle:[NSString stringWithFormat:@"未使用(%d)",Ncount] forState:UIControlStateNormal];
            [obligationBtn setTitle:[NSString stringWithFormat:@"已使用(%d)",Ycount] forState:UIControlStateNormal];
            [receiptGoodsBtn setTitle:[NSString stringWithFormat:@"已过期(%d)",Scount] forState:UIControlStateNormal];
            
            [self.tableView reloadData];
            if (_pageNum == 0) {
                [totalBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
                [obligationBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
                [receiptGoodsBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];

                [_totalView addSubview:_tableView];
                [_totalView addSubview:_bgView];
                if(self.data.count == 0){
                    _bgView.hidden = NO;
                }else{
                    _bgView.hidden = YES;
                }
                
            }else if(_pageNum == 1){
                [totalBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
                [obligationBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
                [receiptGoodsBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
                [_obligationView addSubview:_tableView];
                [_obligationView addSubview:_bgView];
                if(self.data.count == 0){
                    _bgView.hidden = NO;
                }else{
                    _bgView.hidden = YES;
                }
                
            }else if(_pageNum == 2){
                [totalBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
                [obligationBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
                [receiptGoodsBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
                [_receiptGoodsView addSubview:_tableView];
                [_receiptGoodsView addSubview:_bgView];
                if(self.data.count == 0){
                    _bgView.hidden = NO;
                }else{
                    _bgView.hidden = YES;
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
    
    
    totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.tag = 15000;
    totalBtn.frame = CGRectMake(10, 10, (GGUISCREENWIDTH-20)/3, 20);
    [totalBtn setTitle:@"未使用" forState:UIControlStateNormal];
    [totalBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
    totalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [totalBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    obligationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    obligationBtn.tag = 15001;
    obligationBtn.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)/3, 10, (GGUISCREENWIDTH-20)/3, 20);
    [obligationBtn setTitle:@"已使用" forState:UIControlStateNormal];
    [obligationBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
    obligationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [obligationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    receiptGoodsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    receiptGoodsBtn.tag= 15002;
    receiptGoodsBtn.frame = CGRectMake(10 + (GGUISCREENWIDTH-20)*2/3, 10, (GGUISCREENWIDTH-20)/3, 20);
    [receiptGoodsBtn setTitle:@"已过期" forState:UIControlStateNormal];
    [receiptGoodsBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
    receiptGoodsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [receiptGoodsBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
    _scrollView.frame = CGRectMake(0, 45, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40-5);
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(GGUISCREENWIDTH * 3, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _totalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40-5)];
    _totalView.backgroundColor = GGBgColor;
    [_scrollView addSubview:_totalView];
    
    _obligationView = [[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40-5)];
    _obligationView.backgroundColor = GGBgColor;
    [_scrollView addSubview:_obligationView];
    
    
    
    _receiptGoodsView = [[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH*2, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40-5)];
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
    
    if(_pageNum==0){
        
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.frame = CGRectMake(10, 40-2, (GGUISCREENWIDTH-20)/3, 2);
        }];
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }else if(_pageNum==1){//
        
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


-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40-5) style:UITableViewStylePlain];
    _tableView.backgroundColor = GGBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"MyCouponCell" bundle:nil] forCellReuseIdentifier:@"MyCouponCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponCell" forIndexPath:indexPath];
    cell.data = _data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return (GGUISCREENWIDTH-20)*130/356 + 15;
    return 145;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)backController{
    [self requestData];
}
@end
