//
//  CartViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"
#import "CartData.h"
#import "GoodsDetailViewController.h"
#import "LoginViewController.h"
#import "ShoppingCart.h"
#import "OrderData.h"
#import "OrderViewController.h"
#import "TableHeadView.h"

@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,CartCellDelegate,TableHeadViewDelegate>
{
    BOOL isLogin;
    FMDatabase * database;
    BOOL isSelectAll;
    NSMutableArray * sArray;//存放失效状态的数据
    
    
    
    NSInteger  goodAmount;//所有产品数量
    NSInteger selectCount;
    float totalAmt;
    float realityAmount;
    BOOL isJiaJianReload;
    NSString * jiaJianFlag;
    OrderData * orderData;
    UIView * statusbar;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
//@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
//- (IBAction)allSelectBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *realityPay;
@property (weak, nonatomic) IBOutlet UILabel *save;
//@property (weak, nonatomic) IBOutlet UILabel *tiShiLab;
- (IBAction)settlementBtn:(UIButton *)sender;
//@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *goSettle;

@property (weak, nonatomic) IBOutlet UILabel *notifyLab;


@property (nonatomic)  UIView * bgView;

@end

@implementation CartViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    statusbar = [[UIView alloc]init];
    //4.屏幕的宽度style-ios
    
    statusbar.frame = CGRectMake(0, -20,GGUISCREENWIDTH,64);
    statusbar.backgroundColor = GGMainColor;
    [self.navigationController.navigationBar insertSubview:statusbar atIndex:0];
    
    [self headerRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [statusbar removeFromSuperview];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * views  = self.navigationController.navigationBar.subviews;
    for (UIView * view in views) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    _tableView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    database = [PublicMethod shareDatabase];
    self.navigationItem.title = @"购物车";

    self.hidesBottomBarWhenPushed=NO;
//    sArray = [NSMutableArray array];

    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"CartCell" bundle:nil] forCellReuseIdentifier:@"CartCell"];
    self.data  = [NSMutableArray array];
    [self createNoCartView];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    selectCount = 0;
    totalAmt = 0;
    realityAmount = 0;
}
//进到购物车组织请求参数
-(void)headerRefresh{
    
    NSMutableArray *mutArray = [NSMutableArray array];
    
    //未登陆时从数据库获取数据
    isLogin = [PublicMethod checkLogin];
    if (!isLogin) {
        
        FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart"];
        while ([rs next]){
            
            NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
            [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid"]] forKey:@"skuId"];
            [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"cart_id"]] forKey:@"cartId"];
            [myDict setObject:[NSNumber numberWithInt:[rs intForColumn:@"pid_amount"]] forKey:@"amount"];
            [myDict setObject:[rs stringForColumn:@"state"] forKey:@"state"];
            [myDict setObject:[rs stringForColumn:@"sku_type"] forKey:@"skuType"];
            [myDict setObject:[NSNumber numberWithLong:[rs longForColumn:@"sku_type_id"]] forKey:@"skuTypeId"];
            
            if([@"G"isEqualToString:[rs stringForColumn:@"state"]]){
                [myDict setObject:@"Y" forKey:@"orCheck"];
            }else{
                [myDict setObject:@"" forKey:@"orCheck"];
            }
            [myDict setObject:[NSNumber numberWithInt:3] forKey:@"cartSource"];
            [mutArray addObject:myDict];
        }
    }
    isJiaJianReload = NO;
    [self requestData:[mutArray copy]];
}
//没有数据情况显示的页面
-(void)createNoCartView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT-64-49)];
    _bgView.backgroundColor = GGBgColor;
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((GGUISCREENWIDTH -200)/2, GGUISCREENHEIGHT/8, 200, 200)];
    bgImageView.image = [UIImage imageNamed:@"shoppingcart"];
    
    
    UIButton * bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = CGRectMake((GGUISCREENWIDTH-100)/2, bgImageView.y + bgImageView.height +20, 100, 30) ;
    
    [bgButton setTitle:@"随便逛逛" forState:UIControlStateNormal];
    bgButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgButton.layer setMasksToBounds:YES];
    [bgButton.layer setCornerRadius:4.0];
    [bgButton setTitleColor:GGMainColor forState:UIControlStateNormal];
    [bgButton.layer setBorderColor:GGMainColor.CGColor];
    [bgButton.layer setBorderWidth:1.0];
    [bgButton addTarget:self  action:@selector(bgButtonClick)  forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:bgButton];
    [_bgView addSubview:bgImageView];
    [self.view addSubview:_bgView];
    _bgView.hidden = YES;
}
-(void)bgButtonClick{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"home",@"jumpKey", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToTabbar" object:nil userInfo:dict];
}
//请求数据入口
-(void)requestData:(NSArray *) array{



    AFHTTPRequestOperationManager * manager = nil;
    //此处设置后返回的默认是NSData的数据
    isLogin = [PublicMethod checkLogin];
    if(isLogin){
        manager = [PublicMethod shareRequestManager];
        if(manager == nil){
            //断网情况显示断网页面
            NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
            noNetView.delegate = self;
            [self.view addSubview:noNetView];
            return;
        }

    }else{
        manager = [PublicMethod shareNoHeadRequestManager];
        if(manager == nil){
            NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
            noNetView.delegate = self;
            [self.view addSubview:noNetView];
            return;
        }
        
        if(array.count <= 0){
            //未登录没有数据情况
            array = nil;
            [self.data removeAllObjects];
            [self.tableView reloadData];
            _bgView.hidden = NO;
            //修改购物车badgeValue
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"badgeValue", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];

            return;
        }
    }

    
    if(array.count <= 0){
        array = nil;
    }

    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    if(isLogin){
        //登录状态非购物车点加减按钮，时候刷新数据
        if(!isJiaJianReload){
             NSString * urlString = [HSGlobal sendCartUrl];
            [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                [self.tableView.header endRefreshing];
                
                NSArray * dataArray = [object objectForKey:@"cartList"];
                if(dataArray.count>0){
                    _bgView.hidden = YES;
                }else{
                    _bgView.hidden = NO;
                }
                NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
                NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
                NSLog(@"message= %@",message);
                NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
                if(code == 200 ||code == 1015 ){//1015 表示购物车为空
                    
                    [self.data removeAllObjects];
                    for (id node in dataArray) {
                        CartData * data = [[CartData alloc] initWithJSONNode:node];
                        [self.data addObject:data];
                    }
                    if(_data.count > 0){
                        //更新购物车上面提示栏
                        [self updataNotify];
                        //更新购物车上面提示栏和下面的总额，结算按钮等
                        [self updateOtherMessage:_data];
                        [self.footView setHidden:NO];
                        [self.notifyLab setHidden:NO];
                    }
                    
                    [self.tableView reloadData];
                    PublicMethod * pm = [[PublicMethod alloc]init];
                    [pm sendCustNum];
                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = message;
                    hud.labelFont = [UIFont systemFontOfSize:11];
                    hud.margin = 10.f;
                    //    hud.yOffset = 150.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
                [GiFHUD dismiss];
                isJiaJianReload = NO;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [GiFHUD dismiss];
                [self.footView setHidden:YES];
                [self.notifyLab setHidden:YES];
                [PublicMethod printAlert:@"请求购物车数据失败"];
            }];

        
        }else{
            //重新组织参数，去掉sendUpdateData方法传过来的那三个参数
            NSDictionary * dict1 =  array[0];
            NSMutableArray * mutArray1 = [NSMutableArray array];
            
            NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
            [myDict setObject:[dict1 objectForKey:@"skuId"] forKey:@"skuId"];
            [myDict setObject:[dict1 objectForKey:@"cartId"] forKey:@"cartId"];
            [myDict setObject:[dict1 objectForKey:@"amount"] forKey:@"amount"];
            [myDict setObject:[dict1 objectForKey:@"state"]forKey:@"state"];
            [myDict setObject:[dict1 objectForKey:@"skuType"] forKey:@"skuType"];
            [myDict setObject:[dict1 objectForKey:@"skuTypeId"] forKey:@"skuTypeId"];
            [myDict setObject:[dict1 objectForKey:@"orCheck"] forKey:@"orCheck"];
            [myDict setObject:[dict1 objectForKey:@"cartSource"] forKey:@"cartSource"];
            
            [mutArray1 addObject:myDict];
            //登录状态购物车点加减按钮，只要返回的成功或失败，
            NSString * urlString =[HSGlobal addToCartUrl];
            [manager POST:urlString  parameters:mutArray1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                [self.tableView.header endRefreshing];

                NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
                NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
                NSLog(@"message= %@",message);
                if(code == 200 ||code == 1015 ){//1015 表示购物车为空
                    if(_data.count > 0){
                        
                        NSDictionary * dict =  array[0];
                        long skuId = [[dict objectForKey:@"skuId"]longValue];
                        NSString * skuType = [dict objectForKey:@"skuType"];
                        long skuTypeId = [[dict objectForKey:@"skuTypeId"]longValue];
                        NSString * invArea = [dict objectForKey:@"invArea"];
                        NSString *state = [dict objectForKey:@"state"];
                        //更新全局_data
                        for (int i=0; i<_data.count; i++) {
                            CartData * cData = _data[i];
                            //更新数量
                            for(int j=0; j < cData.cartDetailArray.count; j++){
                                CartDetailData * cdData =  cData.cartDetailArray[j];
                                if(skuId == cdData.skuId && [cdData.skuType isEqualToString:skuType] && skuTypeId == cdData.skuTypeId){
                                    if([jiaJianFlag isEqualToString:@"jia"]){
                                        cdData.amount = cdData.amount + 1;
                                    }else if([jiaJianFlag isEqualToString:@"jian"]){
                                        cdData.amount = cdData.amount - 1;
                                    }
                                    break;
                                }

                            }
                            //更新行邮税
                            if([cData.invArea isEqualToString:invArea]){
                                if([state isEqualToString:@"G"]){
                                    if([jiaJianFlag isEqualToString:@"jia"]){
                                        cData.selectPostalTaxRate = cData.selectPostalTaxRate + [[dict objectForKey:@"itemPrice"] floatValue] * [[dict objectForKey:@"postalTaxRate"] floatValue]* 0.01;
                                    }else if([jiaJianFlag isEqualToString:@"jian"]){
                                        cData.selectPostalTaxRate = cData.selectPostalTaxRate - [[dict objectForKey:@"itemPrice"] floatValue] * [[dict objectForKey:@"postalTaxRate"] floatValue] * 0.01;
                                    }
                                }
                            }

                            
                        }
                        
                        [self updataNotify];
                        [self updateOtherMessage:_data];
                        [self.footView setHidden:NO];
                        [self.notifyLab setHidden:NO];
                        _bgView.hidden = YES;
                    }else{
                        _bgView.hidden = NO;
                    }
                    

                    [self.tableView reloadData];
                    PublicMethod * pm = [[PublicMethod alloc]init];
                    [pm sendCustNum];
                    
                }else{
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = message;
                    hud.labelFont = [UIFont systemFontOfSize:11];
                    hud.margin = 10.f;
                    //    hud.yOffset = 150.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
                [GiFHUD dismiss];
                isJiaJianReload = NO;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [GiFHUD dismiss];
                [self.footView setHidden:YES];
                [self.notifyLab setHidden:YES];
                [PublicMethod printAlert:@"请求购物车数据失败"];
            }];
        }
        
    }else{
        //未登录状态下获取数据，包括未登录点击加减按钮重新获取数据，刷新页面
        NSString * urlString =[HSGlobal getCartByPidUrl];
        [manager POST:urlString  parameters:array success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            [self.tableView.header endRefreshing];
            
            NSArray * dataArray = [object objectForKey:@"cartList"];
            if(dataArray.count>0){
                _bgView.hidden = YES;
            }else{
                _bgView.hidden = NO;
            }
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            NSLog(@"message= %@",message);
            NSLog(@"后台返回来数据条数%lu",(unsigned long)dataArray.count);
            if(code == 200 ||code == 1010 ){//1010 表示购物车为空
                
                [self.data removeAllObjects];
                for (id node in dataArray) {
                    CartData * data = [[CartData alloc] initWithJSONNode:node];
                    [self.data addObject:data];
                }
                
                if(_data.count > 0){
                    [self updataNotify];
                    [self updateOtherMessage:_data];
                    [self.footView setHidden:NO];
                    [self.notifyLab setHidden:NO];
                }
                
                [self.tableView reloadData];
                PublicMethod * pm = [[PublicMethod alloc]init];
                [pm sendCustNum];
                
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
            isJiaJianReload = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [GiFHUD dismiss];
            [self.footView setHidden:YES];
            [self.notifyLab setHidden:YES];
            [PublicMethod printAlert:@"请求购物车数据失败"];
        }];

    }
    
}

-(void)updateOtherMessage :(NSArray *) array{
    goodAmount = 0;
    for (int i = 0; i<array.count; i++) {
        for (int j = 0; j<((CartData *)array[i]).cartDetailArray.count; j++) {
            if(![@"S" isEqualToString:((CartDetailData *)((CartData *)_data[i]).cartDetailArray[j]).state]){
                goodAmount = goodAmount + ((CartDetailData *)((CartData *)_data[i]).cartDetailArray[j]).amount;
            }
        }
    }
    
    selectCount = 0;
    totalAmt = 0;
    realityAmount = 0;
//    _tiShiLab.text = @"";
//    _goSettle.enabled = YES;
//    _goSettle.backgroundColor = GGMainColor;
    for (int i=0; i< array.count; i++) {
        CartData * cData = array[i];
        float invAreaAmount=0;
        NSMutableArray * mArray = [cData.cartDetailArray mutableCopy];
        for(int j=0; j < mArray.count; j++){
            CartDetailData * cdData = mArray[j];
            if([@"G" isEqualToString: cdData.state]){
                selectCount = selectCount + cdData.amount;
                totalAmt = totalAmt + cdData.amount * cdData.itemPrice;
                realityAmount = totalAmt;
                invAreaAmount = invAreaAmount + cdData.amount * cdData.itemPrice;
            }
        }
        //海外直邮和国内直邮不限制金额
        if(invAreaAmount>[cData.postalLimit floatValue] && ![cData.invArea isEqualToString:@"K"] && ![cData.invArea isEqualToString:@"NK"]){
            _notifyLab.text = [NSString stringWithFormat:@"提示：%@仓库的商品总金额超过￥%@",cData.invAreaNm,cData.postalLimit];
            _goSettle.enabled = NO;
            _goSettle.backgroundColor = [UIColor grayColor];
        }
    }

//    self.goodsCount.text = [NSString stringWithFormat:@"商品数量:%ld",(long)selectCount];
    if (selectCount==0) {
        self.goSettle.titleLabel.text = @"结算(0)";
        [self.goSettle setTitle:@"结算(0)" forState:UIControlStateNormal];
        _goSettle.enabled = YES;
        _goSettle.backgroundColor = GGMainColor;
    }else{
        self.goSettle.titleLabel.text =[NSString stringWithFormat:@"结算(%ld)",(long)selectCount];
        [self.goSettle setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)selectCount] forState:UIControlStateNormal];
//        _goSettle.enabled = YES;
//        _goSettle.backgroundColor = GGMainColor;
    }
    if(totalAmt == 0){
//        self.totalAmount.text = @"￥0";
        self.realityPay.text = @"总计:￥0";
    }else{
//        self.totalAmount.text = [NSString stringWithFormat:@"￥%.2f",totalAmt];
        self.realityPay.text = [NSString stringWithFormat:@"总计:￥%.2f",realityAmount];
    }

    
//    self.save.text = [NSString stringWithFormat:@"以节省:￥0"];
    if( selectCount == goodAmount){
//        [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        isSelectAll = true;
    }else {
//        [self.selectBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        isSelectAll = false;
    }
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    TableHeadView * tableHeadView = [[TableHeadView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
    tableHeadView.delegate = self;
    [tableHeadView setTag:2000 + section];
    tableHeadView.cartData = (CartData *)_data[section];

    return tableHeadView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 10)];
    footView.backgroundColor = GGBgColor;
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((CartData *)_data[section]).cartDetailArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
    cell.delegate =self;
    cell.data = (CartDetailData *)((CartData *)_data[indexPath.section]).cartDetailArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 115;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(isLogin){
            [self sendDelUrl:(CartDetailData *)((CartData *)_data[indexPath.section]).cartDetailArray[indexPath.row]];
        }else{
            [self delCart:(CartDetailData *)((CartData *)_data[indexPath.section]).cartDetailArray[indexPath.row]];
            [self headerRefresh];
        }
    }

}
-(void)delCart:(CartDetailData *)detailData{
    [database beginTransaction];
    [database executeUpdate:@"DELETE FROM Shopping_Cart WHERE pid =? and sku_type = ? and sku_type_id = ?",[NSNumber numberWithLong:detailData.skuId],detailData.skuType,[NSNumber numberWithLong:detailData.skuTypeId]];
    [database commit];
}


-(void)loadDataNotify{
    [self headerRefresh];
}



//登录状态点击加减按钮回调方法
-(void)sendUpdateData:(CartDetailData *)data andJJFlag:(NSString *)jjFlag{
    jiaJianFlag = jjFlag;
    isJiaJianReload = YES;
    NSMutableArray * mutArray = [NSMutableArray array];
    
    NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
    [myDict setObject:[NSNumber numberWithLong:data.skuId] forKey:@"skuId"];
    [myDict setObject:[NSNumber numberWithLong:data.cartId] forKey:@"cartId"];
    if([jjFlag isEqualToString:@"jia"]){
        [myDict setObject:[NSNumber numberWithLong:data.amount+1] forKey:@"amount"];
    }else if([jjFlag isEqualToString:@"jian"]){
        [myDict setObject:[NSNumber numberWithLong:data.amount-1] forKey:@"amount"];
    }
    [myDict setObject:data.state forKey:@"state"];
    [myDict setObject:data.skuType forKey:@"skuType"];
    [myDict setObject:[NSNumber numberWithLong:data.skuTypeId] forKey:@"skuTypeId"];
    if([@"G"isEqualToString:data.state]){
        [myDict setObject:@"Y" forKey:@"orCheck"];
    }else{
        [myDict setObject:@"" forKey:@"orCheck"];
    }
    [myDict setObject:[NSNumber numberWithInt:3] forKey:@"cartSource"];
    //下面三个参数不是传给后台的请求参数，是请求成功后重新组织_data用的参数
    [myDict setObject:data.invArea forKey:@"invArea"];
    [myDict setObject:[NSNumber numberWithFloat:data.itemPrice] forKey:@"itemPrice"];
    [myDict setObject:data.postalTaxRate forKey:@"postalTaxRate"];
    
    [mutArray addObject:myDict];
    

    [self requestData:mutArray];
}

//删除
-(void)sendDelUrl:(CartDetailData *)data{

    AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
  
    [manager GET:data.cartDelUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSLog(@"message= %@",message);
        if(code == 200){
            //更新全局_data
            for (int i=0; i<_data.count; i++) {
                CartData * cData = _data[i];
                for(int j=0; j < cData.cartDetailArray.count; j++){
                    CartDetailData * cdData =  cData.cartDetailArray[j];
                    if(data.skuId == cdData.skuId && [data.skuType isEqualToString:cdData.skuType] && data.skuTypeId == cdData.skuTypeId){
                        //如果一个保税区只剩下一个商品，并且点击删除的时候直接删保税区的数据，如果不是只剩一个商品则删除保税区里面的数据
                        if(cData.cartDetailArray.count == 1){
                            [_data removeObjectAtIndex:i];
                            i--;
                        }else{
                            [cData.cartDetailArray removeObjectAtIndex:j];
                            if([data.state isEqualToString:@"G"]){
                                cData.selectPostalTaxRate = cData.selectPostalTaxRate - data.itemPrice * data.amount * [data.postalTaxRate floatValue] * 0.01;
                            }
                            j--;
                        }
                        break;
                    }
                }
                
            }
            if(_data.count == 0){
                _bgView.hidden = NO;
            }
            
            if(_data.count > 0){
                [self updataNotify];
                [self updateOtherMessage:_data];
            }
            [self.tableView reloadData];
            //修改购物车tabbar的badgeValue
            PublicMethod * pm = [[PublicMethod alloc]init];
            [pm sendCustNum];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [PublicMethod printAlert:@"删除数据失败"];
    }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//点击全选按钮触发事件
//- (IBAction)allSelectBtn:(UIButton *)sender {
//    if(![PublicMethod isConnectionAvailable]){
//        return;
//    }
//    isSelectAll=!isSelectAll;
//
//    if(isSelectAll){
//        for (int i=0; i<_data.count; i++) {
//            CartData * cData = _data[i];
//            cData.selectPostalTaxRate = 0;
//            for(int j=0; j < cData.cartDetailArray.count; j++){
//                CartDetailData * cdData = cData.cartDetailArray[j];
//                if(![@"S" isEqualToString: cdData.state]){
//
//                    cdData.state = @"G";
//                    cData.selectPostalTaxRate = cData.selectPostalTaxRate + cdData.itemPrice * cdData.amount * [cdData.postalTaxRate intValue] * 0.01;
//                }
//            }
//
//        }
//    }else{
//        
//        for (int i=0; i<_data.count; i++) {
//            CartData * cData = _data[i];
//
//            cData.selectPostalTaxRate = 0;
//            for(int j=0; j < cData.cartDetailArray.count; j++){
//                CartDetailData * cdData = cData.cartDetailArray[j];
//                if(![@"S" isEqualToString: cdData.state]){
//
//                    cdData.state = @"I";
//                }
//            }
//        }
//    }
//    
//    [self.tableView reloadData];
//    
//    [self updateOtherMessage:_data];
//    
//    isLogin = [PublicMethod checkLogin];
//    if(!isLogin){
//        [self updataCart];
//    }
//    
//}
-(void)updataNotify{
    int selectAreaCount = 0;
    for (int i=0; i<_data.count; i++) {
        BOOL haveSelect = NO;
        CartData * cData = _data[i];
        for (int j = 0;j < cData.cartDetailArray.count; j++) {
            CartDetailData * cdData = cData.cartDetailArray[j];
            if([@"G" isEqualToString: cdData.state]){
                haveSelect = YES;
            }
        }
        if (haveSelect) {
            selectAreaCount++;
        }
    }
    if(selectAreaCount > 1){
        _notifyLab.text = @"提示：单次购买，只能购买同一保税区商品";
        _goSettle.enabled = NO;
        _goSettle.backgroundColor = [UIColor grayColor];
    }else{
        _notifyLab.text = @"友情提示：同一保税区商品总额有限";
        _goSettle.enabled = YES;
        _goSettle.backgroundColor = GGMainColor;
    }
}

//勾选按钮（登录状态）
-(void)sendSelectData:(CartDetailData *)data{
    
    
    [self updataNotify];
    if([@"I" isEqualToString: data.state]){
        selectCount = selectCount - data.amount;
        totalAmt = totalAmt - data.amount * data.itemPrice;
        realityAmount = totalAmt;
    }else if([@"G" isEqualToString: data.state]){
        selectCount = selectCount + data.amount;
        totalAmt = totalAmt + data.amount * data.itemPrice;
        realityAmount = totalAmt;
    }
    
//    self.goodsCount.text = [NSString stringWithFormat:@"商品数量:%ld",(long)selectCount];
    if (selectCount==0) {
        self.goSettle.titleLabel.text = @"结算(0)";
        [self.goSettle setTitle:@"结算(0)" forState:UIControlStateNormal];
        _goSettle.enabled = YES;
        _goSettle.backgroundColor = GGMainColor;
    }else{
        self.goSettle.titleLabel.text =[NSString stringWithFormat:@"结算(%ld)",(long)selectCount];
        [self.goSettle setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)selectCount] forState:UIControlStateNormal];
    }
    if(totalAmt == 0){
//        self.totalAmount.text = @"￥0";
        self.realityPay.text = @"总计:￥0";
    }else{
//        self.totalAmount.text = [NSString stringWithFormat:@"￥%.2f",totalAmt];
        
        self.realityPay.text = [NSString stringWithFormat:@"总计:￥%.2f",realityAmount];
    }
    
    
//    self.save.text = [NSString stringWithFormat:@"以节省:￥0"];
    if( selectCount == goodAmount){
//        [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        isSelectAll = true;
    }else {
//        [self.selectBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        isSelectAll = false;
    }
    for (int i=0; i<_data.count; i++) {
        CartData * cData = _data[i];
        if([cData.invArea isEqualToString:data.invArea]){
            TableHeadView *tableHeadView = (TableHeadView *)[self.tableView viewWithTag:2000 + i];
            [tableHeadView setCartData:cData];
//            if([@"I" isEqualToString: data.state]){
//                cData.selectPostalTaxRate =  cData.selectPostalTaxRate - data.itemPrice * data.amount * [data.postalTaxRate floatValue] * 0.01;
//            }else if([@"G" isEqualToString: data.state]){
//                cData.selectPostalTaxRate =  cData.selectPostalTaxRate + data.itemPrice * data.amount * [data.postalTaxRate floatValue] * 0.01;
//            }
//            TableHeadView *tableHeadView = (TableHeadView *)[self.tableView viewWithTag:2000 + i];
//            if(cData.selectPostalTaxRate>cData.postalStandard){//如果行邮税大于行邮税标准，则用正常的行邮税，否则，免税
//                tableHeadView.postalTaxLabel.text = [NSString stringWithFormat:@"行邮税￥%.2f",cData.selectPostalTaxRate] ;
//            }else{
//                if([@"-0.0" isEqualToString:[NSString stringWithFormat:@"%.1f",cData.selectPostalTaxRate]] || [@"0.0" isEqualToString:[NSString stringWithFormat:@"%.1f",cData.selectPostalTaxRate]]){
//                    tableHeadView.postalTaxLabel.text = @"免税";
//                }else{
//                    tableHeadView.postalTaxLabel.text = [NSString stringWithFormat:@"行邮税￥%.2f(免)",cData.selectPostalTaxRate] ;
//                }
//                
//            }

        }
    }

    //这段逻辑为了你判断一个保税区里面的商品是否超过限制金额
//    _tiShiLab.text = @"";
//    _goSettle.enabled = YES;
//    _goSettle.backgroundColor = GGMainColor;
    for (int i=0; i< _data.count; i++) {
        CartData * cData = _data[i];
        float invAreaAmount=0;
        NSMutableArray * mArray = [cData.cartDetailArray mutableCopy];
        for(int j=0; j < mArray.count; j++){
            CartDetailData * cdData = mArray[j];
            if([@"G" isEqualToString: cdData.state]){
                invAreaAmount = invAreaAmount + cdData.amount * cdData.itemPrice;
            }
        }
        if(invAreaAmount>[cData.postalLimit floatValue] && ![cData.invArea isEqualToString:@"K"] && ![cData.invArea isEqualToString:@"NK"]){
            _notifyLab.text = [NSString stringWithFormat:@"提示：%@仓库的商品总金额超过￥%@",cData.invAreaNm,cData.postalLimit];
            _goSettle.enabled = NO;
            _goSettle.backgroundColor = [UIColor grayColor];
        }
    }

    
    
}





//结算
- (IBAction)settlementBtn:(UIButton *)sender {
    
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    if(selectCount==0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先勾选商品";
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
    }
    isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        self.hidesBottomBarWhenPushed=YES;
        LoginViewController * login = [[LoginViewController alloc]init];
        login.comeFrom = @"CartVC";
        [self.navigationController pushViewController:login animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        return;
    }
    
    
    

    
    
    NSMutableArray * mutArray = [NSMutableArray array];
    for (int i=0; i<_data.count; i++) {
        CartData * cData = _data[i];
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject: cData.invCustoms forKey:@"invCustoms"];
        [myDict setObject: cData.invArea forKey:@"invArea"];
        [myDict setObject: cData.invAreaNm forKey:@"invAreaNm"];

         NSMutableArray * cartArray = [NSMutableArray array];
        for(int j=0; j < cData.cartDetailArray.count; j++){
            CartDetailData * cdData = cData.cartDetailArray[j];
            if([cdData.state isEqualToString:@"G"]){
                NSMutableDictionary *cartDict = [NSMutableDictionary dictionary];
                [cartDict setObject: cdData.state forKey:@"state"];
                [cartDict setObject: [NSString stringWithFormat: @"%ld", (long)cdData.amount] forKey:@"amount"];
                [cartDict setObject: [NSString stringWithFormat: @"%ld", (long)cdData.skuId] forKey:@"skuId"];
                [cartDict setObject: [NSString stringWithFormat: @"%ld", (long)cdData.cartId] forKey:@"cartId"];
                [cartDict setObject: cdData.skuType forKey:@"skuType"];
                [cartDict setObject: [NSNumber numberWithLong:cdData.skuTypeId] forKey:@"skuTypeId"];
                [cartArray addObject:cartDict];
            }
        }
        [myDict setObject:cartArray forKey:@"cartDtos"];
        [mutArray addObject:myDict];
        
    }
    
    //删除一个保税区里面只有一件商品，并且商品已经失效的情况。
    for(int i = 0; i<mutArray.count; i++){
        NSDictionary * dict = mutArray[i];
        NSArray * array = [dict objectForKey:@"cartDtos"];
        if(array.count<=0){
            [mutArray removeObjectAtIndex:i];
            i--;
        }
    }
    
    NSMutableDictionary * lastDict = [NSMutableDictionary dictionary];
    [lastDict setObject: [mutArray copy] forKey:@"settleDTOs"];
    [lastDict setObject: [NSNumber numberWithInt:0] forKey:@"addressId"];
    [lastDict setObject: @"" forKey:@"couponId"];
    [lastDict setObject: @"" forKey:@"clientIp"];
//    [lastDict setObject: [NSNumber numberWithInt:1] forKey:@"shipTime"];
    [lastDict setObject: [NSNumber numberWithInt:2] forKey:@"clientType"];
    [lastDict setObject: @"" forKey:@"orderDesc"];
//    [lastDict setObject: @"JD" forKey:@"payMethod"];
    [lastDict setObject: [NSNumber numberWithInt:2] forKey:@"buyNow"];

    

    
    
    if(mutArray.count >0){
        NSString * urlString =[HSGlobal sendCartToOrder];
        AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
        
        
        [manager POST:urlString  parameters:lastDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary * settleDict = [object objectForKey:@"settle"];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSInteger code =[[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
            NSLog(@"message= %@",message);
            if(code == 200){
                orderData = [[OrderData alloc]initWithJSONNode:settleDict];
                for(int i=0; i<orderData.singleCustomsArray.count; i++){
                    OrderDetailData * odData = orderData.singleCustomsArray[i];
                    
                    for (int j=0; j<_data.count; j++) {
                        
                        CartData * cData = _data[j];
                        //相同发货仓，把购物车勾选的数据添加到data里面
                        if([odData.invArea isEqualToString:cData.invArea]){
                            for(int k=0; k < cData.cartDetailArray.count; k++){

                                if([((CartDetailData *)cData.cartDetailArray[k]).state isEqualToString:@"G"]){
                                    CartDetailData * cdData = cData.cartDetailArray[k];
                                    [odData.cartDataArray addObject:cdData];
                                }

                            }
                        }
                        
                    }
                }
                
                OrderViewController * order = [[OrderViewController alloc]init];
                order.orderType = @"item";
                order.orderData = orderData;
                order.mutArray = mutArray;
                order.buyNow = 2;
                order.realityPay = [NSString stringWithFormat:@"%.2f",realityAmount];
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
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [PublicMethod printAlert:@"下订单失败"];
        }];
        
    }else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先勾选商品";
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];

    }
  
}
-(void)enterDetail:(NSString *)url{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    //进入到商品展示页面
    self.hidesBottomBarWhenPushed=YES;
    GoodsDetailViewController * gdViewController = [[GoodsDetailViewController alloc]init];
    gdViewController.url = url;
    [self.navigationController pushViewController:gdViewController animated:YES];
    self.hidesBottomBarWhenPushed=NO;

}

-(void)backController{
    [self headerRefresh];
}
@end
