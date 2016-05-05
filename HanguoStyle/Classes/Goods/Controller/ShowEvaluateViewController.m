//
//  ShowEvaluateViewController.m
//  HanguoStyle
//
//  Created by wayne on 16/4/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "ShowEvaluateViewController.h"
#import "ShowEvaluateCollectionViewCell.h"
#import "GGButton.h"
#import "ShowBigImageForShowImageViewController.h"

#define titleH 44
@interface ShowEvaluateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>
{
    GGButton * goodButton;
    GGButton * allButton;
    GGButton * imageButton;
    GGButton * badButton;
    int  page_count_all;
    int  page_count_good;
    int  page_count_bad;
    int  page_count_image;
    NSString * type; // all good bad
}
@end

@implementation ShowEvaluateViewController
@synthesize tableView = tableView_;
@synthesize  collectionView = collectionView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden=YES;
    self.title = @"评价";
    
    _imageArray = [[NSMutableArray alloc]init];
    _allEvaluateArray = [[NSMutableArray alloc]init];
    _goodEvaluateArray = [[NSMutableArray alloc]init];
    _badEvaluateArray = [[NSMutableArray alloc]init];
    
    page_count_all = 1;
    page_count_good=1;
    page_count_bad =1;
    page_count_image =1;
    type = @"0";
    [self setModel];
    
    [self createSubViews];
    
    [self setModelCount];
}



-(void)setModel{
    
    
    if ([type isEqualToString:@"0"]) {
            NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowEvaluateUrl],self.skuType,self.orderID,page_count_all];
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowEvaluateUrl],@"customize",@"130155",page_count_all];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);

            if(200 == code){
                
                
                NSArray * array = [object objectForKey:@"remarkList"];
                if (array.count!=0) {
                    NSMutableArray * arrayNew = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in array) {
                        self.evaluateModel = [[ShowEvaluateModel alloc]initWithJSONNode:dict];
                        [arrayNew addObject:self.evaluateModel];
                    }
                    [self.allEvaluateArray addObjectsFromArray:arrayNew];
                }
                
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];

    }else if([type isEqualToString:@"1"])
    {//好评
        NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowgoodEvaluateUrl],self.skuType,self.orderID,page_count_good];
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowgoodEvaluateUrl],@"customize",@"130155",page_count_good];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            if(200 == code){
                
                
                NSArray * array = [object objectForKey:@"remarkList"];
                if (array.count!=0) {
                    NSMutableArray * arrayNew = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in array) {
                        self.evaluateModel = [[ShowEvaluateModel alloc]initWithJSONNode:dict];
                        [arrayNew addObject:self.evaluateModel];
                    }
                    [self.goodEvaluateArray addObjectsFromArray:arrayNew];
                }
                
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }else if([type isEqualToString:@"2"])
    {//差评
        NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowgoodEvaluateUrl],self.skuType,self.orderID,page_count_bad];
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowbadEvaluateUrl],@"customize",@"130155",page_count_bad];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
  
            if(200 == code){
                
                
                NSArray * array = [object objectForKey:@"remarkList"];
                if (array.count!=0) {
                    NSMutableArray * arrayNew = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in array) {
                        self.evaluateModel = [[ShowEvaluateModel alloc]initWithJSONNode:dict];
                        [arrayNew addObject:self.evaluateModel];
                    }
                    [self.badEvaluateArray addObjectsFromArray:arrayNew];
                }
                
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }else if([type isEqualToString:@"3"])
    {//图片
//        http://172.28.3.51:9001/comm/comment/rank/img/customize/130155/1
        NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowimageEvaluateUrl],self.skuType,self.orderID,page_count_image];
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowimageEvaluateUrl],@"customize",@"130155",page_count_image];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            if(200 == code){
                
                NSArray * array = [object objectForKey:@"remarkList"];
                if (array.count!=0) {
                    NSMutableArray * arrayNew = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in array) {
                        self.imageEvaluateModel = [ShowImageEvaluateModel  yy_modelWithDictionary:dict];
                        [arrayNew addObject:self.imageEvaluateModel];
                    }
                    [self.imageArray addObjectsFromArray:arrayNew];
                }
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];

    }
    
    
}


-(void)createSubViews
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleH)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineview.backgroundColor = UIColorFromRGB(0xd2d2d2);
    [titleView addSubview:lineview];
    
    //创建三个按钮
    allButton = [[GGButton alloc]init];
    allButton.frame = CGRectMake(0, 0.5, SCREEN_WIDTH/4, titleH-0.5);
    [allButton setImage:[UIImage imageNamed:@"all_evaluate_normal"] forState:UIControlStateNormal];
    [allButton setImage:[UIImage imageNamed:@"all_evaluate_selected"] forState:UIControlStateSelected];
    [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allButton setTitleColor:GGMainColor forState:UIControlStateSelected];
//    [allButton setTitle:@"12380" forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(evaluateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:allButton];
    
    goodButton = [[GGButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0.5, SCREEN_WIDTH/4, titleH-0.5)];
    [goodButton setImage:[UIImage imageNamed:@"good_evaluate_normal"] forState:UIControlStateNormal];
    [goodButton setImage:[UIImage imageNamed:@"good_evaluate_selected"] forState:UIControlStateSelected];
    [goodButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goodButton setTitleColor:GGMainColor forState:UIControlStateSelected];
//    [goodButton setTitle:@"12" forState:UIControlStateNormal];
        [goodButton addTarget:self action:@selector(evaluateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:goodButton];
    

    
    badButton = [[GGButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4)*2, 0.5, SCREEN_WIDTH/4, titleH-0.5)];
    [badButton setImage:[UIImage imageNamed:@"bad_evaluate_normal"] forState:UIControlStateNormal];
    [badButton setImage:[UIImage imageNamed:@"bad_evaluate_selected"] forState:UIControlStateSelected];
    [badButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [badButton setTitleColor:GGMainColor forState:UIControlStateSelected];
//    [badButton setTitle:@"23" forState:UIControlStateNormal];
        [badButton addTarget:self action:@selector(evaluateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:badButton];
    
    
    imageButton = [[GGButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4)*3, 0.5, SCREEN_WIDTH/4, titleH-0.5)];
    [imageButton setImage:[UIImage imageNamed:@"photo_normal"] forState:UIControlStateNormal];
    [imageButton setImage:[UIImage imageNamed:@"photo_selected"] forState:UIControlStateSelected];
    [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageButton setTitleColor:GGMainColor forState:UIControlStateSelected];
//    [imageButton setTitle:@"333" forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(evaluateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:imageButton];
    
    allButton.selected = YES;
    
    
    
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionView_=[[UICollectionView alloc] initWithFrame:CGRectMake(0, titleH, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -titleH) collectionViewLayout:flowLayout];
    collectionView_.dataSource=self;
    collectionView_.showsHorizontalScrollIndicator  = NO;
    collectionView_.showsVerticalScrollIndicator = NO;
    collectionView_.delegate=self;
//    collectionView_.alwaysBounceVertical = YES;
//    collectionView_.alwaysBounceHorizontal = YES;
    [collectionView_ setBackgroundColor:[UIColor clearColor]];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"showEvaluateUICollectionViewCell3"];
    [self.collectionView registerClass:[ShowEvaluateCollectionViewCell class] forCellWithReuseIdentifier:@"showEvaluateUICollectionViewCell1"];
    [self.collectionView registerClass:[ShowEvaluateCollectionViewCell class] forCellWithReuseIdentifier:@"showEvaluateUICollectionViewCell2"];
    [self.collectionView registerClass:[ShowEvaluateCollectionViewCell class] forCellWithReuseIdentifier:@"showEvaluateUICollectionViewCell0"];
    [self.view addSubview:collectionView_];
    
    
    // 下拉刷新
    self.collectionView.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([type isEqualToString:@"0"]) {
            page_count_all =1;
        }else if([type isEqualToString:@"1"])
        {
            page_count_good =1;
        }else if([type isEqualToString:@"2"])
        {
             page_count_bad =1;
        }else if([type isEqualToString:@"3"])
        {
            page_count_image =1;
        }
    
        [self setModel1];
        [self.collectionView.header endRefreshing];
    }];
    
    //上拉加载
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if ([type isEqualToString:@"0"]) {
            page_count_all +=1;
        }else if([type isEqualToString:@"1"])
        {
            page_count_good +=1;
        }else if([type isEqualToString:@"2"])
        {
            page_count_bad +=1;
        }else if([type isEqualToString:@"3"])
        {
            page_count_image +=1;
        }
        
        
        [self setModel];
        [self.collectionView.footer endRefreshing];
    }];
    // 默认先隐藏footer
    self.collectionView.footer.hidden = YES;
}

-(void)evaluateButtonClick:(UIButton *)btn
{
    
    goodButton.selected = NO;
    allButton.selected = NO;
    imageButton.selected = NO;
    badButton.selected = NO;
    
    btn.selected = YES;
    
    if (btn == allButton) {
        type = @"0";
        
        if (self.allEvaluateArray.count==0) {
            [self setModel];
        }else
        {
          [collectionView_ reloadData];
        }
        
    }else if(btn == goodButton)
    {
        type = @"1";
        if (self.goodEvaluateArray.count==0) {
            [self setModel];
        }else
        {
            [collectionView_ reloadData];
        }
    }
    else if(btn == badButton)
    {
        type = @"2";
        if (self.badEvaluateArray.count==0) {
            [self setModel];
        }else
        {
            [collectionView_ reloadData];
        }
    }
    else if(btn == imageButton)
    {
        type = @"3";
        if (self.imageArray.count==0) {
            [self setModel];
        }else
        {
            [collectionView_ reloadData];
        }
    }
    

    

  
    
    
    
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if ([type isEqualToString:@"3"]) {
        return self.imageArray.count;
    }else if([type isEqualToString:@"0"])
    {
        return self.allEvaluateArray.count;
    }else if([type isEqualToString:@"1"])
    {
        return self.goodEvaluateArray.count;
    }else if([type isEqualToString:@"2"])
    {
        return self.badEvaluateArray.count;
    }
    return 30;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

   
    if ([type isEqualToString:@"3"]) {
         self.imageEvaluateModel = self.imageArray[indexPath.row];
        static NSString * CellIdentifier = @"showEvaluateUICollectionViewCell3";
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

        UIImageView * view  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-30)/3,100)];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [view sd_setImageWithURL:[NSURL URLWithString:self.imageEvaluateModel.picture] placeholderImage:[UIImage imageNamed:@"loading2"]];
        
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.contentView addSubview:view];
        return cell;
    }else
    {

        
        if ([type isEqualToString:@"0"]) {
            static NSString * CellIdentifier = @"showEvaluateUICollectionViewCell0";
            ShowEvaluateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            
            self.evaluateModel = self.allEvaluateArray[indexPath.row];
            
            cell.evaluateModel = self.evaluateModel;
            return  cell;
            
        }else if([type isEqualToString:@"1"])
        {
            static NSString * CellIdentifier = @"showEvaluateUICollectionViewCell1";
            ShowEvaluateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            self.evaluateModel = self.goodEvaluateArray[indexPath.row];
            
            cell.evaluateModel = self.evaluateModel;
            return  cell;
        }else  //([type isEqualToString:@"2"])
        {
            static NSString * CellIdentifier = @"showEvaluateUICollectionViewCell2";
            ShowEvaluateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            self.evaluateModel = self.badEvaluateArray[indexPath.row];
            
            cell.evaluateModel = self.evaluateModel;
            return  cell;
        }
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:@"3"]) {
        return CGSizeMake((SCREEN_WIDTH-30)/3, 100);
    }else if([type isEqualToString:@"0"])
    {
        CGFloat H = [ShowEvaluateCollectionViewCell CellHight:self.allEvaluateArray[indexPath.row]];
        return CGSizeMake(SCREEN_WIDTH, H);
    }else if([type isEqualToString:@"1"])
    {
        CGFloat H = [ShowEvaluateCollectionViewCell CellHight:self.goodEvaluateArray[indexPath.row]];
        return CGSizeMake(SCREEN_WIDTH, H);
    }else if([type isEqualToString:@"2"])
    {
        CGFloat H = [ShowEvaluateCollectionViewCell CellHight:self.badEvaluateArray[indexPath.row]];
        return CGSizeMake(SCREEN_WIDTH, H);
    }
    
    return CGSizeMake(SCREEN_WIDTH, 0
                      );
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([type isEqualToString:@"3"]) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return UIEdgeInsetsMake(0,0, 0, 0);
    
}











//计算总数
-(void)setModelCount
{
    
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowEvaluateUrl],@"customize",@"130155",page_count_all];
    NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowEvaluateUrl],self.skuType,self.orderID,page_count_all];
        AFHTTPRequestOperationManager * manager = [PublicMethod shareRequestManager];
        if(manager == nil){
            return;
        }

        
        [manager GET:urlString  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSString * str = @"0";
            if ([object objectForKey:@"count_num"] != nil) {
                str = [object objectForKey:@"count_num"];
            }
            
            
            [allButton setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
//好评
//        NSString * urlString1 =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowgoodEvaluateUrl],@"customize",@"130155",page_count_good];
    NSString * urlString1 =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowgoodEvaluateUrl],self.skuType,self.orderID,page_count_good];
        AFHTTPRequestOperationManager * manager1= [PublicMethod shareRequestManager];
        if(manager1 == nil){
            return;
        }

        [manager1 GET:urlString1  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSString * str = @"0";
            if ([object objectForKey:@"count_num"] != nil) {
                str = [object objectForKey:@"count_num"];
            }
            
            
            [goodButton setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    
//        NSString * urlString2 =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowbadEvaluateUrl],@"customize",@"130155",page_count_bad];
        NSString * urlString2 =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowgoodEvaluateUrl],self.skuType,self.orderID,page_count_bad];
        AFHTTPRequestOperationManager * manager2 = [PublicMethod shareRequestManager];
        if(manager2 == nil){
            return;
        }

        
        [manager2 GET:urlString2  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSString * str =  @"0";
            if ([object objectForKey:@"count_num"] != nil) {
                str = [object objectForKey:@"count_num"];
            }
            [badButton setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
//图片

//        NSString * urlString3 =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowimageEvaluateUrl],@"customize",@"130155",page_count_image];
        NSString * urlString3 =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowimageEvaluateUrl],self.skuType ,self.orderID,page_count_image];
        AFHTTPRequestOperationManager * manager3 = [PublicMethod shareRequestManager];
        if(manager3 == nil){
            return;
        }

        
        [manager3 GET:urlString3  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSString * str =  @"0";
            if ([object objectForKey:@"count_num"] != nil) {
                str = [object objectForKey:@"count_num"];
            }
            
            [imageButton setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    

}


-(void)setModel1{
    
    
    if ([type isEqualToString:@"0"]) {
        page_count_all = 1;
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowEvaluateUrl],@"customize",@"130155",page_count_all];
        NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowEvaluateUrl],self.skuType,self.orderID,page_count_all];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            
            
            
            if(200 == code){
                
                
                
                NSArray * array = [object objectForKey:@"remarkList"];
                [self.allEvaluateArray removeAllObjects];
                if (array.count!=0) {
                    for (NSDictionary * dict in array) {
                        self.evaluateModel = [[ShowEvaluateModel alloc]initWithJSONNode:dict];
                        [self.allEvaluateArray addObject:self.evaluateModel];
                    }
                }
                
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
        
    }else if([type isEqualToString:@"1"])
    {//好评
        page_count_good = 1;
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowgoodEvaluateUrl],@"customize",@"130155",page_count_good];
        NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowgoodEvaluateUrl],self.skuType,self.orderID,page_count_good];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            
            if(200 == code){
                
                
                NSArray * array = [object objectForKey:@"remarkList"];
                [self.goodEvaluateArray removeAllObjects];
                if (array.count!=0) {
                    for (NSDictionary * dict in array) {
                        self.evaluateModel = [[ShowEvaluateModel alloc]initWithJSONNode:dict];
                        [self.goodEvaluateArray addObject:self.evaluateModel];
                    }
                }
                
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }else if([type isEqualToString:@"2"])
    {//差评
        page_count_bad = 1;
//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowbadEvaluateUrl],@"customize",@"130155",page_count_bad];
        NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowbadEvaluateUrl],self.skuType,self.orderID,page_count_bad];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            
            if(200 == code){
                
                
                NSArray * array = [object objectForKey:@"remarkList"];
                [self.badEvaluateArray removeAllObjects];
                if (array.count!=0) {
                    for (NSDictionary * dict in array) {
                        self.evaluateModel = [[ShowEvaluateModel alloc]initWithJSONNode:dict];
                        [self.badEvaluateArray addObject:self.evaluateModel];
                    }
                }
                
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
    }else if([type isEqualToString:@"3"])
    {//图片
        page_count_image = 1;

//        NSString * urlString =[NSString stringWithFormat:@"%@%@/%@/%d",[HSGlobal ShowimageEvaluateUrl],@"customize",@"130155",page_count_image];
        NSString * urlString =[NSString stringWithFormat:@"%@%@/%ld/%d",[HSGlobal ShowimageEvaluateUrl],self.skuType,self.orderID,page_count_image];
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
            NSInteger code = [[[object objectForKey:@"message"] objectForKey:@"code"] integerValue];
            NSString * message = [[object objectForKey:@"message"] objectForKey:@"message"];
            NSLog(@"code= %ld",(long)code);
            NSLog(@"message= %@",message);
            
            if(200 == code){
                
                NSArray * array = [object objectForKey:@"remarkList"];
                [self.imageArray removeAllObjects];
                if (array.count!=0) {
                    for (NSDictionary * dict in array) {
                        self.imageEvaluateModel = [ShowImageEvaluateModel  yy_modelWithDictionary:dict];
                        [self.imageArray addObject:self.imageEvaluateModel];
                    }
                }
                [collectionView_ reloadData];
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                
                hud.labelFont = [UIFont systemFontOfSize:11];
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:1];
            }
            
            [GiFHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GiFHUD dismiss];
            [PublicMethod printAlert:@"数据加载失败"];
            
        }];
        
    }
    
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([type isEqualToString:@"3"]) {
//        // Browser
//        NSMutableArray *photos = [[NSMutableArray alloc] init];
//        MWPhoto *photo;
//        BOOL displayActionButton = NO;
//        BOOL displaySelectionButtons = NO;
//        BOOL displayNavArrows = NO;
//        BOOL enableGrid = YES;
//        BOOL startOnGrid = NO;
//        
//        for (int i = 0; i < self.imageArray.count; i++)
//        {
//            NSString * url = ((ShowImageEvaluateModel *)self.imageArray[i]).picture;
//            photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
//            [photos addObject:photo];
//            
//        }
//
//        self.photos = photos;
//        //
//        // Create browser
//        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//        browser.displayActionButton = displayActionButton;//分享按钮,默认是
//        browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
//        browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
//        browser.alwaysShowControls = displaySelectionButtons;//控制条件控件 是否显示,默认否
//        browser.zoomPhotosToFill = NO;//是否全屏,默认是
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//        browser.wantsFullScreenLayout = YES;//是否全屏
//#endif
//        browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
//        browser.startOnGrid = startOnGrid;//是否第一张,默认否
//        browser.enableSwipeToDismiss = YES;
//        [browser showNextPhotoAnimated:YES];
//        [browser showPreviousPhotoAnimated:YES];
//        [browser setCurrentPhotoIndex:indexPath.row];
//        
//        [self.navigationController pushViewController:browser animated:NO];
        
        ShowBigImageForShowImageViewController * vc = [ShowBigImageForShowImageViewController new];
        
        vc.index = indexPath.row;
        vc.array = self.imageArray;
        [self.navigationController pushViewController:vc animated:NO];
        
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
