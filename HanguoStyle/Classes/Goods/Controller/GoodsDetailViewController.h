//
//  GoodsDetailViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/23.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailData.h"
@interface GoodsDetailViewController : UIViewController
//@property (nonatomic) NSMutableArray * data;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)GoodsDetailData * detailData;
@end
