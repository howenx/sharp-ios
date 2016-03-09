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

- (void)touchPage:(NSInteger)index andImageArray :(NSArray *) imageArray;

@end

@interface DetaileOneCell : UITableViewCell
+(id)subjectCell;

@property (nonatomic, weak) GoodsDetailData * data;

//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic, weak) id <DetaileOneCellDelegate> delegate;
@end
