//
//  RecommendGoodsView.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/3/8.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseView.h"

@interface RecommendGoodsView : BaseView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSArray * data;
-(void)makeUI;
@end
