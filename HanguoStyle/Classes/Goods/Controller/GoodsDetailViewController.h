//
//  GoodsDetailViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailData.h"
@protocol GoodsDetailViewDelegate <NSObject>
-(void)tabBarDelagateFromDetailFrom:(NSInteger)from to:(NSInteger)to;

@end
@interface GoodsDetailViewController : UIViewController

@property (nonatomic)BOOL * isFromCart;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,weak) id <GoodsDetailViewDelegate> delegate;
@property (nonatomic,strong)GoodsDetailData * detailData;
@end
