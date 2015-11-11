//
//  DetailThreeCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/9.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeViewData.h"
@protocol DetailThreeCellDelegate <NSObject>

//回传cell高度
-(void)getThreeCellH:(CGFloat)cellHeight ;

@end

@interface DetailThreeCell : UITableViewCell
@property (nonatomic, weak) ThreeViewData * data;
@property (nonatomic, weak) id <DetailThreeCellDelegate> delegate;

@end
