//
//  DetaileOneCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/2.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"

#import "GoodsDetailData.h"

@protocol DetaileOneCellDelegate <NSObject>
//回传cell高度
-(void)getOneCellH:(CGFloat)cellHeight ;
- (void)touchPage:(NSInteger)index andImageArray :(NSArray *) imageArray;

@end

@interface DetaileOneCell : UITableViewCell
+(id)subjectCell;

@property (nonatomic, weak) GoodsDetailData * data;


@property (nonatomic, weak) id <DetaileOneCellDelegate> delegate;
@end
