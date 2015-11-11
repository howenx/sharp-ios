//
//  GoodsShowCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/19.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShowData.h"

@interface GoodsShowCell : UICollectionViewCell
@property (nonatomic, weak) GoodsShowData * data;
+(id)subjectCell;
@end
