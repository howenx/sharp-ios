//
//  MessageViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/4/6.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "LoginViewController.h"
#import "SystemMessageViewController.h"
#import "UIBarButtonItem+GG.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MessageViewController
@synthesize tableView = tableView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = GGColor(240, 240, 240);
    


}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self createSettingView];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back" target:self action:@selector(backViewController)];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icongengduo"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [self setModel];
    
}
-(void)rightBarButton:(UIBarButtonItem *)bar
{
    //全部删除
    UIAlertView *alertView = [[ UIAlertView alloc ] initWithTitle : @"提示" message : @" 全部删除?" delegate : self cancelButtonTitle : @" 删除 " otherButtonTitles : @" 取消 " , nil ];
    
    [alertView show ];
}


-(void)setModel{
        NSString * urlString =[HSGlobal messageListUrl];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        if(manager == nil){
            NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
            noNetView.delegate = self;
            [self.view addSubview:noNetView];
            return;
        }
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];

    
    
        //    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:genderFlag,@"gender",encodeImage,@"photoUrl",nil];
        [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);

            if(200 == code){

                
                NSArray * array =  [object objectForKey:@"msgTypeDTOList"];
                
                if (array.count<=0) {
                
                    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
                    bgImageView.image = [UIImage imageNamed:@"message_wu"];
                    [self.view addSubview:bgImageView];
                     [GiFHUD dismiss];
                    return ;
                }
            
                self.arrayData = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in array) {
                    self.messageModel = [MessageModel yy_modelWithDictionary:dict];
                    [self.arrayData addObject:self.messageModel];
                }
                [tableView_ reloadData];
            }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                
                    hud.labelFont = [UIFont systemFontOfSize:11];
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];

    
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
//    tableView_.bounces = NO;
    [self.view addSubview:tableView_];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"messageCell";
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell setData:[self.arrayData objectAtIndex:indexPath.row] Row:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138/2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel * messageModel = [[MessageModel alloc]init];
    messageModel = [self.arrayData objectAtIndex:indexPath.row];
    SystemMessageViewController * vc = [[SystemMessageViewController alloc]init];
    vc.messageType = messageModel.msgType;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)backViewController
{
    
    self.selectButtonBlock(nil);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
