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
#import "MBProgressHUD.h"
@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ThreeViewCellDelegate,MBProgressHUDDelegate,DetailTwoCellDelegate,DetailThreeCellDelegate>
{

    NSMutableArray * _dataSource;
    NSInteger _pageNum; //最后一个section里面有scrollview里面有三个view，这个标示是表示哪个view
//    CGFloat _rowHeight;//最后一个section的高度（这个高度是是随着section里面scrollview里面分别三个view的高度而变化的）
    CGFloat _otherRowHeight;//除了最后一组，其他section的高度和
    UIView *_lineView;//最后一个组的组头里面三个按钮下面的线
    CGFloat _sectionZeroHeight;//第0个分组的高度
    MBProgressHUD *HUD;
    DetaileOneCell * oneCell;
    DetailTwoCell * twoCell;
    DetailThreeCell * threeCell;
//    ThreeViewCell * threeViewCell;
    ThreeViewCell * oneView;//存放图文详情的cell
    ThreeViewCell * twoView;//存放商品参数的cell
    ThreeViewCell * threeView;//存放热卖商品的cell
    
    CGFloat twoCellHeight;//第二个cell的高度
    CGFloat threeCellHeight;//第三个cell的高度
    
    CGFloat fourCellHeight;//第四个cell的高度
    NSString * colorClassifyId;//选择的颜色
    NSString * sizeId;//选择的尺寸
    NSInteger numberOfSection;//共几个section

    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL globleIsStore;
@property (nonatomic,assign) NSInteger globleStoreCount;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setAlpha:0.2];
    HUD = [[MBProgressHUD alloc]  initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self prepareDataSource];
    _pageNum = 0;
    _otherRowHeight = 0;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40-2, GGUISCREENWIDTH/3, 2)];
    _lineView.backgroundColor = GGColor(254, 99, 108);
}


-(void)prepareDataSource
{
    _data = [[NSMutableArray alloc]init];
    ThreeViewData * threeData = [[ThreeViewData alloc]init];
    threeData.isStore = NO;
    threeData.storeCount = 40;
    [_data addObject:threeData];
    //从网络获取到数据之后，给收藏数量等全局变量赋值
    ThreeViewData * data = self.data[0];
    _globleIsStore = data.isStore;
    _globleStoreCount = data.storeCount;
    _dataSource = [[NSMutableArray alloc]init];
    numberOfSection = 4;
    for (int i = 0; i<4; i++) {
        NSString * string = [NSString stringWithFormat:@"第 %d 条数据",i];
        [_dataSource addObject:string];
    }
    [self.tableView reloadData];
    [HUD hide:YES];
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
        if(oneCell == nil){
            oneCell = [DetaileOneCell subjectCell];
            oneCell.data = self.data[indexPath.section];
            [oneCell.storeBtn addTarget:self action:@selector(storeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [oneCell.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        return oneCell;
        
    }else if(indexPath.section == 1){
        if(twoCell == nil){
            twoCell = [[DetailTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            twoCell.delegate = self;
            twoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            twoCell.data = _dataSource[indexPath.section];
        }
        return twoCell;
    }
    
    if(indexPath.section==2 && numberOfSection == 4){
        if(threeCell == nil){
            threeCell = [[DetailThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            threeCell.delegate = self;
            threeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            threeCell.data = _dataSource[indexPath.section];
        }
        return threeCell;
    }
    
    if((indexPath.section == 3 && numberOfSection == 4)|| (numberOfSection == 3 &&indexPath.section == 2)){
        // _otherRowHeight是上面三个cell的高度
        _otherRowHeight =_sectionZeroHeight + twoCellHeight + threeCellHeight;
        
        if(tableView.contentOffset.y > _otherRowHeight){
            [_tableView setContentOffset:CGPointMake(0, _otherRowHeight - 64) animated:YES];
        }
        
        if(_pageNum == 0){
            if(oneView == nil){
                oneView  = [ThreeViewCell subjectCell];
                oneView.pageNum = _pageNum;
                oneView.delegate = self;
                oneView.data = _dataSource[indexPath.section];
            }
            [oneView.scrollView setContentOffset:CGPointMake(0, 0)];
            return oneView;
        }
        if(_pageNum == 1){
            if(twoView == nil){
                twoView  = [ThreeViewCell subjectCell];
                twoView.pageNum = _pageNum;
                twoView.delegate = self;
                twoView.data = _dataSource[indexPath.section];
            }
            [twoView.scrollView setContentOffset:CGPointMake(GGUISCREENWIDTH, 0)];
            return twoView;
        }
        if(_pageNum == 2){
            if(threeView == nil){
                threeView  = [ThreeViewCell subjectCell];
                threeView.pageNum = _pageNum;
                threeView.delegate = self;
                threeView.data = _dataSource[indexPath.section];
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

    _globleIsStore = !_globleIsStore;
    UIImage * image;
    if (_globleIsStore) {
        image = [UIImage imageNamed:@"redStore"];
       [ oneCell.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",_globleStoreCount + 1] forState:UIControlStateNormal];
        _globleStoreCount++;
    }else{
        image = [UIImage imageNamed:@"grayStore"];
        [ oneCell.storeBtn setTitle:[NSString stringWithFormat:@"（%ld）",_globleStoreCount - 1] forState:UIControlStateNormal];
        _globleStoreCount--;
    }
    [oneCell.storeBtn setImage:image forState:UIControlStateNormal];

}
- (void) shareBtnClicked: (UIButton *) button{

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if((section==3 && numberOfSection == 4) || (section ==2 && numberOfSection == 3)){
        UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GGUISCREENWIDTH, 40)];
        barView.backgroundColor = [UIColor whiteColor];
        //    barView.backgroundColor = [UIColor whiteColor];
        UIButton * tuWenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tuWenBtn.frame = CGRectMake(0, 10, GGUISCREENWIDTH/3, 20);
        [tuWenBtn setTitle:@"图文详情" forState:UIControlStateNormal];
        [tuWenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tuWenBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [tuWenBtn addTarget:self action:@selector(tuWenClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *canShuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        canShuBtn.frame = CGRectMake(GGUISCREENWIDTH/3, 10, GGUISCREENWIDTH/3, 20);
        [canShuBtn setTitle:@"商品参数" forState:UIControlStateNormal];
        [canShuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        canShuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [canShuBtn addTarget:self action:@selector(canShuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *reMaiBtn = [UIButton buttonWithType:UIButtonTypeSystem];
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
    [self scrollPage:0];
}

- (void) canShuClick:(UIButton *)button
{
    [self scrollPage:1];
}

- (void) reMaiClick:(UIButton *)button
{
    [self scrollPage:2];
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
        _sectionZeroHeight = GGUISCREENWIDTH + 40 + 1 + 80 + 8;
        return _sectionZeroHeight;
    }
    if(indexPath.section == 1){
        return twoCellHeight;
    }

    if(indexPath.section == 2 && numberOfSection == 4){
        return threeCellHeight;
    }
    
    if((indexPath.section == 3 && numberOfSection == 4) || (indexPath.section == 2 && numberOfSection == 3)){
        return fourCellHeight;
    }

    return 0;
}


-(void)scrollPage:(NSInteger)page{
    _pageNum = page;
    if(numberOfSection == 4){
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if(numberOfSection == 3){
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
-(void)getColorClassify:(NSString *)colorClassify{
    colorClassifyId = colorClassify;
}

-(void)getSize:(NSString *)size{
    sizeId = size;
}

-(void)getThreeCellH:(CGFloat)cellHeight{
    
    threeCellHeight = cellHeight;
}
-(void)getFourCellH:(CGFloat)cellHeight{
    
    fourCellHeight = cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
