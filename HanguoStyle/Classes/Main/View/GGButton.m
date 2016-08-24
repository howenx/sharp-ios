//
//  GGButton.m
//  GiftGuide
//
//  Created by qianfeng on 15/8/16.
//  Copyright (c) 2015年 ThirdGroup. All rights reserved.
//
#define IWabBarHight 0.4 
#import "GGButton.h"

@implementation GGButton

 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor: UIColorFromRGB(0x242424) forState:UIControlStateNormal];
        [self setTitleColor: UIColorFromRGB(0x431c02)  forState:UIControlStateSelected];
        
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
    if ([_controller isEqualToString:@"cust"]) {
        [self setBadge];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCustBadgeValue:) name:@"CustBadgeValue" object:nil];
    }
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = 8;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * IWabBarHight;
    return  CGRectMake(x, y, w, h);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * IWabBarHight+10;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height - y;
    return  CGRectMake(x, y, w, h);
}
-(void)setBadge{
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(GGUISCREENWIDTH/10 , 5, 15, 15)];
    _cntLabel.textColor = [UIColor whiteColor];
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont systemFontOfSize:10];
    _cntLabel.backgroundColor = GGRedColor;
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = GGBgColor.CGColor;
    _cntLabel.hidden = YES;
    [self addSubview:_cntLabel];

}
-(void)getCustBadgeValue:(NSNotification *)noti{
    NSString * value = noti.userInfo[@"badgeValue"];
    if([@"" isEqualToString:value]){
        _cntLabel.hidden = YES;
    }else{
        _cntLabel.hidden = NO;
        _cntLabel.text = value;
    }
}
@end
