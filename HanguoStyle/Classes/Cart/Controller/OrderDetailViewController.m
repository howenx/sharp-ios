//
//  OrderDetailViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/4.
//  Copyright (c) 2016年 liudongsheng. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PayViewController.h"
#import "GoodsDetailViewController.h"
#import "RefundViewController.h"
#import "SearchLogisticsViewController.h"
#import "AssessListViewController.h"
#import "PinGoodsDetailViewController.h"
@interface OrderDetailViewController ()<UIScrollViewDelegate>
{
    long secondsCountDown;
    UILabel * auctionTimeLab;
    UIScrollView * scrollView;
    UIButton *cancelBtn;
    UIButton *payBtn;
    UILabel * orderStatusLab;
    NSInteger delOrCancelFlag;//1:删除订单，2：取消订单
    
    UIButton *ckwlBtn;
    UIButton *ckpjBtn;
    
}
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = GGNavColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //只有已取消的订单才能删除
    if ([_orderData.orderInfo.orderStatus isEqualToString:@"C"]||[_orderData.orderInfo.orderStatus isEqualToString:@"T"]) {

        //右上角删除按钮
        UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
        rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [rightButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(delOrderClick)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    


//    [self creatView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self creatView];
}
- (void)delOrderClick{
    delOrCancelFlag = 1;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self delOrCancelOrder];
    }
}
//删除或者取消按钮触发方法
-(void)delOrCancelOrder{
        NSString * urlString;
    if(delOrCancelFlag == 1){
        urlString =  [NSString stringWithFormat:@"%@%ld",[HSGlobal delOrderUrl],_orderData.orderInfo.orderId];
    }else if(delOrCancelFlag == 2){
        urlString =  [NSString stringWithFormat:@"%@%ld",[HSGlobal cancelOrderUrl],_orderData.orderInfo.orderId];
    }
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
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            if(delOrCancelFlag == 2){//取消订单
                scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64);
                [cancelBtn removeFromSuperview];
                [payBtn removeFromSuperview];
                [auctionTimeLab removeFromSuperview];
                orderStatusLab.text = @"订单状态：已取消";
                
                
                //右上角添加删除按钮
                UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
                rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
                [rightButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
                [rightButton addTarget:self action:@selector(delOrderClick)forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                self.navigationItem.rightBarButtonItem = rightItem;

                
            }else if(delOrCancelFlag == 1){//删除订单
                [self.navigationController popViewControllerAnimated:YES];
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
//timer定时器方法
- (void)timerFireMethod:(NSTimer *)timer
{
    secondsCountDown--;
    if(secondsCountDown == 0){
        [timer invalidate];
        delOrCancelFlag = 2;
        [self delOrCancelOrder];
    }
    auctionTimeLab.text = [NSString stringWithFormat:@"还剩%ld小时%ld分%ld秒，订单将被取消",  secondsCountDown/3600, (secondsCountDown%3600)/60, (secondsCountDown%3600)%60];//倒计时显示
}
-(void)creatView{
   
    //设置scrollview
    scrollView = [[UIScrollView alloc] init];
    
    if ([_orderData.orderInfo.orderStatus isEqualToString:@"I"]) {
        scrollView.frame = CGRectMake(0, 40, GGUISCREENWIDTH, GGUISCREENHEIGHT-104-50);
        scrollView.contentSize = CGSizeMake(0, 450 + _orderData.skuArray.count * 80);
        
        auctionTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
        auctionTimeLab.numberOfLines = 1;
        auctionTimeLab.font = [UIFont systemFontOfSize:15];
        auctionTimeLab.textColor = GGTextBlackColor;
        auctionTimeLab.backgroundColor = GGMainColor;
        auctionTimeLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:auctionTimeLab];
        secondsCountDown = _orderData.orderInfo.countDown/1000-10;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }else if([_orderData.orderInfo.orderStatus isEqualToString:@"S"]||[_orderData.orderInfo.orderStatus isEqualToString:@"T"])
    {
        

        
        if (_orderData.refund!=nil) {
            scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64);
            scrollView.contentSize = CGSizeMake(0, 450 + _orderData.skuArray.count * 80 +115 +10);
        }else
        {
            scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-50);
            scrollView.contentSize = CGSizeMake(0, 450 + _orderData.skuArray.count * 80);
        }
    }
    else if([_orderData.orderInfo.orderStatus isEqualToString:@"R"])
    {
        scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-50);
        scrollView.contentSize = CGSizeMake(0, 450 + _orderData.skuArray.count * 80);
        
    }
    
    else if([_orderData.orderInfo.orderStatus isEqualToString:@"F"])
    {
        scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64);
        scrollView.contentSize = CGSizeMake(0, 490 + _orderData.skuArray.count * 80 + 120);
        
    }

    else
    {
        scrollView.frame = CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64);
        scrollView.contentSize = CGSizeMake(0, 450 + _orderData.skuArray.count * 80);
    }

    scrollView.delegate = self;
    
    
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.pagingEnabled = NO;
    scrollView.backgroundColor = GGBgColor;
    scrollView.scrollsToTop = YES;
    [self.view addSubview:scrollView];
    
    
    UIView * orderIdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 100)];
    orderIdView.backgroundColor = [UIColor whiteColor];

    [scrollView addSubview:orderIdView];
    
    
    
    
    
    
    UILabel * orderIdLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
    orderIdLab.numberOfLines = 1;
    orderIdLab.font = [UIFont systemFontOfSize:12];
    orderIdLab.textColor = [UIColor grayColor];
    orderIdLab.text = [NSString stringWithFormat:@"订单号：%ld",_orderData.orderInfo.orderId];
    [orderIdView addSubview:orderIdLab];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
    line1.backgroundColor = GGBgColor;
    [orderIdView addSubview:line1];
    
    
    
    
    
    orderStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, GGUISCREENWIDTH-20, 20)];
    orderStatusLab.numberOfLines = 1;
    orderStatusLab.font = [UIFont systemFontOfSize:12];
    orderStatusLab.textColor = [UIColor grayColor];
    //订单状态
    NSString * status = _orderData.orderInfo.orderStatus;
    //		I:初始化即未支付状态，S:成功，C：取消， F:失败，R:已完成，D:已经发货，J:拒收
    
    
    if([status isEqualToString:@"C"]){
        orderStatusLab.text = @"订单状态：已取消";
    }else if([status isEqualToString:@"I"]){
        orderStatusLab.text = @"订单状态：待付款";
    }else if([status isEqualToString:@"S"]){
        orderStatusLab.text = @"订单状态：待发货";
    }else if([status isEqualToString:@"F"]){
        orderStatusLab.text = @"订单状态：交易失败";
    }else if([status isEqualToString:@"R"]){
        orderStatusLab.text = @"订单状态：已完成";
    }else if([status isEqualToString:@"D"]){
        orderStatusLab.text = @"订单状态：待收货";
    }else if([status isEqualToString:@"J"]){
        orderStatusLab.text = @"订单状态：拒收货";
    }else if([status isEqualToString:@"T"]){
        orderStatusLab.text = @"订单状态：已退款";
    }
    [orderIdView addSubview:orderStatusLab];
    
    
    
    
    UILabel * payTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, GGUISCREENWIDTH-20, 20)];
    payTypeLab.numberOfLines = 1;
    payTypeLab.font = [UIFont systemFontOfSize:12];
    payTypeLab.textColor = [UIColor grayColor];
    NSString * payType;
    if(![NSString isNSNull:_orderData.orderInfo.payMethod]){
        if([_orderData.orderInfo.payMethod isEqualToString:@"JD"]){
            payType = @"京东支付";
        }else if([_orderData.orderInfo.payMethod isEqualToString:@"ALIPAY"]){
            payType = @"支付宝支付";
        }else if([_orderData.orderInfo.payMethod isEqualToString:@"WEIXIN"]){
            payType = @"微信支付";
        }else{
            payType = @"在线支付";
        }
    }else{
        payType = @"在线支付";
    }
    payTypeLab.text = [NSString stringWithFormat:@"支付方式：%@",payType];
    [orderIdView addSubview:payTypeLab];
    
    
    
    
    UILabel * createTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, GGUISCREENWIDTH-20, 20)];
    createTimeLab.numberOfLines = 1;
    createTimeLab.font = [UIFont systemFontOfSize:12];
    createTimeLab.textColor = [UIColor grayColor];
    createTimeLab.text = [NSString stringWithFormat:@"下单时间：%@",_orderData.orderInfo.orderCreateAt];
    [orderIdView addSubview:createTimeLab];
    
    
    
    
    UIView * orderDetailView = [[UIView alloc]initWithFrame:CGRectMake(0 , orderIdView.y + orderIdView.height + 10, GGUISCREENWIDTH, 40 + _orderData.skuArray.count * 80)];
    orderDetailView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:orderDetailView];
    
    UILabel * orderDetailLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
    orderDetailLab.numberOfLines = 1;
    orderDetailLab.font = [UIFont systemFontOfSize:12];
    orderDetailLab.textColor = [UIColor grayColor];
    orderDetailLab.text = @"商品详情";
    [orderDetailView addSubview:orderDetailLab];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
    line2.backgroundColor = GGBgColor;
    [orderDetailView addSubview:line2];
    
    
    for (int i = 0; i < _orderData.skuArray.count;i++ ) {
        SkuData * skuData = _orderData.skuArray[i];
        CGFloat hei = 40 + i * 80 ;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, hei + 5, 70, 70)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:skuData.invImg]];
        imageView.layer.borderColor = GGBgColor.CGColor;
        imageView.layer.borderWidth = 1.0f;
        [orderDetailView addSubview:imageView];
        //添加单击手势
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        imageView.tag = 24000+i;
        
        UILabel * orderTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, hei + 5, GGUISCREENWIDTH-100, 30)];
        orderTitleLab.numberOfLines = 2;
        orderTitleLab.font = [UIFont systemFontOfSize:12];
        orderTitleLab.textColor = [UIColor grayColor];
        orderTitleLab.text = skuData.skuTitle;
        [orderDetailView addSubview:orderTitleLab];
        
        
        UILabel * orderAmountLab = [[UILabel alloc]initWithFrame:CGRectMake(90, hei + 35, GGUISCREENWIDTH-100, 20)];
        orderAmountLab.numberOfLines = 1;
        orderAmountLab.font = [UIFont systemFontOfSize:12];
        orderAmountLab.textColor = [UIColor grayColor];
        orderAmountLab.text = [NSString stringWithFormat:@"数量：%ld",(long)skuData.amount];
        [orderDetailView addSubview:orderAmountLab];
        
        UILabel * orderPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(90, hei + 55, GGUISCREENWIDTH-100, 20)];
        orderPriceLab.numberOfLines = 1;
        orderPriceLab.font = [UIFont systemFontOfSize:12];
        orderPriceLab.textColor = GGRedColor;
        orderPriceLab.text = [NSString stringWithFormat:@"￥%@",skuData.price];
        [orderDetailView addSubview:orderPriceLab];
        
        
        if(i != _orderData.skuArray.count-1){
            UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, hei + 80 -1, GGUISCREENWIDTH, 1)];
            line2.backgroundColor = GGBgColor;
            [orderDetailView addSubview:line2];
        }
    }
    
    
    
    
    
    
    //收货地址
    UIView * orderAddressView = [[UIView alloc]initWithFrame:CGRectMake(0 , orderDetailView.y + orderDetailView.height + 10, GGUISCREENWIDTH, 140)];
    orderAddressView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:orderAddressView];

    
    UILabel * orderAddressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
    orderAddressLab.numberOfLines = 1;
    orderAddressLab.font = [UIFont systemFontOfSize:12];
    orderAddressLab.textColor = [UIColor grayColor];
    orderAddressLab.text = @"收货信息";
    [orderAddressView addSubview:orderAddressLab];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
    line3.backgroundColor = GGBgColor;
    [orderAddressView addSubview:line3];
    
    
    UILabel * presonNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, GGUISCREENWIDTH-20, 20)];
    presonNameLab.numberOfLines = 1;
    presonNameLab.font = [UIFont systemFontOfSize:12];
    presonNameLab.textColor = [UIColor grayColor];
    presonNameLab.text = [NSString stringWithFormat:@"收货人：%@",_orderData.addressData.name];
    [orderAddressView addSubview:presonNameLab];
    
    
    UILabel * phoneNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, GGUISCREENWIDTH-20, 20)];
    phoneNumLab.numberOfLines = 1;
    phoneNumLab.font = [UIFont systemFontOfSize:12];
    phoneNumLab.textColor = [UIColor grayColor];
    
    phoneNumLab.text = [NSString stringWithFormat:@"手机号码：%@****%@",[_orderData.addressData.tel substringToIndex:3],[_orderData.addressData.tel substringFromIndex:8]];
    [orderAddressView addSubview:phoneNumLab];
    
    
    
    UILabel * idNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, GGUISCREENWIDTH-20, 20)];
    idNumLab.numberOfLines = 1;
    idNumLab.font = [UIFont systemFontOfSize:12];
    idNumLab.textColor = [UIColor grayColor];
    idNumLab.text = [NSString stringWithFormat:@"身份证号：%@****%@",[_orderData.addressData.idCardNum substringToIndex:10],[_orderData.addressData.idCardNum substringFromIndex:14]];
    [orderAddressView addSubview:idNumLab];
    
    
    
    UILabel * addressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, GGUISCREENWIDTH-20, 20)];
    addressLab.numberOfLines = 1;
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.textColor = [UIColor grayColor];
    addressLab.text = [NSString stringWithFormat:@"收货地址：%@ %@",_orderData.addressData.deliveryCity,_orderData.addressData.deliveryDetail];
    [orderAddressView addSubview:addressLab];


    //订单金额
    UIView * orderPayView = [[UIView alloc]initWithFrame:CGRectMake(0 , orderAddressView.y + orderAddressView.height + 10, GGUISCREENWIDTH, 140)];
    orderPayView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:orderPayView];
    
    
    UILabel * orderPayLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
    orderPayLab.numberOfLines = 1;
    orderPayLab.font = [UIFont systemFontOfSize:12];
    orderPayLab.textColor = [UIColor grayColor];
    orderPayLab.text = @"订单金额";
    [orderPayView addSubview:orderPayLab];
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
    line4.backgroundColor = GGBgColor;
    [orderPayView addSubview:line4];
    
    
    
    UILabel * totalOrderNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, GGUISCREENWIDTH-20, 20)];
    totalOrderNumLab.numberOfLines = 1;
    totalOrderNumLab.font = [UIFont systemFontOfSize:12];
    totalOrderNumLab.textColor = [UIColor grayColor];
    totalOrderNumLab.text = [NSString stringWithFormat:@"订单总件数：%ld",(long)_orderData.orderInfo.orderAmount];
    [orderPayView addSubview:totalOrderNumLab];
    
    UILabel * totalFeeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, GGUISCREENWIDTH-20, 20)];
    totalFeeLab.numberOfLines = 1;
    totalFeeLab.font = [UIFont systemFontOfSize:12];
    totalFeeLab.textColor = [UIColor grayColor];
    totalFeeLab.text = [NSString stringWithFormat:@"商品总费用：￥%@",_orderData.orderInfo.totalFee];
    [orderPayView addSubview:totalFeeLab];
    
    
//    UILabel * shipFeeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, GGUISCREENWIDTH-20, 20)];
//    shipFeeLab.numberOfLines = 1;
//    shipFeeLab.font = [UIFont systemFontOfSize:12];
//    shipFeeLab.textColor = [UIColor grayColor];
//    shipFeeLab.text = [NSString stringWithFormat:@"邮费：￥%@",_orderData.orderInfo.shipFee];
//    [orderPayView addSubview:shipFeeLab];
//    
//    
//    
//    UILabel * postalFeeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, GGUISCREENWIDTH-20, 20)];
//    postalFeeLab.numberOfLines = 1;
//    postalFeeLab.font = [UIFont systemFontOfSize:12];
//    postalFeeLab.textColor = [UIColor grayColor];
//    postalFeeLab.text = [NSString stringWithFormat:@"行邮税：￥%@",_orderData.orderInfo.postalFee];
//    [orderPayView addSubview:postalFeeLab];
    
    
    
    
    UILabel * discountLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, GGUISCREENWIDTH-20, 20)];
    discountLab.numberOfLines = 1;
    discountLab.font = [UIFont systemFontOfSize:12];
    discountLab.textColor = [UIColor grayColor];
    discountLab.text = [NSString stringWithFormat:@"已优惠金额：￥%@",_orderData.orderInfo.discount];
    [orderPayView addSubview:discountLab];
    
    
    
    
    UILabel * payTotalLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, GGUISCREENWIDTH-20, 20)];
    payTotalLab.numberOfLines = 1;
    payTotalLab.font = [UIFont systemFontOfSize:12];
    payTotalLab.textColor = [UIColor grayColor];
    payTotalLab.text = [NSString stringWithFormat:@"订单应付金额：￥%@",_orderData.orderInfo.payTotal];
    [orderPayView addSubview:payTotalLab];
    
    
    
    if([_orderData.orderInfo.orderStatus isEqualToString:@"S"]||[_orderData.orderInfo.orderStatus isEqualToString:@"T"])
    {
        
        if (_orderData.refund!=nil) {
            if([_orderData.orderInfo.orderStatus isEqualToString:@"S"]){
                 orderStatusLab.text = @"订单状态：待发货(已锁定)";
            }
            
            //订单金额
            UIView * refundView = [[UIView alloc]initWithFrame:CGRectMake(0 , PosYFromView(orderPayView, 10), GGUISCREENWIDTH, 115)];
            refundView.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:refundView];
            
            
            
            UILabel * refundLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
            refundLab.numberOfLines = 1;
            refundLab.font = [UIFont systemFontOfSize:12];
            refundLab.textColor = [UIColor grayColor];
            refundLab.text = @"退款信息";
            [refundView addSubview:refundLab];
            
            
            UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
            line5.backgroundColor = GGBgColor;
            [refundView addSubview:line5];
            
            UILabel * priceLab = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(line5, 5), GGUISCREENWIDTH-20, 20)];
            priceLab.numberOfLines = 1;
            priceLab.font = [UIFont systemFontOfSize:12];
            priceLab.textColor = [UIColor grayColor];
            priceLab.text = [NSString stringWithFormat:@"退款金额：%@",_orderData.refund.payBackFee];
            [refundView addSubview:priceLab];
            
            
            UILabel * reasonLab = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(priceLab, 0), GGUISCREENWIDTH-20, 20)];
            reasonLab.numberOfLines = 1;
            reasonLab.font = [UIFont systemFontOfSize:12];
            reasonLab.textColor = [UIColor grayColor];
            reasonLab.text = [NSString stringWithFormat:@"退款原因：%@",_orderData.refund.reason];
            [refundView addSubview:reasonLab];
            
            UILabel * stateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(reasonLab, 0), GGUISCREENWIDTH-20, 20)];
            stateLab.numberOfLines = 1;
            stateLab.font = [UIFont systemFontOfSize:12];
            stateLab.textColor = [UIColor grayColor];
            
            if ([_orderData.refund.state isEqualToString:@"I"]) {
                stateLab.text = [NSString stringWithFormat:@"退款状态：申请受理中"];
            }else if([_orderData.refund.state isEqualToString:@"A"])
            {
                stateLab.text = [NSString stringWithFormat:@"退款状态：退款受理中，资金会在1-5个工作日内退回您的账户"];
            }else if([_orderData.refund.state isEqualToString:@"R"])
            {
                stateLab.text = [NSString stringWithFormat:@"退款状态：拒绝退款"];
            }else if([_orderData.refund.state isEqualToString:@"N"])
            {
                stateLab.text = [NSString stringWithFormat:@"退款状态：由于某种不可抗力量，导致退款受理失败，我们客服MM会及时联系您"];

            }else if([_orderData.refund.state isEqualToString:@"Y"])
            {
                stateLab.text = [NSString stringWithFormat:@"退款状态：退款受理成功"];
            }
            
            [refundView addSubview:stateLab];
            
        }else
        {   UIView * footLine = [[UIView alloc]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT-64-50, GGUISCREENWIDTH, 1)];
            footLine.backgroundColor = GGBgColor;
            [self.view addSubview:footLine];

            UIButton * looutMoneyButton = [[UIButton alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-110, GGUISCREENHEIGHT-64-40, 100, 30)];
            [looutMoneyButton setTitleColor:GGMainColor forState:UIControlStateNormal];
            [looutMoneyButton.layer setBorderColor:GGMainColor.CGColor];
            [looutMoneyButton.layer setBorderWidth:1.0];
            looutMoneyButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [looutMoneyButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [looutMoneyButton addTarget:self action:@selector(looutMoneyButtonclcik:) forControlEvents:UIControlEventTouchUpInside];
            [looutMoneyButton.layer setMasksToBounds:YES];
            [looutMoneyButton.layer setCornerRadius:4.0];
            [self.view addSubview:looutMoneyButton];
        }

    }
    
    if([_orderData.orderInfo.orderStatus isEqualToString:@"I"]){
        
        UIView * footLine = [[UIView alloc]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT-64-50, GGUISCREENWIDTH, 1)];
        footLine.backgroundColor = GGBgColor;
        [self.view addSubview:footLine];
        //取消订单
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn.layer setMasksToBounds:YES];
        [cancelBtn.layer setCornerRadius:5.0];
        cancelBtn.frame = CGRectMake(GGUISCREENWIDTH-220,  GGUISCREENHEIGHT-64-40, 100, 30);
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [cancelBtn.layer setBorderColor:UIColorFromRGB(0x333333).CGColor];
        [cancelBtn.layer setBorderWidth:1.0];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:cancelBtn];
        
        //去支付
        payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn.layer setMasksToBounds:YES];
        [payBtn.layer setCornerRadius:5.0];
        payBtn.frame = CGRectMake(GGUISCREENWIDTH-110,  GGUISCREENHEIGHT-64-40, 100, 30);
        [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [payBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
        [payBtn.layer setBorderColor:GGMainColor.CGColor];
        [payBtn.layer setBorderWidth:1.0];
        [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payBtn];
        

    }
    if([_orderData.orderInfo.orderStatus isEqualToString:@"R"]){
        
        UIView * footLine = [[UIView alloc]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT-64-50, GGUISCREENWIDTH, 1)];
        footLine.backgroundColor = GGBgColor;
        [self.view addSubview:footLine];
        
        //查看物流
        ckwlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ckwlBtn.layer setMasksToBounds:YES];
        [ckwlBtn.layer setCornerRadius:5.0];
        ckwlBtn.frame = CGRectMake(GGUISCREENWIDTH-220,  GGUISCREENHEIGHT-64-40, 100, 30);
        [ckwlBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        ckwlBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [ckwlBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [ckwlBtn.layer setBorderColor:UIColorFromRGB(0x333333).CGColor];
        [ckwlBtn.layer setBorderWidth:1.0];
        [ckwlBtn addTarget:self action:@selector(ckwlBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:ckwlBtn];
        [[self.view viewWithTag:50034]removeFromSuperview];
        //查看评价
        ckpjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ckpjBtn.tag = 50034;
        [ckpjBtn.layer setMasksToBounds:YES];
        [ckpjBtn.layer setCornerRadius:5.0];
        ckpjBtn.frame = CGRectMake(GGUISCREENWIDTH-110,  GGUISCREENHEIGHT-64-40, 100, 30);
        if([_orderData.orderInfo.remark isEqualToString:@"N"]){
            [ckpjBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
        }else{
            [ckpjBtn setTitle:@"查看评价" forState:UIControlStateNormal];
        }
        
        ckpjBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [ckpjBtn setTitleColor:GGMainColor forState:UIControlStateNormal];
        [ckpjBtn.layer setBorderColor:GGMainColor.CGColor];
        [ckpjBtn.layer setBorderWidth:1.0];
        [ckpjBtn addTarget:self action:@selector(ckpjBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ckpjBtn];
        
        
    }
    if([_orderData.orderInfo.orderStatus isEqualToString:@"F"]){
        //失败提示
        UIView * failView = [[UIView alloc]initWithFrame:CGRectMake(0 , orderPayView.y + orderPayView.height + 10, GGUISCREENWIDTH, 110)];
        failView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:failView];
        UILabel * failLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
        failLab.numberOfLines = 1;
        failLab.font = [UIFont systemFontOfSize:12];
        failLab.textColor = [UIColor grayColor];
        failLab.text = @"重要提示";
        [failView addSubview:failLab];
        
        UIView * line9 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH, 1)];
        line9.backgroundColor = GGBgColor;
        [failView addSubview:line9];
        
        
        UILabel * failDetailLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, GGUISCREENWIDTH-20, 60)];
        failDetailLab.numberOfLines = 0;
        failDetailLab.font = [UIFont systemFontOfSize:12];
        failDetailLab.textColor = [UIColor grayColor];
        failDetailLab.text = @"如果此笔订单扣款成功，我们将会在1-5个工作日返回您的支付金额至您的支付账户里，请以支付公司的通知信息为准，如有疑问请联系我们客服400-664-0808";
        [failView addSubview:failDetailLab];

    }

    
}
//查看评价，或者去评价
-(void)ckpjBtnClick{
    
    AssessListViewController * assess = [[AssessListViewController alloc]init];
    assess.orderId = [NSString stringWithFormat:@"%ld",_selectOrderId];
    [self.navigationController pushViewController:assess animated:YES];
    [assess setBackButtonBlock:^(NSString *str) {
        [self requestData];
    }];

}
//查看物流
-(void)ckwlBtnClick{
    SearchLogisticsViewController * searchLogistics = [[SearchLogisticsViewController alloc]init];
    searchLogistics.orderId = [NSString stringWithFormat:@"%ld",self.selectOrderId];
    [self.navigationController pushViewController:searchLogistics animated:YES];
}
-(void)payBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    NSString * urlString =  [NSString stringWithFormat:@"%@%ld",[HSGlobal checkOrderUrl],_orderData.orderInfo.orderId];
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

        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            PayViewController * pay = [[PayViewController alloc]init];
            pay.payType = @"item";
            pay.orderId = _orderData.orderInfo.orderId;
            [self.navigationController pushViewController:pay animated:YES];
            
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

-(void)cancelBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    delOrCancelFlag =2;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要取消？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
-(void) tapAction:(UITapGestureRecognizer *)recognizer{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    NSInteger tag =  recognizer.self.view.tag-24000;
    SkuData * sd = _orderData.skuArray[tag];
    if([sd.skuType isEqualToString:@"pin"]){
        PinGoodsDetailViewController * pinViewController = [[PinGoodsDetailViewController alloc]init];
        pinViewController.url = sd.invUrl;
        [self.navigationController pushViewController:pinViewController animated:YES];
    }else{
        GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
        gdViewController.url = sd.invUrl;
        [self.navigationController pushViewController:gdViewController animated:YES];
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)looutMoneyButtonclcik:(UIButton *)btn
{
    RefundViewController * vc = [[RefundViewController alloc]init];
    vc.orderData = self.orderData;
    [self.navigationController pushViewController:vc animated:YES];
    [vc setSelectButtonBlock:^(NSString * str) {
        [self requestData];
    }];
}
-(void)requestData{
    NSString * urlString;
    urlString = [NSString stringWithFormat:@"%@/%ld",[HSGlobal myOrderUrl],self.selectOrderId];
    
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
        NSArray * dataArray = [object objectForKey:@"orderList"];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
        if(code == 200){
            //进入到订单详情
            
            
            for (id node in dataArray) {
                MyOrderData * singleData = [[MyOrderData alloc] initWithJSONNode:node];
                
                self.orderData = singleData;
            }
            
            [self creatView];
            
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

@end
