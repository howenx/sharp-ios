//
//  OrderViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/15.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "OrderViewController.h"
#import "AddressCell.h"
#import "OrderCartCell.h"
#import "AddAddrCell.h"
#import "AddressViewController.h"
#import "SendGoodTimeCell.h"
#import "PayTypeCell.h"
#import "CouponCell.h"
#import "HSGlobal.h"
#import "PayViewController.h"

@interface OrderViewController ()<AddressViewControllerDelegate,SendGoodTimeCellDelegate,PayTypeCellDelegate,CouponCellDelegate>
{
    AddressCell * addressCell;
    OrderCartCell * orderCartCell;
    AddAddrCell * addAddrCell;
    SendGoodTimeCell * sendGoodTimeCell;
    PayTypeCell * payTypeCell;
    CouponCell * couponCell;
    CGFloat bottom;
    BOOL isTimeEdit;
    BOOL isPayTypeEdit;
    BOOL isCouponEdit;
    CGFloat rowTwoH;
    CGFloat rowThreeH;
    CGFloat rowFourH;
    NSString * sendTime;
    int sendTimeId;
    NSString * payType;
//    NSString * payTypeId;
    NSString * coupon;
    NSString * _couponId;
    
    CGFloat couponBottom;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footView;

@property (nonatomic) UILabel * payLab;
@property (nonatomic) UIButton * payBtn;
@property (nonatomic) UILabel * noticeLab;
@end

@implementation OrderViewController
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.scrollsToTop = YES;
    self.navigationItem.title = @"支付";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadBasic];
    [self createFootView];
    _noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT-60-64, GGUISCREENWIDTH, 20)];
    _noticeLab.textAlignment = NSTextAlignmentCenter;
    _noticeLab.alpha = 0.9;
    _noticeLab.font = [UIFont systemFontOfSize:12];
    _noticeLab.text = @"海关规定跨境商品支付金额不小于1元";
    _noticeLab.backgroundColor = UIColorFromRGB(0xFFEDCF);
    _noticeLab.textColor = GGMainColor;
    [self.view addSubview:_noticeLab];
    _noticeLab.hidden = YES;
}


-(void) loadBasic{
    bottom = 0;
    couponBottom = 0;
    rowTwoH = 110;
    rowThreeH = 90;
    rowFourH = 60+160;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    sendTime = @"工作日双休日与假期均可送货";
    payType = @"在线支付";
    coupon = @"0";
    _couponId= @"";
//    payTypeId = @"JD";
    sendTimeId = 1;
    isTimeEdit = NO;
    isPayTypeEdit = NO;
    isCouponEdit = NO;
    


}
-(void) createFootView{
    _payLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH/2, _footView.height)];
    _payLab.backgroundColor = [UIColor grayColor];
    _payLab.textAlignment = NSTextAlignmentCenter;
    _payLab.font = [UIFont systemFontOfSize:14];
    _payLab.textColor = [UIColor whiteColor];
    _payLab.text = [NSString stringWithFormat:@"应支付：￥%.2f",[_realityPay floatValue] + [self.orderData.factPortalFee floatValue] + [self.orderData.factShipFee floatValue]];
    [_footView addSubview:_payLab];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.backgroundColor = GGMainColor;
    _payBtn.frame = CGRectMake(GGUISCREENWIDTH/2, 0, GGUISCREENWIDTH/2,  _footView.height);
    [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    _payBtn.titleLabel.textColor = [UIColor whiteColor];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_footView addSubview:_payBtn];
}
- (void)payBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    if([NSString isBlankString:self.orderData.addressData.addId]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.labelText = @"请选择收货地址";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
    }
    
    NSMutableDictionary * lastDict = [NSMutableDictionary dictionary];
    [lastDict setObject: _mutArray forKey:@"settleDTOs"];
    [lastDict setObject: [NSNumber numberWithInt:self.orderData.addressData.addId.intValue] forKey:@"addressId"];
    [lastDict setObject: _couponId forKey:@"couponId"];//优惠券
    [lastDict setObject: @"" forKey:@"clientIp"];
    [lastDict setObject: [NSNumber numberWithInt:sendTimeId] forKey:@"shipTime"];//送货时间
    [lastDict setObject: [NSNumber numberWithInt:2] forKey:@"clientType"];//2:ios
    [lastDict setObject: @"" forKey:@"orderDesc"];
//    [lastDict setObject: payTypeId forKey:@"payMethod"];//支付方式
    [lastDict setObject: [NSNumber numberWithInt:_buyNow] forKey:@"buyNow"];
    [lastDict setObject: [NSNumber numberWithLong:_pinActiveId] forKey:@"pinActiveId"];
    
    
    NSString * urlString =[HSGlobal sendOrderInfo];
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager POST:urlString  parameters:lastDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code =[[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
           long orderId = [[object objectForKey:@"orderId"]longValue];
            PayViewController * pay = [[PayViewController alloc]init];
            pay.payType = _orderType;
            pay.orderId = orderId;
            
            [self.navigationController pushViewController:pay animated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        NSLog(@"Error: %@", error);
        [PublicMethod printAlert:@"下订单失败"];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        if([NSString isBlankString:self.orderData.addressData.addId] ){
            if (addAddrCell == nil) {
                addAddrCell  = [AddAddrCell subjectCell];
                addAddrCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return addAddrCell;
        }else{

            addressCell  = [AddressCell subjectCell];
            addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
            addressCell.from =  @"orderAddr";
            addressCell.data = self.orderData.addressData;

            return addressCell;
        }
        
    }
    if(indexPath.row == 1){
        if(orderCartCell == nil){
            orderCartCell = [[OrderCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            orderCartCell.selectionStyle = UITableViewCellSelectionStyleNone;
            orderCartCell.data = self.orderData;

        }
        return orderCartCell;
    }
    if(indexPath.row == 2){

        sendGoodTimeCell = [[SendGoodTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        sendGoodTimeCell.isTimeEdit = isTimeEdit;
        sendGoodTimeCell.sendTime =  sendTime;
        [sendGoodTimeCell createView];
        sendGoodTimeCell.delegate = self;
        [sendGoodTimeCell.editBtn addTarget:self action:@selector(editTimeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [sendGoodTimeCell.editBtn.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTimeBtnClicked)]];
        sendGoodTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return sendGoodTimeCell;
    }
//    if(indexPath.row == 3){
//        
//        payTypeCell = [[PayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        payTypeCell.isPayTypeEdit = isPayTypeEdit;
//        payTypeCell.payType =  payType;
//        [payTypeCell createView];
//        payTypeCell.delegate = self;
//        [payTypeCell.editBtn addTarget:self action:@selector(editPayTypeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [payTypeCell.editBtn.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPayTypeBtnClicked)]];
//        payTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        return payTypeCell;
//    }
    if(indexPath.row == 3){
        
        couponCell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        couponCell.isCouponEdit = isCouponEdit;
        couponCell.coupon =  coupon;
        couponCell.realityPay = _realityPay;
        couponCell.delegate = self;
        couponCell.data = self.orderData;
        [couponCell.editBtn addTarget:self action:@selector(couponBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [couponCell.editBtn.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponBtnClicked)]];
        couponCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return couponCell;
    }

    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 110;
    }
    if (indexPath.row == 1) {
        if(bottom == 0){
            bottom = 10;
            for(int i = 0 ;i<_orderData.singleCustomsArray.count; i++){
                OrderDetailData * orderDetailData = _orderData.singleCustomsArray[i];
                int cartCount = (int)orderDetailData.cartDataArray.count;
                bottom = bottom + cartCount*100 + 80;
            }
        }
        return bottom;
    }
    if (indexPath.row == 2) {
        return rowTwoH;
    }
//    if (indexPath.row == 3) {
//        return rowThreeH;
//    }
    if (indexPath.row == 3) {
        return rowFourH;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到商品展示页面
    if(indexPath.row == 0){
        if(![PublicMethod isConnectionAvailable]){
            return;
        }
        AddressViewController * adViewController = [[AddressViewController alloc]init];
        adViewController.delegate =self;
        adViewController.addId = self.orderData.addressData.addId;
        adViewController.comeFrom = @"order";
        [self.navigationController pushViewController:adViewController animated:YES];

    }
}
- (void) editTimeBtnClicked
{
    isTimeEdit = !isTimeEdit;

    if (isTimeEdit){
        rowTwoH = 220;
    }else{
        rowTwoH = 110;
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
//- (void) editPayTypeBtnClicked
//{
//    isPayTypeEdit = !isPayTypeEdit;
//    
//    if (isPayTypeEdit){
//        rowThreeH = 120;
//    }else{
//        rowThreeH = 90;
//    }
//    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

- (void) couponBtnClicked
{
    isCouponEdit = !isCouponEdit;
    
    if (isCouponEdit){

        int couponCount = (int)_orderData.couponsArray.count;
        rowFourH = 90 + couponCount * 40 + 160;
        
    }else{
        rowFourH = 60 + 160;
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//代理方法
-(void)backAddressData:(AddressData *)addressData{
    self.orderData.addressData = addressData;
    [self updatePageData];

}

-(void)sendTimeFlag:(NSString *)timeFlag{
    sendTime = timeFlag ;
    if([timeFlag isEqualToString:@"工作日双休日与假期均可送货"]){
        sendTimeId = 1;
    }else if([timeFlag isEqualToString:@"只工作日送货"]){
        sendTimeId = 2;
    }else if([timeFlag isEqualToString:@"只双休日与假期送货"]){
        sendTimeId = 3;
    }
}

//-(void)payTypeFlag:(NSString *)payTypeFlag{
//    payType = payTypeFlag ;
////    payTypeId = @"JD";
//}
-(void)couponFlag:(NSString *)couponFlag andCouponId:(NSString *)couponId{
    coupon = couponFlag;
    _couponId = couponId;
    
    if([couponFlag floatValue]>[_realityPay floatValue] + [self.orderData.factPortalFee floatValue] + [self.orderData.factShipFee floatValue]){
        _payLab.text = [NSString stringWithFormat:@"应支付：￥1"];
        _noticeLab.hidden = NO;
    }else{
        _payLab.text = [NSString stringWithFormat:@"应支付：￥%.2f",[_realityPay floatValue] + [self.orderData.factPortalFee floatValue] + [self.orderData.factShipFee floatValue]-[couponFlag floatValue]];
        _noticeLab.hidden = YES;
    }

}


- (void)updatePageData {

        
        NSMutableDictionary * lastDict = [NSMutableDictionary dictionary];
        [lastDict setObject: _mutArray forKey:@"settleDTOs"];
        [lastDict setObject: [NSNumber numberWithInt:self.orderData.addressData.addId.intValue] forKey:@"addressId"];
        [lastDict setObject: @"" forKey:@"couponId"];
        [lastDict setObject: @"" forKey:@"clientIp"];
        [lastDict setObject: [NSNumber numberWithInt:1] forKey:@"shipTime"];
        [lastDict setObject: [NSNumber numberWithInt:2] forKey:@"clientType"];//2:ios
        [lastDict setObject: @"" forKey:@"orderDesc"];
//        [lastDict setObject: payTypeId forKey:@"payMethod"];//支付方式
        [lastDict setObject: [NSNumber numberWithInt:_buyNow] forKey:@"buyNow"];

            NSString * urlString =[HSGlobal sendCartToOrder];
            AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
            
            if (manager ==nil) {
                return;
            }
            [GiFHUD setGifWithImageName:@"hmm.gif"];
            [GiFHUD show];
            [manager POST:urlString  parameters:lastDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary * settleDict = [object objectForKey:@"settle"];
                NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
                NSInteger code =[[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
                NSLog(@"message= %@",message);
                if(code == 200){
                    OrderData * orderData1 = [[OrderData alloc]initWithJSONNode:settleDict];
                    for(int i=0; i<orderData1.singleCustomsArray.count; i++){//orderData.singleCustomsArray.count其实就是1
                        for(int j = 0; j < _orderData.singleCustomsArray.count;j++){
                            if([((OrderDetailData *)_orderData.singleCustomsArray[j]).invAreaNm isEqualToString:((OrderDetailData *)orderData1.singleCustomsArray[i]).invAreaNm]){
                                ((OrderDetailData *)_orderData.singleCustomsArray[j]).invCustoms = ((OrderDetailData *)orderData1.singleCustomsArray[i]).invCustoms;
                                ((OrderDetailData *)_orderData.singleCustomsArray[j]).portalSingleCustomsFee = ((OrderDetailData *)orderData1.singleCustomsArray[i]).portalSingleCustomsFee;
                                ((OrderDetailData *)_orderData.singleCustomsArray[j]).shipSingleCustomsFee = ((OrderDetailData *)orderData1.singleCustomsArray[i]).shipSingleCustomsFee;
                                ((OrderDetailData *)_orderData.singleCustomsArray[j]).factPortalFeeSingleCustoms = ((OrderDetailData *)orderData1.singleCustomsArray[i]).factPortalFeeSingleCustoms;
                                ((OrderDetailData *)_orderData.singleCustomsArray[j]).singleCustomsSumFee = ((OrderDetailData *)orderData1.singleCustomsArray[i]).singleCustomsSumFee;
                                ((OrderDetailData *)_orderData.singleCustomsArray[j]).factSingleCustomsShipFee = ((OrderDetailData *)orderData1.singleCustomsArray[i]).factSingleCustomsShipFee;

                            }
                        }
                    }
                    _orderData.shipFee = orderData1.shipFee;
                    _orderData.factPortalFee = orderData1.factPortalFee;
                    _orderData.portalFee = orderData1.portalFee;
                    _orderData.factShipFee = orderData1.factShipFee;
                    _payLab.text = [NSString stringWithFormat:@"应支付：￥%.2f",[_realityPay floatValue] + [self.orderData.factPortalFee floatValue] + [self.orderData.factShipFee floatValue]];
                    [self loadBasic];
                    [_tableView reloadData];
                    

                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                NSLog(@"Error: %@", error);
                [PublicMethod printAlert:@"下订单失败"];
            }];

}



@end
