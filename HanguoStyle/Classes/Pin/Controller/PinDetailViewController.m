//
//  PinDetailViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/2.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "PinDetailViewController.h"
#import "PinDetailData.h"
#import "ShareView.h"
#import "LoginViewController.h"
#import "OrderData.h"
#import "CartData.h"
#import "OrderViewController.h"
#import "ChooseTeamViewController.h"
#import "UIBarButtonItem+GG.h"
#import "MyPinTeamViewController.h"
@interface PinDetailViewController ()<UIScrollViewDelegate>
{
    float statusH;//上面拼购状态高度
    float goodsH;//商品详情高度
    float personH;//参团人头像高度
    float joinTimeH;//下面参团人参团时间的高度
    float buyNowH;//立即下单高度
    float goSeeOtherBtnH;//失效状态查看其它商品按钮高度
    
    float onePhotoH;
    long secondsCountDown;
    UILabel * surplusTimeLab;//倒计时
    BOOL alreadyBack;

}
@property(nonatomic)PinDetailData * data;

@end

@implementation PinDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"组团详情";
    onePhotoH = (GGUISCREENWIDTH-60)/5 +10;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_back" highImage:@"icon_back" target:self action:@selector(backViewController)];
    
}
-(void)backViewController{
    [GiFHUD dismiss];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ChooseTeamViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            alreadyBack = YES;
            break;
        }
        if ([temp isKindOfClass:[MyPinTeamViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            alreadyBack = YES;
            break;
        }
    }
    if(!alreadyBack){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
}

- (void) createView{
    // 商品 为y状态 ，拼团中
    if([_data.status isEqualToString:@"Y"]){
        // 参团支付成功，进入本页
        if ([_data.pay isEqualToString:@"new"]) {
            statusH = 80;
        }else{
            statusH = 0;
        }
        
        ;
        personH = ceilf([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue /5)*onePhotoH +100;//(m+n-1)/n 向上取余，100是文字和倒计时高度
        joinTimeH = _data.joinPersons * 80;
        goodsH = 100;
        buyNowH = 80;
        goSeeOtherBtnH = 0;
    }else if([_data.status isEqualToString:@"F"]){
        statusH = 80;
        personH = ceilf([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue/5)*onePhotoH +10;//(m+n-1)/n 向上取余
        joinTimeH = _data.joinPersons * 80;
        goodsH = 100;
        buyNowH = 0;
        goSeeOtherBtnH = 0;
    }else if([_data.status isEqualToString:@"C"]){
        statusH = 80;
        NSLog(@"+++++++++%f",ceil([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue/5));

        personH = ceil([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue /5)*onePhotoH +40;//(m+n-1)/n 向上取余 40是文字
        joinTimeH = _data.joinPersons * 80;
        goodsH = 100;
        buyNowH = 0;
        goSeeOtherBtnH = 0;
    }else if([_data.status isEqualToString:@"E"]){
        statusH = 0;
        personH = ceilf([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue/5)*onePhotoH +10;//(m+n-1)/n 向上取余
        joinTimeH = _data.joinPersons * 80;
        goodsH = 100;
        buyNowH = 0;
        goSeeOtherBtnH = 30;
    }
    UIScrollView * _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT- 64- buyNowH - goSeeOtherBtnH)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(0,statusH + personH + joinTimeH + goodsH);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //状态imageview
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, statusH)];
    statusView.backgroundColor =GGBgColor;
    UIImageView * statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20, GGUISCREENWIDTH-100, statusH-40)];
    statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    [statusView addSubview:statusImageView];
    
    [_scrollView addSubview: statusView];
    
    
    //商品详情
    UIView * goodsView= [[UIView alloc]initWithFrame:CGRectMake(0, statusH, GGUISCREENWIDTH, goodsH)];
    [_scrollView addSubview: goodsView];
    
    UIImageView * invImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    invImageView.layer.borderWidth = 1;
    invImageView.layer.borderColor = GGBgColor.CGColor;
    invImageView.contentMode = UIViewContentModeScaleAspectFit;
    [invImageView sd_setImageWithURL:[NSURL URLWithString:_data.pinImg]];
    [goodsView addSubview:invImageView];
    
    
    UILabel  * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100,10, GGUISCREENWIDTH-110, 40)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.numberOfLines = 2;
    titleLabel.text = _data.pinTitle;
    [goodsView addSubview:titleLabel];
    
    UILabel  * personNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 70, 20)];
    personNumLabel.font = [UIFont systemFontOfSize:15];
    personNumLabel.text = [NSString stringWithFormat:@"%ld人团：",(long)_data.personNum];
    [goodsView addSubview:personNumLabel];
    
    UILabel  * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 60, 100, 20)];
    priceLabel.textColor = GGMainColor;
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",_data.pinPrice];
    [goodsView addSubview:priceLabel];
    
    UIImageView * stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-120, 5, 90, 90)];
    stateImageView.backgroundColor = [UIColor clearColor];
    stateImageView.contentMode = UIViewContentModeScaleAspectFit;
    [goodsView addSubview:stateImageView];

    
    
    //头像view
    UIView * photoView = [[UIView alloc]initWithFrame:CGRectMake(0, goodsView.height + goodsView.y, GGUISCREENWIDTH, personH)];
    photoView.backgroundColor =GGBgColor;
    [_scrollView addSubview:photoView];

    for(int i = 0;i < ceilf([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue/5);i++){
        int lastRowCount = 0;
        if(i == ceilf([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue/5) -1){
            lastRowCount = _data.personNum % 5;
            if(lastRowCount==0){
                lastRowCount =5;
            }
        }else{
            lastRowCount = 5;
        }
        
        for(int j = 0;j < lastRowCount;j++){
            UIImageView * photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + j * onePhotoH ,10 + i * onePhotoH, (GGUISCREENWIDTH-60)/5, (GGUISCREENWIDTH-60)/5)];
            [photoImageView.layer setMasksToBounds:YES];
            [photoImageView.layer setCornerRadius:(GGUISCREENWIDTH-60)/10];
            [photoImageView.layer setBorderWidth:1];
            
            if(i*5+j<_data.pinUsersArray.count){
                [photoImageView.layer setBorderColor:GGMainColor.CGColor];
                [photoImageView sd_setImageWithURL:[NSURL URLWithString:((PinUsersData*)_data.pinUsersArray[i*5+j]).userImg]];
                [photoView addSubview:photoImageView];
                if (((PinUsersData*)_data.pinUsersArray[i*5+j]).orMaster == 1) {
                    UILabel * masterLab = [[UILabel alloc]initWithFrame:CGRectMake(10 + j * onePhotoH +(GGUISCREENWIDTH-60)/10 ,10 + i * onePhotoH, 30, 20)];
                    [masterLab.layer setMasksToBounds:YES];
                    [masterLab.layer setCornerRadius:5];
                    masterLab.backgroundColor = GGMainColor;
                    masterLab.font = [UIFont systemFontOfSize:12];
                    masterLab.textColor = [UIColor whiteColor];
                    masterLab.text = @"团长";
                    masterLab.textAlignment = NSTextAlignmentCenter;
                    [photoView addSubview:masterLab];
                }

            }else{
                [photoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
                [photoImageView setImage:[UIImage imageNamed:@"icon_default_header"]];
                [photoView addSubview:photoImageView];
            }
            
            
        }
    }
    
    
    //下面加入时间
    UIView * joinTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, photoView.height + photoView.y, GGUISCREENWIDTH, joinTimeH)];
    
    [_scrollView addSubview:joinTimeView];
    for(int i = 0;i < _data.pinUsersArray.count; i++){
        
        if (((PinUsersData*)_data.pinUsersArray[i]).orMaster == 1) {
            UIView * singleView = [[UIView alloc]initWithFrame:CGRectMake(0, i*80, GGUISCREENWIDTH, 80)];
            singleView.backgroundColor = GGBgColor;
            [joinTimeView addSubview:singleView];
            
            UIImageView * masterBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 80)];
            invImageView.contentMode = UIViewContentModeScaleAspectFit;
            masterBgImageView.image = [UIImage imageNamed:@"hmm_bg_jiantou"];
            [singleView addSubview:masterBgImageView];
            
            UIImageView * photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 40, 40)];
            [photoImageView.layer setMasksToBounds:YES];
            [photoImageView.layer setCornerRadius:20];
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:((PinUsersData*)_data.pinUsersArray[i]).userImg]];
            [singleView addSubview:photoImageView];
            
            
            UILabel  * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, GGUISCREENWIDTH/2-50, 40)];
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.textColor = [UIColor grayColor];
            nameLabel.text = ((PinUsersData*)_data.pinUsersArray[i]).userNm;
            [singleView addSubview:nameLabel];
            
            UILabel  * joinTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH/2, 30, GGUISCREENWIDTH/2, 40)];
            joinTimeLabel.font = [UIFont systemFontOfSize:14];
            joinTimeLabel.textColor = [UIColor grayColor];
            joinTimeLabel.text = [NSString stringWithFormat:@"%@开团",((PinUsersData*)_data.pinUsersArray[i]).joinAt];
            [singleView addSubview:joinTimeLabel];
            
        }else{
            UIView * singleView = [[UIView alloc]initWithFrame:CGRectMake(0, i*80, GGUISCREENWIDTH, 80)];
            [joinTimeView addSubview:singleView];
            
            UIView  * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 20)];
            topView.backgroundColor = GGBgColor;
            [singleView addSubview:topView];
            
            UIView  * shuLineView = [[UIView alloc]initWithFrame:CGRectMake(30, 0, 1, 20)];
            shuLineView.backgroundColor = [UIColor lightGrayColor];
            [singleView addSubview:shuLineView];
            
            UIView  * topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, GGUISCREENWIDTH, 1)];
            topLineView.backgroundColor = [UIColor lightGrayColor];
            [singleView addSubview:topLineView];
            
            
            UIImageView * photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 40, 40)];
            [photoImageView.layer setCornerRadius:20];
            [photoImageView.layer setMasksToBounds:YES];
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:((PinUsersData*)_data.pinUsersArray[i]).userImg]];
            [singleView addSubview:photoImageView];
            
            
            UILabel  * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, GGUISCREENWIDTH/2-50, 40)];
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.textColor = [UIColor grayColor];
            nameLabel.text = ((PinUsersData*)_data.pinUsersArray[i]).userNm;
            [singleView addSubview:nameLabel];
            
            UILabel  * joinTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH/2, 30, GGUISCREENWIDTH/2, 40)];
            joinTimeLabel.font = [UIFont systemFontOfSize:14];
            joinTimeLabel.textColor = [UIColor grayColor];
            joinTimeLabel.text = [NSString stringWithFormat:@"%@参团",((PinUsersData*)_data.pinUsersArray[i]).joinAt];
            [singleView addSubview:joinTimeLabel];

            
            
            UIView  * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 79, GGUISCREENWIDTH, 1)];
            bottomLineView.backgroundColor = [UIColor lightGrayColor];
            [singleView addSubview:bottomLineView];

        }
            
    }
    
    
    
    
    
    
    
    
    
    
    if([_data.status isEqualToString:@"Y"]){

        stateImageView.image = [UIImage imageNamed:@"hmm_zutuan"];
        
        UIView * btnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, GGUISCREENHEIGHT-80-64, GGUISCREENWIDTH, 80)];
        btnBgView.backgroundColor = [UIColor blackColor];
        btnBgView.alpha = 0.6;
        [self.view addSubview:btnBgView];
        UIButton * buyNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyNowBtn.frame = CGRectMake(10,GGUISCREENHEIGHT-65-64 , GGUISCREENWIDTH-20, 50);
        [buyNowBtn.layer setCornerRadius:3];
        buyNowBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        buyNowBtn.backgroundColor = GGMainColor;
        [buyNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:buyNowBtn];
        if ([_data.pay isEqualToString:@"new"]) {
            // 刚刚支付完跳到这个页面 pay = new
            if([_data.userType isEqualToString:@"master"]){
                statusImageView.image = [UIImage imageNamed:@"hmm_kaituan_success"];
            }else{
                statusImageView.image = [UIImage imageNamed:@"hmm_cantuan_success"];
            }
            
            [buyNowBtn setTitle:[NSString stringWithFormat:@"还差%ld人，点击复制去分享",_data.personNum - _data.joinPersons] forState:UIControlStateNormal];
            [buyNowBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            // 通过分享链接 进入本团,或者从我的拼团进入到这个页面
            if (_data.orJoinActivity == 1) {
                // 已经参加本团成员
                [buyNowBtn setTitle:[NSString stringWithFormat:@"还差%ld人，让小伙伴们都来组团吧！",_data.personNum - _data.joinPersons] forState:UIControlStateNormal];
                [buyNowBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [buyNowBtn setTitle:@"立即下单" forState:UIControlStateNormal];
                [buyNowBtn addTarget:self action:@selector(buyNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }

        UILabel * aboutLab = [[UILabel alloc]initWithFrame:CGRectMake(10, onePhotoH * ceilf([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue/5)+10, GGUISCREENWIDTH-20, 30)];
        aboutLab.textAlignment = NSTextAlignmentCenter;
        aboutLab.font = [UIFont systemFontOfSize:15];
        aboutLab.textColor = [UIColor grayColor];
        aboutLab.text = [NSString stringWithFormat:@"还差%ld人，让小伙伴们都来组团吧",_data.personNum - _data.joinPersons];
        [photoView addSubview:aboutLab];
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(10, aboutLab.y + aboutLab.height+30, (GGUISCREENWIDTH-150-40)/2, 1)];
        leftLine.backgroundColor = [UIColor grayColor];
        [photoView addSubview:leftLine];
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH-(GGUISCREENWIDTH-150-40)/2-10, aboutLab.y + aboutLab.height+30, (GGUISCREENWIDTH-150-40)/2, 1)];
        rightLine.backgroundColor = [UIColor grayColor];
        [photoView addSubview:rightLine];
        secondsCountDown = _data.endCountDown/1000;
        surplusTimeLab= [[UILabel alloc]initWithFrame:CGRectMake(GGUISCREENWIDTH/2-75, aboutLab.y + aboutLab.height, 150, 60)];
        surplusTimeLab.textAlignment = NSTextAlignmentCenter;
        surplusTimeLab.font = [UIFont systemFontOfSize:15];
        [photoView addSubview:surplusTimeLab];

        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
    }else if([_data.status isEqualToString:@"F"]){
        statusImageView.image = [UIImage imageNamed:@"hmm_pingou_fail"];
        stateImageView.image = [UIImage imageNamed:@"hmm_zutuan_fail"];

    }else if([_data.status isEqualToString:@"C"]){
        statusImageView.image = [UIImage imageNamed:@"hmm_pingou_success"];
        stateImageView.image = [UIImage imageNamed:@"hmm_zutuan_success"];
        UILabel * aboutLab = [[UILabel alloc]initWithFrame:CGRectMake(10, onePhotoH*ceilf([NSString stringWithFormat: @"%ld", (long)_data.personNum].floatValue/5)+10, GGUISCREENWIDTH-20, 30)];
        aboutLab.textAlignment = NSTextAlignmentCenter;
        aboutLab.font = [UIFont systemFontOfSize:15];
        aboutLab.textColor = [UIColor grayColor];
        aboutLab.text = @"对于诸位大侠的相助，团长感激涕零";
        [photoView addSubview:aboutLab];

    }else if([_data.status isEqualToString:@"E"]){


    }
    

}
- (void) requestData
{
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        
        if(code == 200){
            NSDictionary * dataDict = [object objectForKey:@"activity"];
            
            _data = [[PinDetailData alloc] initWithJSONNode:dataDict];
            [self createView];
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
        [PublicMethod printAlert:@"数据加载失败"];
    }];
}
//timer定时器方法
- (void)timerFireMethod:(NSTimer *)timer
{
    secondsCountDown--;
    if(secondsCountDown == 0){
        [timer invalidate];
    }
    surplusTimeLab.text = [NSString stringWithFormat:@"剩余%ld:%ld:%ld结束",  secondsCountDown/3600, (secondsCountDown%3600)/60, (secondsCountDown%3600)%60];//倒计时显示
}


- (void) shareBtnClicked: (UIButton *) button{
  
    
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
    shareView.tag = 1000000000;
    
    shareView.shareStr =  _data.pinTitle;
    shareView.shareTitle = @"韩秘美，只卖韩国正品";
    

    NSArray  * array = [_data.pinUrl componentsSeparatedByString:@"promotion"];
    NSString * shareUrl = [NSString stringWithFormat:@"https://style.hanmimei.com%@",array[array.count-1]];
    if(array.count >= 2){
        shareView.shareUrl = shareUrl;
        shareView.shareImage = _data.pinImg;
        shareView.shareDetailPage = [NSString stringWithFormat:@"KAKAO-HMM 复制这条信息,打开👉韩秘美👈即可看到<T>【 %@】,%@－🔑 M令 🔑",_data.pinTitle,shareUrl];
        [shareView makeUI];
        [self.tabBarController.view addSubview:shareView];
    }

    
    
    
    
    
}
- (void) buyNowBtnClicked: (UIButton *) button{
    BOOL isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        self.hidesBottomBarWhenPushed=YES;
        LoginViewController * login = [[LoginViewController alloc]init];
        login.comeFrom = @"PinDetailVC";
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
    [cartDict setObject: [NSNumber numberWithLong:_data.skuId] forKey:@"skuId"];
    [cartDict setObject: _data.skuType forKey:@"skuType"];
    [cartDict setObject: [NSNumber numberWithLong:_data.skuTypeId] forKey:@"skuTypeId"];
    [cartDict setObject: [NSNumber numberWithLong:_data.pinTieredPriceId] forKey:@"pinTieredPriceId"];//阶梯价格id
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
//    [lastDict setObject: @"JD" forKey:@"payMethod"];
    [lastDict setObject: [NSNumber numberWithInt:1] forKey:@"buyNow"];//立即支付
    [lastDict setObject: [NSNumber numberWithLong:_data.pinActiveId] forKey:@"pinActiveId"];
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
                cdData.invTitle = _data.pinTitle;
                cdData.invImg = _data.pinImg;
                cdData.amount = 1;
                cdData.itemPrice = [_data.pinPrice floatValue];
                [odData.cartDataArray addObject:cdData];
                
            }
            
            OrderViewController * order = [[OrderViewController alloc]init];
            order.orderType = _data.skuType;
            order.orderData = orderData;
            order.mutArray = mutArray;
            order.buyNow = 1;
            order.realityPay = _data.pinPrice;
            order.pinActiveId = _data.pinActiveId;
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
}
-(void)backController{
    [self requestData];
}
@end

