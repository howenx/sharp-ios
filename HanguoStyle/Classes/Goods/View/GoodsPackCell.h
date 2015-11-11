//
//  GoodsPackCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/12.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsPackData.h"
@interface GoodsPackCell : UITableViewCell
@property (nonatomic, weak) GoodsPackData * data;
+(id)subjectCell;
@end
