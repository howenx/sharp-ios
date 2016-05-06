//
//  AssessListViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "AssessListViewController.h"
#import "AssessListData.h"
#import "AssessListCell.h"

@interface AssessListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray * data;
@end

@implementation AssessListViewController
- (void)viewWillAppear:(BOOL)animated{
    [self headerRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价中心";
    _tableView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"AssessListCell" bundle:nil] forCellReuseIdentifier:@"AssessListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.data = [NSMutableArray array];
    
    
    //左上角添加按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,10,20)];
    [leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
    self.backButtonBlock(nil);
}

-(void)headerRefresh{
    NSString * url = [NSString stringWithFormat:@"%@%@",[HSGlobal assessCenterUrl],_orderId];
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.data removeAllObjects];
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        if(code == 200){
            NSArray * dataArray = [object objectForKey:@"orderRemark"];
            for (id node in dataArray) {
                AssessListData * data = [[AssessListData alloc] initWithJSONNode:node];
                [self.data addObject:data];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AssessListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AssessListCell" forIndexPath:indexPath];
    cell.data = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
