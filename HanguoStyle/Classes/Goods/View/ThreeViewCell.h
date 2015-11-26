//
//  ThreeViewCell.h
//  UITableViewDemo3
//
//  Created by liudongsheng on 15/10/26.
//  Copyright (c) 2015年 KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailData.h"
@protocol ThreeViewCellDelegate <NSObject>

//回传数据的协议方法
-(void)scrollPage:(NSInteger)page;
-(void)getFourCellH:(CGFloat)cellHeight ;
@end

@interface ThreeViewCell : UITableViewCell
+(id)subjectCell;
@property (nonatomic, weak) GoodsDetailData * data;

@property (nonatomic,assign) NSInteger pageNum;

@property (strong, nonatomic)  UIScrollView *scrollView;


@property(nonatomic,weak) id <ThreeViewCellDelegate> delegate;
@end
