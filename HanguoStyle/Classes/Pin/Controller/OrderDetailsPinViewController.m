//
//  OrderDetailsViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/3/31.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "OrderDetailsPinViewController.h"
#define sapce 8
@interface OrderDetailsPinViewController ()<UITableViewDelegate,UITableViewDataSource>
{
}
@end


@interface OrderDetailsPinCell : UITableViewCell
@property (nonatomic ,strong) SkuData * skuData;
@end



@implementation OrderDetailsPinViewController
@synthesize orderId = selectOrderId;
@synthesize tableView = tableView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"团购订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    
}
-(void)requestData{
    NSString *

    urlString = [NSString stringWithFormat:@"%@/%ld",[HSGlobal myOrderUrl],selectOrderId];
    
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
            if (selectOrderId != 0) {
                for (id node in dataArray) {
                    self.singleData = [[MyOrderData alloc] initWithJSONNode:node];
//                    [self.tableView reloadData];
                }
                [self createWebView];
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



-(void)createWebView{
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT) style:UITableViewStylePlain];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.bounces = YES;
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.showsHorizontalScrollIndicator = NO;
    tableView_.showsVerticalScrollIndicator = NO;
    tableView_.bounces = YES;
    [self.view addSubview:tableView_];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120 + 200)];
    
    UIImageView * statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    
    if ([self.singleData.orderInfo.orderStatus isEqualToString:@"S"]) {
        statusImageView.image = [UIImage imageNamed:@"order"];
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"D"])
    {
        statusImageView.image = [UIImage imageNamed:@"peisong"];
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"R"])
    {
        statusImageView.image = [UIImage imageNamed:@"sign"];
    }else
    {
        statusImageView.image = [UIImage imageNamed:@"oldtime"];
    }
    
    [headerView addSubview:statusImageView];
    
    
    CGFloat top = PosYFromView(statusImageView, 0);
    
//    分割线
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 1)];
    topLine.backgroundColor = GGBgColor;
    
    [headerView addSubview:topLine];
    
    top = PosYFromView(topLine, 15);
    
//订单状态 标题
    UILabel * statusLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, top, 70, 15)];
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.textColor = [UIColor grayColor];
    statusLabel.text = @"订单状态:";
    [headerView addSubview:statusLabel];
//订单状态 标题值
    
    UILabel * statusDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(statusLabel, 5), top, SCREEN_WIDTH-45-10-20, 15)];
    statusDataLabel.font = [UIFont systemFontOfSize:14];
    if ([self.singleData.orderInfo.orderStatus isEqualToString:@"S"]) {
       statusDataLabel.text =@"等待配送";
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"D"])
    {
       statusDataLabel.text =@"配送中";
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"R"])
    {
       statusDataLabel.text =@"已签收";
    }else
    {
        statusDataLabel.text =@"已过期";
    }
    
    statusDataLabel.textColor = GGMainColor;
     [headerView addSubview:statusDataLabel];
    top = PosYFromView(statusDataLabel, sapce);
//总额
    UILabel * countPriceLabelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, top, 70, 15)];
    countPriceLabelTitle.font = [UIFont systemFontOfSize:14];
    countPriceLabelTitle.textColor = [UIColor grayColor];
    countPriceLabelTitle.text = @"总额:  ";
    
    [headerView addSubview:countPriceLabelTitle];
    
    UILabel * countPriceLabelData = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(countPriceLabelTitle, 5), top, 40, 15)];
    
    countPriceLabelData.font = [UIFont systemFontOfSize:14];
    countPriceLabelData.text = [NSString stringWithFormat:@"￥%@ ",self.singleData.orderInfo.payTotal];
    countPriceLabelData.textColor = GGRedColor;
    [headerView addSubview:countPriceLabelData];
    
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize  lastSize1 = [countPriceLabelData.text boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    countPriceLabelData.frame = CGRectMake(PosXFromView(countPriceLabelTitle, 5), top, lastSize1.width, lastSize1.height);
    
    
    UILabel * countPriceLabelframe = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(countPriceLabelData
                                                                                           , 0), top, SCREEN_WIDTH-20-5-20-lastSize1.width, 15)];
    NSString * payType = @"";
    countPriceLabelframe.font = [UIFont systemFontOfSize:14];
    if(![NSString isNSNull:self.singleData.orderInfo.payMethod]){
        if([self.singleData.orderInfo.payMethod isEqualToString:@"JD"]){
            payType = @"京东支付";
        }else if([self.singleData.orderInfo.payMethod isEqualToString:@"ALIPAY"]){
            payType = @"支付宝支付";
        }else if([self.singleData.orderInfo.payMethod isEqualToString:@"WEIXIN"]){
            payType = @"微信支付";
        }
    }else{
        payType = @"在线支付";
    }

    countPriceLabelframe.text = [NSString stringWithFormat:@"(%@)",payType];
    countPriceLabelframe.textColor = [UIColor grayColor];
    [headerView addSubview:countPriceLabelframe];

    top = PosYFromView(countPriceLabelframe, sapce);
//送至
    
    UILabel * songTo = [self createLabel:70 H:15 X:10 Y:top textColor:[UIColor grayColor] text:@"送至:  "];
    [headerView addSubview:songTo];
    
//送至内容
    
    UILabel * songTodata = [self createLabel:SCREEN_WIDTH - 20 -70  H:15 X:PosXFromView(songTo, 5) Y:top textColor:[UIColor grayColor] text:[NSString stringWithFormat:@"%@,%@",self.singleData.addressData.deliveryCity,self.singleData.addressData.deliveryDetail]];
    
    CGSize maxSize2 = CGSizeMake(SCREEN_WIDTH - 20 -70, MAXFLOAT);
    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize  lastSize2 = [songTodata.text boundingRectWithSize:maxSize2 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
    songTodata.numberOfLines = 0;
    
    songTodata.frame = CGRectMake(PosXFromView(songTo, 5), top, lastSize2.width, lastSize2.height);
    [headerView addSubview:songTodata];
    
   
    
    top = PosYFromView(songTodata, sapce);
//收货人
    UILabel * shouPerson = [self createLabel:70 H:15 X:10 Y:top textColor:[UIColor grayColor] text:@"收货人: "];
    [headerView addSubview:shouPerson];
    
    UILabel * shouPersonData = [self createLabel:SCREEN_WIDTH - 20 -70 H:15 X:PosXFromView(shouPerson, 5) Y:top textColor:[UIColor grayColor] text:[NSString stringWithFormat:@"%@ %@",self.singleData.addressData.name,self.singleData.addressData.tel]];
    [headerView addSubview:shouPersonData];

    top = PosYFromView(shouPerson, sapce);
//订单编号
    UILabel * orderID = [self createLabel:70 H:15 X:10 Y:top textColor:[UIColor grayColor] text:@"订单编号:"];
    [headerView addSubview:orderID];
    UILabel * orderIDData = [self createLabel:70 H:15 X:PosXFromView(orderID, 5) Y:top textColor:[UIColor grayColor] text:[NSString stringWithFormat:@"%ld",self.singleData.orderInfo.orderId]];
    [headerView addSubview:orderIDData];
    top = PosYFromView(orderID, sapce);
//下单时间
    UILabel * time = [self createLabel:70 H:15 X:10 Y:top textColor:[UIColor grayColor] text:@"下单时间:"];
    [headerView addSubview:time];
    UILabel * timeData = [self createLabel:SCREEN_WIDTH - 20 -70 H:15 X:PosXFromView(time, 5) Y:top textColor:[UIColor grayColor] text:self.singleData.orderInfo.orderCreateAt];
    [headerView addSubview:timeData];
    top = PosYFromView(time, sapce);
//配送方式
    
    
    
    UILabel * peisongType = [self createLabel:70 H:15 X:10 Y:top textColor:[UIColor grayColor
                                                                            ] text:@"配送方式:"];
    [headerView addSubview:peisongType];
    UILabel * peisongTypeData = [self createLabel:70 H:15 X:PosXFromView(peisongType, 5) Y:top textColor:[UIColor grayColor] text:self.singleData.orderInfo.orderCreateAt];
    [headerView addSubview:peisongTypeData];
    
    
    if ([self.singleData.orderInfo.orderStatus isEqualToString:@"S"]) {
        peisongType.hidden = YES;
        peisongTypeData.hidden = YES;
        top = top - sapce;
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"D"])
    {
        peisongType.hidden = NO;
        peisongTypeData.hidden = NO;
        top = PosYFromView(peisongType, 8);
        
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"R"])
    {
        peisongType.hidden = NO;
        peisongTypeData.hidden = NO;
        top = PosYFromView(peisongType, 8);
    }else
    {
        peisongType.hidden = YES;
        peisongTypeData.hidden = YES;
        top = top;
    }
    
    
//退货 评价按钮
    
    
    if ([self.singleData.orderInfo.orderStatus isEqualToString:@"S"]) {
         top =top+15;
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"D"])
    {
        UIButton * lookWuliu = [[UIButton alloc]initWithFrame:CGRectMake(10, top, (SCREEN_WIDTH - 30)/2, 30)];
        [lookWuliu setTitle:@"查看物流" forState:UIControlStateNormal];
        [lookWuliu setBackgroundColor:[UIColor grayColor]];
        [lookWuliu setTintColor:[UIColor whiteColor]];
        [headerView addSubview:lookWuliu];
        
        UIButton * queRenShouHuo = [[UIButton alloc]initWithFrame:CGRectMake(PosXFromView(lookWuliu, 10), top, (SCREEN_WIDTH - 30)/2, 30)];
        [queRenShouHuo setTitle:@"确认收货" forState:UIControlStateNormal];
        [queRenShouHuo setBackgroundColor:[UIColor grayColor]];
        [queRenShouHuo setTintColor:GGMainColor];
        [headerView addSubview:queRenShouHuo];
        top = PosYFromView(queRenShouHuo, 15);
    }else if([self.singleData.orderInfo.orderStatus isEqualToString:@"R"])
    {
        peisongType.hidden = NO;
        peisongTypeData.hidden = NO;
        UIButton * tuihuo = [[UIButton alloc]initWithFrame:CGRectMake(10, top, (SCREEN_WIDTH - 30)/2, 30)];
        [tuihuo setTitle:@"退货" forState:UIControlStateNormal];
        [tuihuo setBackgroundColor:[UIColor grayColor]];
        [tuihuo setTintColor:[UIColor whiteColor]];
        [headerView addSubview:tuihuo];
        
        UIButton * pingjia = [[UIButton alloc]initWithFrame:CGRectMake(PosXFromView(tuihuo, 10), top, (SCREEN_WIDTH - 30)/2, 30)];
        [pingjia setTitle:@"评价" forState:UIControlStateNormal];
        [pingjia setBackgroundColor:[UIColor grayColor]];
        [pingjia setTintColor:GGMainColor];
        [headerView addSubview:pingjia];
        
        top = PosYFromView(tuihuo, 15);
        
    }
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = GGBgColor;
    [headerView addSubview:lineView];
    
    
    top  = PosYFromView(lineView, 8);
    
    //商品信息
    
    UILabel * dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, top, 80, 20)];
    dataLabel.textColor = [UIColor blackColor];
    dataLabel.text = @"商品信息";
    dataLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:dataLabel];
    
    top  = PosYFromView(dataLabel, 8);
    
    
    UIView * lineViewdata = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 1)];
    lineViewdata.backgroundColor = GGBgColor;
    [headerView addSubview:lineViewdata];
    
    
    headerView.height = top+1;
     tableView_.tableHeaderView = headerView;
}


-(UILabel *)createLabel:(CGFloat )w H:(CGFloat)h X:(CGFloat)x Y:(CGFloat)y textColor:(UIColor *)textcolor text:(NSString *)text
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
    label.textColor = textcolor;
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.singleData.skuArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailsPinCell *cell = (OrderDetailsPinCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    
    if (nil == cell) {
        cell = [[OrderDetailsPinCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"OrderCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SkuData * data =  self.singleData.skuArray[indexPath.row];
    cell.skuData = data;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



@end



@implementation OrderDetailsPinCell{
    UIImageView *iconImageView;
    UILabel * titleLabel;
    UILabel * countLabel;
    UILabel * priceLabel;
    UIView * lineView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        iconImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self.contentView addSubview:iconImageView];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(iconImageView, 10), 10, SCREEN_WIDTH - 10-100, 20)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:titleLabel];
        
        countLabel = [[UILabel alloc]initWithFrame:CGRectMake(PosXFromView(iconImageView, 10), 100-10-15, 200, 15)];
        countLabel.textAlignment = NSTextAlignmentLeft;
        countLabel.font = [UIFont systemFontOfSize:14];
        countLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:countLabel];
        
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 100, 100-10-15 , 100, 15)];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = [UIFont systemFontOfSize:14];
        priceLabel.textColor = GGMainColor;
        [self.contentView addSubview:priceLabel];
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 100-0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = GGBgColor;
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

-(void)setSkuData:(SkuData *)skuData
{
    _skuData = skuData;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:skuData.invImg]];
    titleLabel.text = skuData.skuTitle;
    countLabel.text = [NSString stringWithFormat:@"数量:%ld",skuData.amount];
    priceLabel.text = [NSString stringWithFormat:@"￥%@/件",skuData.price];
    
    
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 10-100, MAXFLOAT);
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize  lastSize1 = [titleLabel.text boundingRectWithSize:maxSize1 options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    titleLabel.numberOfLines = 0;
    titleLabel.frame = CGRectMake(PosXFromView(iconImageView, 10), 10, lastSize1.width, lastSize1.height);
    
}


@end
