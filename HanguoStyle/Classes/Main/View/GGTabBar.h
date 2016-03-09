//
//  GGTabBar.h
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGTabBar;
@protocol GGTabBarDelegate <NSObject>
@optional
-(void)tabBarDelagate:(GGTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to;
@end

@interface GGTabBar : UIView
-(void)addTabBarItem:(UITabBarItem *)item andController:(NSString* )controller;
@property (nonatomic,weak)id<GGTabBarDelegate> delegate;
@end
