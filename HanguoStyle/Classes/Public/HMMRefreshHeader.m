//
//  WGRefreshHeader.m
//  Weego
//
//  Created by Kevin on 16/3/17.
//  Copyright © 2016年 Weego. All rights reserved.
//

#import "HMMRefreshHeader.h"

@implementation HMMRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=32; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refresh_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 32; i<=0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refresh_%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
         [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    self.stateLabel.hidden = YES;
}
@end
