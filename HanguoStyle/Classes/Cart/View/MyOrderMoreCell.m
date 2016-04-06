//
//  MyOrderMoreCell.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/12/29.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "MyOrderMoreCell.h"
#import "UIView+frame.h"
#import "UIImageView+WebCache.h"
@interface MyOrderMoreCell()<UIScrollViewDelegate>{
    UIView * globView;
    UIView * headView;
    UILabel * orderIdLab;
    UILabel * createDateLab;
    UILabel * orderStatusLab;
    UIImageView * nextImageView;
    UIView * footView;
    UIView * middleView;
    UILabel * payLab;
    UIButton * payBtn;
    UIButton * qrshBtn;
    UIButton * ckwlBtn;
    UIScrollView * scrollView;
}
@end
@implementation MyOrderMoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        orderIdLab.textColor = [UIColor grayColor];
        orderIdLab.tag = 50002;
        [headView addSubview:orderIdLab];
        
    }
    orderIdLab.text = [NSString stringWithFormat:@"订单号：%ld",data.orderInfo.orderId];
    
    if([self.contentView viewWithTag:50003] == nil){
        
        //创建时间
        createDateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, GGUISCREENWIDTH-100, 25)];
        createDateLab.font = [UIFont systemFontOfSize:12];
        createDateLab.textColor = [UIColor grayColor];
        createDateLab.tag = 50003;
        [headView addSubview:createDateLab];
        
    }
    createDateLab.text = data.orderInfo.orderCreateAt;
    
    
    if([self.contentView viewWithTag:50004] == nil){
        
        orderStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH - 90, 0, 50, 50)];
        orderStatusLab.font = [UIFont systemFontOfSize:12];
        orderStatusLab.textAlignment = NSTextAlignmentRight;
        orderStatusLab.textColor = [UIColor grayColor];
        orderStatusLab.tag = 50004;
        [headView addSubview:orderStatusLab];
        
    }
    //订单状态
    NSString * status = data.orderInfo.orderStatus;
    //		I:初始化即未支付状态，S:成功，C：取消， F:失败，R:已收货，D:已经发货，J:拒收
    
    
    if([status isEqualToString:@"C"]){
        orderStatusLab.text = @"已取消";
    }else if([status isEqualToString:@"I"]){
        orderStatusLab.text = @"待付款";
    }else if([status isEqualToString:@"S"]){
        orderStatusLab.text = @"待发货";
    }else if([status isEqualToString:@"F"]){
        orderStatusLab.text = @"失败";
    }else if([status isEqualToString:@"R"]){
        orderStatusLab.text = @"已收货";
    }else if([status isEqualToString:@"D"]){
        orderStatusLab.text = @"待收货";
    }else if([status isEqualToString:@"J"]){
        orderStatusLab.text = @"拒收货";
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
    
    if([self.contentView viewWithTag:50007] != nil){
        [[self.contentView viewWithTag:50007] removeFromSuperview];
    }
    //设置scrollview
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(10, 10, GGUISCREENWIDTH-20, 80);
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(80 * _data.skuArray.count, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.tag =50007;
    [middleView addSubview:scrollView];
    
    for (int i = 0; i<_data.skuArray.count; i++) {
        UIImageView * titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*80,0,75,75)];
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [titleImageView sd_setImageWithURL:[NSURL URLWithString:((SkuData *)data.skuArray[i]).invImg]];
        
        
        CALayer *layer = [titleImageView layer];
        layer.borderColor = GGBgColor.CGColor;
        layer.borderWidth = 1.0f;
        [scrollView addSubview:titleImageView];
    }
    
    
   
    //底部视图
    if([self.contentView viewWithTag:50011] == nil){
        
        footView = [[UIView alloc]initWithFrame:CGRectMake(0,middleView.y + middleView.height + 1 , GGUISCREENWIDTH, 50)];
        footView.backgroundColor = [UIColor whiteColor];
        footView.tag = 50011;
        [globView addSubview:footView];
        
    }
    
    if([status isEqualToString:@"I"]){//待支付
        
        if([self.contentView viewWithTag:50012] == nil){
            payLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, GGUISCREENWIDTH-150, 30)];
            payLab.numberOfLines = 1;
            payLab.font = [UIFont systemFontOfSize:12];
            payLab.textColor = [UIColor grayColor];
            payLab.tag = 50012;
            [footView addSubview:payLab];
            
        }
        payLab.text = [NSString stringWithFormat:@"应付金额%@",data.orderInfo.payTotal];
        
        
        
        if([self.contentView viewWithTag:50013] == nil){
            payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [payBtn.layer setMasksToBounds:YES];
            [payBtn.layer setCornerRadius:5.0];
            payBtn.frame = CGRectMake(GGUISCREENWIDTH-80, 10, 70, 30);
            [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
            payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [payBtn setBackgroundColor:GGMainColor];
            [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
            payBtn.tag = 50013;
            [footView addSubview:payBtn];
        }
        
        
        
        
        
    }else if([status isEqualToString:@"D"]){//待收货
        
        
        
        if([self.contentView viewWithTag:50014] == nil){
            qrshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [qrshBtn.layer setMasksToBounds:YES];
            [qrshBtn.layer setCornerRadius:5.0];
            qrshBtn.frame = CGRectMake(GGUISCREENWIDTH-160, 10, 70, 30);
            [qrshBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            qrshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [qrshBtn setBackgroundColor:GGMainColor];
            [qrshBtn addTarget:self action:@selector(qrshBtnClick) forControlEvents:UIControlEventTouchUpInside];
            qrshBtn.tag = 50014;
            [footView addSubview:qrshBtn];
        }
        
        
        if([self.contentView viewWithTag:50015] == nil){
            ckwlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [ckwlBtn.layer setMasksToBounds:YES];
            [ckwlBtn.layer setCornerRadius:5.0];
            ckwlBtn.frame = CGRectMake(GGUISCREENWIDTH-80, 10, 70, 30);
            [ckwlBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            ckwlBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [ckwlBtn setBackgroundColor:GGMainColor];
            [ckwlBtn addTarget:self action:@selector(ckwlBtnClick) forControlEvents:UIControlEventTouchUpInside];
            ckwlBtn.tag = 50015;
            [footView addSubview:ckwlBtn];
        }
        
    }else{
        
        [[self.contentView viewWithTag:50011] removeFromSuperview];
    }
    
}
-(void)payBtnClick{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    [self.delegate checkOrder:_data];
}
//确认收货
-(void)qrshBtnClick{
    
}
//查看物流
-(void)ckwlBtnClick{
    
}
@end
