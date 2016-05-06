//
//  MyOrderOneCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/29.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MyOrderOneCell.h"
#import "UIView+frame.h"
#import "UIImageView+WebCache.h"
#import "SearchLogisticsViewController.h"
#import "AssessListViewController.h"
@interface MyOrderOneCell(){
    UIView * globView;
    UIView * headView;
    UILabel * orderIdLab;
    UILabel * createDateLab;
    UILabel * orderStatusLab;
    UIImageView * nextImageView;
    UIView * footView;
    UIView * middleView;
    UIImageView * titleImageView;
    UILabel * titleLab;
    UILabel * sizeLab;
    UILabel * priceLab;
    UILabel * payLab;
    UIButton * payBtn;
    UIButton * qrshBtn;
    UIButton * ckwlBtn;
    UIButton * pjsdBtn;
    UILabel * amountLab;

}

@end
@implementation MyOrderOneCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setData:(MyOrderData *)data{
    _data = data;
    
    
    
    if([self.contentView viewWithTag:50000] == nil){
        
        globView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, data.cellHeight)];
        globView.backgroundColor = GGBgColor;
        globView.tag = 50000;
        [self.contentView addSubview:globView];
    
    }
    UIView * view = (UIView *)[self.contentView viewWithTag:50000];
    view.frame = CGRectMake(0, 0, GGUISCREENWIDTH, data.cellHeight);
    
    
    //上面视图
    if([self.contentView viewWithTag:50001] == nil){
        
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, GGUISCREENWIDTH, 50)];
        headView.backgroundColor = [UIColor whiteColor];
        headView.tag = 50001;
        [globView addSubview: headView];
        
    }
    
    if([self.contentView viewWithTag:50002] == nil){
        
        //订单号
        orderIdLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-100, 25)];
        orderIdLab.font = [UIFont systemFontOfSize:12];
        orderIdLab.textColor = UIColorFromRGB(0x333333);
        orderIdLab.tag = 50002;
        [headView addSubview:orderIdLab];
        
    }
    orderIdLab.text = [NSString stringWithFormat:@"订单号：%ld",data.orderInfo.orderId];
    
    if([self.contentView viewWithTag:50003] == nil){
        
        //创建时间
        createDateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, GGUISCREENWIDTH-100, 25)];
        createDateLab.font = [UIFont systemFontOfSize:12];
        createDateLab.textColor = UIColorFromRGB(0x666666);
        createDateLab.tag = 50003;
        [headView addSubview:createDateLab];
        
    }
    createDateLab.text = data.orderInfo.orderCreateAt;
    
    
    if([self.contentView viewWithTag:50004] == nil){
        
        orderStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH - 160, 0, 130, 50)];
        orderStatusLab.font = [UIFont systemFontOfSize:14];
        orderStatusLab.textAlignment = NSTextAlignmentRight;
        orderStatusLab.textColor = [UIColor grayColor];
        orderStatusLab.tag = 50004;
        [headView addSubview:orderStatusLab];
        
    }
    //订单状态
    NSString * status = data.orderInfo.orderStatus;
    //		I:初始化即未支付状态，S:成功，C：取消， F:失败，R:已完成，D:已经发货，J:拒收
    
    
    if([status isEqualToString:@"C"]){
        orderStatusLab.text = @"已取消";
        orderStatusLab.textColor = UIColorFromRGB(0x333333);//黑色
    }else if([status isEqualToString:@"I"]){
        orderStatusLab.text = @"待付款";
        orderStatusLab.textColor = GGMainColor;
    }else if([status isEqualToString:@"S"]){
        if (data.refund!=nil) {
            orderStatusLab.text = @"待发货(已锁定)";
        }else{
            orderStatusLab.text = @"待发货";
        }
        orderStatusLab.textColor = GGMainColor;
    }else if([status isEqualToString:@"F"]){
        orderStatusLab.text = @"失败";
        orderStatusLab.textColor = GGMainColor;
    }else if([status isEqualToString:@"R"]){
        orderStatusLab.text = @"已完成";
        orderStatusLab.textColor = UIColorFromRGB(0x16bb5c);//绿色
    }else if([status isEqualToString:@"D"]){
        orderStatusLab.text = @"待收货";
        orderStatusLab.textColor = GGMainColor;
    }else if([status isEqualToString:@"J"]){
        orderStatusLab.text = @"拒收货";
        orderStatusLab.textColor = GGMainColor;
    }else if([status isEqualToString:@"T"]){
        orderStatusLab.text = @"已退款";
        orderStatusLab.textColor = UIColorFromRGB(0x333333);
    }

    
    
    
    if([self.contentView viewWithTag:50005] == nil){
        
        //向右箭头
        nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(GGUISCREENWIDTH - 20,15,10,20)];
        nextImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image = [UIImage imageNamed:@"icon_more_hui"];
        nextImageView.image = image;
        nextImageView.tag = 50005;
        [headView addSubview:nextImageView];
        
    }
    
    
    //中间视图
    if([self.contentView viewWithTag:50006] == nil){
        
        //中间留一个像素的线
        middleView = [[UIView alloc]initWithFrame:CGRectMake(0,headView.y + headView.height + 1 , GGUISCREENWIDTH, 99)];
        middleView.backgroundColor = [UIColor whiteColor];
        middleView.tag = 50006;
        [globView addSubview:middleView];
    }
    
    if([self.contentView viewWithTag:50007] == nil){
        titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,80,80)];
        titleImageView.tag = 50007;
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        CALayer *layer = [titleImageView layer];
        layer.borderColor = GGBgColor.CGColor;
        layer.borderWidth = 1.0f;

        [middleView addSubview:titleImageView];
    }
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:((SkuData *)data.skuArray[0]).invImg]];
    
    
    if([self.contentView viewWithTag:50008] == nil){
        //title
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, GGUISCREENWIDTH-100-10, 35)];
        titleLab.numberOfLines = 2;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textColor = UIColorFromRGB(0x333333);
        titleLab.tag = 50008;
        [middleView addSubview:titleLab];
    }
    titleLab.text = ((SkuData *)data.skuArray[0]).skuTitle;
    
    
    if([self.contentView viewWithTag:50009] == nil){
        //size
        sizeLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 150, 20)];
        sizeLab.numberOfLines = 1;
        sizeLab.font = [UIFont systemFontOfSize:12];
        sizeLab.textColor = UIColorFromRGB(0x666666);
        sizeLab.tag = 50009;
        [middleView addSubview:sizeLab];

    }
    sizeLab.text = [NSString stringWithFormat:@"规格：%@  %@",((SkuData *)data.skuArray[0]).itemColor,((SkuData *)data.skuArray[0]).itemSize];
    
    if([self.contentView viewWithTag:50010] == nil){
        //price
        priceLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-110, 50, 100, 20)];
        priceLab.textAlignment = NSTextAlignmentRight;
        priceLab.numberOfLines = 1;
        priceLab.font = [UIFont systemFontOfSize:12];
        priceLab.textColor = UIColorFromRGB(0x666666);
        priceLab.tag = 50010;
        [middleView addSubview:priceLab];
        
    }
    priceLab.text = [NSString stringWithFormat:@"￥%@",((SkuData *)data.skuArray[0]).price];
    
    if([self.contentView viewWithTag:50030] == nil){
        //price
        amountLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-110, 70, 100, 20)];
        amountLab.textAlignment = NSTextAlignmentRight;
        amountLab.numberOfLines = 1;
        amountLab.font = [UIFont systemFontOfSize:13];
        amountLab.textColor = UIColorFromRGB(0x333333);
        amountLab.tag = 50030;
        [middleView addSubview:amountLab];
        
    }
    amountLab.text = [NSString stringWithFormat:@"共%ld件商品",((SkuData *)data.skuArray[0]).amount];

    
    



    
    
    
    [[self.contentView viewWithTag:50011] removeFromSuperview];
    //底部视图
    if([self.contentView viewWithTag:50011] == nil){
        
        footView = [[UIView alloc]initWithFrame:CGRectMake(0,middleView.y + middleView.height + 1 , GGUISCREENWIDTH, 50)];
        footView.backgroundColor = [UIColor whiteColor];
        footView.tag = 50011;
        [globView addSubview:footView];
        
    }
    
    qrshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrshBtn.layer setMasksToBounds:YES];
    [qrshBtn.layer setCornerRadius:4.0];
    qrshBtn.frame = CGRectMake(GGUISCREENWIDTH-80, 10, 70, 30);
    [qrshBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    [qrshBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
    [qrshBtn.layer setBorderColor:GGMainColor.CGColor];
    [qrshBtn.layer setBorderWidth:1.0];
    qrshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [qrshBtn addTarget:self action:@selector(qrshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    qrshBtn.tag = 50014;
    [footView addSubview:qrshBtn];
    
    
    
    
    ckwlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ckwlBtn.layer setMasksToBounds:YES];
    [ckwlBtn.layer setCornerRadius:4.0];
    ckwlBtn.frame = CGRectMake(GGUISCREENWIDTH-160, 10, 70, 30);
    [ckwlBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    [ckwlBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [ckwlBtn.layer setBorderColor:UIColorFromRGB(0x333333).CGColor];
    [ckwlBtn.layer setBorderWidth:1.0];
    ckwlBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [ckwlBtn addTarget:self action:@selector(ckwlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    ckwlBtn.tag = 50015;
    [footView addSubview:ckwlBtn];
    
    
    
    payLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, GGUISCREENWIDTH-150, 30)];
    payLab.numberOfLines = 1;
    payLab.font = [UIFont systemFontOfSize:12];
    payLab.textColor = [UIColor grayColor];
    payLab.tag = 50012;
    [footView addSubview:payLab];
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn.layer setMasksToBounds:YES];
    [payBtn.layer setCornerRadius:4.0];
    payBtn.frame = CGRectMake(GGUISCREENWIDTH-80, 10, 70, 30);
    [payBtn setTitle:@"付 款" forState:UIControlStateNormal];
    [payBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
    [payBtn.layer setBorderColor:GGMainColor.CGColor];
    [payBtn.layer setBorderWidth:1.0];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = 50013;
    [footView addSubview:payBtn];
    
    pjsdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pjsdBtn.layer setMasksToBounds:YES];
    [pjsdBtn.layer setCornerRadius:4.0];
    pjsdBtn.frame = CGRectMake(GGUISCREENWIDTH-80, 10, 70, 30);
    [pjsdBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
    [pjsdBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
    [pjsdBtn.layer setBorderColor:GGMainColor.CGColor];
    [pjsdBtn.layer setBorderWidth:1.0];
    pjsdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [pjsdBtn addTarget:self action:@selector(pjsdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    pjsdBtn.tag = 50025;
    [footView addSubview:pjsdBtn];


    
    if([status isEqualToString:@"I"]){//待支付

        payLab.text = [NSString stringWithFormat:@"应付金额:￥%@",data.orderInfo.payTotal];

        payLab.hidden = NO;
        payBtn.hidden = NO;
        ckwlBtn.hidden = YES;
        qrshBtn.hidden = YES;
        pjsdBtn.hidden = YES;
        
        

    }else if([status isEqualToString:@"D"]){//待收货
        
        payLab.hidden = YES;
        payBtn.hidden = YES;
        ckwlBtn.hidden = NO;
        qrshBtn.hidden = NO;
        pjsdBtn.hidden = YES;

        
        
    }else if([status isEqualToString:@"R"]){
        payLab.hidden = YES;
        payBtn.hidden = YES;
        ckwlBtn.hidden = NO;
        qrshBtn.hidden = YES;
        if([data.orderInfo.remark isEqualToString:@"N"]){
            ckwlBtn.frame = CGRectMake(GGUISCREENWIDTH-160, 10, 70, 30);
            pjsdBtn.hidden = NO;
        }else{
            pjsdBtn.hidden = YES;
            ckwlBtn.frame = CGRectMake(GGUISCREENWIDTH-80, 10, 70, 30);
        }
        
    }else{

        [[self.contentView viewWithTag:50011] removeFromSuperview];
        payLab.hidden = YES;
        payBtn.hidden = YES;
        ckwlBtn.hidden = YES;
        qrshBtn.hidden = YES;
        pjsdBtn.hidden = YES;
    }

}
-(void)pjsdBtnClick{
    UIViewController * controller = [self getCurrentVC];
    
    AssessListViewController * assess = [[AssessListViewController alloc]init];
    assess.orderId = [NSString stringWithFormat:@"%ld",_data.orderInfo.orderId];
    [(UINavigationController *)controller pushViewController:assess animated:YES];
    [assess setBackButtonBlock:^(NSString *str) {
        
    }];
}
-(void)payBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }

    [self.delegate checkOrder:_data];
}

//确认收货
-(void)qrshBtnClick{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定已收货？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        NSString * url = [NSString stringWithFormat:@"%@%ld",[HSGlobal confirmReceiptUrl],_data.orderInfo.orderId];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        
        [GiFHUD setGifWithImageName:@"hmm.gif"];
        [GiFHUD show];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            
            if(code == 200){
                [self.delegate reloadData];
            }else{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = message;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
            
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
        
    }
}

//查看物流
-(void)ckwlBtnClick{
    UIViewController * controller = [self getCurrentVC];
    SearchLogisticsViewController * searchLogistics = [[SearchLogisticsViewController alloc]init];
    searchLogistics.orderId = [NSString stringWithFormat:@"%ld",_data.orderInfo.orderId];
    [(UINavigationController *)controller pushViewController:searchLogistics animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    UITabBarController *tab = (UITabBarController *)result;
    return tab.selectedViewController;
}
@end
