//
//  KKGbutton.m
//  HanguoStyle
//
//  Created by wayne on 16/7/27.
//  Copyright © 2016年 liudongsheng. All rights reserved.
//
#define IWabBarHight 0.6
#import "KKGbutton.h"

@implementation KKGbutton
- (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)size imageAndTitleSpaceing:(CGFloat)spaceing baifenbi:(CGFloat)baifenbi
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fontSize = size;
        self.imageAndTitleSpaceing = spaceing;
        self.baifebi = baifenbi;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        [self setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor: [UIColor redColor]  forState:UIControlStateSelected];
        
    }
    return self;
}
//- (void)setHighlighted:(BOOL)highlighted {}


-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = 5;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * self.baifebi;
    return  CGRectMake(x, y, w, h);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * self.baifebi + self.imageAndTitleSpaceing;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height - y;
    return  CGRectMake(x, y, w, h);
}


@end
