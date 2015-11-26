//
//  DetailTwoCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/6.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsDetailData.h"
@protocol DetailTwoCellDelegate <NSObject>

//回传cell高度
-(void)getTwoCellH:(CGFloat)cellHeight ;
////回传颜色分类
//-(void)getColorClassify :(NSString *)colorClassify;
////回传尺寸
//-(void)getSize :(NSString *)size;
-(void)getNewData :(GoodsDetailData *)newData;

@end
@interface DetailTwoCell : UITableViewCell

@property (nonatomic, weak) GoodsDetailData * data;
//
@property (nonatomic, strong) NSArray * colorMutArray;

@property (nonatomic, weak) id <DetailTwoCellDelegate> delegate;
@end
