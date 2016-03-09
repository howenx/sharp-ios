//
//  GoodsDetailViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//


#import "GoodsDetailData.h"
#import "BaseViewController.h"
@protocol GoodsDetailViewDelegate <NSObject>
-(void)tabBarDelagateFromDetailFrom:(NSInteger)from to:(NSInteger)to;

@end
@interface GoodsDetailViewController : BaseViewController

@property (nonatomic)BOOL isFromCart;
@property (nonatomic)BOOL isFromMiPwd;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,weak) id <GoodsDetailViewDelegate> delegate;
@property (nonatomic,strong)GoodsDetailData * detailData;


@property (nonatomic, strong) NSMutableArray *photos;
@end
