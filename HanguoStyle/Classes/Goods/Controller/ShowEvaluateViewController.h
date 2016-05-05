//
//  ShowEvaluateViewController.h
//  HanguoStyle
//
//  Created by wayne on 16/4/26.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowEvaluateModel.h"
#import "ShowImageEvaluateModel.h"
#import "MWPhotoBrowser.h"
@interface ShowEvaluateViewController : BaseViewController
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) long  orderID;
@property (nonatomic,strong) NSString * skuType;
@property (nonatomic ,strong) UICollectionView * collectionView;

//晒图集合
@property (nonatomic,strong)NSMutableArray * imageArray;
//全部评价
@property (nonatomic,strong)NSMutableArray * allEvaluateArray;
//好评
@property (nonatomic,strong)NSMutableArray * goodEvaluateArray;
//差评
@property (nonatomic,strong)NSMutableArray * badEvaluateArray;

@property (nonatomic,strong)ShowEvaluateModel * evaluateModel;
@property (nonatomic,strong)ShowImageEvaluateModel * imageEvaluateModel;

@property (nonatomic, strong) NSMutableArray *photos;
@end
