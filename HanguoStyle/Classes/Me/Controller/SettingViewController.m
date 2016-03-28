//
//  SettingViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/14.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "SettingViewController.h"
#import "ResetButton.h"
#import "AboutOurViewController.h"
#import "FeedbackViewController.h"
#import <SDImageCache.h>
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation SettingViewController
@synthesize tableView = tableView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = GGColor(240, 240, 240);
    [self createSettingView];
}
-(void)createSettingView{
<<<<<<< HEAD

    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT) style:UITableViewStylePlain];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.bounces = YES;
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.showsHorizontalScrollIndicator = NO;
    tableView_.showsVerticalScrollIndicator = NO;
    tableView_.bounces = NO;
    [self.view addSubview:tableView_];
    
    
    
=======
    ResetButton   * aboutBtn = [ResetButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(10, 64, GGUISCREENWIDTH, 40);
    [aboutBtn setTitle:@"关于我们" forState:UIControlStateNormal];
    aboutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [aboutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aboutBtn setImage:[UIImage imageNamed:@"about_us"] forState:UIControlStateNormal];
>>>>>>> 10f53d2066dc4c0f012484952343c904ff8a6761
    
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 50)];
//    footerView.backgroundColor = [UIColor redColor];
        BOOL isLogin = [PublicMethod checkLogin];
    
        if(isLogin){
            UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            exitBtn.frame = CGRectMake(10, 10, GGUISCREENWIDTH-20, 30);
            exitBtn.backgroundColor = GGMainColor;
            [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
            exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
            [footerView addSubview:exitBtn];
    
        }
    
    tableView_.tableFooterView = footerView;

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifyID = @"meCell";
    UITableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:indentifyID];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:indentifyID];
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
        UIView  * viBg = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, GGUISCREENWIDTH, 0.5)];
        viBg.backgroundColor = UIColorFromRGB(0x8a8a8a);
        [cell.contentView addSubview:viBg];
        
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"关于我们"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_us"]];
                    iv.frame = CGRectMake(18, 19, 18, 18);
                    //                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:iv];
                }
                    break;
                    
                case 1: {
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"意见反馈"];

                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"opinion"]];
                    iv.frame = CGRectMake(18, 19, 18, 18);
                    [cell.contentView addSubview:iv];
                }
                    break;
                    
                case 2:{
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"联系客服"];
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact-us"]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    iv.frame = CGRectMake(18, 19, 18, 18);
                    [cell.contentView addSubview:iv];

                }
                    break;
                    
                case 3: {
                    
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@",@"清除缓存"];
                    NSUInteger count = [[SDImageCache sharedImageCache]getSize];
                    
//                     NSLog(@"%ld",count);
                    NSUInteger lastCount = count/(1024.f);
//                    NSLog(@"%ld",lastCount);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldKB",lastCount];
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clean"]];
                    iv.frame = CGRectMake(18, 19, 18, 18);
                    [cell.contentView addSubview:iv];
                }
                    break;
                    
                case 4: {
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"版本号"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)", kSAAPPVERSION, kSABUILDVERSION];
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"System-update"]];
                    iv.frame = CGRectMake(18, 19, 18, 18);
                    [cell.contentView addSubview:iv];
                }
                    break;
            }
            break;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
//                    关于我们
                    AboutOurViewController * vc = [[AboutOurViewController alloc]init];
                    vc.url =@"https://api.hanmimei.com/comm/views/about";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 1: {
//                    意见反馈
                    FeedbackViewController * vc = [FeedbackViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 2: {
                    //联系客服
                    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"18500041543"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

                }
                    break;
                    
                case 3: {
                    //清除缓存
                    [self clearTmpPics];
                }
                    break;
                    
                case 4: {
                    //版本号
                }
                    break;
                    
                default: {
                    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                                  animated:NO];
                }
                    break;
            }
        }
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}




-(void)exitBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expired"];
//    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"haveLoseTokenOnce"];
    [self.delegate backMeFromSetting];
    [self.navigationController popViewControllerAnimated:YES];
    //修改购物车tabbar的badgeValue
    PublicMethod * pm = [[PublicMethod alloc]init];
    [pm sendCustNum];
}


#pragma 清理缓存图片

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.labelFont = [UIFont systemFontOfSize:11];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"清除缓存成功!";
    [hud hide:YES afterDelay:1];
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:1];
}
-(void)reloadData
{
    [tableView_ reloadData];
}

@end
