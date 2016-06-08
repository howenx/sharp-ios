//
//  SearchLogisticsViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/4/15.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "SearchLogisticsViewController.h"
#import "SearchLogisticsData.h"
@interface SearchLogisticsViewController ()<UIScrollViewDelegate>
{
    UIScrollView * scrollView;
    SearchLogisticsData * _data;
    float flowHeight;
    
}
@end

@implementation SearchLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GGBgColor;
    self.navigationItem.title = @"物流信息";
        [self headerRefresh];
}
- (void) headerRefresh
{
    NSString * url = [NSString stringWithFormat:@"%@%@",[HSGlobal searchLogisticsUrl],_orderId];
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        _data = [[SearchLogisticsData alloc] initWithJSONNode:object];
        if([_data.message isEqualToString:@"ok"]){
            [self createView];
        }else{
            UIView * _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64)];
            _bgView.backgroundColor = GGBgColor;
            UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH -152)/2, GGUISCREENHEIGHT/8, 152, 190)];
            bgImageView.image = [UIImage imageNamed:@"no_logistics"];
            [_bgView addSubview:bgImageView];
            [self.view addSubview:_bgView];
        }
        
        [GiFHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
    }];
}
-(void)createView{
    
    //上面的view
    UIView * orderIdView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, GGUISCREENWIDTH-20, 71)];
    orderIdView.backgroundColor = [UIColor whiteColor];
    
    UILabel * payTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, GGUISCREENWIDTH-40, 20)];
    payTypeLab.numberOfLines = 1;
    payTypeLab.font = [UIFont systemFontOfSize:12];
    payTypeLab.textColor = GGMainColor;
    payTypeLab.text = [NSString stringWithFormat:@"物流状态：%@",_data.state];
    [orderIdView addSubview:payTypeLab];
    
    
    UILabel * sendPersonLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, GGUISCREENWIDTH-40, 20)];
    sendPersonLab.numberOfLines = 1;
    sendPersonLab.font = [UIFont systemFontOfSize:12];
    sendPersonLab.textColor = [UIColor grayColor];
    sendPersonLab.text = [NSString stringWithFormat:@"快递类型：%@",_data.expressName];
    [orderIdView addSubview:sendPersonLab];
    
    UILabel * orderIdLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, GGUISCREENWIDTH-40, 20)];
    orderIdLab.numberOfLines = 1;
    orderIdLab.font = [UIFont systemFontOfSize:12];
    orderIdLab.textColor = [UIColor grayColor];
    orderIdLab.text = [NSString stringWithFormat:@"快递单号：%@",_data.nu];
    [orderIdView addSubview:orderIdLab];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 69, GGUISCREENWIDTH-20, 2)];
    line1.backgroundColor = GGBgColor;
    [orderIdView addSubview:line1];
    
    
    UIView * flowView = [[UIView alloc]init];
    flowView.backgroundColor = [UIColor whiteColor];
    
    flowHeight = 0;
    for (int i = 0; i < _data.flowArray.count; i++) {
        FlowData * flowData = _data.flowArray[i];
        CGSize size  = [PublicMethod getSize:flowData.context Font:12 Width:GGUISCREENWIDTH-70 Height:1000];
        
        
        
        UIView * addressView = [[UIView alloc]init];
        
        UILabel * addressLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, GGUISCREENWIDTH-70, size.height)];
        addressLab.numberOfLines = 0;
        addressLab.font = [UIFont systemFontOfSize:12];
        addressLab.textColor = [UIColor grayColor];
        addressLab.text = flowData.context;
        [addressView addSubview:addressLab];
        
        UILabel * timeLab = [[UILabel alloc]initWithFrame:CGRectMake(40, addressLab.height+addressLab.y+10, GGUISCREENWIDTH-70, 20)];
        timeLab.font = [UIFont systemFontOfSize:12];
        timeLab.textColor = [UIColor grayColor];
        timeLab.text = flowData.time;
        [addressView addSubview:timeLab];
        
        //竖线
        UIView * lineView;
        if(i == 0){
            addressLab.textColor = GGMainColor;
            timeLab.textColor = GGMainColor;
            UIImageView * newCircleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 12,12)];
            newCircleImageView.image = [UIImage imageNamed:@"redLogistic"];
            [addressView addSubview:newCircleImageView];
            addressView.backgroundColor = [UIColor whiteColor];
            
            lineView = [[UIView alloc]initWithFrame:CGRectMake(19, 26, 2, timeLab.y+timeLab.height+15)];
            lineView.backgroundColor = GGBgColor;
            [addressView addSubview:lineView];
        }else{
            UIView * circleView = [[UIView alloc]initWithFrame:CGRectMake(17, 20, 6,6)];
            circleView.backgroundColor = GGBgColor;
            [circleView.layer setMasksToBounds:YES];
            [circleView.layer setCornerRadius:3.0];
            [addressView addSubview:circleView];
            addressView.backgroundColor = [UIColor whiteColor];
            
            lineView = [[UIView alloc]initWithFrame:CGRectMake(19, 0, 2, timeLab.y+timeLab.height+15)];
            lineView.backgroundColor = GGBgColor;
            [addressView addSubview:lineView];
        }

        //下面横线
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(40, lineView.height-1, GGUISCREENWIDTH-60, 1)];
        lineView2.backgroundColor = GGBgColor;
        [addressView addSubview:lineView2];
        
        addressView.frame = CGRectMake(0, flowHeight, GGUISCREENWIDTH-20, lineView.height);
        
        [flowView addSubview:addressView];
        
        flowHeight = addressView.y+addressView.height;

        
    }
    flowView.frame = CGRectMake(0, 71, GGUISCREENWIDTH-20, flowHeight);

    //设置scrollview
    scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = CGRectMake(10, 10, GGUISCREENWIDTH-20, GGUISCREENHEIGHT-64-9);
    scrollView.contentSize = CGSizeMake(0, flowHeight+71);
    scrollView.delegate = self;
    
    
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.pagingEnabled = NO;
    scrollView.backgroundColor = GGBgColor;
    scrollView.scrollsToTop = YES;
    
    scrollView.layer.borderWidth = 2;
    scrollView.layer.borderColor = GGBgColor.CGColor;
    scrollView.layer.cornerRadius = 6.0;
  
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:orderIdView];
    [scrollView addSubview:flowView];

    
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)backController{
    [self headerRefresh];
}
@end
