//
//  PinGoodsDetailViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/17.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "PinGoodsDetailViewController.h"
#import "ThreeViewCell.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "PinDetailOneCell.h"
#import "JoinTeamMethodViewController.h"
#import "ChooseTeamViewController.h"
#import "OrderData.h"
#import "LoginViewController.h"
#import "OrderViewController.h"
#import "CartData.h"
#import "ShareView.h"
#import "RecommendGoodsView.h"
#import "GoodsShowData.h"
@interface PinGoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PinDetailOneCellDelegate,ThreeViewCellDelegate,MBProgressHUDDelegate,MWPhotoBrowserDelegate>
{
    
    NSInteger _pageNum; //最后一个section里面有scrollview里面有三个view，这个标示是表示哪个view
    UIView *_lineView;//最后一个组的组头里面三个按钮下面的线
    PinDetailOneCell * oneCell;

    
    ThreeViewCell * oneView;//存放图文详情的cell
    ThreeViewCell * twoView;//存放商品参数的cell
    ThreeViewCell * threeView;//存放热卖商品的cell

    CGFloat _sectionZeroHeight;//第0个分组的高度
    CGFloat oneViewHeight;//第1个分组的第一个view高度
    CGFloat twoViewHeight;//第1个分组的第二个view高度
    CGFloat threeViewHeight;//第1个分组的第三个view高度

    //只有第一个cell 数据会改变，并且只有点击尺寸的时候变，滚动的时候所有的数据都不重新加载，下面参数就是为了做这个
    BOOL oneCellAlreadyLoad;
    BOOL oneViewAlreadyLoad;
    BOOL twoViewAlreadyLoad;
    BOOL threeViewAlreadyLoad;
}
@property (nonatomic) BOOL globleIsStore;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *openTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *singleBuyButton;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@end

@implementation PinGoodsDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden=YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"商品详情";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self prepareDataSource];
    _pageNum = 0;
    _sectionZeroHeight = 0;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40-2, GGUISCREENWIDTH/3, 2)];
    _lineView.backgroundColor = GGMainColor;
    [self makeShareButton];
}
-(void)makeShareButton{
    
    //右上角添加按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [rightButton setImage:[UIImage imageNamed:@"iconfont_fenxiang"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareBtnClicked:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)prepareDataSource
{
    
    NSLog(@"pinDetailViewUrl  ++++++++++++%@",_url);
    
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
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSString * message = [[dict objectForKey:@"message"] objectForKey:@"message"];
        
        if(code == 200){
            _detailData = [[PinGoodsDetailData alloc] initWithJSONNode:dict];
            [self whenRequestSuccDo];
        }else{
            _footView.hidden = YES;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.labelText = message;
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            
        }
        
        [self.tableView reloadData];
        [GiFHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        [PublicMethod printAlert:@"数据加载失败"];
        
    }];
     
}
-(void)whenRequestSuccDo{
    oneCellAlreadyLoad = true;
    oneViewAlreadyLoad = true;
    twoViewAlreadyLoad = true;
    threeViewAlreadyLoad = true;
    
    if(_detailData.collectId == 0){
        _globleIsStore = false;
        [self.collectBtn setImage:[UIImage imageNamed:@"grayStore"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"redStore"] forState:UIControlStateNormal];
        _globleIsStore = true;
    }
    if(![_detailData.status isEqualToString:@"Y"]){
        _openTeamButton.enabled = NO;
        _singleBuyButton.enabled = NO;
        _openTeamButton.alpha = 0.4;
        _singleBuyButton.alpha = 0.4;
    }
    if(![_detailData.status isEqualToString:@"Y"] && ![_detailData.status isEqualToString:@"P"]){
        UIButton * otherPinGoodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherPinGoodsBtn.frame = CGRectMake(0, GGUISCREENHEIGHT - 70-64, GGUISCREENWIDTH, 20) ;
        otherPinGoodsBtn.backgroundColor = GGMainColor;
        
        [otherPinGoodsBtn setTitle:@"该活动已结束，去看看其他拼购吧" forState:UIControlStateNormal];
        otherPinGoodsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [otherPinGoodsBtn addTarget:self  action:@selector(otherPinGoodsBtnClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:otherPinGoodsBtn];
    }

}
-(void)otherPinGoodsBtnClick{
    RecommendGoodsView * reView  = [[RecommendGoodsView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
    reView.data = _detailData.pushArray;
    [reView makeUI];
    [self.tabBarController.view addSubview:reView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(oneCell == nil || oneCellAlreadyLoad){
            oneCell = [PinDetailOneCell subjectCell];
            oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
            oneCell.delegate = self;
            oneCell.data = _detailData;
            

            [oneCell.pinMethodBtn addTarget:self action:@selector(pinMethodBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [oneCell.pinSaleTopBtn addTarget:self action:@selector(pinSaleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [oneCell.pinSaleBottomBtn addTarget:self action:@selector(pinSaleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [oneCell.singleSaleBottomBtn addTarget:self action:@selector(singleSaleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [oneCell.singleSaleTopBtn addTarget:self action:@selector(singleSaleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            oneCellAlreadyLoad = false;

        }
        return oneCell;
        
    }
    if(indexPath.section == 1){
        // _otherRowHeight是上面三个cell的高度

        
        
        //64为导航条和状态栏，40为下面购物车一行高度
        if(_tableView.contentOffset.y > _sectionZeroHeight - 64){
            
            [_tableView setContentOffset:CGPointMake(0, _sectionZeroHeight - 64 )];
        }

        if(_pageNum == 0){
            if(oneView == nil || oneViewAlreadyLoad){
                oneView  = [ThreeViewCell subjectCell];
                oneView.pageNum = _pageNum;
                oneView.delegate = self;
                oneView.data = _detailData;
                oneViewAlreadyLoad = false;
            }
            [oneView.scrollView setContentOffset:CGPointMake(0, 0)];
            return oneView;
        }
        if(_pageNum == 1){
            if(twoView == nil || twoViewAlreadyLoad){
                twoView  = [ThreeViewCell subjectCell];
                twoView.pageNum = _pageNum;
                twoView.delegate = self;
                twoView.data = _detailData;
                twoViewAlreadyLoad = false;
            }
            [twoView.scrollView setContentOffset:CGPointMake(GGUISCREENWIDTH, 0)];
            return twoView;
        }
        if(_pageNum == 2){
            if(threeView == nil || threeViewAlreadyLoad){
                threeView  = [ThreeViewCell subjectCell];
                threeView.pageNum = _pageNum;
                threeView.delegate = self;
                threeView.data = _detailData;
                threeViewAlreadyLoad = false;
            }
            [threeView.scrollView setContentOffset:CGPointMake(GGUISCREENWIDTH * 2, 0)];
            return threeView;
        }
        return nil;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1){
        //设置页眉视图的高度
        return 40.0f;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        _sectionZeroHeight = GGUISCREENWIDTH + 208;
        
//        if(_detailData.itemPreviewImgs.count>0){
//            _sectionZeroHeight = ((ItemPreviewImgsData *)_detailData.itemPreviewImgs[0]).height* GGUISCREENWIDTH/((ItemPreviewImgsData *)_detailData.itemPreviewImgs[0]).width + 200;
//        }
        
        
        return _sectionZeroHeight;
    }
    
    if(indexPath.section == 1){
        if(_pageNum == 0){
            return oneViewHeight;
        }else if(_pageNum == 1){
            return twoViewHeight;
        }else if (_pageNum == 2){
            return threeViewHeight;
        }
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1){
        UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
        barView.backgroundColor = GGBgColor;
        UIButton * tuWenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tuWenBtn.frame = CGRectMake(0, 10, GGUISCREENWIDTH/3, 20);
        [tuWenBtn setTitle:@"图文详情" forState:UIControlStateNormal];
        [tuWenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tuWenBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [tuWenBtn addTarget:self action:@selector(tuWenClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *canShuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        canShuBtn.frame = CGRectMake(GGUISCREENWIDTH/3, 10, GGUISCREENWIDTH/3, 20);
        [canShuBtn setTitle:@"商品参数" forState:UIControlStateNormal];
        [canShuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        canShuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [canShuBtn addTarget:self action:@selector(canShuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *reMaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reMaiBtn.frame = CGRectMake(GGUISCREENWIDTH*2/3, 10, GGUISCREENWIDTH/3, 20);
        [reMaiBtn setTitle:@"热卖商品" forState:UIControlStateNormal];
        [reMaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        reMaiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [reMaiBtn addTarget:self action:@selector(reMaiClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [barView addSubview:tuWenBtn];
        [barView addSubview:canShuBtn];
        [barView addSubview:reMaiBtn];
        
        
        
        [barView addSubview:_lineView];
        
        return barView;
    }
    return nil;
}

- (void) tuWenClick:(UIButton *)button
{
    if(_pageNum != 0){
        [self scrollPage:0];
    }
}

- (void) canShuClick:(UIButton *)button
{
    if(_pageNum != 1){
        [self scrollPage:1];
    }
}

- (void) reMaiClick:(UIButton *)button
{
    if(_pageNum != 2){
        [self scrollPage:2];
    }
}
//详情页面下面的组团和立即购买按钮
- (IBAction)organizeTeam:(UIButton *)sender {
    [self pinSaleBtnClicked];
}
- (IBAction)singleBuy:(UIButton *)sender {
    [self singleSaleBtnClicked];
}
//组团方式按钮
-(void)pinMethodBtnClicked{

    JoinTeamMethodViewController *joinMethodViewController = [[JoinTeamMethodViewController alloc]init];
    [self.navigationController pushViewController:joinMethodViewController animated:YES];
}
//组团
-(void)pinSaleBtnClicked{
    ChooseTeamViewController * chooseTeam = [[ChooseTeamViewController alloc]init];
    chooseTeam.data = _detailData;
    [self.navigationController pushViewController:chooseTeam animated:YES];
}
//立即购买
-(void)singleSaleBtnClicked{
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
    [myDict setObject: _detailData.invCustoms forKey:@"invCustoms"];
    [myDict setObject: _detailData.invArea forKey:@"invArea"];
    [myDict setObject: _detailData.invAreaNm forKey:@"invAreaNm"];
    NSMutableArray * cartArray = [NSMutableArray array];
    
    NSMutableDictionary *cartDict = [NSMutableDictionary dictionary];
    [cartDict setObject: @"G" forKey:@"state"];
    [cartDict setObject: @"1" forKey:@"amount"];
    [cartDict setObject: _detailData.sizeId forKey:@"skuId"];
    [cartDict setObject: @"item" forKey:@"skuType"];
    [cartDict setObject: _detailData.sizeId forKey:@"skuTypeId"];
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
                cdData.invTitle = _detailData.itemTitle;
                cdData.invImg = _detailData.invImg;
                cdData.amount = 1;
                cdData.itemPrice = [_detailData.invPrice floatValue];
                [odData.cartDataArray addObject:cdData];
                
            }
            
            OrderViewController * order = [[OrderViewController alloc]init];
            order.orderType = @"item";
            order.orderData = orderData;
            order.mutArray = mutArray;
            order.buyNow = 1;
            order.realityPay = _detailData.invPrice;
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

/**
 *  自定义代理方法
 *
 */
-(void)scrollPage:(NSInteger)page{
    _pageNum = page;
    CGFloat tableContOffSet = _tableView.contentOffset.y;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    if(tableContOffSet != 0){
        if(tableContOffSet >= _sectionZeroHeight - 64){
            [_tableView setContentOffset:CGPointMake(0,_sectionZeroHeight + 20)];//为了刷新下这个section，不然不会刷新
        }else{
            [_tableView setContentOffset:CGPointMake(0,tableContOffSet)];
        }
    }
    
    if(page ==0){
        _lineView.frame = CGRectMake(0, 40-2, GGUISCREENWIDTH/3, 2);
    }else if(page == 1){
        _lineView.frame = CGRectMake(GGUISCREENWIDTH/3, 40-2, GGUISCREENWIDTH/3, 2);
    }else if(page == 2){
        _lineView.frame = CGRectMake(GGUISCREENWIDTH*2/3, 40-2, GGUISCREENWIDTH/3, 2);
    }
}

-(void)getFourCellH:(CGFloat)cellHeight{
    if(_pageNum == 0 ){
        oneViewHeight = cellHeight;
        //webview加载完之后，如果最后一个cell已经在界面上 ，那么改变tableview的contentOffset，让最后的一个cell，别出来，重新加载最后一个cell
        if(_sectionZeroHeight < self.tableView.contentOffset.y + self.tableView.frame.size.height){
            self.tableView.contentOffset = CGPointMake(0, _sectionZeroHeight-self.tableView.frame.size.height);
        }
    }else if(_pageNum == 1){
        twoViewHeight = cellHeight;
    }else if (_pageNum == 2){
        threeViewHeight = cellHeight;
    }
}
/**
 *  点击预览图代理方法
 */
-(void)touchPage:(NSInteger)index andImageArray:(NSArray *)imageArray{
    
    
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    for (int i = 0; i < imageArray.count; i++)
    {
        NSString * url = ((itemPreviewImgsData *)imageArray[i]).url;
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        [photos addObject:photo];
        
    }
    
    
    
    self.photos = photos;
    
    
    
    //
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;//分享按钮,默认是
    browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
    browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = displaySelectionButtons;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = startOnGrid;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:NO];
    
    
    
}
- (void) shareBtnClicked: (UIButton *) button{
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
    shareView.tag = 1000000000;
    //    shareView.delegate = self;
    
    shareView.shareStr =  _detailData.itemTitle;
    shareView.shareTitle = _detailData.itemTitle;
    
    shareView.shareUrl = @"http://www.hanmimei.com";
    shareView.shareImage = _detailData.invImg;
    NSArray  * array= [_url componentsSeparatedByString:@"comm/detail/pin"];
    if(array.count == 2){
        shareView.shareDetailPage = [NSString stringWithFormat:@"KAKAO-HMM 复制这条信息,打开👉韩秘美👈即可看到<P>【 %@】,%@,－🔑 M令 🔑",_detailData.pinTitle,array[1]];
        [shareView makeUI];
        [self.tabBarController.view addSubview:shareView];
    }
    
    
}

-(void)backController{
    [self prepareDataSource];
}
- (IBAction)collectClick:(id)sender {
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    BOOL isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.labelText = @"未登录状态下不能收藏商品";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
        
    }else{
        _globleIsStore = !_globleIsStore;
        
        AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
        
        if (_globleIsStore) {
            
            NSString * urlString =[HSGlobal collectUrl];
            
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_detailData.sizeId,@"skuId",_detailData.skuType,@"skuType",[NSNumber numberWithLong: _detailData.skuTypeId],@"skuTypeId",nil];
            [GiFHUD setGifWithImageName:@"hmm.gif"];
            [GiFHUD show];
            [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //转换为词典数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                
                NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
                
                if(code == 200){
                    [self.collectBtn setImage:[UIImage imageNamed:@"redStore"] forState:UIControlStateNormal];
                    _detailData.collectId = [[dict objectForKey:@"collectId"]longValue];
                }else{
                     _globleIsStore = !_globleIsStore;
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelFont = [UIFont systemFontOfSize:11];
                    hud.labelText = @"收藏失败";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
                [GiFHUD dismiss];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                 _globleIsStore = !_globleIsStore;
                [GiFHUD dismiss];
                [PublicMethod printAlert:@"收藏失败"];
            }];
            
            
        }else{
            NSString * urlString = [NSString stringWithFormat:@"%@%ld",[HSGlobal unCollectUrl],_detailData.collectId];
            [GiFHUD setGifWithImageName:@"hmm.gif"];
            [GiFHUD show];
            [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //转换为词典数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
                
                if(code == 200){
                    [self.collectBtn setImage:[UIImage imageNamed:@"grayStore"] forState:UIControlStateNormal];
                    _detailData.collectId = 0;
                }else{
                     _globleIsStore = !_globleIsStore;
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelFont = [UIFont systemFontOfSize:11];
                    hud.labelText = @"取消收藏失败";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                }
                [GiFHUD dismiss];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                 _globleIsStore = !_globleIsStore;
                [GiFHUD dismiss];
                [PublicMethod printAlert:@"取消收藏失败"];
            }];
            
            
        }
        
        
    }

}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

@end
