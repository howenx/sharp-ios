//
//  MeCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/21.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeData.h"
@interface MeCell : UITableViewCell
@property(nonatomic,strong) MeData * data;
+(id)subjectCell;

@end
