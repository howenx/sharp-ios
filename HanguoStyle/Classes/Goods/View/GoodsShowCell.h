//
//  GoodsShowCell.h
//  HanguoStyle
//
//  Created by liudongsheng on 15/10/19.
//  Copyright (c) 2015年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "GoodsShowData.h"
@protocol GoodsShowCellDelegate <NSObject>

//标签url
-(void)flagUrl:(NSString *)url;

@end
@interface GoodsShowCell : UICollectionViewCell
@property (nonatomic, weak) GoodsShowData * data;
@property(nonatomic,weak) id <GoodsShowCellDelegate> delegate;
@end
