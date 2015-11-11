//
//  DetailTwoCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/11/6.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeViewData.h"
@protocol DetailTwoCellDelegate <NSObject>

//回传cell高度
-(void)getTwoCellH:(CGFloat)cellHeight ;
//回传颜色分类
-(void)getColorClassify :(NSString *)colorClassify;
//回传尺寸
-(void)getSize :(NSString *)size;
@end
@interface DetailTwoCell : UITableViewCell

@property (nonatomic, weak) ThreeViewData * data;
//
@property (nonatomic, strong) NSArray * colorMutArray;
@property (nonatomic, strong) NSArray * sizeMutArray;
@property (nonatomic, assign) NSInteger colorBtnTag;
@property (nonatomic, assign) NSInteger sizeBtnTag;
@property (nonatomic, weak) id <DetailTwoCellDelegate> delegate;
@end
