//
//  DetaileOneCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeViewData.h"
@interface DetaileOneCell : UITableViewCell
+(id)subjectCell;
@property (nonatomic,strong)NSArray * scrollArr;
@property (nonatomic, weak) ThreeViewData * data;

//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@end
