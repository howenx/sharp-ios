//
//  GGTabBar.m
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//

#import "GGTabBar.h"
#import "GGButton.h"

@interface GGTabBar()
@property (nonatomic ,weak) GGButton  * selectedButton;
@end
@implementation GGTabBar

-(void)addTabBarItem:(UITabBarItem *)item
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterCart) name:@"enterCart" object:nil];
    // 1.创建按钮
    GGButton *button = [[GGButton alloc] init];
    // 2.设置数据 ,设置图片
    button.item = item;
    [self addSubview:button];

    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
    
}

-(void)buttonClick :(GGButton * )button
{
    
    if ([self.delegate respondsToSelector:@selector(tabBarDelagate:didSelectButtonFrom:to:)]) {
        [self.delegate tabBarDelagate:self didSelectButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 按钮的frame数据
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.subviews.count; index++) {
        // 1.取出按钮
        GGButton *button = self.subviews[index];
        
        // 2.设置按钮的frame
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 3.绑定tag
        button.tag = index;
    }
}
//从详情页面点击购物车跳到第二个tabbar（购物车）
-(void)enterCart{
    GGButton *cartButton =(GGButton*)[self viewWithTag:1];
    [self buttonClick:cartButton];
}

@end
