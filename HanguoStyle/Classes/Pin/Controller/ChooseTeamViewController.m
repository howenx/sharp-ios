//
//  ChooseTeamViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/19.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "ChooseTeamViewController.h"
#import "LoginViewController.h"
#import "OrderData.h"
#import "CartData.h"
#import "OrderViewController.h"
@interface ChooseTeamViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIButton * sureButton;
@property (nonatomic)  UIView * mainView;
@property (nonatomic,assign) CGFloat chooseHeight;
@property (nonatomic,copy) NSString * pinTieredId;//选中的拼购的阶梯价格id
@property (nonatomic,copy) NSString * pinPrice;//选中的拼购的阶梯价格
@end

@implementation ChooseTeamViewController
-(void)viewWillAppear:(BOOL)animated{
   self.tabBarController.tabBar.hidden=YES; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"选择拼团";
    self.view.backgroundColor = GGColor(240, 240, 240);
    [self createGoodsView];
    [self createTeamView];
}

//创建上面view
-(void)createGoodsView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 74, GGUISCREENWIDTH-20, 100)];
    view.backgroundColor = [UIColor whiteColor];
//    [view.layer setMasksToBounds:YES];
    view.layer.cornerRadius = 4.0;
    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3
    
    [self.view addSubview:view];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 70, 70)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_data.invImg]];
    CALayer * layer = [imageView layer];
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
    layer.borderWidth = 1.0f;
    [view addSubview:imageView];
    
    
    UILabel  * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 15, GGUISCREENWIDTH-130, 40)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 2;
    titleLabel.text = _data.pinTitle;
    [view addSubview:titleLabel];
    
    
}

//创建下面view
-(void)createTeamView{
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(10, 190, GGUISCREENWIDTH-20, GGUISCREENHEIGHT-190-60)];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.cornerRadius = 4.0;
    _mainView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _mainView.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _mainView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _mainView.layer.shadowRadius = 2;//阴影半径，默认3
    
    [self.view addSubview:_mainView];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(10, _mainView.y+_mainView.height+10, GGUISCREENWIDTH-20, 40);
    [_sureButton setBackgroundColor:GGMainColor];
    [_sureButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
   
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    NSDictionary * dict =  _data.floorPrice;
    
    if([dict allKeys].count>0){
        [_sureButton setTitle:[NSString stringWithFormat:@"立即开团(%@元/%@人)",[dict objectForKey:@"price"],[dict objectForKey:@"person_num"]] forState:UIControlStateNormal];
    }else{
        return;
    }
    [self.view addSubview:_sureButton];
    
    UILabel  * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, GGUISCREENWIDTH-50, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = GGMainColor;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    titleLabel.text = @"请选择拼购类型";
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    titleLabel.layer.mask = maskLayer;
    
    
    [_mainView addSubview:titleLabel];
    
    
    NSArray * pinArray = _data.pinTieredPricesArray;
    UIScrollView * _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 45, GGUISCREENWIDTH-50, GGUISCREENHEIGHT-190-60-45-10)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(0,pinArray.count*40+20);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [_mainView addSubview:_scrollView];
    for (int i = 0; i < pinArray.count; i++) {
        NSInteger personNum = ((PinTieredPricesData *)pinArray[i]).peopleNum;
        NSString * price = ((PinTieredPricesData *)pinArray[i]).price;
        
        if ([price isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]]]) {
            _pinTieredId = ((PinTieredPricesData *)pinArray[i]).pinTieredId;
            _pinPrice = ((PinTieredPricesData *)pinArray[i]).price;
            //团长优惠券为0的时候，页面不显示团长优惠
            if (((PinTieredPricesData *)pinArray[i]).masterCoupon != 0) {
                _chooseHeight = 20;
            }
            
            UIView * teamView = [[UIView alloc]initWithFrame:CGRectMake(0, i*40, _scrollView.width,40+_chooseHeight)];
            teamView.tag = 2200+i;
            teamView.userInteractionEnabled = YES;
            [teamView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)]];
            CALayer * layer = [teamView layer];
            layer.borderColor = [GGMainColor CGColor];
            layer.borderWidth = 1.0f;
            //红色竖线
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 40+_chooseHeight)];
            lineView.backgroundColor = GGMainColor;
            [teamView addSubview:lineView];
            
            
            //开团人数
            UILabel  * personLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 40)];
            personLabel.font = [UIFont systemFontOfSize:13];
            personLabel.numberOfLines = 1;
            personLabel.text = [NSString stringWithFormat:@"开团人数：%ld",(long)personNum];
            
            [teamView addSubview:personLabel];
            
            //团购价格
            UILabel  * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_scrollView.width-100, 0, 70, 40)];
            priceLabel.font = [UIFont systemFontOfSize:13];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.numberOfLines = 1;
            priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
            
            [teamView addSubview:priceLabel];
            
            //推荐文字图片
            UIImageView * tjImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.width-30,0, 30, 30)];
            tjImageView.image = [UIImage imageNamed:@"icon_tuijian"];
            
            [teamView addSubview:tjImageView];
            if (((PinTieredPricesData *)pinArray[i]).masterCoupon != 0){
                //惠文字图片
                UIImageView * huiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,32, 15, 15)];
                huiImageView.image = [UIImage imageNamed:@"hmm_hui"];
                
                [teamView addSubview:huiImageView];
                
                //团长特惠
                UILabel  * masterCouponLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, GGUISCREENWIDTH-100, 20)];
                masterCouponLabel.font = [UIFont systemFontOfSize:11];
                masterCouponLabel.textColor = [UIColor grayColor];
                masterCouponLabel.numberOfLines = 1;
                masterCouponLabel.text = [NSString stringWithFormat:@"团长特惠：赠%.f元优惠券",((PinTieredPricesData *)pinArray[i]).masterCoupon];
                
                [teamView addSubview:masterCouponLabel];
            }
            
            [_scrollView addSubview:teamView];
            
        }else{
            UIView * teamView = [[UIView alloc]initWithFrame:CGRectMake(0, i*40 + _chooseHeight, _scrollView.width,40)];
            teamView.tag = 2200+i;
            teamView.userInteractionEnabled = YES;
            [teamView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)]];
            CALayer * layer = [teamView layer];
            layer.borderColor = [[UIColor lightGrayColor] CGColor];
            layer.borderWidth = 1.0f;
            //开团人数
            UILabel  * personLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 40)];
            personLabel.font = [UIFont systemFontOfSize:13];
            personLabel.numberOfLines = 1;
            personLabel.text = [NSString stringWithFormat:@"开团人数：%ld",(long)personNum];
            
            [teamView addSubview:personLabel];
            
            //团购价格
            UILabel  * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_scrollView.width-100, 0, 70, 40)];
            priceLabel.font = [UIFont systemFontOfSize:13];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.numberOfLines = 1;
            priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
            
            [teamView addSubview:priceLabel];
            [_scrollView addSubview:teamView];
        }
        
        
    }

}
-(void) touchUpInside:(UITapGestureRecognizer *)recognizer{
    
    [_mainView removeFromSuperview];
    _chooseHeight = 0;
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(10, 190, GGUISCREENWIDTH-20, GGUISCREENHEIGHT-190-60)];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.cornerRadius = 4.0;
    _mainView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _mainView.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _mainView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _mainView.layer.shadowRadius = 2;//阴影半径，默认3
    
    [self.view addSubview:_mainView];
    
    UILabel  * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, GGUISCREENWIDTH-50, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = GGMainColor;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    titleLabel.text = @"请选择拼购类型";
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    titleLabel.layer.mask = maskLayer;
    
    
    [_mainView addSubview:titleLabel];
    
    NSDictionary * dict =  _data.floorPrice;
    NSArray * pinArray = _data.pinTieredPricesArray;
    UIScrollView * _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 45, GGUISCREENWIDTH-50, GGUISCREENHEIGHT-190-60-45-10)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(0,pinArray.count*40+20);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [_mainView addSubview:_scrollView];
    NSInteger tag =  recognizer.view.tag;
    for (int i = 0; i < pinArray.count; i++) {
        NSInteger personNum = ((PinTieredPricesData *)pinArray[i]).peopleNum;
        NSString * price = ((PinTieredPricesData *)pinArray[i]).price;
        
        if (tag-2200 == i) {
            _pinTieredId = ((PinTieredPricesData *)pinArray[i]).pinTieredId;
            _pinPrice = ((PinTieredPricesData *)pinArray[i]).price;
            [_sureButton setTitle:[NSString stringWithFormat:@"立即开团(%@元/%ld人)",price,(long)personNum] forState:UIControlStateNormal];
            
            if (((PinTieredPricesData *)pinArray[i]).masterCoupon != 0){
                _chooseHeight = 20;
            }
            
            UIView * teamView = [[UIView alloc]initWithFrame:CGRectMake(0, i*40, _scrollView.width,40+_chooseHeight)];
            teamView.tag = 2200+i;
            teamView.userInteractionEnabled = YES;
            [teamView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)]];
            CALayer * layer = [teamView layer];
            layer.borderColor = [GGMainColor CGColor];
            layer.borderWidth = 1.0f;
            
            //红色竖线
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 40+_chooseHeight)];
            lineView.backgroundColor = GGMainColor;
            [teamView addSubview:lineView];
            
            //开团人数
            UILabel  * personLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 40)];
            personLabel.font = [UIFont systemFontOfSize:13];
            personLabel.numberOfLines = 1;
            personLabel.text = [NSString stringWithFormat:@"开团人数：%ld",(long)personNum];
            
            [teamView addSubview:personLabel];
            
            //团购价格
            UILabel  * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_scrollView.width-100, 0, 70, 40)];
            priceLabel.font = [UIFont systemFontOfSize:13];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.numberOfLines = 1;
            priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
            
            [teamView addSubview:priceLabel];
            

            if ([price isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]]]){
                //推荐文字图片
                UIImageView * tjImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.width-30,0, 30, 30)];
                tjImageView.image = [UIImage imageNamed:@"icon_tuijian"];
                
                [teamView addSubview:tjImageView];
            }
            if (((PinTieredPricesData *)pinArray[i]).masterCoupon != 0){
                //惠文字图片
                UIImageView * huiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,32, 15, 15)];
                huiImageView.image = [UIImage imageNamed:@"hmm_hui"];
                
                [teamView addSubview:huiImageView];
                
                //团长特惠
                UILabel  * masterCouponLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, GGUISCREENWIDTH-100, 20)];
                masterCouponLabel.font = [UIFont systemFontOfSize:11];
                masterCouponLabel.textColor = [UIColor grayColor];
                masterCouponLabel.numberOfLines = 1;
                masterCouponLabel.text = [NSString stringWithFormat:@"团长特惠：赠%.f元优惠券",((PinTieredPricesData *)pinArray[i]).masterCoupon];
                
                [teamView addSubview:masterCouponLabel];

            }
            [_scrollView addSubview:teamView];
            
        }else{
            UIView * teamView = [[UIView alloc]initWithFrame:CGRectMake(0, i*40 + _chooseHeight, _scrollView.width,40)];
            teamView.tag = 2200+i;
            teamView.userInteractionEnabled = YES;
            [teamView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)]];
            CALayer * layer = [teamView layer];
            layer.borderColor = [[UIColor lightGrayColor] CGColor];
            layer.borderWidth = 1.0f;
            //开团人数
            UILabel  * personLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 40)];
            personLabel.font = [UIFont systemFontOfSize:13];
            personLabel.numberOfLines = 1;
            personLabel.text = [NSString stringWithFormat:@"开团人数：%ld",(long)personNum];
            
            [teamView addSubview:personLabel];
            
            //团购价格
            UILabel  * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_scrollView.width-100, 0, 70, 40)];
            priceLabel.font = [UIFont systemFontOfSize:13];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.numberOfLines = 1;
            priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
            
            [teamView addSubview:priceLabel];
            if ([price isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]]]){
                //推荐文字图片
                UIImageView * tjImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.width-30,0, 30, 30)];
                tjImageView.image = [UIImage imageNamed:@"icon_tuijian"];
                
                [teamView addSubview:tjImageView];
            }
            [_scrollView addSubview:teamView];
        }
        
        
    }

    
}

- (void)buyNow:(UIButton *)sender {
    BOOL isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        self.hidesBottomBarWhenPushed=YES;
        LoginViewController * login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        return;
    }
    
    NSMutableArray * mutArray = [NSMutableArray array];
    
    NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
    [myDict setObject: _data.invCustoms forKey:@"invCustoms"];
    [myDict setObject: _data.invArea forKey:@"invArea"];
    [myDict setObject: _data.invAreaNm forKey:@"invAreaNm"];
    NSMutableArray * cartArray = [NSMutableArray array];
    
    NSMutableDictionary *cartDict = [NSMutableDictionary dictionary];
    [cartDict setObject: @"G" forKey:@"state"];
    [cartDict setObject: @"1" forKey:@"amount"];
    [cartDict setObject: _data.sizeId forKey:@"skuId"];
    [cartDict setObject: _data.skuType forKey:@"skuType"];
    [cartDict setObject: [NSNumber numberWithLong:_data.skuTypeId] forKey:@"skuTypeId"];
    [cartDict setObject: _pinTieredId forKey:@"pinTieredPriceId"];//阶梯价格id
    [cartDict setObject: @"0" forKey:@"cartId"];
    [cartArray addObject:cartDict];
    
    [myDict setObject:cartArray forKey:@"cartDtos"];
    [mutArray addObject:myDict];
    
    
    
    NSMutableDictionary * lastDict = [NSMutableDictionary dictionary];
    [lastDict setObject: [mutArray copy] forKey:@"settleDTOs"];
    [lastDict setObject: [NSNumber numberWithInt:0] forKey:@"addressId"];
    [lastDict setObject: @"" forKey:@"couponId"];
    [lastDict setObject: @"" forKey:@"clientIp"];
    [lastDict setObject: [NSNumber numberWithInt:1] forKey:@"shipTime"];
    [lastDict setObject: [NSNumber numberWithInt:2] forKey:@"clientType"];
    [lastDict setObject: @"" forKey:@"orderDesc"];
    [lastDict setObject: @"JD" forKey:@"payMethod"];
    [lastDict setObject: [NSNumber numberWithInt:1] forKey:@"buyNow"];//立即支付
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
            OrderData * orderData = [[OrderData alloc]initWithJSONNode:settleDict];
            for(int i=0; i<orderData.singleCustomsArray.count; i++){//orderData.singleCustomsArray.count其实就是1
                
                OrderDetailData * odData = orderData.singleCustomsArray[i];
                CartDetailData * cdData =[[CartDetailData alloc]init];
                cdData.invTitle = _data.itemTitle;
                cdData.invImg = _data.invImg;
                cdData.amount = 1;
                cdData.itemPrice = [_pinPrice floatValue];
                [odData.cartDataArray addObject:cdData];
                
            }
            
            OrderViewController * order = [[OrderViewController alloc]init];
            order.pinType = _data.skuType;
            order.orderData = orderData;
            order.mutArray = mutArray;
            order.buyNow = 1;
            order.realityPay = _pinPrice;
            [self.navigationController pushViewController:order animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
