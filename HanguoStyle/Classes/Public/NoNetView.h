//
//  NoNetView.h
//  HanguoStyle
//
//  Created by liudongsheng on 16/1/28.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//

#import "BaseView.h"
#import "GoodsDetailData.h"
@protocol NoNetViewDelegate <NSObject>
-(void)backController;
@end
@interface NoNetView :BaseView

@property(nonatomic,weak) id <NoNetViewDelegate> delegate;
@end
