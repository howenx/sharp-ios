//
//  DetailTwoCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/6.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"

#import "GoodsDetailData.h"
@protocol DetailTwoCellDelegate <NSObject>

//回传cell高度
-(void)getTwoCellH:(CGFloat)cellHeight ;

-(void)getNewData :(GoodsDetailData *)newData;

@end
@interface DetailTwoCell : UITableViewCell

@property (nonatomic, weak) GoodsDetailData * data;
//
@property (nonatomic, strong) NSArray * colorMutArray;

@property (nonatomic, weak) id <DetailTwoCellDelegate> delegate;
@end
