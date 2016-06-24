    //
//  GoodsDetailViewController.m
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ThreeViewCell.h"
#import "DetaileOneCell.h"
#import "DetailTwoCell.h"
#import "DetailThreeCell.h"
#import "ShoppingCart.h"
#import "CartData.h"
#import "CartViewController.h"
#import "OrderViewController.h"
#import "OrderData.h"
#import "LoginViewController.h"
#import "ShareView.h"
#import "GoodsDetailData.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "RecommendGoodsView.h"
#import "UIImage+GG.h"
#import "ShowEvaluateViewController.h"

@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ThreeViewCellDelegate,MBProgressHUDDelegate,DetailTwoCellDelegate,DetailThreeCellDelegate,DetaileOneCellDelegate,MWPhotoBrowserDelegate>
{

//    NSMutableArray * _dataSource;
    NSInteger _pageNum; //最后一个section里面有scrollview里面有三个view，这个标示是表示哪个view
//    CGFloat _rowHeight;//最后一个section的高度（这个高度是是随着section里面scrollview里面分别三个view的高度而变化的）
    CGFloat _otherRowHeight;//除了最后一组，其他section的高度和
    UIView *_lineView;//最后一个组的组头里面三个按钮下面的线
    CGFloat _sectionZeroHeight;//第0个分组的高度
//    MBProgressHUD *HUD;
    
    DetaileOneCell * oneCell;
    DetailTwoCell * twoCell;
    DetailThreeCell * threeCell;

    ThreeViewCell * oneView;//存放图文详情的cell
    ThreeViewCell * twoView;//存放商品参数的cell
    ThreeViewCell * threeView;//存放热卖商品的cell
    
    CGFloat twoCellHeight;//第二个cell的高度
    CGFloat threeCellHeight;//第三个cell的高度
    
    CGFloat oneViewHeight;//第四个cell的第一个view高度
    CGFloat twoViewHeight;//第四个cell的第二个view高度
    CGFloat threeViewHeight;//第四个cell的第三个view高度
    
    NSInteger numberOfSection;//共几个section
    //只有第一个cell 数据会改变，并且只有点击尺寸的时候变，滚动的时候所有的数据都不重新加载，下面参数就是为了做这个
    BOOL oneCellAlreadyLoad;
    BOOL twoCellAlreadyLoad;
    BOOL threeCellAlreadyLoad;
    BOOL oneViewAlreadyLoad;
    BOOL twoViewAlreadyLoad;
    BOOL threeViewAlreadyLoad;
    
    BOOL oneCellAgainLoad;//当点击尺寸的时候，置为true，刷新第一个cell
    
    CGFloat tableContOffSet;
    FMDatabase * database;
    BOOL isLogin;
    
    
    
    CALayer     *layer;
    UILabel     *_cntLabel;
    NSInteger    _cnt;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addToShoppingCart:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;

- (IBAction)buyNow:(UIButton *)sender;

- (IBAction)enterShoppingCart:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIView *footView;

@property (nonatomic) BOOL globleIsStore;
@property (nonatomic,assign) NSInteger globleStoreCount;

@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation GoodsDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.alpha = 1;
    [self queryCustNum];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    _tableView.scrollsToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    database = [PublicMethod shareDatabase];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hidesBottomBarWhenPushed = NO;
    self.navigationItem.title = @"商品详情";

    
//    _cartButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10);
    _cartButton.hidden = NO;
    _cntLabel.hidden = NO;
    [self makeCartUI];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self prepareDataSource];
    _pageNum = 0;
    _otherRowHeight = 0;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40-2, GGUISCREENWIDTH/3, 2)];
    _lineView.backgroundColor = GGMainColor;
    [_buyNowButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xF03046)] forState:UIControlStateNormal];
    [_addCartButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xff5359)] forState:UIControlStateNormal];
    [_buyNowButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xe82e43)] forState:UIControlStateHighlighted];
    [_addCartButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xf55165)] forState:UIControlStateHighlighted];
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
-(void)makeCartUI{
    
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cartButton.x + _cartButton.width -15, _cartButton.y, 15, 15)];
    _cntLabel.textColor = [UIColor whiteColor];
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont systemFontOfSize:10];
    _cntLabel.backgroundColor = GGMainColor;
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }
   
    [_footView addSubview:_cntLabel];
    
    
    self.path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(GGUISCREENWIDTH/2, GGUISCREENHEIGHT/2)];
    [_path addQuadCurveToPoint:CGPointMake(35, GGUISCREENHEIGHT - 20) controlPoint:CGPointMake(GGUISCREENWIDTH/6, GGUISCREENHEIGHT * 3/4)];
    
    
    
}
-(void)queryCustNum{
    isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        FMResultSet * rs = [database executeQuery:@"SELECT SUM(pid_amount) as amount FROM Shopping_Cart "];
        //购物车如果存在这件商品，就更新数量
        while ([rs next]){
            _cnt = [rs intForColumn:@"amount"] ;
            if (_cnt == 0) {
                _cntLabel.hidden = YES;
            }else{
                _cntLabel.hidden = NO;
                _cntLabel.text= [NSString stringWithFormat:@"%ld",(long)_cnt];
            }
            
        }
    }else{
        NSString * url = [HSGlobal queryCustNum];
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

            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];

            if(code == 200){
                _cnt = [[object objectForKey:@"cartNum"]integerValue];
                if (_cnt == 0) {
                    _cntLabel.hidden = YES;
                }else{
                    _cntLabel.hidden = NO;
                    _cntLabel.text= [NSString stringWithFormat:@"%ld",(long)_cnt];
                }
            }

            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }
}
-(void)prepareDataSource
{
    
    isLogin = [PublicMethod checkLogin];
    NSLog(@"detailViewUrl  ++++++++++++%@",_url);
    
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    numberOfSection = 3;
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
        NSString * message = [[dict objectForKey:@"message"] objectForKey:@"message"];
        
        if(code == 200){
            _detailData = [[GoodsDetailData alloc] initWithJSONNode:dict];
            [self whenRequestSuccDo];
        }else{
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
    if(_detailData.publicity == nil && _detailData.remarkRate == nil){
        numberOfSection = 3;
    }else{
        numberOfSection = 4;
    }
    
    oneCellAlreadyLoad = true;
    twoCellAlreadyLoad = true;
    threeCellAlreadyLoad = true;
    oneViewAlreadyLoad = true;
    twoViewAlreadyLoad = true;
    threeViewAlreadyLoad = true;
    NSString* status = @"other" ;
    for(SizeData * sizeData in _detailData.sizeArray){
        if([sizeData.state isEqualToString:@"Y"]){
            status = @"Y";
        }
    }

    if(![status isEqualToString:@"Y"]){
        _buyNowButton.enabled = NO;
        _addCartButton.enabled = NO;
        _buyNowButton.alpha = 0.4;
        _addCartButton.alpha = 0.4;
        
        
        UIButton * otherPinGoodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherPinGoodsBtn.frame = CGRectMake(0, GGUISCREENHEIGHT - 70-64, GGUISCREENWIDTH, 20) ;
        otherPinGoodsBtn.backgroundColor = GGMainColor;
        
        [otherPinGoodsBtn setTitle:@"该商品已下架，去看看其他商品吧" forState:UIControlStateNormal];
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
    return numberOfSection;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(oneCell == nil || oneCellAlreadyLoad ||oneCellAgainLoad){
            for(SizeData * sizeData in _detailData.sizeArray){
                
                if(sizeData.orMasterInv){
                    if(sizeData.collectId == 0){
                        _globleIsStore = false;
                    }else{
                        _globleIsStore = true;
                    }
                    _globleStoreCount = sizeData.collectCount;
                }
            }

            
            oneCell = [DetaileOneCell subjectCell];
            oneCell.delegate = self;
            oneCell.data = _detailData;
            [oneCell.storeBtn addTarget:self action:@selector(storeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [oneCell.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            oneCellAlreadyLoad = false;
            oneCellAgainLoad = false;
        }
        return oneCell;
        
    }else if(indexPath.section == 1){
        if(twoCell == nil || twoCellAlreadyLoad){
            twoCell = [[DetailTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            twoCell.delegate = self;
            twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            twoCell.data = _detailData;
            twoCellAlreadyLoad = false;
        }
        return twoCell;
    }
    
    if(indexPath.section==2 && numberOfSection == 4){
        if(threeCell == nil || threeCellAlreadyLoad){
            threeCell = [[DetailThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            threeCell.delegate = self;
            threeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            threeCell.data = _detailData;
            threeCellAlreadyLoad = false;
        }
        return threeCell;
    }
    
    if((indexPath.section == 3 && numberOfSection == 4)|| (numberOfSection == 3 &&indexPath.section == 2)){
        // _otherRowHeight是上面三个cell的高度
        _otherRowHeight =_sectionZeroHeight + twoCellHeight + threeCellHeight;
        //64为导航条和状态栏，40为下面购物车一行高度
//        if(_tableView.contentOffset.y > _otherRowHeight + 64){
//            
//            [_tableView setContentOffset:CGPointMake(0, _otherRowHeight + 64 )];
//        }
        tableContOffSet = 0;
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
- (void) storeBtnClicked: (UIButton *) button
{
    
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        LoginViewController * login = [[LoginViewController alloc]init];
        login.comeFrom = @"GoodsDetailVC";
        [self.navigationController pushViewController:login animated:YES];
        return;
        
    }else{
        _globleIsStore = !_globleIsStore;
        AFHTTPRequestOperationManager *manager = [PublicMethod shareRequestManager];
        if (_globleIsStore) {
            NSString * urlString =[HSGlobal collectUrl];
            
            NSDictionary * dict;
            for(SizeData * sizeData in _detailData.sizeArray){
                if(sizeData.orMasterInv){
                    dict = [NSDictionary dictionaryWithObjectsAndKeys:sizeData.sizeId,@"skuId",sizeData.skuType,@"skuType",[NSNumber numberWithLong: sizeData.skuTypeId],@"skuTypeId",nil];
                    break;
                }
            }
            [manager POST:urlString  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //转换为词典数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

                
                NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
                
                if(code == 200){
                    for(SizeData * sizeData in _detailData.sizeArray){
                        
                        if(sizeData.orMasterInv){
                            sizeData.collectId = [[dict objectForKey:@"collectId"]longValue];
                        }
                    }
                    UIImage * image = [UIImage imageNamed:@"redStore"];
//                    [ oneCell.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",_globleStoreCount + 1] forState:UIControlStateNormal];
                    _globleStoreCount++;
                    [oneCell.storeBtn setImage:image forState:UIControlStateNormal];
                    
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

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                 _globleIsStore = !_globleIsStore;
                [PublicMethod printAlert:@"收藏失败"];
            }];
            
            
        }else{
            NSString * urlString =[HSGlobal unCollectUrl];
            
            for(SizeData * sizeData in _detailData.sizeArray){
                if(sizeData.orMasterInv){
                    urlString = [NSString stringWithFormat:@"%@%ld",urlString,sizeData.collectId];
                    break;
                }
            }

            [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //转换为词典数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                
                NSInteger code = [[[dict objectForKey:@"message"] objectForKey:@"code"]integerValue];
                
                if(code == 200){
                    for(SizeData * sizeData in _detailData.sizeArray){
                        
                        if(sizeData.orMasterInv){
                            sizeData.collectId = 0;
                        }
                    }
                    UIImage * image = [UIImage imageNamed:@"grayStore"];
//                    [ oneCell.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",_globleStoreCount - 1] forState:UIControlStateNormal];
                    _globleStoreCount--;
                    [oneCell.storeBtn setImage:image forState:UIControlStateNormal];
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
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                 _globleIsStore = !_globleIsStore;
                [PublicMethod printAlert:@"取消收藏失败"];
            }];

            
        }
        

    }
   
}
- (void) shareBtnClicked: (UIButton *) button{
    
    if(![PublicMethod isConnectionAvailable]){
        return;
    }
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
    shareView.tag = 1000000000;
//    shareView.delegate = self;
    
    shareView.shareStr =  _detailData.itemTitle;
    shareView.shareTitle = @"韩秘美，只卖韩国正品";
    
    NSString * copyUrl;
    for(SizeData * sizeData in _detailData.sizeArray){
        if(sizeData.orMasterInv){
            shareView.shareImage = sizeData.invImg;
            copyUrl = sizeData.invUrl;
            break;
        }
    }
//    NSArray  * array= [copyUrl componentsSeparatedByString:@"comm/detail/item"];
    NSArray  * array= [copyUrl componentsSeparatedByString:@"comm"];
    if(array.count >= 2){
        NSString * shareUrl = [NSString stringWithFormat:@"https://style.hanmimei.com%@",array[array.count-1]];
        shareView.shareUrl = shareUrl;
        shareView.shareDetailPage = [NSString stringWithFormat:@"KAKAO-HMM 复制这条信息,打开👉韩秘美👈即可看到<C>【 %@】,%@－🔑 M令 🔑",_detailData.itemTitle,shareUrl];
        [shareView makeUI];
        [self.tabBarController.view addSubview:shareView];
    }
    

}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if((section==3 && numberOfSection == 4) || (section ==2 && numberOfSection == 3)){
        UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
        barView.backgroundColor = GGBgColor;
        //    barView.backgroundColor = [UIColor whiteColor];
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if((section==3 && numberOfSection == 4) || (section==2 && numberOfSection == 3)){
        //设置页眉视图的高度
        return 40.0f;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        _sectionZeroHeight = GGUISCREENWIDTH + 80 + 8;
//        for(SizeData * sizeData in _detailData.sizeArray){
//            
//            if(sizeData.orMasterInv){
//                if(sizeData.itemPreviewImgs.count>0){
//                    _sectionZeroHeight = ((itemPreviewImgsData *)sizeData.itemPreviewImgs[0]).height* GGUISCREENWIDTH/((itemPreviewImgsData *)sizeData.itemPreviewImgs[0]).width + 40 + 1 + 80 + 8;
//                    break;
//                }
//                
//            }
//        }
        
        return _sectionZeroHeight;
    }
    if(indexPath.section == 1){
        return twoCellHeight;
        
    }

    if(indexPath.section == 2 && numberOfSection == 4){
        return threeCellHeight;
    }
    
    if((indexPath.section == 3 && numberOfSection == 4) || (indexPath.section == 2 && numberOfSection == 3)){
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


-(void)scrollPage:(NSInteger)page{
    _pageNum = page;
    tableContOffSet = _tableView.contentOffset.y;
    if(numberOfSection == 4){
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else if(numberOfSection == 3){
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if(tableContOffSet != 0){
        if(tableContOffSet >= _otherRowHeight){
            [_tableView setContentOffset:CGPointMake(0,_otherRowHeight)];//为了刷新下这个section，不然不会刷新
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
//实现代理方法
-(void)getTwoCellH:(CGFloat)cellHeight{

    twoCellHeight = cellHeight;
}
//点击尺寸刷新第一个cell
-(void)getNewData:(GoodsDetailData *)newData{
    
    _detailData = newData;
    oneCellAgainLoad = true;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


-(void)getThreeCellH:(CGFloat)cellHeight{
    
    threeCellHeight = cellHeight;
}
-(void)getFourCellH:(CGFloat)cellHeight{
    if(_pageNum == 0 ){
        oneViewHeight = cellHeight;
        //webview加载完之后，如果最后一个cell已经在界面上 ，那么改变tableview的contentOffset，让最后的一个cell，别出来，重新加载最后一个cell
        if(_otherRowHeight < self.tableView.contentOffset.y + self.tableView.frame.size.height){
            self.tableView.contentOffset = CGPointMake(0, _otherRowHeight-self.tableView.frame.size.height);
        }


    }else if(_pageNum == 1){
        twoViewHeight = cellHeight;
    }else if (_pageNum == 2){
        threeViewHeight = cellHeight;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addToShoppingCart:(UIButton *)sender {
    NSString * sizeId;
    NSString * skuType;
    long skuTypeId = 0;
    
    for(SizeData * sizeData in _detailData.sizeArray){
        
        if(sizeData.orMasterInv){
            if(![sizeData.state isEqualToString:@"Y"]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.labelText = @"商品库存不足";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                return;
            }
            sizeId = sizeData.sizeId;
            skuType = sizeData.skuType;
            skuTypeId = sizeData.skuTypeId;
        }
    }
    isLogin = [PublicMethod checkLogin];
    if(isLogin){
        NSMutableArray * mutArray = [NSMutableArray array];
        
        NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
        [myDict setObject:[NSNumber numberWithInt:[sizeId intValue]] forKey:@"skuId"];
        [myDict setObject:[NSNumber numberWithInt:0] forKey:@"cartId"];
        [myDict setObject:[NSNumber numberWithInt:1] forKey:@"amount"];
        [myDict setObject:@"G" forKey:@"state"];
        [myDict setObject:[NSNumber numberWithLong:skuTypeId] forKey:@"skuTypeId"];
        [myDict setObject:skuType forKey:@"skuType"];
        [myDict setObject:@"Y" forKey:@"orCheck"];
        [myDict setObject:[NSNumber numberWithInt:2] forKey:@"cartSource"];

        [mutArray addObject:myDict];
        [self requestData:[mutArray copy]];

    }else{
        NSLog(@"---------事务开始");
        
        //开始添加事务
        [database beginTransaction];
        FMResultSet * rs = [database executeQuery:@"SELECT * FROM Shopping_Cart where pid = ? and sku_type = ? and sku_type_id = ?",[NSNumber numberWithInt:[sizeId intValue]],skuType,[NSNumber numberWithLong:skuTypeId]];
        //购物车如果存在这件商品，就更新数量
        if ([rs next]){
            int amount = [rs intForColumn:@"pid_amount"]+1 ;
            NSString * checkUrl = [HSGlobal checkAddCartAmount];

            AFHTTPRequestOperationManager * manager = [PublicMethod shareNoHeadRequestManager];
            if(manager == nil){
                NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
                noNetView.delegate = self;
                [self.view addSubview:noNetView];
                return;
            }
            
            
            NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
            [myDict setObject:[NSNumber numberWithInt:[sizeId intValue]] forKey:@"skuId"];
            [myDict setObject:[NSNumber numberWithInt:amount] forKey:@"amount"];
            [myDict setObject:[NSNumber numberWithLong:skuTypeId] forKey:@"skuTypeId"];
            [myDict setObject:skuType forKey:@"skuType"];
            

            [GiFHUD setGifWithImageName:@"hmm.gif"];
            [GiFHUD show];
            [manager POST:checkUrl  parameters:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
                NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
                NSString * returnMsg ;
                if(code == 200){
                    BOOL isUpdateOK = [database executeUpdate:@"UPDATE Shopping_Cart SET pid_amount = ? WHERE pid = ? and sku_type = ? and sku_type_id = ?",[NSNumber numberWithInt:amount],[NSNumber numberWithInt:[sizeId intValue]],skuType,[NSNumber numberWithLong:skuTypeId]];
                    
                    if (isUpdateOK) {
                        returnMsg = @"成功添加购物车";
                        [self startAnimation];
                    }else{
                        returnMsg = @"添加购物车失败";
                    }
                    [database commit];
                    
                }else{
                    returnMsg = message;
                }
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.labelText = returnMsg;
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];

                [GiFHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [GiFHUD dismiss];
                NSLog(@"Error: %@", error);
                [PublicMethod printAlert:@"添加失败"];
            }];
            return;
        }else{
            int amount = 1 ;
            NSString * checkUrl = [HSGlobal checkAddCartAmount];
            
            AFHTTPRequestOperationManager * manager = [PublicMethod shareNoHeadRequestManager];
            if(manager == nil){
                NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
                noNetView.delegate = self;
                [self.view addSubview:noNetView];
                return;
            }
            
            
            NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
            [myDict setObject:[NSNumber numberWithInt:[sizeId intValue]] forKey:@"skuId"];
            [myDict setObject:[NSNumber numberWithInt:amount] forKey:@"amount"];
            [myDict setObject:[NSNumber numberWithLong:skuTypeId] forKey:@"skuTypeId"];
            [myDict setObject:skuType forKey:@"skuType"];

            
            
            
            [GiFHUD setGifWithImageName:@"hmm.gif"];
            [GiFHUD show];
            [manager POST:checkUrl  parameters:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
                NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
                NSString * returnMsg ;
                if(code == 200){
                    NSString * sql = @"insert into Shopping_Cart (pid,cart_id,pid_amount,state,sku_type,sku_type_id) values (?,?,?,?,?,?)";
                    
                    //插入
                    BOOL isInsertOK = [database executeUpdate:sql,[NSNumber numberWithInt:[sizeId intValue]],0,[NSNumber numberWithInt:1],@"G",skuType,[NSNumber numberWithLong:skuTypeId]];
                    
                    if (isInsertOK)
                    {
                        [self startAnimation];
                        returnMsg = @"成功添加购物车";
                    }else{
                        returnMsg = @"添加购物车失败";
                    }
                    //提交事务
                    [database commit];
                }else{
                    returnMsg = message;
                }
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.labelText = returnMsg;
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                [GiFHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [GiFHUD dismiss];
                NSLog(@"Error: %@", error);
                [PublicMethod printAlert:@"添加失败"];
            }];
            return;

        
        }
        NSLog(@"---------事务结束");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"成功添加购物车";
        hud.labelFont = [UIFont systemFontOfSize:11];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
}
-(void)requestData:(NSArray *) array{
    
    NSString * urlString;
    AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
    if(manager == nil){
        NoNetView * noNetView = [[NoNetView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, GGUISCREENHEIGHT)];
        noNetView.delegate = self;
        [self.view addSubview:noNetView];
        return;
    }
    [GiFHUD setGifWithImageName:@"hmm.gif"];
    [GiFHUD show];
    urlString =[HSGlobal addToCartUrl];
    if(array.count <=0){
        array = nil;
    }
    [manager POST:urlString  parameters:array success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
        NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"]integerValue];
        if(code == 200){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"成功添加购物车";
            hud.labelFont = [UIFont systemFontOfSize:11];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            
            [self startAnimation];
            
            
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GiFHUD dismiss];
        NSLog(@"Error: %@", error);
        [PublicMethod printAlert:@"添加失败"];
    }];
    
    
}
- (IBAction)buyNow:(UIButton *)sender {
    isLogin = [PublicMethod checkLogin];
    if(!isLogin){
        self.hidesBottomBarWhenPushed=YES;
        LoginViewController * login = [[LoginViewController alloc]init];
        login.comeFrom = @"GoodsDetailVC";
        [self.navigationController pushViewController:login animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        return;
    }
    
    for(SizeData * sizeData in _detailData.sizeArray){
        
        if(sizeData.orMasterInv){
            if(![sizeData.state isEqualToString:@"Y"]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.labelText = @"商品库存不足";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                return;
            }
            NSMutableArray * mutArray = [NSMutableArray array];
            
            NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
            [myDict setObject: sizeData.invCustoms forKey:@"invCustoms"];
            [myDict setObject: sizeData.invArea forKey:@"invArea"];
            [myDict setObject: sizeData.invAreaNm forKey:@"invAreaNm"];
            NSMutableArray * cartArray = [NSMutableArray array];
            
            NSMutableDictionary *cartDict = [NSMutableDictionary dictionary];
            [cartDict setObject: @"G" forKey:@"state"];
            [cartDict setObject: @"1" forKey:@"amount"];
            [cartDict setObject: sizeData.sizeId forKey:@"skuId"];
            [cartDict setObject: sizeData.skuType forKey:@"skuType"];
            [cartDict setObject: [NSNumber numberWithLong:sizeData.skuTypeId] forKey:@"skuTypeId"];
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
//            [lastDict setObject: @"JD" forKey:@"payMethod"];
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
                    for(int i=0; i<orderData.singleCustomsArray.count; i++){//orderData.singleCustomsArray.count其实就是1,singleCustomsArray代表多个保税区

                        OrderDetailData * odData = orderData.singleCustomsArray[i];
                        CartDetailData * cdData =[[CartDetailData alloc]init];
                        cdData.invTitle = sizeData.invTitle;
                        cdData.invImg = sizeData.invImg;
                        cdData.amount = 1;
                        cdData.itemPrice = [sizeData.itemPrice floatValue];
                        [odData.cartDataArray addObject:cdData];

                    }
                    
                    OrderViewController * order = [[OrderViewController alloc]init];
                    order.orderType = @"item";
                    order.orderData = orderData;
                    order.mutArray = mutArray;
                    order.buyNow = 1;
                    order.realityPay = sizeData.itemPrice;
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
    }
    
}

- (IBAction)enterShoppingCart:(UIButton *)sender {
    BOOL orJumpTab = NO;
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CartViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopViewControllerNotification" object:nil];
            orJumpTab = YES;
            break;
        }
    }
    
    if(!orJumpTab){
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"cart",@"jumpKey", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToTabbar" object:nil userInfo:dict];
    }
}
-(void)startAnimation
{
    if (!layer) {
        _addCartButton.enabled = NO;
        layer = [CALayer layer];
        
        for(SizeData * sizeData in _detailData.sizeArray){
            if(sizeData.orMasterInv){
                NSString * str = sizeData.invImg;
                UIImage * image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                layer.contents = (__bridge id)image.CGImage;
                break;
            }
        }
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.bounds = CGRectMake(0, 0, 50, 50);
        [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
        layer.masksToBounds = YES;
//        layer.position =CGPointMake(0,0);
        [self.view.layer addSublayer:layer];
    }
    [self groupAnimation];
}


-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.3f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.3;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 0.3f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 0.6f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"group"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    [anim def];
    if (anim == [layer animationForKey:@"group"]) {
        _addCartButton.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
        _cnt++;
        if (_cnt) {
            _cntLabel.hidden = NO;
        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.2f;
        _cntLabel.text = [NSString stringWithFormat:@"%ld",(long)_cnt];
        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.2f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [_cartButton.layer addAnimation:shakeAnimation forKey:nil];
        
        //设置 购物车tabbar的badgeValue
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_cnt],@"badgeValue", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CustBadgeValue" object:nil userInfo:dict];
    }
}
/**
 *  代理方法
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


-(void)backController{
    [self prepareDataSource];
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
