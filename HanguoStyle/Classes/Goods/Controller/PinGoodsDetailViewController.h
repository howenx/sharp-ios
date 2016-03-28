//
//  PinGoodsDetailViewController.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/2/17.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PinGoodsDetailData.h"
@interface PinGoodsDetailViewController : BaseViewController

@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)PinGoodsDetailData * detailData;
@property (nonatomic, strong) NSMutableArray *photos;
@end
