//
//  SystemMessageViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/4/7.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "MessageTypeSystemTableViewCell.h"
#import "MessageTypeLogisticsTableViewCell.h"
#import "MessageTypeDiscountTableViewCell.h"
#import "MessageTypeCouponTableViewCell.h"
#import "MessageTypeGoodsTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "PinGoodsDetailViewController.h"
#import "PinDetailViewController.h"
@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SystemMessageViewController
@synthesize tableView = tableView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    
    
    
    if ([self.messageType isEqualToString:@"system"]) {
        self.navigationItem.title = @"系统通知";
    }
    if ([self.messageType isEqualToString:@"discount"]) {
        self.navigationItem.title = @"商品提醒";
    }
    if ([self.messageType isEqualToString:@"coupon"]) {
            self.navigationItem.title = @"优惠促销";
    }
    if ([self.messageType isEqualToString:@"logistics"]) {
            self.navigationItem.title = @"物流通知";
    }
    if ([self.messageType isEqualToString:@"goods"]) {
            self.navigationItem.title = @"我的资产";
    }
    
    

    self.view.backgroundColor = GGColor(240, 240, 240);
    
    
    [self createSettingView];
    [self setModel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //右侧按钮
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconshezhi"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)rightBarButton:(UIBarButtonItem *)bar
{
    //全部删除
    UIAlertView *alertView = [[ UIAlertView alloc ] initWithTitle : @"提示" message : @" 全部删除?" delegate : self cancelButtonTitle : @" 删除 " otherButtonTitles : @" 取消 " , nil ];
    
    [alertView show ];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.arrayData removeAllObjects];
        [tableView_ removeFromSuperview];
        
        
        if (_arrayData.count<=0) {
            UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
            bgImageView.image = [UIImage imageNamed:@"icon_delete"];
            [self.view addSubview:bgImageView];
        }
        
        
        NSString * urlString =[NSString stringWithFormat:@"%@%@",[HSGlobal deleteMessageListType],self.messageType];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            
            if(200 == code){
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"删除成功";
                [hud hide:YES afterDelay:1];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"删除失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"删除失败"];
            
        }];
    
        
        
        
    }
}



-(void)setModel{
    NSString * urlString =[NSString stringWithFormat:@"%@%@",[HSGlobal messageListType],self.messageType];
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
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSLog(@"code= %ld",(long)code);
        NSLog(@"message= %@",message);
        
        if(200 == code){
            
            NSArray * array =  [object objectForKey:@"msgList"];
            self.arrayData = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in array) {
                self.messageModel = [MessageTypeModel yy_modelWithDictionary:dict];
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
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64) style:UITableViewStylePlain];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.bounces = YES;
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.showsHorizontalScrollIndicator = NO;
    tableView_.showsVerticalScrollIndicator = NO;
    //    tableView_.bounces = NO;
    tableView_.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:tableView_];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%--------ld",self.arrayData.count);
    return self.arrayData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.messageType isEqualToString:@"system"]) {
        static NSString * ID = @"messagesystemCell";
        MessageTypeSystemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell = [[MessageTypeSystemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.messageModel = [self.arrayData objectAtIndex:indexPath.row];
        return cell;
    }
    
    if ([self.messageType isEqualToString:@"logistics"]) {
        static NSString * ID = @"messagelogisticsCell";
        MessageTypeLogisticsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            
            cell = [[MessageTypeLogisticsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.messageModel = [self.arrayData objectAtIndex:indexPath.row];
        return cell;
    }
    
    if ([self.messageType isEqualToString:@"discount"]) {
        
        static NSString * ID = @"messagediscountCell";
        MessageTypeDiscountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            
            cell = [[MessageTypeDiscountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.messageModel = [self.arrayData objectAtIndex:indexPath.row];
        return cell;
    }
    if ([self.messageType isEqualToString:@"coupon"]) {
        
        static NSString * ID = @"messagecouponCell";
        MessageTypeCouponTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            
            cell = [[MessageTypeCouponTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.messageModel = [self.arrayData objectAtIndex:indexPath.row];
        return cell;
    }
    
    if ([self.messageType isEqualToString:@"goods"]) {
           static NSString * ID = @"messagegoodsCell";
        MessageTypeGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            
            cell = [[MessageTypeGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.messageModel = [self.arrayData objectAtIndex:indexPath.row];
        return cell;
    }

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.messageType isEqualToString:@"system"]) {
        return [MessageTypeSystemTableViewCell cellH:[self.arrayData objectAtIndex:indexPath.row]];
    }else if ([self.messageType isEqualToString:@"logistics"])
    {
        return 200;
    }else if([self.messageType isEqualToString:@"discount"])
    {
        return 470;
    }else if([self.messageType isEqualToString:@"coupon"])
    {
        return 470;
    }else if([self.messageType isEqualToString:@"goods"])
    {
        return 100;
    }
    return 200;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.messageModel = [self.arrayData objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.arrayData removeObjectAtIndex:indexPath.row];
        [tableView_ deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        
        
        if (_arrayData.count<=0) {
            UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
            bgImageView.image = [UIImage imageNamed:@"message_wu"];
            [tableView_ removeFromSuperview];
            [self.view addSubview:bgImageView];
        }
        
        
        
        NSString * urlString =[NSString stringWithFormat:@"%@%@",[HSGlobal deleteMessageOne],self.messageModel.ID];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            
            if(200 == code){
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"删除成功";
                [hud hide:YES afterDelay:1];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"删除失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"删除失败"];
            
        }];

        
        
        
        
        
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.messageType isEqualToString:@"discount"] || [self.messageType isEqualToString:@"coupon"] || [self.messageType isEqualToString:@"system"] ) {
        
        MessageTypeModel *  model =  [self.arrayData objectAtIndex:indexPath.row];
        
        if ([model.targetType isEqualToString:@"D"]) {
            GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
            gdViewController.url = model.msgUrl;
            [self.navigationController pushViewController:gdViewController animated:YES];
        }else if([model.targetType isEqualToString:@"P"]){
            PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
            pinViewController.url = model.msgUrl;
            [self.navigationController pushViewController:pinViewController animated:YES];
           
        }else if([model.targetType isEqualToString:@"V"])
        {
            PinDetailViewController * detailVC = [[PinDetailViewController alloc]init];
            detailVC.url = model.msgUrl;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        self.hidesBottomBarWhenPushed=NO;
    }
}

@end
