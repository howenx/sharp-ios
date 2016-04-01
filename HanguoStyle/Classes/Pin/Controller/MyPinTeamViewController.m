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
@interface MyPinTeamViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,MyPinTeamCellDelegate>
{
    UILabel * emptyLab;
}
@property (nonatomic) UITableView * tableView;
@property (nonatomic) UIScrollView * scrollView;
@property (nonatomic) UIView * lineView;
@property (nonatomic) UIView * totalView;//我的开团
@property (nonatomic) UIView * obligationView;//我的参团

@property (nonatomic) int pageNum;
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
    self.navigationItem.title=@"我的拼团";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.data = [NSMutableArray array];
    [self createHeadView];
    [self createScrollView];
    [self createTableView];
    [self requestData];
    emptyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (GGUISCREENHEIGHT-104)/2-40, GGUISCREENWIDTH, 40)];
    emptyLab.textAlignment = NSTextAlignmentCenter;
    emptyLab.textColor = [UIColor grayColor];
    emptyLab.font = [UIFont systemFontOfSize:15];
    emptyLab.text =@"暂无拼团商品";

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
    _totalView.backgroundColor = GGColor(240, 240, 240);
    [_scrollView addSubview:_totalView];
    
    _obligationView = [[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40)];
    _obligationView.backgroundColor = GGColor(240, 240, 240);
    [_scrollView addSubview:_obligationView];
    
    
}
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.backgroundColor = GGColor(240, 240, 240);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"MyPinTeamCell" bundle:nil] forCellReuseIdentifier:@"MyPinTeamCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
}
@end
