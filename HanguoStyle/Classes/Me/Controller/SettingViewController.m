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
#import <StoreKit/StoreKit.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong, readwrite) MFMailComposeViewController *mailVC;
@end

@implementation SettingViewController
@synthesize tableView = tableView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = GGBgColor;
    [self createSettingView];
}
-(void)createSettingView{
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
    
    
//    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 50)];
//    //    footerView.backgroundColor = [UIColor redColor];
//    BOOL isLogin = [PublicMethod checkLogin];
//    
//    if(isLogin){
//        UIButton * exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        exitBtn.frame = CGRectMake(10, 20, GGUISCREENWIDTH-20, 35);
//        [exitBtn.layer setMasksToBounds:YES];
//        [exitBtn.layer setCornerRadius:4];
//        exitBtn.backgroundColor = GGMainColor;
//        [exitBtn setTitle:@"退 出" forState:UIControlStateNormal];
//        exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [exitBtn setTitleColor:GGTextBlackColor forState:UIControlStateNormal];
//        [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        
//        [footerView addSubview:exitBtn];
//        
//    }
//    
//    tableView_.tableFooterView = footerView;
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
        viBg.backgroundColor = GGBgColor;
        [cell.contentView addSubview:viBg];
        
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"关于我们"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_us"]];
                    iv.frame = CGRectMake(18, (50-18)/2, 18, 18);
                    //                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:iv];
                }
                    break;
                    
                case 1: {
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"意见反馈"];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"opinion"]];
                    iv.frame = CGRectMake(18, (50-18)/2, 18, 18);
                    [cell.contentView addSubview:iv];
                }
                    break;
                    
                case 2:{
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"联系客服"];
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact-us"]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    iv.frame = CGRectMake(18, (50-18)/2, 18, 18);
                    [cell.contentView addSubview:iv];
                    
                }
                    break;
                    
                case 3: {
                    
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@",@"清除缓存"];
                    NSUInteger count = [[SDImageCache sharedImageCache]getSize];
                    
                    //                     NSLog(@"%ld",count);
                    NSUInteger lastCount = count/(1024.f);
                    //                    NSLog(@"%ld",lastCount);
                    
                    if (lastCount>1024) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fM",lastCount/1024.0];
                    }else
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldKB",lastCount];
                    }
                    
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clean"]];
                    iv.frame = CGRectMake(18, (50-18)/2, 18, 18);
                    [cell.contentView addSubview:iv];
                }
                    break;
                    
                case 4: {
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"版本号"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", kSAAPPVERSION];
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"System-update"]];
                    iv.frame = CGRectMake(18, (50-18)/2, 18, 18);
                    [cell.contentView addSubview:iv];
                }
                    break;
                    
                case 5: {
                    cell.textLabel.text = [NSString stringWithFormat:@"            %@", @"评分"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark"]];
                    iv.frame = CGRectMake(18, (50-18)/2, 18, 18);
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
                    vc.url =[NSString stringWithFormat:@"%@/comm/views/about",[HSGlobal shareGoodsHeaderUrl]];//@"https://api.hanmimei.com/comm/views/about";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 1: {
                    //                    意见反馈
                    FeedbackViewController * vc = [FeedbackViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                   
                    /*
                    if ([self canSendMail])
                    {
                        
                        if (_mailVC == nil) {
                            [self createMailComposeViewController];
                        }
                        
                        if (IOS7)
                        {
                            [[self.mailVC navigationBar] setTintColor:[UIColor blackColor]];
                            
                            [self presentViewController:self.mailVC animated:YES completion:^{
                                //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                            }];
                            //        [self.navigationController pushViewController:self.mailVC animated:NO];
                        }
                        else
                        {
                            [self presentViewController:self.mailVC animated:YES completion:nil];
                        }
                        
                        
                        
                    }else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"请在手机里面配置邮箱服务!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }

                    */
                    
                }
                    break;
                    
                case 2: {
                    //联系客服
                    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"010-53678808"];
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
                case 5: {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1137893817"]];
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




//-(void)exitBtnClick{
//    if(![PublicMethod isConnectionAvailable]){
//        return;
//    }
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userToken"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expired"];
//    //    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"haveLoseTokenOnce"];
//    [self.delegate backMeFromSetting];
//    [self.navigationController popViewControllerAnimated:YES];
//    //修改购物车tabbar的badgeValue
//    PublicMethod * pm = [[PublicMethod alloc]init];
//    [pm sendCustNum];
//}


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

#pragma 评分

- (void)evaluate{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"1137893817"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)reloadData
{
    [tableView_ reloadData];
}


- (BOOL)canSendMail
{
    return [MFMailComposeViewController canSendMail];
}


- (void)createMailComposeViewController
{
    if (!self.canSendMail) {
        return;
    }
    
    NSString *content = [NSString stringWithFormat:@"\n"
                         "\n"
                         "User: %@\n"
                         "iOS Version: %@\n"
                         "Platform: %@\n"
                         "HMM iOS App "
                         "Version: %@\n",
                         [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],
                         [[UIDevice currentDevice] systemVersion],
                         [[UIDevice currentDevice] model],
                         [NSString stringWithFormat:@"%@(%@)", kSAAPPVERSION, kSABUILDVERSION]];
    
    
    self.mailVC = [[MFMailComposeViewController alloc] init];
    self.mailVC.mailComposeDelegate = self;
    [self.mailVC setMessageBody:content isHTML:NO];
    [self.mailVC setTitle:@"HMM iOS Feedbac"];
    [self.mailVC setSubject:@"HMM iOS Feedback"];
    [self.mailVC setToRecipients:[[NSArray alloc] initWithObjects:@"services@hanmimei.com", nil]];
}

#pragma mark - - cell click event
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    if (MFMailComposeResultSent == result) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"正在发送..."];
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }else if (result == MFMailComposeResultSaved)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"保存邮件."];
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }else if (result == MFMailComposeResultFailed)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"发送错误."];
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }
    
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
    
    _mailVC = nil;
}


@end
