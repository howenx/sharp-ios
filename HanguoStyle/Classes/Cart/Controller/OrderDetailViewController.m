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
@interface OrderDetailViewController ()<UIScrollViewDelegate>
{
    long secondsCountDown;
    UILabel * auctionTimeLab;
    UIScrollView * scrollView;
    UIButton *cancelBtn;
    UIButton *payBtn;
    UILabel * orderStatusLab;
    NSInteger delOrCancelFlag;//1:删除订单，2：取消订单
}
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = GGBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //只有已取消的订单才能删除
    if ([_orderData.orderInfo.orderStatus isEqualToString:@"C"]) {

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
                scrollView.frame = CGRectMake(10, 64, GGUISCREENWIDTH-20, GGUISCREENHEIGHT-64);
                scrollView.contentSize = CGSizeMake(0, 510 + _orderData.skuArray.count * 80);
                [cancelBtn removeFromSuperview];
                [payBtn removeFromSuperview];
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
    auctionTimeLab.text = [NSString stringWithFormat:@"%ld小时%ld分%ld秒",  secondsCountDown/3600, (secondsCountDown%3600)/60, (secondsCountDown%3600)%60];//倒计时显示
}
-(void)creatView{
   
    //设置scrollview
    scrollView = [[UIScrollView alloc] init];
    
    if ([_orderData.orderInfo.orderStatus isEqualToString:@"I"]) {
        scrollView.frame = CGRectMake(10, 40, GGUISCREENWIDTH-20, GGUISCREENHEIGHT-104);
        scrollView.contentSize = CGSizeMake(0, 570 + _orderData.skuArray.count * 80);
        
        auctionTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-20, 40)];
        auctionTimeLab.numberOfLines = 1;
        auctionTimeLab.font = [UIFont systemFontOfSize:15];
        auctionTimeLab.textColor = GGMainColor;
        auctionTimeLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:auctionTimeLab];
        secondsCountDown = 24 * 60 * 60 - _orderData.orderInfo.countDown/1000;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }else if([_orderData.orderInfo.orderStatus isEqualToString:@"S"])
    {
        scrollView.frame = CGRectMake(10, 0, GGUISCREENWIDTH-20, GGUISCREENHEIGHT-64);

        
        if (_orderData.refund!=nil) {
            scrollView.contentSize = CGSizeMake(0, 510 + _orderData.skuArray.count * 80 +115);
        }else
        {
            scrollView.contentSize = CGSizeMake(0, 510 + _orderData.skuArray.count * 80 +45);
        }
    }
    else
    {
        scrollView.frame = CGRectMake(10, 0, GGUISCREENWIDTH-20, GGUISCREENHEIGHT-64);
        scrollView.contentSize = CGSizeMake(0, 510 + _orderData.skuArray.count * 80);
    }

    scrollView.delegate = self;
    
    
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.pagingEnabled = NO;
    scrollView.backgroundColor = GGBgColor;
    scrollView.scrollsToTop = YES;
    [self.view addSubview:scrollView];
    
    
    UIView * orderIdView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, GGUISCREENWIDTH-20, 100)];
    orderIdView.backgroundColor = [UIColor whiteColor];
    orderIdView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    orderIdView.layer.borderWidth = 1.0f;
    [scrollView addSubview:orderIdView];
    
    
    
    
    
    
    UILabel * orderIdLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-40, 40)];
    orderIdLab.numberOfLines = 1;
    orderIdLab.font = [UIFont systemFontOfSize:12];
    orderIdLab.textColor = [UIColor grayColor];
    orderIdLab.text = [NSString stringWithFormat:@"订单号：%ld",_orderData.orderInfo.orderId];
    [orderIdView addSubview:orderIdLab];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH-20, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [orderIdView addSubview:line1];
    
    
    
    
    
    orderStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, GGUISCREENWIDTH-40, 20)];
    orderStatusLab.numberOfLines = 1;
    orderStatusLab.font = [UIFont systemFontOfSize:12];
    orderStatusLab.textColor = [UIColor grayColor];
    //订单状态
    NSString * status = _orderData.orderInfo.orderStatus;
    //		I:初始化即未支付状态，S:成功，C：取消， F:失败，R:已收货，D:已经发货，J:拒收
    
    
    if([status isEqualToString:@"C"]){
        orderStatusLab.text = @"订单状态：已取消";
    }else if([status isEqualToString:@"I"]){
        orderStatusLab.text = @"订单状态：待付款";
    }else if([status isEqualToString:@"S"]){
        orderStatusLab.text = @"订单状态：待发货";
    }else if([status isEqualToString:@"F"]){
        orderStatusLab.text = @"订单状态：失败";
    }else if([status isEqualToString:@"R"]){
        orderStatusLab.text = @"订单状态：已收货";
    }else if([status isEqualToString:@"D"]){
        orderStatusLab.text = @"订单状态：待收货";
    }else if([status isEqualToString:@"J"]){
        orderStatusLab.text = @"订单状态：拒收货";
    }
    [orderIdView addSubview:orderStatusLab];
    
    
    
    
    UILabel * payTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, GGUISCREENWIDTH-40, 20)];
    payTypeLab.numberOfLines = 1;
    payTypeLab.font = [UIFont systemFontOfSize:12];
    payTypeLab.textColor = [UIColor grayColor];
    NSString * payType;
    if([_orderData.orderInfo.payMethod isEqualToString:@"JD"]){
        payType = @"京东支付";
    }
    payTypeLab.text = [NSString stringWithFormat:@"支付方式：%@",payType];
    [orderIdView addSubview:payTypeLab];
    
    
    
    
    UILabel * createTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, GGUISCREENWIDTH-40, 20)];
    createTimeLab.numberOfLines = 1;
    createTimeLab.font = [UIFont systemFontOfSize:12];
    createTimeLab.textColor = [UIColor grayColor];
    createTimeLab.text = [NSString stringWithFormat:@"下单时间：%@",_orderData.orderInfo.orderCreateAt];
    [orderIdView addSubview:createTimeLab];
    
    
    
    
    UIView * orderDetailView = [[UIView alloc]initWithFrame:CGRectMake(0 , orderIdView.y + orderIdView.height + 10, GGUISCREENWIDTH-20, 40 + _orderData.skuArray.count * 80)];
    orderDetailView.backgroundColor = [UIColor whiteColor];
    orderDetailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    orderDetailView.layer.borderWidth = 1.0f;
    [scrollView addSubview:orderDetailView];
    
    UILabel * orderDetailLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-40, 40)];
    orderDetailLab.numberOfLines = 1;
    orderDetailLab.font = [UIFont systemFontOfSize:12];
    orderDetailLab.textColor = [UIColor grayColor];
    orderDetailLab.text = @"商品详情";
    [orderDetailView addSubview:orderDetailLab];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH-20, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [orderDetailView addSubview:line2];
    
    
    for (int i = 0; i < _orderData.skuArray.count;i++ ) {
        SkuData * skuData = _orderData.skuArray[i];
        CGFloat hei = 40 + i * 80 ;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, hei + 5, 70, 70)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:skuData.invImg]];
        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        [orderDetailView addSubview:imageView];
        //添加单击手势
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        imageView.tag = 24000+i;
        
        UILabel * orderTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, hei + 5, GGUISCREENWIDTH-120, 30)];
        orderTitleLab.numberOfLines = 2;
        orderTitleLab.font = [UIFont systemFontOfSize:12];
        orderTitleLab.textColor = [UIColor grayColor];
        orderTitleLab.text = skuData.skuTitle;
        [orderDetailView addSubview:orderTitleLab];
        
        
        UILabel * orderAmountLab = [[UILabel alloc]initWithFrame:CGRectMake(90, hei + 35, GGUISCREENWIDTH-120, 20)];
        orderAmountLab.numberOfLines = 1;
        orderAmountLab.font = [UIFont systemFontOfSize:12];
        orderAmountLab.textColor = [UIColor grayColor];
        orderAmountLab.text = [NSString stringWithFormat:@"数量：%ld",(long)skuData.amount];
        [orderDetailView addSubview:orderAmountLab];
        
        UILabel * orderPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(90, hei + 55, GGUISCREENWIDTH-120, 20)];
        orderPriceLab.numberOfLines = 1;
        orderPriceLab.font = [UIFont systemFontOfSize:12];
        orderPriceLab.textColor = [UIColor grayColor];
        orderPriceLab.text = [NSString stringWithFormat:@"￥%@",skuData.price];
        [orderDetailView addSubview:orderPriceLab];
        
        
        if(i != _orderData.skuArray.count-1){
            UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, hei + 80 -1, GGUISCREENWIDTH-20, 1)];
            line2.backgroundColor = [UIColor lightGrayColor];
            [orderDetailView addSubview:line2];
        }
    }
    
    
    
    
    
    
    //收货地址
    UIView * orderAddressView = [[UIView alloc]initWithFrame:CGRectMake(0 , orderDetailView.y + orderDetailView.height + 10, GGUISCREENWIDTH-20, 140)];
    orderAddressView.backgroundColor = [UIColor whiteColor];
    orderAddressView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    orderAddressView.layer.borderWidth = 1.0f;
    [scrollView addSubview:orderAddressView];

    
    UILabel * orderAddressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-40, 40)];
    orderAddressLab.numberOfLines = 1;
    orderAddressLab.font = [UIFont systemFontOfSize:12];
    orderAddressLab.textColor = [UIColor grayColor];
    orderAddressLab.text = @"收货信息";
    [orderAddressView addSubview:orderAddressLab];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH-20, 1)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [orderAddressView addSubview:line3];
    
    
    UILabel * presonNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, GGUISCREENWIDTH-40, 20)];
    presonNameLab.numberOfLines = 1;
    presonNameLab.font = [UIFont systemFontOfSize:12];
    presonNameLab.textColor = [UIColor grayColor];
    presonNameLab.text = [NSString stringWithFormat:@"收货人：%@",_orderData.addressData.name];
    [orderAddressView addSubview:presonNameLab];
    
    
    UILabel * phoneNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, GGUISCREENWIDTH-40, 20)];
    phoneNumLab.numberOfLines = 1;
    phoneNumLab.font = [UIFont systemFontOfSize:12];
    phoneNumLab.textColor = [UIColor grayColor];
    
    phoneNumLab.text = [NSString stringWithFormat:@"手机号码：%@****%@",[_orderData.addressData.tel substringToIndex:3],[_orderData.addressData.tel substringFromIndex:8]];
    [orderAddressView addSubview:phoneNumLab];
    
    
    
    UILabel * idNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, GGUISCREENWIDTH-40, 20)];
    idNumLab.numberOfLines = 1;
    idNumLab.font = [UIFont systemFontOfSize:12];
    idNumLab.textColor = [UIColor grayColor];
    idNumLab.text = [NSString stringWithFormat:@"身份证号：%@****%@",[_orderData.addressData.idCardNum substringToIndex:10],[_orderData.addressData.idCardNum substringFromIndex:14]];
    [orderAddressView addSubview:idNumLab];
    
    
    
    UILabel * addressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, GGUISCREENWIDTH-40, 20)];
    addressLab.numberOfLines = 1;
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.textColor = [UIColor grayColor];
    addressLab.text = [NSString stringWithFormat:@"收货地址：%@ %@",_orderData.addressData.deliveryCity,_orderData.addressData.deliveryDetail];
    [orderAddressView addSubview:addressLab];


    //订单金额
    UIView * orderPayView = [[UIView alloc]initWithFrame:CGRectMake(0 , orderAddressView.y + orderAddressView.height + 10, GGUISCREENWIDTH-20, 180)];
    orderPayView.backgroundColor = [UIColor whiteColor];
    orderPayView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    orderPayView.layer.borderWidth = 1.0f;
    [scrollView addSubview:orderPayView];
    
    
    UILabel * orderPayLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-40, 40)];
    orderPayLab.numberOfLines = 1;
    orderPayLab.font = [UIFont systemFontOfSize:12];
    orderPayLab.textColor = [UIColor grayColor];
    orderPayLab.text = @"订单金额";
    [orderPayView addSubview:orderPayLab];
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH-20, 1)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [orderPayView addSubview:line4];
    
    
    
    UILabel * totalOrderNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, GGUISCREENWIDTH-40, 20)];
    totalOrderNumLab.numberOfLines = 1;
    totalOrderNumLab.font = [UIFont systemFontOfSize:12];
    totalOrderNumLab.textColor = [UIColor grayColor];
    totalOrderNumLab.text = [NSString stringWithFormat:@"订单总件数：%ld",(long)_orderData.orderInfo.orderAmount];
    [orderPayView addSubview:totalOrderNumLab];
    
    UILabel * totalFeeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, GGUISCREENWIDTH-40, 20)];
    totalFeeLab.numberOfLines = 1;
    totalFeeLab.font = [UIFont systemFontOfSize:12];
    totalFeeLab.textColor = [UIColor grayColor];
    totalFeeLab.text = [NSString stringWithFormat:@"商品总费用：%@",_orderData.orderInfo.totalFee];
    [orderPayView addSubview:totalFeeLab];
    
    
    UILabel * shipFeeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, GGUISCREENWIDTH-40, 20)];
    shipFeeLab.numberOfLines = 1;
    shipFeeLab.font = [UIFont systemFontOfSize:12];
    shipFeeLab.textColor = [UIColor grayColor];
    shipFeeLab.text = [NSString stringWithFormat:@"邮费：%@",_orderData.orderInfo.shipFee];
    [orderPayView addSubview:shipFeeLab];
    
    
    
    UILabel * postalFeeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, GGUISCREENWIDTH-40, 20)];
    postalFeeLab.numberOfLines = 1;
    postalFeeLab.font = [UIFont systemFontOfSize:12];
    postalFeeLab.textColor = [UIColor grayColor];
    postalFeeLab.text = [NSString stringWithFormat:@"行邮税：%@",_orderData.orderInfo.postalFee];
    [orderPayView addSubview:postalFeeLab];
    
    
    
    
    UILabel * discountLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, GGUISCREENWIDTH-40, 20)];
    discountLab.numberOfLines = 1;
    discountLab.font = [UIFont systemFontOfSize:12];
    discountLab.textColor = [UIColor grayColor];
    discountLab.text = [NSString stringWithFormat:@"已优惠金额：%@",_orderData.orderInfo.discount];
    [orderPayView addSubview:discountLab];
    
    
    
    
    UILabel * payTotalLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, GGUISCREENWIDTH-40, 20)];
    payTotalLab.numberOfLines = 1;
    payTotalLab.font = [UIFont systemFontOfSize:12];
    payTotalLab.textColor = [UIColor grayColor];
    payTotalLab.text = [NSString stringWithFormat:@"订单应付金额：%@",_orderData.orderInfo.payTotal];
    [orderPayView addSubview:payTotalLab];
    
    
    
    if([_orderData.orderInfo.orderStatus isEqualToString:@"S"])
    {
        
        if (_orderData.refund!=nil) {
            //订单金额
            UIView * refundView = [[UIView alloc]initWithFrame:CGRectMake(0 , PosYFromView(orderPayView, 5), GGUISCREENWIDTH-20, 115)];
            refundView.backgroundColor = [UIColor whiteColor];
            refundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            refundView.layer.borderWidth = 1.0f;
            [scrollView addSubview:refundView];
            
            
            
            UILabel * refundLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GGUISCREENWIDTH-40, 40)];
            refundLab.numberOfLines = 1;
            refundLab.font = [UIFont systemFontOfSize:12];
            refundLab.textColor = [UIColor grayColor];
            refundLab.text = @"退款信息";
            [refundView addSubview:refundLab];
            
            
            UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, GGUISCREENWIDTH-20, 1)];
            line5.backgroundColor = [UIColor lightGrayColor];
            [refundView addSubview:line5];
            
            UILabel * priceLab = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(line5, 5), GGUISCREENWIDTH-40, 20)];
            priceLab.numberOfLines = 1;
            priceLab.font = [UIFont systemFontOfSize:12];
            priceLab.textColor = [UIColor grayColor];
            priceLab.text = [NSString stringWithFormat:@"退款金额：%@",_orderData.refund.payBackFee];
            [refundView addSubview:priceLab];
            
            
            UILabel * reasonLab = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(priceLab, 0), GGUISCREENWIDTH-40, 20)];
            reasonLab.numberOfLines = 1;
            reasonLab.font = [UIFont systemFontOfSize:12];
            reasonLab.textColor = [UIColor grayColor];
            reasonLab.text = [NSString stringWithFormat:@"退款原因：%@",_orderData.refund.reason];
            [refundView addSubview:reasonLab];
            
            UILabel * stateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, PosYFromView(reasonLab, 0), GGUISCREENWIDTH-40, 20)];
            stateLab.numberOfLines = 1;
            stateLab.font = [UIFont systemFontOfSize:12];
            stateLab.textColor = [UIColor grayColor];
            
            if ([_orderData.refund.state isEqualToString:@"I"]) {
                stateLab.text = [NSString stringWithFormat:@"退款状态：申请受理中"];
            }else if([_orderData.refund.state isEqualToString:@"A"])
            {
                stateLab.text = [NSString stringWithFormat:@"退款状态：提示5-15个工作日，退款金额自动返回"];
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
        {
            UIButton * looutMoneyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, PosYFromView(orderPayView, 5), SCREEN_WIDTH, 40)];
            [looutMoneyButton setBackgroundColor:GGMainColor];
            [looutMoneyButton setTitle:@"退款" forState:UIControlStateNormal];
            [looutMoneyButton addTarget:self action:@selector(looutMoneyButtonclcik:) forControlEvents:UIControlEventTouchUpInside];
            [looutMoneyButton.layer setMasksToBounds:YES];
            [looutMoneyButton.layer setCornerRadius:4.0];
            [scrollView addSubview:looutMoneyButton];
        }

    }
    
    if([_orderData.orderInfo.orderStatus isEqualToString:@"I"]){
        //取消订单
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn.layer setMasksToBounds:YES];
        [cancelBtn.layer setCornerRadius:5.0];
        cancelBtn.frame = CGRectMake(0,  orderPayView.y + orderPayView.height + 20, GGUISCREENWIDTH/2-20, 40);
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancelBtn setBackgroundColor:[UIColor grayColor]];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag = 50013;
        [scrollView addSubview:cancelBtn];
        
        //去支付
        payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn.layer setMasksToBounds:YES];
        [payBtn.layer setCornerRadius:5.0];
        payBtn.frame = CGRectMake(cancelBtn.x + cancelBtn.width +20,  orderPayView.y + orderPayView.height + 20, GGUISCREENWIDTH/2-20, 40);
        [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [payBtn setBackgroundColor:GGMainColor];
        [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        payBtn.tag = 50013;
        [scrollView addSubview:payBtn];
        

    }
    
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
    GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
    gdViewController.url = sd.invUrl;
    [self.navigationController pushViewController:gdViewController animated:YES];

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
