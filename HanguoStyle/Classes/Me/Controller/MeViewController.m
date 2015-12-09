//
//  MeViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MeViewController.h"
#import "MeCell.h"
#import "MeData.h"
#import "AddressViewController.h"
#import "HSGlobal.h"
#import "MineData.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UpdateUserInfoViewController.h"
#import "LoginViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UpdateUserInfoDelegate>
{
    MineData * mineData;
    MBProgressHUD * HUD;
    BOOL isFromUpdate;
    UIImage * updateImage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated{
    BOOL isLogin = [HSGlobal checkLogin];
    if(isLogin){
        HUD = [HSGlobal getHUD:self];
        [HUD show:YES];
        self.tableView.delegate =self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.data = [NSMutableArray array];
        [self setTableViewDataSource];
        [self footerRefresh];
    }else{
        LoginViewController * login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:NO];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void) footerRefresh
{
    NSString * url = [HSGlobal mineUrl];
    
    AFHTTPRequestOperationManager * manager = [HSGlobal shareRequestManager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * node = [object objectForKey:@"userInfo"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"message= %@",message);
        mineData = [[MineData alloc] initWithJSONNode:node];
        [self createHeadScrollView];
        [self.tableView reloadData];
        [HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        [HSGlobal printAlert:@"数据加载失败"];
    }];
}


- (void)createHeadScrollView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 170)];
    headView.backgroundColor = GGColor(254, 99, 108);
    //设置头像
    UIButton * photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(GGUISCREENWIDTH/2-80/2, 30, 80, 80);
    //修改头像时候，返回要等待一会，以为服务器那边的图片还没准备好
    if(!isFromUpdate || updateImage == nil){
        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:mineData.photo]];
        UIImage *image = [[UIImage alloc]initWithData:data];
        [photoBtn setImage:image forState:UIControlStateNormal];
    }else{
        [photoBtn setImage:updateImage forState:UIControlStateNormal];
        isFromUpdate = NO;
        updateImage = nil;
    }
    [photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn.layer setMasksToBounds:YES];
    [photoBtn.layer setCornerRadius:40.0];
    
    UIImageView * genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 25, 30, 30)];
    if([@"M" isEqualToString: mineData.gender]){
        genderImageView.image = [UIImage imageNamed:@"icon_nan"];
    }else if([@"F" isEqualToString: mineData.gender]){
        genderImageView.image = [UIImage imageNamed:@"icon_nv"];
    }
    
    
    [photoBtn addSubview:genderImageView];
    
    
    
    [headView addSubview:photoBtn];
    
    //设置身份证绑定
//    UIImageView * sfzImageView = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH/2-100/2, 130, 20, 20)];
//    sfzImageView.image =[UIImage imageNamed:@"icon_authenticate"];
//    [headView addSubview:sfzImageView];
//    if([@"Y" isEqualToString: mineData.realYn]){
//        UILabel * sfzLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH/2-100/2 +22, 130, 50, 20)];
//        sfzLabel.font = [UIFont systemFontOfSize:11];
//        sfzLabel.textColor = [UIColor whiteColor];
//        sfzLabel.text= @"身份证已绑定";
//        [headView addSubview:sfzLabel];
//    }else if([@"N" isEqualToString: mineData.realYn]){
//        UIButton * sfzButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        sfzButton.frame = CGRectMake(GGUISCREENWIDTH/2-100/2 +22, 130, 70, 20);
//        sfzButton.titleLabel.textColor = [UIColor whiteColor];
//        sfzButton.titleLabel.font = [UIFont systemFontOfSize:11];
//        [sfzButton setTitle:@"身份证未绑定" forState: UIControlStateNormal];
//        [sfzButton addTarget:self action:@selector(sfzBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [headView addSubview:sfzButton];
//    }
    
    //设置身份证绑定
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, GGUISCREENWIDTH-20, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text= mineData.name;
    [headView addSubview:titleLabel];
    
    //设置名字
    _tableView.tableHeaderView = headView;
    
    
    
}

-(void)photoBtnClick{
    
    UpdateUserInfoViewController * updateUserController = [[UpdateUserInfoViewController alloc]init];
    updateUserController.delegate = self;
    updateUserController.userName = mineData.name;
    if([@"M" isEqualToString:mineData.gender]){
        updateUserController.gender = @"男";
    }else if([@"F" isEqualToString:mineData.gender]){
        updateUserController.gender = @"女";
    }
    
    [self.navigationController pushViewController:updateUserController animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeCell *cell  = [MeCell subjectCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = self.data[indexPath.section];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =  GGColor(240, 240, 240);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到商品展示页面
    [self pushGoodShowView:indexPath.section];
}
-(void)pushGoodShowView :(NSInteger)index{
    if(index == 3){
        AddressViewController * adViewController = [[AddressViewController alloc]init];
        [self.navigationController pushViewController:adViewController animated:YES];
    }
   
}
-(void)setTableViewDataSource{
    MeData * meData0 = [[MeData alloc]init];
    meData0.title = @"我的订单";
    meData0.iconImage = @"icon_dingdan";
    [_data addObject:meData0];
    
    MeData * meData1 = [[MeData alloc]init];
    meData1.title = @"优惠券";
    meData1.iconImage = @"icon_youhuiquan";
    [_data addObject:meData1];
    
    MeData * meData2 = [[MeData alloc]init];
    meData2.title = @"补填身份证";
    meData2.iconImage = @"icon_shenfenzheng";
    [_data addObject:meData2];
    
    MeData * meData3 = [[MeData alloc]init];
    meData3.title = @"管理收货地址";
    meData3.iconImage = @"icon_address";
    [_data addObject:meData3];
    
    MeData * meData4 = [[MeData alloc]init];
    meData4.title = @"关于身份证";
    meData4.iconImage = @"icon_about";
    [_data addObject:meData4];
}
-(void)backIcon:(UIImage *)image{
    isFromUpdate = YES;
    updateImage = image;
}

@end
