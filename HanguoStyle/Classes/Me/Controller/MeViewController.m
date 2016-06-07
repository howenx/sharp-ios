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
#import "MineData.h"
#import "UpdateUserInfoViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MyOrderViewController.h"
#import "CouponViewController.h"
#import "MyPinTeamViewController.h"
#import "CollectViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UpdateUserInfoDelegate,SettingDelegate>
{
    MineData * mineData;
    BOOL agoIsLogin;
    UIView * headView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIButton * titleBtn;
@property (nonatomic) UIImageView * photoBtn;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImageView * genderImageView;

@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [GiFHUD dismiss];

    //下面这段逻辑是当上一次进到我的页面的时候是未登录，然后在购物车页面登陆，再次点击我的页面，让他进入到登陆状态
    
    if(!agoIsLogin){
        BOOL isLogin = [PublicMethod checkLogin];
        if(isLogin){
            [self progessIn];
        }
    }
    agoIsLogin = [PublicMethod checkLogin];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的信息";
    
    [self progessIn];
    
}
-(void)progessIn{
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.data = [NSMutableArray array];
    [self setTableViewDataSource];
    BOOL isLogin = [PublicMethod checkLogin];
    agoIsLogin = [PublicMethod checkLogin];
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 200)];
    headView.backgroundColor = GGMainColor;
    [self.view addSubview:headView];

    if(isLogin){
        [self footerRefresh];
    }else{
        [self createHeadView];
    }
    
}
- (void) footerRefresh
{
    
    NSString * url = [HSGlobal mineUrl];
    
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
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * node = [object objectForKey:@"userInfo"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            mineData = [[MineData alloc] initWithJSONNode:node];
            [self.tableView reloadData];
        }
        [self createHeadView];
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
    }];
}


- (void)createHeadView{

    //设置头像
    _photoBtn = [[UIImageView alloc]init];
    _photoBtn.frame = CGRectMake(GGUISCREENWIDTH/2-80/2, 60, 80, 80);

    
    BOOL isLogin = [PublicMethod checkLogin];
    
    if(isLogin){

//        [_photoBtn sd_setImageWithURL:[NSURL URLWithString:mineData.photo]];
        [_photoBtn sd_setImageWithURL:[NSURL URLWithString:mineData.photo] placeholderImage:[UIImage imageNamed:@"icon_default_header"]];

    }else{
        _image =[UIImage imageNamed:@"icon_default_header"];
        [_photoBtn setImage:_image];
    }
    //添加单击手势
    _photoBtn.userInteractionEnabled=YES;
    [_photoBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoBtnClick)]];

    [_photoBtn.layer setMasksToBounds:YES];
    [_photoBtn.layer setCornerRadius:40.0];
    

    [headView addSubview:_photoBtn];
    
    
    UIButton * settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(GGUISCREENWIDTH-60, 30, 40, 40);
    settingBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [settingBtn setImage:[UIImage imageNamed:@"icon_set"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:settingBtn];
    
    
    NSString * name;
    if(isLogin){
        name = mineData.name;
    }else{
        name = @"登录/注册";
    }
    CGSize textMaxSize = CGSizeMake(GGUISCREENWIDTH-40, 20);

    CGSize textRealSize =  [name boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectMake((GGUISCREENWIDTH-textRealSize.width)/2, 160, textRealSize.width, 20);
    [_titleBtn setTitle:name  forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [headView addSubview:_titleBtn];
    
    
    
    
    if(isLogin){
        _genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_titleBtn.x+_titleBtn.width+10, 160, 15, 15)];
        if([@"M" isEqualToString: mineData.gender]){
            _genderImageView.image = [UIImage imageNamed:@"icon_nan"];
        }else if([@"F" isEqualToString: mineData.gender]){
            _genderImageView.image = [UIImage imageNamed:@"icon_nv"];
        }
        [headView addSubview:_genderImageView];
    }

    //设置名字
//    _tableView.tableHeaderView = headView;
  
}
-(void)settingBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    SettingViewController * settingViewController = [[SettingViewController alloc]init];
    settingViewController.delegate =self;
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}
-(void)photoBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    BOOL isLogin = [PublicMethod checkLogin];
    if(isLogin){
        UpdateUserInfoViewController * updateUserController = [[UpdateUserInfoViewController alloc]init];
        updateUserController.delegate = self;
        updateUserController.userName = mineData.name;
        _image = _photoBtn.image;
        updateUserController.comeImage = _image;
        if([@"M" isEqualToString:mineData.gender]){
            updateUserController.gender = @"男";
        }else if([@"F" isEqualToString:mineData.gender]){
            updateUserController.gender = @"女";
        }
        
        [self.navigationController pushViewController:updateUserController animated:YES];
    }else{
        LoginViewController * login = [[LoginViewController alloc]init];
        login.comeFrom = @"MeVC";
        [self.navigationController pushViewController:login animated:YES];
    }
    
    
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
    headerView.backgroundColor =  GGBgColor;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isLogin = [PublicMethod checkLogin];
    if(isLogin){
        [self pushGoodShowView:indexPath.section];
    }else{
        LoginViewController * login = [[LoginViewController alloc]init];
        login.comeFrom = @"MeVC";
        [self.navigationController pushViewController:login animated:NO];
    }
    
}
-(void)pushGoodShowView :(NSInteger)index{
    
    if(index == 0){
        MyOrderViewController * myOrder = [[MyOrderViewController alloc]init];
        [self.navigationController pushViewController:myOrder animated:YES];
    }
    if(index == 1){
        MyPinTeamViewController * pinOrder = [[MyPinTeamViewController alloc]init];
        [self.navigationController pushViewController:pinOrder animated:YES];
    }
    if(index == 2){
        CollectViewController * collect = [[CollectViewController alloc]init];
        [self.navigationController pushViewController:collect animated:YES];
    }
    if(index == 3){
        CouponViewController * coupon = [[CouponViewController alloc]init];
        [self.navigationController pushViewController:coupon animated:YES];
    }
    if(index == 4){
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
    meData1.title = @"我的拼团";
    meData1.iconImage = @"icon_pintuan";
    [_data addObject:meData1];
    
    
    MeData * meData2 = [[MeData alloc]init];
    meData2.title = @"我的收藏";
    meData2.iconImage = @"icon_collection";
    [_data addObject:meData2];
    
    MeData * meData3 = [[MeData alloc]init];
    meData3.title = @"优惠券";
    meData3.iconImage = @"icon_coupon";
    [_data addObject:meData3];
    

    MeData * meData4 = [[MeData alloc]init];
    meData4.title = @"管理收货地址";
    meData4.iconImage = @"icon_address1";
    [_data addObject:meData4];

}
-(void)backIcon:(UIImage *)image andName:(NSString *)name andSex:(NSString *)sex{

    [_photoBtn setImage:image];
    
    
    
    CGSize textMaxSize = CGSizeMake(GGUISCREENWIDTH-40, 20);
    
    CGSize textRealSize =  [name boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
    

    _titleBtn.frame = CGRectMake((GGUISCREENWIDTH-textRealSize.width)/2, 160, textRealSize.width, 20);
    [_titleBtn setTitle:name forState:UIControlStateNormal];
    _image = image;
    
    _genderImageView.frame = CGRectMake(_titleBtn.x+_titleBtn.width+10, 160, 20, 20);
    if([@"男" isEqualToString: sex]){
        _genderImageView.image = [UIImage imageNamed:@"icon_nan"];
        mineData.gender = @"M";
    }else if([@"女" isEqualToString: sex]){
        _genderImageView.image = [UIImage imageNamed:@"icon_nv"];
        mineData.gender = @"F";
    }
    mineData.name = name;
    

}

-(void) backMeFromSetting{
    [self createHeadView];
}
-(void)backController{
    [self footerRefresh];
}
@end
