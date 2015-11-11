//
//  GGButton.m
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//
#define IWabBarHight 0.6
#import "GGButton.h"

@implementation GGButton

 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor: GGColor(218, 72, 130)  forState:UIControlStateSelected];
        
    }
    return self;
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

-(void)setItem:(UITabBarItem *)item
{
    _item = item;
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitle:self.item.title forState:UIControlStateSelected];
    //设置填充模式
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = 3;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * IWabBarHight;
    return  CGRectMake(x, y, w, h);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * IWabBarHight;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height - y;
    return  CGRectMake(x, y, w, h);
}

@end
